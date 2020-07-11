ArrayList<pRecto> rectos = new ArrayList<pRecto>(); // 1
ArrayList<pEstacional> estacionales = new ArrayList<pEstacional>(); // 2
ArrayList<pAleatorio> aleatorios = new ArrayList<pAleatorio>();// 3
ArrayList<pEstatico> estaticos = new ArrayList<pEstatico>();// 4

ArrayList<Pared> paredes = new ArrayList<Pared>();

ArrayList<Punto> puntos = new ArrayList<Punto>(); 

int datos[][];

int rectos_len;
int estacionales_len;
int aleatorios_len;
int estaticos_len;

int dimensiones[];

float muerte;
int t_muerte;
int t_cura;
int reinfection;
 
float contagios[][] = new float[4][4];

int seconds;
int minutes;
int sec;
int oldsec = second();

Tex latex = new Tex();

int time;

String n1 = "mapaConfig";
String n2 = "agentesConfig";
String n3 = "codevidConfig";

void settings() {
  
  /*
  El mapa debe tener en su primer lı́nea el largo y ancho de la matriz por
  la que se moverán los agentes. La segunda lı́nea tendrá la cantidad P de
  paredes que se deberán colocar y las siguientes P lı́neas tendrán, cada una,
  cuatro números x 1 , y 1 , x 2 , y 2 indicando las coordenadas superior izquierda
  e inferior derecha del rectángulo que serı́a esa pared. Nótese que todas las
  paredes son rectangulares.*/
  String[] datosMapa = loadStrings(n1);
  
  dimensiones = int(split(datosMapa[0], ' '));

  
  size(dimensiones[0],dimensiones[1]);
  
  int cant_paredes = 2;
  while(cant_paredes < datosMapa.length) { // Creamos y recolectaos todas las paredes
    int extremos[] = int(split(datosMapa[cant_paredes], ' '));
    Pared pared = new Pared(extremos[0],extremos[1],extremos[2],extremos[3]);
    this.paredes.add(pared);
    cant_paredes++;
  }
  
}

public void setup(){
  //println("\\hola");
  //size(500,500);
  ellipseMode(RADIUS);
  rectMode(CORNERS);
  noStroke();
  
  time = int(args[0]);
  /*
  sec = second(); //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
  
  if (oldsec < sec || sec == 0) {
    
    if (sec == 0 && oldsec == 59) {
      seconds += 1;
      oldsec = sec;
    }
    else if (sec == 0 && oldsec == 0){
      oldsec = sec;
    }
    else {
      seconds += 1;
      oldsec = sec;
    }
  }
  */
  /*
  El archivo en su primera lı́nea tendrá la
  cantidad de grupos de agentes se van a generar.
  La primer lı́nea de cada grupo tiene la cantidad de agentes con esas
  caracterı́sticas. La segunda lı́nea tendrá el tipo de agente (1- Rectos, 2-
  Estacionales, 3- Aleatorios y 4 Estáticos). La siguiente lı́nea indicando su
  velocidad máxima y mı́nima. La última lı́nea será una s de sano o una e de
  enfermo,indicando si ese grupo está sano o enfermo.
  */
  String[] datosAgentes = loadStrings(n2);
  
  int cantidad_grupos = int(datosAgentes[0]);
  int cantidad_agentes;
  
  int i=1;
  
  while(i < datosAgentes.length){ // Creamos y recolectamos los puntos existentes
    cantidad_agentes = int(datosAgentes[i]);
    
    int vel[] = int(split(datosAgentes[i+2], ' '));
    int estado = 0;
    String s = "";
    s = s+datosAgentes[i+3];
    //println(s);
    if (s.equals("s")){
      estado = 0; 
    }
    if (s.equals("e")){
      estado = -1; 
      //println("##############################################");
    }
    
    while(cantidad_agentes > 0) {
      
      if(int(datosAgentes[i+1]) == 1){
        pRecto recto = new pRecto(1,3, estado, dimensiones);
        this.rectos.add(recto);
      }
      else if(int(datosAgentes[i+1]) == 2){
        pEstacional estacional = new pEstacional(1,3, estado, dimensiones);
        this.estacionales.add(estacional);
      }
      else if(int(datosAgentes[i+1]) == 3){
        pAleatorio aleatorio = new pAleatorio(1,3, estado, dimensiones);
        this.aleatorios.add(aleatorio);
      }
      else {
        pEstatico estatico = new pEstatico(1,3, estado, dimensiones);
        this.estaticos.add(estatico);
      }

      cantidad_agentes--;
    }
    
    i += 4 ;
  }
  
  /*
  Finalmente el archivo de configuración del CodeVid, indicará algunos
  datos importantes del comportamiento de la enfermedad. La primer lı́nea
  indicará la probabilidad (flotante) de que un individuo muera, la segunda
  lı́nea el tiempo en segundos que tarda una persona en morir, en la tercera
  lı́nea el tiempo en segundos que tarda una persona en sanar. Las siguientes
  cuatro lı́neas tendrán la tasa de contagio en forma de matriz para los dife-
  rentes tipos de agentes y como se contagia la enfermedad. La posición (i, j)
  indica la probabilidad de que un individuo de tipo i contagie a alguien de
  tipo j. Finalmente la última lı́nea, indicará si es posible una reinfección, cero
  para indicar que no, una persona curada, no se puede enfermar de Code-vid
  de nuevo y cualquier otro número para que esto sı́ pueda ocurrir.
  */
  String[] datosCodeVid = loadStrings(n3);
  muerte = float(datosCodeVid[0]);
  t_muerte = int(datosCodeVid[1]);
  t_cura = int(datosCodeVid[2]);
  
  contagios[0] = float(split(datosCodeVid[3], ' '));
  contagios[1] = float(split(datosCodeVid[4], ' '));
  contagios[2] = float(split(datosCodeVid[5], ' '));
  contagios[3] = float(split(datosCodeVid[6], ' '));
  
  reinfection = int(datosCodeVid[7]);
  
  datos = new int[2][time+1];
  
  datos[0][0] = 0;
  datos[1][0] = 0;
}

