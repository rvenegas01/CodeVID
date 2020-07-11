class Punto {
  int tipo_punto; // 0 recto, 1 estacional,2 aleatorio, 3 estático
  int coordenadas[]; // x, y
  int radio = 5;
  int vmax;
  int vmin;
  int estado;   //0 sano, -1 enfermo, 1 curado
  int conteo = 0; // segundos para vivir/morir
  int code_color; //colore del punto
  int vida; //0 es muerto, 1 es vivo
  float probaContagio;
  
  public Punto(int vmax,int vmin, int estado, int pxs_mtx[]) { // Crea punto en pocisión aleatoria [pxs_mtx es la cantidad de pixeles de la mtx]
    this.coordenadas = new int[2];
  
    this.coordenadas[0] = int(random(this.radio,pxs_mtx[0] - 10));
    this.coordenadas[1] = int(random(this.radio,pxs_mtx[1] - 10));
    this.estado = estado;
    this.vmax = vmax;
    this.vmin = vmin;
    this.probaContagio = random(1,99);
    this.vida = 1;
    
    if (estado == -1) conteo = 0;
  }
  
  public void updateEstado() {
    if (seconds - conteo == t_muerte && this.estado == -1) {
      float suerte = random(0,100);
      if (suerte <= muerte) {
        this.vida = 0;
      }
    }
    else if (seconds - conteo >= t_cura && this.estado == -1 && this.vida == 1) {
      this.estado = 1;
      this.vida = 1;
    }
  }
  
  public int getTipo() {
    return this.tipo_punto;
  }
  public int getX(){
    return this.coordenadas[0];
  }
  public int getY(){
    return this.coordenadas[1];
  }
  public int getRadio(){
    return this.radio;
  }
  public int getVmax(){
    return this.vmax;
  }
  public int getVmin(){
    return this.vmin;
  }
  public int getEstado(){
    return this.estado;
  }
  public int getColor() {
    return this.code_color;
  }
  public int getVida() {
    return this.vida;  
  }
  public void setEstado(int estado){
    this.estado = estado;
    if (this.estado == -1){
      this.conteo = seconds;
    }
  }
  public void serColor(int code_color) {
    this.code_color = code_color;
  }
  
}
// ------------------------------------------------------------------------------------------ RECTOS -----------------------------------------------------------------------------------------------------
class pRecto extends Punto {
  int velocidad[];// velocidad en x, velocidad en y.
  int direction[];// dirección en x, dirección en y.
  

  public pRecto(int vmax,int vmin,int estado,int pxs_mtx[]){ // Crea punto en pocisión aleatoria
    super(vmax,vmin,estado,pxs_mtx);
    
    this.direction = new int[2];
    this.direction[0] = 1;
    this.direction[1] = -1;
    
    this.velocidad = new int[2];
    this.velocidad[0] = int(random(this.vmin,this.vmax));
    this.velocidad[1] = this.velocidad[0];
    this.tipo_punto = 0;
  }
  

  
  public int[] getVelocidad(){
    return this.velocidad;
  }
  public int[] getDirection(){
    return this.direction;
  }
  
  public void move(){
    if (this.vida == 1){
      ellipse(this.coordenadas[0], this.coordenadas[1], this.radio, this.radio);
      
      this.coordenadas[0] += this.velocidad[0] * this.direction[0];
      if ((this.coordenadas[0] > width - this.radio) || (this.coordenadas[0] < this.radio)){
        this.direction[0] *= -1;
      }
      this.coordenadas[1] += this.velocidad[1] * this.direction[1];
      if ((this.coordenadas[1] > height - this.radio) || (this.coordenadas[1] < this.radio)){
        this.direction[1] *= -1;
      }
      
      for (int i=0; i<paredes.size(); i++) {
        Pared p = paredes.get(i);
        if ((this.coordenadas[0] >= p.getSupIzq()[0] - this.radio) && (this.coordenadas[0] - this.radio <= p.getInfDer()[0]) && (this.coordenadas[1] >= p.getSupIzq()[1] - this.radio) && (this.coordenadas[1] - this.radio <= p.getInfDer()[1])){
          if ((this.coordenadas[0] - (p.getSupIzq()[0] - this.radio) <= this.coordenadas[1] - (p.getSupIzq()[1] - this.radio)) || ((this.coordenadas[0] - p.getInfDer()[0]) >= (this.coordenadas[1] - p.getInfDer()[1]))) {
            this.direction[0] *= -1;
          }
          else this.direction[1] *= -1;
        } 
      }
    }
  }
}
// ------------------------------------------------------------------------------------------ ESTACIONALES -----------------------------------------------------------------------------------------------------
class pEstacional extends Punto {
  int velocidad[];// velocidad en x, velocidad en y.
  int direction[];// dirección en x, dirección en y.
  int ruta[][];
  int nextStop;
  int flag_reverse = 0; //0 sigue la ruta normal, 1 se duvuleve
  

