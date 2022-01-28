final boolean useImages = true;
PImage foxImage, henImage;

// размер клетки на доске
float step;

// диаметр фишки
float d;

void setup() {
  size(800, 800);
  step = width/7;
  d = step*0.75;
  
  if (useImages) {
    foxImage = loadImage("fox.png");
    henImage = loadImage("hen.png");
  }
  resetBoard();
}

// начальное расположение фигур на поле
final String[] b0 = {
  "  ...  ",
  "  ...  ",
  "..*.*..",
  "xxxxxxx",
  "xxxxxxx",
  "  xxx  ",
  "  xxx  "
};

// размер поля
final int N = 7;

// расположение фигур на поле
char[][] b = new char[N][N];

final char SPC = ' ';
final char EMP = '.';
final char FOX = '*';
final char HEN = 'x';
// цвета
final int cGrass = #22A517;
final int cFox = #EDB437;
final int cHen = 128;

final int GAME_IN_PROCESS = 1;
final int GAME_HENS_WIN = 2;
final int GAME_FOXES_WIN = 3;

/* Текущее состояние игры.
   1: игра в процессе
   2: выи��рали курицы
   3: выиграли лисы
 */
int gameScreen;

// какая фишка сейчас выбрана?
// (-1 если никакая)
int xsel = -1;
int ysel = -1;

// позиция первой и второй лисы
int[] xf = new int[2];
int[] yf = new int[2];

// координаты фишки, которую тянут
int xdrag, ydrag;

// возможный ход лисы с прыжками
class FoxJumps {

  // номер лисы
  int n;

  // последовательность прыжков в обратном порядке
  int[] m;

  FoxJumps(int n, int[] m) {
    this.n = n;
    this.m = m;
  }
}

final int COMMAND_DELAY     = 1;
final int COMMAND_MOVE      = 2;
final int COMMAND_JUMP      = 3;
final int COMMAND_HENS_WIN  = 4;
final int COMMAND_FOXES_WIN = 5;

/* Отложення команда.
   Смысл параметров `n` и `d` зависит от типа команды.
 */
class Command {
    // тип комнды
    int type;
    
    int n;
    int d;
}

// стек команд 
ArrayList<Command> commandStack = new ArrayList<Command>();

// задержка анимации
int anidelay = 0;

// начальное заполнение доски
void resetBoard() {
  int curFox = 0;	
  for (int x=0; x<N; x++) {
    for (int y=0; y<N; y++) {
      b[x][y] = b0[y].charAt(x);

      // зафиксировать положение лис
      if (b[x][y] == FOX) {
        xf[curFox] = x;
        yf[curFox] = y;
        curFox++;
      }
    }
  }
  gameScreen = GAME_IN_PROCESS;
}

Command popCommand() {
    int k = commandStack.size()-1;
    Command c = commandStack.get(k);
    commandStack.remove(k);
    return c;
}

void pushCommand(int t, int n, int d) {
    Command c = new Command();
    c.type = t;
    c.n = n;
    c.d = d;
    commandStack.add(c);
}

void pushDelay() {
    pushCommand(COMMAND_DELAY, 50, 0);
}

void draw() {
  
  // Если есть команда, то отрабатываем ее
  if (commandStack.size() > 0) {
      Command c = popCommand();
      switch (c.type) {
        case COMMAND_DELAY:
            anidelay = c.n;
            break;
            
        case COMMAND_MOVE:
            makeFoxMove(c.n, c.d);
            break;
            
        case COMMAND_JUMP:   
            makeFoxJump(c.n, c.d);
            break;
            
        case COMMAND_HENS_WIN:
            gameScreen = GAME_HENS_WIN;
            break;

        case COMMAND_FOXES_WIN:
            gameScreen = GAME_FOXES_WIN;
            break;
      }
  }
  
  // Если есть задержка, то отрабатываем ее
  if (anidelay > 0) {
    anidelay--;
    return;
  }

  background(255);

  switch (gameScreen) {
    case GAME_IN_PROCESS: 
      drawGameScreen();
      break;
    case GAME_HENS_WIN:
      drawClickToRestart(cHen, "Hens Win!");
      break;
    case GAME_FOXES_WIN:
      drawClickToRestart(cFox, "Foxes Win!");
      break;
    }
}