public void draw() {
  background(0);//delay(100);
  
  rectos_len = rectos.size();
  estacionales_len = estacionales.size();
  aleatorios_len = aleatorios.size();
  estaticos_len = estaticos.size();
  
  sec = second();
  colision();
  
  if (oldsec < sec || sec == 0) {
    
    if (sec == 0 && oldsec == 59) {
      
      colectaPuntos();
      seconds += 1;
      oldsec = sec;
      getInfo();
    }
    else if (sec == 0 && oldsec == 0){
      oldsec = sec;
    }
    else {
      colectaPuntos();
      
      seconds += 1;
      oldsec = sec;
      getInfo();
    }
  }
  
  fill(250,250,250);
  
  for (int i = 0; i < rectos_len; i++) {
    fill(255,255,255);
    //rectos.get(i).updateEstado();
    if (rectos.get(i).getEstado() < 0)randColorRed(255,255,255);
    if (rectos.get(i).getEstado() > 0)randColorBlue(255,255,255);
    rectos.get(i).move();
  }
  
  for (int i = 0; i < estacionales_len; i++){
    fill(255,100,255);
    //estacionales.get(i).updateEstado();
    if (estacionales.get(i).getEstado() < 0)randColorRed(255,100,255);
    if (estacionales.get(i).getEstado() > 0)randColorBlue(255,100,255);
    estacionales.get(i).move();
  }
  
  
  for (int i = 0; i < aleatorios_len; i++) {
    fill(55,100,100);
    //aleatorios.get(i).updateEstado();
    if (aleatorios.get(i).getEstado() < 0)randColorRed(55,100,100);
    if (aleatorios.get(i).getEstado() > 0)randColorBlue(55,100,100);
    aleatorios.get(i).move();
    
  }
  
  for (int i = 0; i < estaticos_len; i++) {
    fill(255,255,120);
    //estaticos.get(i).updateEstado();
    if (estaticos.get(i).getEstado() < 0)randColorRed(255,255,120);
    if (estaticos.get(i).getEstado() > 0)randColorBlue(255,255,120);
    estaticos.get(i).show();
  }
  
  
  
  fill(192,192,192);
  int paredes_len = paredes.size();
  for (int i = 0; i < paredes_len; i++) paredes.get(i).show();
  //println(seconds);
  //println("cantidad vivos: "+puntos.size());
  //println(args[0]);
  if (seconds >= time){
    latex.setGraph(datos);
    latex.writeTex();
    latex.closeTex();
    //println("FUNCA????-----------------");
    //println("FUNCA????#####");
    for (int i=0; i <= time; i++) {
      println("Segundo: "+datos[0][i]+"   contagios: "+datos[1][i]);
    }
    
    exit();
  }
  //saveFrame("line-######.png");
}
//------------------------------------------------------------------------------------------------------------ EL FIIIIIIINNNNNNNNNNNNNNN---------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------ EL FIIIIIIINNNNNNNNNNNNNNN---------------------------------------------------------------

public void colectaPuntos() {
  puntos = new ArrayList<Punto>();
  
  for (int i = 0; i < puntos.size(); i++) {
    puntos.get(i).updateEstado();
  }
  
  for (int i = 0; i < rectos_len; i++) {
    if (rectos.get(i).getVida() == 1)puntos.add(rectos.get(i));
  }
  
  for (int i = 0; i < estacionales_len; i++) {
    if (estacionales.get(i).getVida() == 1)puntos.add(estacionales.get(i));
  }
  
  
  for (int i = 0; i < aleatorios_len; i++) {
    if (aleatorios.get(i).getVida() == 1)puntos.add(aleatorios.get(i));
  }
  
  for (int i = 0; i < estaticos_len; i++) {
    if (estaticos.get(i).getVida() == 1)puntos.add(estaticos.get(i));
  }
  
  for (int i = 0; i < puntos.size(); i++) {
    puntos.get(i).updateEstado();
  }
}

