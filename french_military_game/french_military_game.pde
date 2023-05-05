// размер клетки на доске
float step;

// диаметр поля
float d1;

// диаметр фишки
float d2;

final int EMPTY = 0;
final int WHITE = 1;
final int BLACK = 2;

// количество клеток на поле
final int N = 11;

// расположение фигур на поле
int[] b = new int[N];

// начальное расположение фигур на поле
int[] b0 = {
     0,    // 0
  0, 0, 0, // 1 2 3
  0, 2, 0, // 4 5 6
  1, 0, 1, // 7 8 9
     1     // 10
};

// Возможные ходы для белых (только вперед).
int[][] m = {
  {},
  {0,2},   {0,1,3},      {0,2},
  {1,5},   {1,2,3, 4,6}, {3,5},
  {4,5,8}, {7,5,9},      {6,5,8},
  {7,8,9}
};

// Возможные ходы для черных (также назад)
int[][] mb = {
  {1,2,3},
  {4,5}, {5},     {5,6},
  {7},   {7,8,9}, {9},
  {10},  {10},    {10},
  {}
};

int[] xp = {
  2,
  1,2,3,
  1,2,3,
  1,2,3,
  2
};

int[] yp = {
  1,
  2,2,2,
  3,3,3,
  4,4,4,
  5
};

// чей ход? 
// true: white, false: black
boolean whiteMove;

// какая фишка сейчас выбрана?
// (-1 если никакая)
int nsel = -1;

// цвет выбранной фишки
int bsel;

// координаты фишки, которую тянут
int xdrag, ydrag;


class Button {
  float d;
  float r;
  float d2;

  Button() {
    d = step/5;
    r = d/sqrt(2)/2-5;
    d2 = 2*d;
  }
  
  void draw() {
    fill(whiteMove? 220 : 0);
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
  size(533, 800);
  step = height/6;
  d1 = step*0.75;
  d2 = d1*0.75;
  reset = new Button();
  resetBoard();
  strokeWeight(2);
}

void resetBoard() {
  for (int i=0; i<N; i++) {
    b[i] = b0[i];
  }
  whiteMove = true;
}

void draw() {

  background(255); //color('#f8f4d0'));
  // нарисовать сетку
  for (int i=0; i<N; i++) {
    int[] p = m[i];
    for (int j=0; j<p.length; j++) {
      float x1 = step*xp[i];
      float y1 = step*yp[i];
      float x2 = step*xp[p[j]];
      float y2 = step*yp[p[j]];
      line(x1,y1,x2,y2);
    }
  }
  
  // нарисовать поля
  for (int i=0; i<N; i++) {
    float xc = step*xp[i];
    float yc = step*yp[i];
    fill(255);
    ellipse(xc,yc, d1,d1);
    if (b[i] != EMPTY) {
      drawPiece(xc,yc, b[i]);
    } 
  }
  
  // фишка которую тянут
  if (nsel != -1) {
    drawPiece(xdrag,ydrag, bsel);
  }
  
  // кнопка reset
  reset.draw();
}

void drawPiece(float xc, float yc, int cell) {
  fill(cell == WHITE? 220 : 0);
  ellipse(xc,yc, d2,d2);
  stroke(150);
  float d = d2;
  for (int i=0; i<2; i++) {
    d *= 0.8;
    ellipse(xc,yc, d,d);
  }
  stroke(0);
}

// номер поля, на которое сейчас указывает мышь
int mouseCell() {
  int x = round(map(mouseX, 0,width,  0,4));
  int y = round(map(mouseY, 0,height, 0,6));
  if (x == 0 || x == 4 || y == 0 || y == 6) {
    return -1;
  }
  int k = y*3 + x;
  return (k >= 7 && k <=15)? k - 6 : (k == 5)? 0 : (k == 17)? 10 : -1;
}

void mousePressed() {
  if (reset.clicked()) {
    resetBoard();
    return;
  }
  nsel = mouseCell();
  if (nsel == -1) {
    return;
  }
  // проверить что взята фишка соотв. цвета
  if (!(whiteMove && b[nsel] == WHITE || !whiteMove && b[nsel] == BLACK)) {
    nsel = -1;
    return;
  }
  xdrag = mouseX;
  ydrag = mouseY;
  bsel = b[nsel];
  b[nsel] = EMPTY;
}

void mouseDragged() {
  if (nsel != -1) {
    xdrag = mouseX;
    ydrag = mouseY;
  }
}

void mouseReleased() {
  if (nsel == -1) {
    return;
  }
  // определить координаты нажатой клетки
  int n = mouseCell();
  if (n != -1 && canMove(nsel,n)) {
    b[n] = bsel;
    whiteMove = !whiteMove;
  } else {
    b[nsel] = bsel;
  }
  nsel = -1;
}

boolean canMove(int n1, int n2) {
  if (b[n2] != EMPTY) {
    return false;
  }  
  if (arrayContains(m[n1], n2)) {
    return true;
  }
  if (!whiteMove && arrayContains(mb[n1], n2)) {
    return true;
  }
  return false;
}

boolean arrayContains(int[] arr, int n) {
  for (int i=0; i<arr.length; i++) {
    if (arr[i] == n) {
      return true;
    }
  }
  return false;
}