void drawClickToRestart(int c, String message) {
  background(c);
  textAlign(CENTER);
  fill(236, 240, 241);
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
      fill(cell == SPC? cGrass : 255);
      stroke(cGrass);
      rect(xp,yp,xp+step,yp+step);

      // нарисовать лис и кур
      if (cell == FOX || cell == HEN) {
        if (!(xsel == x && ysel==y)) {
          if (useImages) {      
            drawPieceAsImage(xp+step/2,yp+step/2,cell);
          } else {
            drawPieceAsVector(xp+step/2,yp+step/2,cell);
          }
        }
      }
    }
  }

  // фишка которую тянут
  if (xsel != -1) {
      if (useImages) {
        drawPieceAsImage(xdrag,ydrag,HEN);
      } else {
        drawPieceAsVector(xdrag,ydrag,HEN);
      }
  }
}

void drawPieceAsImage(float xp, float yp, char cell) {
    imageMode(CENTER); 
    image(cell == FOX? foxImage : henImage, xp,yp,d,d);
}

void drawPieceAsVector(float xp, float yp, char cell) {
    fill(cell == FOX? cFox : cHen);
    stroke(0);
    ellipse(xp,yp,d,d);
}

void mousePressed() {
  switch (gameScreen) {
    case GAME_IN_PROCESS: 
      mousePressedInGame();
      break;
    case GAME_HENS_WIN:
      resetBoard();
      break;
    case GAME_FOXES_WIN:
      resetBoard();
      break;
  }
}

void mousePressedInGame() {
  // Определим координаты нажатой клетки
  int x = floor(map(mouseX, 0,width,  0,7));
  int y = floor(map(mouseY, 0,height, 0,7));
  if (b[x][y] == HEN) {
    xsel = x;
    ysel = y;
    xdrag = mouseX;
    ydrag = mouseY;
  }
}

void mouseDragged() {
  if (xsel != -1) {
    xdrag = mouseX;
    ydrag = mouseY;
  }
}

void mouseReleased() {
  // определить координаты нажатой клетки
  int x = floor(map(mouseX, 0,width,  0,7));
  int y = floor(map(mouseY, 0,height, 0,7));
  
  // проверить допустимость хода
  if (b[x][y] == EMP && possibleHenMove(x,y,xsel,ysel)) {
    // совершить ход курицы
    b[x][y] = HEN;
    b[xsel][ysel] = EMP;
    
    // Куры выигрывают, если им удается занять верхний квадрат игры.
    if (hensWon()) {
        pushCommand(COMMAND_HENS_WIN,0,0);
        pushDelay();
        
    } else { 
        // совершить ход лисы
        foxMove();
    }
  }
  xsel = -1;
}

boolean hensWon() {
    final String[] hw = {
      "  xxx  ",
      "  xxx  ",
      "..xxx..",
      ".......",
      ".......",
      "  ...  ",
      "  ...  "
    };
    for (int x=0; x<N; x++) {
        for (int y=0; y<N; y++) {
          if (hw[y].charAt(x) == HEN) {
            if (b[x][y] != HEN) {
                return false;
            }
          }
        }
    }
    return true;
}

boolean possibleHenMove(int x1, int y1, int x2, int y2) {
  if (x1 == x2 && y2 == y1 + 1) {
    return true;
  }
  if (y1 == y2 && (x1 == x2 + 1 || x1 == x2 - 1)) {
    return true;
  }
  return false;
}

