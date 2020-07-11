final class Pared{
  int sup_izq[];
  int inf_der[];
  
  public Pared(int x1, int y1, int x2, int y2){
    this.sup_izq = new int[2];
    this.inf_der = new int[2];
    
    this.sup_izq[0] = x1;
    this.sup_izq[1] = y1;
    
    this.inf_der[0] = x2;
    this.inf_der[1] = y2;
  }
  
  public int[] getSupIzq(){
    return this.sup_izq;
  }
  public int[] getInfDer(){
    return this.inf_der;
  }
  
  public void show() {
    rectMode(CORNERS);
    
    rect(this.sup_izq[0], this.sup_izq[1], this.inf_der[0], this.inf_der[1]);
  }
}
