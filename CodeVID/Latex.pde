final class Tex{
  PrintWriter mainTex; 

  String header = "\\documentclass[a4 paper]{article} "
  + "\\usepackage{tikz,pgfplots} "
  + "\\usepackage[pdftex]{graphicx} ";
  
  String graph;
  String inicio = " \\begin{document} ";
  ArrayList<String> cuerpo;
  String end = "\\end{document} ";
  
  public Tex() {
    //macroTex = createWriter("macros.tex");
    mainTex = createWriter("main.tex");
    this.cuerpo = new ArrayList<String>();
 
  }
  public void writeTex() {
    //this.macroTex.println(macro);
    this.mainTex.println(header);
    this.mainTex.println(inicio);
    /*
    this.mainTex.println("\n\n\n");
    this.mainTex.println("\\textbf{Qué pasa???!!!}");
    this.mainTex.println("\n\n\n");*/
    
    this.mainTex.println("\\centering \\textbf{OUTPUT:} \\");
    
    this.mainTex.println("\n\n\n\n");
    
    for (int i = 0; i<cuerpo.size(); i++) {
      this.mainTex.println(cuerpo.get(i));
       this.mainTex.println("\n\n\n\n");
    }
    this.mainTex.println(graph);
    this.mainTex.println(end);
  }
  public void closeTex() {
    //macroTex.flush();  // Writes the remaining data to the file
    //macroTex.close();  // Finishes the file
    
    mainTex.flush();  // Writes the remaining data to the file
    mainTex.close();  // Finishes the file
    //return 1;
  }

  
  public ArrayList<String> getCuerpo() {
    return this.cuerpo;
  }
  public void setCuerpo(String s) {
    this.cuerpo.add(s);
  }
  public void setGraph(int[][] datos) {
    int pico = datos[1][0];
    String xtick = "";
    String ytick = "";
    String coordinates = "";
    int tot = time+1;
    
    for (int i=0;i<time+1; i++) {
      if (datos[1][i]>pico) pico = datos[1][i];
      xtick += datos[0][i];
      ytick += datos[1][i];
      if (i<time) {
        xtick += ",";
        ytick += ",";
      }
      coordinates += "("+datos[0][i]+","+datos[1][i]+")";
    }
    println("pico: "+pico);
    println("xtick: "+xtick);
    println("ytick: "+ytick);
    println("coordinates: "+coordinates);
    
      this.graph = " \\begin{figure} "
      + "\\begin{tikzpicture} "
      + "\\begin{axis} "
      + "[ "
      + "width=15cm, height=15cm, xmin=0, xmax="+tot+", ymin=0, ymax="+pico+", xlabel={Tiempo}, ylabel={Infectados},xmajorgrids=true, ymajorgrids=true, xtick={"+xtick+"}, xticklabels={"+xtick+"}, ytick={"+ytick+"}, yticklabels={"+ytick+"} "
      + "] "
      + "\\addplot[color=red]coordinates {"+coordinates+" "
      + "    };\\addlegendentry{Avance del virus}; "
      + "\\end{axis} "
      + "\\end{tikzpicture} "
      + "\\caption{Diagrama Final} "
      + "\\end{figure} ";
  }

}
