import java.util.Stack;
import processing.pdf.*;

color wallCol = color(0, 0, 0);
color checkedCol = color(255, 255, 255);

float wallWidth = 1;

int gridWidth = 500;
int gridHeight = 500;

Cell[][] cells;

Cell activeCell;

Stack<Cell> stack;

void setup() {
  size(1000, 1000);
  cells = new Cell[gridWidth][gridHeight];
  for (int x=0; x<gridWidth; x++){
    for (int y=0; y<gridHeight; y++){
      cells[x][y] = new Cell(x, y);
    }
  }
  activeCell = cells[0][0];
  activeCell.checked = true;
  
  stack = new Stack<Cell>();
  
  beginRecord(PDF, "maze.pdf");
}

void draw() {
  noLoop();
  float cellWidth = width/float(gridWidth);
  float cellHeight = height/float(gridHeight);
  boolean complete = false;
    
  while (!complete){
    ArrayList<Cell> neighbours = new ArrayList<Cell>();
    if (activeCell.x > 0){
      if (!cells[activeCell.x-1][activeCell.y].checked){
        neighbours.add(cells[activeCell.x-1][activeCell.y]);
      }
    }
    if (activeCell.x < gridWidth-1){
      if (!cells[activeCell.x+1][activeCell.y].checked){
        neighbours.add(cells[activeCell.x+1][activeCell.y]);
      }
    }
    if (activeCell.y > 0){
      if (!cells[activeCell.x][activeCell.y-1].checked){
        neighbours.add(cells[activeCell.x][activeCell.y-1]);
      }
    }
    if (activeCell.y < gridHeight-1){
      if (!cells[activeCell.x][activeCell.y+1].checked){
        neighbours.add(cells[activeCell.x][activeCell.y+1]);
      }
    }
    if (neighbours.size() > 0){
      Cell chosen = neighbours.get(int(random(neighbours.size())));
      stack.push(activeCell);
      
      if (chosen.x < activeCell.x){
        chosen.walls[1] = false;
        activeCell.walls[0] = false;
      } else if (chosen.x > activeCell.x){
        chosen.walls[0] = false;
        activeCell.walls[1] = false;
      } else if (chosen.y < activeCell.y){
        chosen.walls[3] = false;
        activeCell.walls[2] = false;
      } else {
        chosen.walls[2] = false;
        activeCell.walls[3] = false;
      }
      activeCell = chosen;
      activeCell.checked = true;
    } else if (stack.size() > 0){
      activeCell = stack.pop();
    }
    complete = true;
    for (int x=0; x<gridWidth; x++){
      for (int y=0; y<gridHeight; y++){
        if (!cells[x][y].checked){
          complete = false;
        }
      }
    }
  }
  for (int x=0; x<gridWidth; x++){
    for (int y=0; y<gridHeight; y++){
      Cell cell = cells[x][y];
      noStroke();
      fill(checkedCol);
      rect(x*cellWidth, y*cellHeight, cellWidth, cellHeight);
      stroke(wallCol);
      strokeWeight(wallWidth);
      if (cell.walls[0]){
        line(x*cellWidth, y*cellHeight, x*cellWidth, (y+1)*cellHeight);
      }
      if (cell.walls[1]){
        line((x+1)*cellWidth, y*cellHeight, (x+1)*cellWidth, (y+1)*cellHeight);
      }
      if (cell.walls[2]) {
        line(x*cellWidth, y*cellHeight, (x+1)*cellWidth, y*cellHeight);
      }
      if (cell.walls[3]) {
        line(x*cellWidth, (y+1)*cellHeight, (x+1)*cellWidth, (y+1)*cellHeight);
      }
    }
  }
  endRecord();
  println("done");
}
