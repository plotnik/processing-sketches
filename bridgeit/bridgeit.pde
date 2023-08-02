// размер клетки на доске
float step;

final char EMPTY = ' ';
final char RED   = '+';
final char BLUE  = '-';

// цвета
final int cBlue = #5831F5;
final int cRed  = #F53148;

final int radius = 10;

// количество клеток на поле
final int N = 11;

// расположение фигур на поле
char[][] b = new char[N][N];

// начальное расположение фигур на поле
String[] b0 = {
  " + + + + + ",
  "- - - - - -",
  " + + + + + ",
  "- - - - - -",
  " + + + + + ",
  "- - - - - -",
  " + + + + + ",
  "- - - - - -",
  " + + + + + ",
  "- - - - - -",
  " + + + + + "
};

// чей ход? 
// true: blue, false: red
boolean blueMove;

class Button {
  float d;
  float r;
  float d2;

  Button() {
    d = step/2;
    r = d/sqrt(2)/2-5;
    d2 = 2*d;
  }
  
  void draw() {
    fill(blueMove? cBlue : cRed);
    ellipse(d,d, d,d);
    stroke(150);
    line(d-r,d-r,d+r,d+r);
    line(d+r,d-r,d-r,d+r);
    stroke(0);
  }
  
  boolean clicked() {
      return mouseX < d2 && mouseY < d2; 
  }
}

Button reset;

void setup() {
  size(800, 800);
  step = height/N;
  
  reset = new Button();
  resetBoard();
  strokeWeight(2);
}

void resetBoard() {
  for (int x=0; x<N; x++) {
    for (int y=0; y<N; y++) {
      b[x][y] = b0[y].charAt(x);
    }
  }
  blueMove = true;
}

void draw() {

  background(255); 
  
  for (int i=0; i<N; i++) {
    for (int j=0; j<N; j++) {
      char c = b[i][j];
      float x = step*(i+0.5);
      float y = step*(j+0.5);
      int imod = i % 2;
      int jmod = j % 2;
      if (imod == 1 && jmod == 0) {
        fill(cBlue); stroke(cBlue);
        circle(x,y,radius);
      }
      if (imod == 0 && jmod == 1) {
        fill(cRed); stroke(cRed);
        circle(x,y,radius);
      }
      if (imod == jmod) {
        if (c == BLUE) {
          stroke(cBlue);
          if (imod == 0) {
            line(x-step,y,x+step,y);
          } else {
            line(x,y-step,x,y+step);
          }
        }
        if (c == RED) {
          stroke(cRed);
          if (imod == 0) {
            line(x,y-step,x,y+step);
          } else {
            line(x-step,y,x+step,y);
          }
        }
      }
    }
  }
  
  // кнопка reset
  reset.draw();
}

void mousePressed() {
  if (reset.clicked()) {
    resetBoard();
    return;
  }
  float x = map(mouseX, 0,width,  0,N);
  float y = map(mouseY, 0,height, 0,N);
  int i = round(x - 0.5);
  int j = round(y - 0.5);
  println(x,y);
  int imod = i % 2;
  int jmod = j % 2;
  if (imod == jmod) {
    char c = b[i][j];
    if (c == EMPTY) {
      if (blueMove) {
        if (i != 0 && i != N-1) {
          b[i][j] = BLUE;
        }
      } else {
        if (j != 0 && j != N-1) {
          b[i][j] = RED;
        }
      }
      if (b[i][j] != EMPTY) {
        blueMove = !blueMove;
      }
    }
  }
}