  public pEstacional(int vmax,int vmin,int estado,int pxs_mtx[]){ // Crea punto en pocisión aleatoria
    super(vmax,vmin,estado,pxs_mtx);
    
    this.direction = new int[2];
    this.direction[0] = 1;
    this.direction[1] = -1;
    
    this.velocidad = new int[2];
    this.velocidad[0] = int(random(this.vmin,this.vmax));
    this.velocidad[1] = this.velocidad[0];
    
    this.ruta = new int [2][200];
    this.ruta[0][0] = coordenadas[0];
    this.ruta[1][0] = coordenadas[1];
    this.nextStop = 0;
    
    
    int signo = int(random(0,100));

    signo = rand(1,-1);
    //println("signo= "+signo);
    for (int i = 1; i < 40; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] + signo);
      this.ruta[1][i] = (this.ruta[1][i-1] + signo);
    }
    
   signo = rand(1,-1);
    //println("signo= "+signo);
    for (int i = 40; i < 80; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] + signo);
      this.ruta[1][i] = (this.ruta[1][i-1] - signo);
    }
    
    signo = rand(1,-1);
    //println("signo= "+signo);
    for (int i = 80; i < 120; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] - signo);
      this.ruta[1][i] = (this.ruta[1][i-1] + signo);
    }
    
    signo = rand(1,-1);
    //println("signo= "+signo);
    for (int i = 120; i < 160; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] - signo);
      this.ruta[1][i] = (this.ruta[1][i-1] - signo);
    }
    
    signo = rand(1,-1);
    for (int i = 160; i < 200; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] - signo);
      this.ruta[1][i] = (this.ruta[1][i-1] - signo);
    }
    
    this.tipo_punto = 1;
  }
  
  public int rand(int a, int b) {
    int r = int(random(0,100));
    if (r%2 == 0) return a;
    return b;
  }

  public int[] getVelocidad(){
    return this.velocidad;
  }
  public int[] getDirection(){
    return this.direction;
  }
  
  public void move(){
    if (this.vida == 1){
    
    
      if (this.nextStop % 200 < this.nextStop) {
        this.flag_reverse = 1;
        this.nextStop --;
      }
      //this.nextStop = this.nextStop % 80;
      if (this.nextStop < 0) {
        this.flag_reverse = 0;
        this.nextStop = 0;
      }
      
      ellipse(this.ruta[0][this.nextStop], this.ruta[1][this.nextStop], this.radio, this.radio);
      this.coordenadas[0] = this.ruta[0][this.nextStop];
      this.coordenadas[1] = this.ruta[1][this.nextStop];
      
      
      
      if ((this.ruta[0][this.nextStop] > width - this.radio) || (this.ruta[0][this.nextStop] < this.radio)){
        this.flag_reverse = 1;
      }
      
      if ((this.ruta[1][this.nextStop] > height - this.radio) || (this.ruta[1][this.nextStop] < this.radio)){
        this.flag_reverse = 1;
      }
      
      for (int i=0; i<paredes.size(); i++) {
        Pared p = paredes.get(i);
        
        //this.coordenadas[0] += this.velocidad[0] * this.direction[0];
        //this.coordenadas[1] += this.velocidad[1] * this.direction[1];
        if ((this.ruta[0][this.nextStop] >= p.getSupIzq()[0] - this.radio) && (this.ruta[0][this.nextStop] <= p.getInfDer()[0] + this.radio) && (this.ruta[1][this.nextStop] >= p.getSupIzq()[1] - this.radio) && (this.ruta[1][this.nextStop] <= p.getInfDer()[1] + this.radio)){
          this.flag_reverse = 1;
        }
      }
      
      if (this.flag_reverse == 1) this.nextStop--;
      else this.nextStop++;
    }

  }
}
// ------------------------------------------------------------------------------------------ ALEATORIOS -----------------------------------------------------------------------------------------------------
class pAleatorio extends Punto {
  int velocidad[];// velocidad en x, velocidad en y.
  int direction[];// dirección en x, dirección en y.
  int ruta[][];
  int nextStop;
  
  public pAleatorio(int vmax,int vmin,int estado,int pxs_mtx[]){ // Crea punto en pocisión aleatoria
    super(vmax,vmin,estado,pxs_mtx);
    
    this.direction = new int[2];
    this.direction[0] = 1;
    this.direction[1] = -1;
    
    this.velocidad = new int[2];
    this.velocidad[0] = int(random(this.vmin,this.vmax));
    this.velocidad[1] = this.velocidad[0];
    
    this.ruta = new int [2][200];
    generateRuta(coordenadas[0],coordenadas[1]);
    
    
    this.tipo_punto = 2;
  }
  
