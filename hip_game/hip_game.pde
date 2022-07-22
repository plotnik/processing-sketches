// начальное расположение фигур на поле
final String[] b0 = {
  "    * ", 
  "  *   ", 
  "**x * ", 
  "  * x ", 
  " x  * ", 
  "   x  "
};

// размер поля
final int N = 6;

// расположение фигур на поле
char[][] b = new char[N][N];

final char A = '*';
final char B = 'x';
final char Z = ' ';

// цвета
final int cWhite = 255;
final int cBlack = 128;
final int cRed = #FA5656;
final int cA = #3D3CBF;
final int cB = #DCEA21;

// размер клетки на доске
float step;

// диаметр фишки
float d;

final int GAME_A_MOVE = 1;
final int GAME_B_MOVE = 2;
final int GAME_A_WIN  = 3;
final int GAME_B_WIN  = 4;

// Текущее состояние игры
int gameScreen;

// текущий список квадратов
ArrayList<Square> squares = new ArrayList();

class Point {
  int x;
  int y;
  
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  String toString() {
    return "("+x+","+y+")";
  }
}

class Square {
  Point a;
  Point b;
  Point c;
  Point d;
  
  Square(Point a, Point b, Point c, Point d) {
    this.a = a;
    this.b = b;
    this.c = d;
    this.d = c;
  }
  
  boolean isSquare() {
    /*
    int xc = a.x + b.x + c.x + d.x;
    int yc = a.y + b.y + c.y + d.y;
    int ac = sqr(4*a.x - xc) + sqr(4*a.y - yc);
    int bc = sqr(4*b.x - xc) + sqr(4*b.y - yc);
    int cc = sqr(4*c.x - xc) + sqr(4*c.y - yc);
    int dc = sqr(4*d.x - xc) + sqr(4*d.y - yc);
    return (ac==bc) && (bc==cc) && (cc==dc);
    */ //<>//
  }
   //<>//
  String toString() {
    return "<"+a+"-"+b+"-"+c+"-"+d+">";
  }
}

void setup() {
  size(800, 800);
  step = width/N;
  d = step*0.75;
  resetBoard();
}

ArrayList<Square> findSquares(ArrayList<Point> list) {
  ArrayList<Square> result = new ArrayList();
  for (int a=0; a<list.size()-3; a++) {
    for (int b=a+1; b<list.size()-2; b++) {
      for (int c=b+1; c<list.size()-1; c++) {
        for (int d=c+1; d<list.size(); d++) {
          Square sq = new Square(list.get(a), list.get(b), list.get(c), list.get(d));
          if (sq.isSquare()) {
            result.add(sq);
          }
        }
      }
    }
  }  
  return result;
}

int sqr(int x) {
  return x*x;
}

int mag(Point a, Point b) {
  return sqr(a.x-b.x)+sqr(a.y-b.y);
}

// начальное заполнение доски
void resetBoard() {
  for (int x=0; x<N; x++) {
    for (int y=0; y<N; y++) {
      b[x][y] = b0[y].charAt(x);
    }
  }
  gameScreen = GAME_A_MOVE;
}

ArrayList<Point> calcList(char ch) {
  ArrayList<Point> result = new ArrayList();  
  for (int x=0; x<N; x++) {
    for (int y=0; y<N; y++) {   
      if (b[x][y] == ch) {
        result.add(new Point(x, y));
      }
    }
  }
  return result;
}

void draw() {
  background(255);
  drawGameScreen();
  
  switch (gameScreen) {
    case GAME_A_MOVE: 
    case GAME_B_MOVE: 
      break;
    case GAME_A_WIN:
      drawClickToRestart("Blue Wins!");
      break;
    case GAME_B_WIN:
      drawClickToRestart("Yellow Wins!");
      break;
    }
}

void drawClickToRestart(String message) {
  println("drawClickToRestart");
  fill(0);
  textAlign(CENTER);
  textSize(70);
  text(message, width/2, height/2 - 20);
  textSize(15);
  text("Click to Restart", width/2, height-30);
}

void drawGameScreen() {
  for (int x=0; x<N; x++) {
    float xp = x*step;
    for (int y=0; y<N; y++) {
      float yp = y*step;
      char cell = b[x][y];

      // нарисовать квадрат поля
      fill((x + y) % 2 == 0? cWhite : cBlack);
      stroke(cBlack);
      rect(xp, yp, xp+step, yp+step);

      // нарисовать фигуры
      if (cell == A || cell == B) {
        drawPieceAsPoint(xp+step/2, yp+step/2, cell);
      }
    }
  }
  
  stroke(cRed);
  strokeWeight(10);
  for (int k=0; k<squares.size(); k++) {
    Square p = squares.get(k);
    pline(p.a, p.b);
    pline(p.b, p.c);
    pline(p.c, p.d);
    pline(p.a, p.d);
  }
  strokeWeight(1);
}

void pline(Point a, Point b) {
    line(ks(a.x),ks(a.y),ks(b.x),ks(b.y));
}

float ks(int n) {
  return step*(n+0.5);
}

void drawPieceAsPoint(float xp, float yp, char cell) {
  fill(cell == A? cA : cB);
  stroke(0);
  ellipse(xp, yp, d, d);
}

void mousePressed() {
  switch (gameScreen) {
    case GAME_A_MOVE: 
      mousePressedInGame(A);
      break;
    case GAME_B_MOVE: 
      mousePressedInGame(B);
      break;
    case GAME_A_WIN:
      resetBoard(); //<>//
      break;
    case GAME_B_WIN:
      resetBoard();
      break;
  }
}

void mousePressedInGame(char ch) {
  // Определим координаты нажатой клетки
  int x = floor(map(mouseX, 0,width,  0,N));
  int y = floor(map(mouseY, 0,height, 0,N));
  println("|" + ch + "|" + b[y][x] + "| mousePressedInGame " + new Point(x,y));
  if (b[x][y] == Z) {
    b[x][y] = ch;
    
    ArrayList<Point> list = calcList(ch);
    squares = findSquares(list);
    if (ch == A) { 
      if (squares.size()==0) {
          gameScreen = GAME_B_MOVE;
      } else {
          println(squares.get(0));
          gameScreen = GAME_B_WIN;
      }
    }
    if (ch == B) {
      if (squares.size()==0) {
          gameScreen = GAME_A_MOVE;
      } else {
          println(squares.get(0));
          gameScreen = GAME_A_WIN;
      }
    }
  }
}