/* Совершить следующий ход одной из лис */
void foxMove() {
  /* Собрать полный набор максимально длинных прыжков */
  int maxlen = 1;
  
  // список максимально длинных ходов лис 
  ArrayList<FoxJumps> mm = new ArrayList<FoxJumps>();
  
  // цикл по номерам лис
  for (int i=0; i<2; i++) {
    IntList stack = new IntList();
    ArrayList<int[]> jj = new ArrayList<int[]>();
    collectFoxJumps(xf[i],yf[i],stack,jj);

    for (int[] ii: jj) {
      if (ii.length > maxlen) {
        // если найден более длинный ход, то сбрсываем список
        maxlen = ii.length;
        mm = new ArrayList<FoxJumps>();
        mm.add(new FoxJumps(i,ii));
      } else
      if (ii.length == maxlen) {
        mm.add(new FoxJumps(i,ii));
      }
    }
  }

  /* Выбрать случайную цепочку из максимально длинных прыжков */
  if (mm.size() > 0) {
    int r = int(random(mm.size()));

    // вызвать анимацию для цепочки прыжков
    FoxJumps jumps = mm.get(r);
    for (int k=0; k<jumps.m.length; k++) {
        pushDelay();
        pushCommand(COMMAND_JUMP, jumps.n, jumps.m[k]);
    }

  } else {
    // случайным образом выбрать один из оставшихся
    // ходов для одной из лис
    int[] m0 = findFoxMoves(xf[0],yf[0]).array();
    int[] m1 = findFoxMoves(xf[1],yf[1]).array();
    if (m0.length == 0 && m1.length == 0) {
      pushCommand(COMMAND_HENS_WIN,0,0);
      pushDelay();
      
    } else {
      int k = int(random(m0.length + m1.length));
      if (k < m0.length) {
        makeFoxMove(0, m0[k]);
      } else {
        makeFoxMove(1, m1[k - m0.length]);
      }
    }
  }
  
  // лисы выигрывают, если им удается съесть 12 кур
  int nHens = 0;
  for (int x=0; x<N; x++) {
    for (int y=0; y<N; y++) {
      if (b[x][y] == HEN) {  
          nHens++;
      }
    }
  }
  if (nHens < 9) {
      pushCommand(COMMAND_FOXES_WIN,0,0);
      pushDelay();
  }
}

/* Передвинуть лису на соседнюю клетку.
 */
void makeFoxMove(int nf, int dir) {
  b[xf[nf]][yf[nf]] = EMP;

  xf[nf] += dx[dir];
  yf[nf] += dy[dir];
  b[xf[nf]][yf[nf]] = FOX;
}

/* Перепрыгнуть лисой через одну курицу в указанном направлении.
 */
void makeFoxJump(int nf, int dir) {
  b[xf[nf]][yf[nf]] = EMP;

  xf[nf] += dx[dir];
  yf[nf] += dy[dir];
  b[xf[nf]][yf[nf]] = EMP;

  xf[nf] += dx[dir];
  yf[nf] += dy[dir];
  b[xf[nf]][yf[nf]] = FOX;
}

// направления
int[] dx = {-1,0,1, 0};
int[] dy = { 0,1,0,-1};

// позиция в допустимом диапазоне?
boolean onBoard(int x, int y) {
  return x>=0 && x<N && y>=0 && y<N;
}

/* Получть список направлений н свободные клетки 
   для указанной лисы.
 */
IntList findFoxMoves(int fx, int fy) {
  IntList result = new IntList();
  for (int i=0; i<4; i++) {
    int x1 = fx + dx[i];
    int y1 = fy + dy[i];
    if (onBoard(x1,y1) && b[x1][y1] == EMP) {
      result.append(i);
    }
  }
  return result;
}

/* От заданной точки с координатами лисы `(fx,fy)` 
   продолжить стек прыжков `stack`, содержащий направления.
   Если больше прыжков сделать из заданной точки
   невозможно, добавить стек в список результатов.
 */
void collectFoxJumps(int fx, int fy,
                     IntList stack,
                     ArrayList<int[]> result) {
  // переберем 4 возможных напрвления
  for (int i=0; i<4; i++) {
    int x1 = fx + dx[i];
    int y1 = fy + dy[i];
    
    /* Если рядом с лисой в указанном направлении находится курица,
       перепрыгнем через нее.
     */  
    if (onBoard(x1,y1) && b[x1][y1] == HEN) {
      int x2 = x1 + dx[i];
      int y2 = y1 + dy[i];
      if (onBoard(x2,y2) && b[x2][y2] == EMP) {
        
        /* Изменить позицию на доске и 
           сохранить направление возможного прыжка в стеке.
           Затем продолжить рекурсивно искать возможные ходы.
         */
        b[fx][fy] = EMP;
        b[x1][y1] = EMP;
        b[x2][y2] = FOX;
        stack.append(i);

        collectFoxJumps(x2,y2,stack,result);

        /* Восстановить позицию на доске и 
           убрать последний прыжок из стека .
         */
        b[fx][fy] = FOX;
        b[x1][y1] = HEN;
        b[x2][y2] = EMP;
        stack.remove(stack.size()-1);
      }
    }
  }

  /* Если больше прыжков сделать из заданной точки
     невозможно, добавить стек в список результатов.
   */  
  stack.reverse();
  result.add(stack.array());
}