  public int[] getVelocidad(){
    return this.velocidad;
  }
  public int[] getDirection(){
    return this.direction;
  }
  public void setDirection(int dirX, int dirY){ //Cambiar la dirección del puntos aleatorio
    this.direction[0] = dirX;
    this.direction[1] = dirY;
  }
  
  public int rand(int a, int b) {
    int r = int(random(0,100));
    if (r%2 == 0) return a;
    return b;
  }
  
    public void move(){
    if (this.vida == 1){

      
      if (this.nextStop >= 200) {
        //println("EStaaaaaaa murieeendooooo");
        generateRuta(this.ruta[0][199], this.ruta[1][199]);
      }
    
      ellipse(this.ruta[0][this.nextStop], this.ruta[1][this.nextStop], this.radio, this.radio);
      this.coordenadas[0] = this.ruta[0][this.nextStop];
      this.coordenadas[1] = this.ruta[1][this.nextStop];
      
      
      
      if ((this.ruta[0][this.nextStop] > width - this.radio) || (this.ruta[0][this.nextStop] < this.radio)){
        generateRuta(this.ruta[0][this.nextStop-1], this.ruta[1][this.nextStop-1]);

      }
      
      if ((this.ruta[1][this.nextStop] > height - this.radio) || (this.ruta[1][this.nextStop] < this.radio)){
        generateRuta(this.ruta[0][this.nextStop-1], this.ruta[1][this.nextStop-1]);

      }
      
      for (int i=0; i<paredes.size(); i++) {
        Pared p = paredes.get(i);
        
        //this.coordenadas[0] += this.velocidad[0] * this.direction[0];
        //this.coordenadas[1] += this.velocidad[1] * this.direction[1];
        if ((this.ruta[0][this.nextStop] >= p.getSupIzq()[0] - this.radio) && (this.ruta[0][this.nextStop] <= p.getInfDer()[0] + this.radio) && (this.ruta[1][this.nextStop] >= p.getSupIzq()[1] - this.radio) && (this.ruta[1][this.nextStop] <= p.getInfDer()[1] + this.radio)){
          generateRuta(this.ruta[0][this.nextStop-1], this.ruta[1][this.nextStop-1]);

        }
      }
      
      this.nextStop++;
    }

  }
  
  public void generateRuta(int ceroX, int ceroY) {
    
    this.ruta = new int [2][200];
    this.nextStop = 1;
    this.ruta[0][0] = ceroX;
    this.ruta[1][0] = ceroY;
    
    int signo = int(random(0,100));

    signo = rand(1,-1);
    //println("signo= "+signo);
    for (int i = 1; i < 40; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] + signo  * rand(rand(rand(-1,1),1),1));
      this.ruta[1][i] = (this.ruta[1][i-1] + signo  * rand(rand(rand(-1,1),1),1));
    }
    
   signo = rand(1,-1);
    //println("signo= "+signo);
    for (int i = 40; i < 80; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] + signo * rand(rand(rand(-1,1),1),1));
      this.ruta[1][i] = (this.ruta[1][i-1] - signo * rand(rand(rand(-1,1),1),1));
    }
    
    signo = rand(1,-1);
    //println("signo= "+signo);
    for (int i = 80; i < 120; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] - signo * rand(rand(rand(-1,1),1),1));
      this.ruta[1][i] = (this.ruta[1][i-1] + signo * rand(rand(rand(-1,1),1),1));
    }
    
    signo = rand(1,-1);
    //println("signo= "+signo);
    for (int i = 120; i < 160; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] - signo * rand(rand(rand(-1,1),1),1));
      this.ruta[1][i] = (this.ruta[1][i-1] - signo * rand(rand(rand(-1,1),1),1));
    }
    
    signo = rand(1,-1);
    for (int i = 160; i < 200; i++) {
      
      this.ruta[0][i] = (this.ruta[0][i-1] - signo * rand(rand(rand(-1,1),1),1));
      this.ruta[1][i] = (this.ruta[1][i-1] - signo * rand(rand(rand(-1,1),1),1));
    }
  }
  
}
// ------------------------------------------------------------------------------------------ Estaticos -----------------------------------------------------------------------------------------------------
class pEstatico extends Punto {
  
  public pEstatico(int vmax,int vmin,int estado,int pxs_mtx[]){ // Crea punto en pocisión aleatoria
    super(vmax,vmin,estado,pxs_mtx);
    this.tipo_punto = 3;
  }
  
  public void show(){
    if (this.vida == 1){
      ellipse(this.coordenadas[0],this.coordenadas[1], this.radio, this.radio);
    }
  }
}
