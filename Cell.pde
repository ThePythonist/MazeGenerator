class Cell {
    
  int x;
  int y;
  
  boolean[] walls = {true, true, true, true};
  
  boolean checked = false;
    
  public Cell(int x, int y){
    this.x = x;
    this.y = y;
  }
  
}