public void colision() {
  
  for (int i=0; i < puntos.size(); i++) {
    for (int j = i + 1; j < puntos.size(); j++) {

      if (i == j) continue;
      int r = puntos.get(i).getRadio();
      if ((puntos.get(i).getX() + r >= puntos.get(j).getX() - r && puntos.get(i).getX() - r <= puntos.get(j).getX() + r) && 
      (puntos.get(i).getY() + r >= puntos.get(j).getY() - r && puntos.get(i).getY() - r <= puntos.get(j).getY() + r)) {
        if(puntos.get(i).getEstado() == -1) {
          if (puntos.get(j).getEstado() == 0 || (puntos.get(j).getEstado() == 1 && reinfection > 0)) {
            float proba = random(0,100);
            if (proba < contagios[puntos.get(i).getTipo()][puntos.get(j).getTipo()]) {
              puntos.get(j).setEstado(-1);
            }
          }
        }
        else if (puntos.get(j).getEstado() == -1) {
          if (puntos.get(i).getEstado() == 0 || (puntos.get(i).getEstado() == 1 && reinfection > 0)) {
            float proba = random(0,100);
            if (proba < contagios[puntos.get(j).getTipo()][puntos.get(i).getTipo()]) {
              puntos.get(i).setEstado(-1);
            }
          }
        }
        else continue;
      }
    
    }
  } 
}

public void randColorRed(int x, int y, int z) {
  int r = int(random(0,100));
  if (r%2 == 0) fill(255,0,0);
  else fill(x,y,z);
}
public void randColorBlue(int x, int y, int z) {
  int r = int(random(0,100));
  if (r%2 == 0) fill(0,0,255);
  else fill(x,y,z);
}

public void getInfo() {
  background(0);//delay(100);
  
  rectos_len = rectos.size();
  estacionales_len = estacionales.size();
  aleatorios_len = aleatorios.size();
  estaticos_len = estaticos.size();
  
  fill(250,250,250);
  //println("LEGAAAAAAA111111111111111111111111");
  if (seconds <= 200){
    datos[0][seconds] = seconds;
    datos[1][seconds] = 0;
  }
  //println("LEGAAAAAAA222222222222222222222");
  
  for (int i = 0; i < rectos_len; i++) {
    fill(255,255,255);
    //rectos.get(i).updateEstado();
    if (rectos.get(i).getEstado() < 0){
      datos[1][seconds]++;
      fill(255,0,0);
    }
    else if (rectos.get(i).getEstado() > 0)fill(0,0,255);
    else fill(0,255,0);
    rectos.get(i).move();
  }
  
  for (int i = 0; i < estacionales_len; i++){
    fill(255,100,255);
    //estacionales.get(i).updateEstado();
    if (estacionales.get(i).getEstado() < 0){
      datos[1][seconds]++;
      fill(255,0,0);
    }
    else if (estacionales.get(i).getEstado() > 0)fill(0,0,255);
    else fill(0,255,0);
    estacionales.get(i).move();
  }
  
  
  for (int i = 0; i < aleatorios_len; i++) {
    fill(55,100,100);
    //aleatorios.get(i).updateEstado();
    if (aleatorios.get(i).getEstado() < 0){
      datos[1][seconds]++;
      fill(255,0,0);
    }
    else if (aleatorios.get(i).getEstado() > 0)fill(0,0,255);
    else fill(0,255,0);
    aleatorios.get(i).move();
    
  }
  
  for (int i = 0; i < estaticos_len; i++) {
    fill(255,255,120);
    //estaticos.get(i).updateEstado();
    if (estaticos.get(i).getEstado() < 0){
      datos[1][seconds]++;
      fill(255,0,0);
    }
    else if (estaticos.get(i).getEstado() > 0)fill(0,0,255);
    else fill(0,255,0);
    estaticos.get(i).show();
  }
  
  fill(192,192,192);
  int paredes_len = paredes.size();
  for (int i = 0; i < paredes_len; i++) paredes.get(i).show();
  
  String name = "img"+seconds;
  String png = ".png";
  
  saveFrame("../"+name+png);
  
  //String dims = "\\includegraphics[width=0.8\\textwidth]{"+name+png+"}";
  
  String s = "\\textbf{IMG seg: "+ seconds+"} \\\\ "+" \\centering \\includegraphics[width=0."+width+"\\textwidth,height=0."+height+"\\textwidth]{"+name+png+"}";
  latex.setCuerpo(s);
}
