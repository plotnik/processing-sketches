String[] b0 = {
  "  ...  ",
  "  ...  ",
  "..*.*..",
  "xxxxxxx",
  "xxxxxxx",
  "  xxx  ",
  "  xxx  "
};

int N = 7;
char[][] b = new char[N][N];

char SPC = ' ';
char EMP = '.';
char FOX = '*';
char HEN = 'x';

// цвета
int cGrass = #22A517;
int cFox = #EDB437;
int cHen = 128;

// размер клетки на доске
float step;

// диаметр фишки
float d;

// какая фишка сейчас выбрана?
// (-1 если никакая)
int xsel = -1;
int ysel = -1;

// позиция первой и второй лисы
int[] xf = new int[2];
int[] yf = new int[2];
int curFox = 0;

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

// номер хода лисы который сейчас анимируем
int aninum = -1;

// ход лисы который сейчас анимируем
FoxJumps anijump;

// счетчик задержки анимации
int anidelay = 0;

void setup() {
  size(800, 800);
  step = width/7;
  d = step*0.75;

  // начальное заполнение доски
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
}

void draw() {
  // Если есть ход, то отрабатываем ход
  if (aninum >= 0) {
    // Если есть задержка, то отрабатываем задержку
    if (anidelay > 0) {
      anidelay--;
      return;
    }
    aniFoxMove();
  }

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
        fill(cell == FOX? cFox : cHen);
        stroke(0);
        if (!(xsel == x && ysel==y)) {
          ellipse(xp+step/2,yp+step/2,d,d);
        }
      }
    }
  }

  // фишка которую тянут
  if (xsel != -1) {
    fill(cHen);
    stroke(0);
    ellipse(xdrag,ydrag,d,d);
  }

  // TODO: прочертить линиями последний ход лисы
}

void mousePressed() {
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
  //println("--- " + x + "," + y + " : " + b[x][y]);
  
  // проверить допустимость хода
  if (b[x][y] == EMP && possibleHenMove(x,y,xsel,ysel)) {
    // совершить ход курицы
    b[x][y] = HEN;
    b[xsel][ysel] = EMP;
    
    // совершить ход лисы
    foxMove();
  }
  xsel = -1;
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
  ArrayList<FoxJumps> mm = new ArrayList<FoxJumps>();
  for (int i=0; i<2; i++) {
    IntList stack = new IntList();
    ArrayList<int[]> jj = new ArrayList<int[]>();
    collectFoxJumps(xf[i],yf[i],stack,jj);

    for (int[] ii: jj) {
      // найти самый длинный ход
      if (ii.length > maxlen) {
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
    int k = int(random(mm.size()));

    // вызвать анимацию для цепочки прыжков
    anijump = mm.get(k);
    aninum = anijump.m.length - 1;
    aniFoxMove();

  } else {
    // случайным образом выбрать один из оставшихся
    // ходов для одной из лис
    int[] m0 = findFoxMoves(xf[0],yf[0]).array();
    int[] m1 = findFoxMoves(xf[1],yf[1]).array();
    if (m0.length == 0 && m1.length == 0) {
      stopGame("HENS WIN!");
    } else {
      int k = int(random(m0.length + m1.length));
      if (k < m0.length) {
        makeFoxMove(0, m0[k]);
      } else {
        makeFoxMove(1, m1[k - m0.length]);
      }
    }
  }
  // TODO: лисы выигрывают, если им удается съесть 12 кур.
  // TODO: Куры выигрывают, если им удается занять верхний
  // квадрат игры.
}

/* Анимировать прыжковый ход лисы.
   Номер хода лисы указан в переменной `aninum`.
   Если `aninum == -1`, то анимация завершена.
   Список ходов находится в объекте `anijump: FoxJumps`.
*/
void aniFoxMove() {
  println("-- aniFoxMove: [" + aninum + "] " + anijump);
  int nf = anijump.n;
  int dir = anijump.m[aninum];
  int x1 = xf[nf];
  int y1 = yf[nf];
  int x2 = x1 + dx[dir];
  int y2 = y1 + dy[dir];
  int x3 = x2 + dx[dir];
  int y3 = y2 + dy[dir];
  b[x1][y1] = EMP;
  b[x2][y2] = EMP;
  b[x3][y3] = FOX;
  xf[nf] = x3;
  yf[nf] = y3;

  aninum--;
  anidelay = 20;
}

/* Передвинуть лису на соседнюю клетку.
 */
void makeFoxMove(int nf, int dir) {
  int x1 = xf[nf];
  int y1 = yf[nf];
  int x2 = x1 + dx[dir];
  int y2 = y1 + dy[dir];
  b[x2][y2] = FOX;
  b[x1][y1] = EMP;
  xf[nf] = x2;
  yf[nf] = y2;
}

void stopGame(String msg) {
  // TODO: остановить игру
  println(msg);
}

// направления
int[] dx = {-1,0,1, 0};
int[] dy = { 0,1,0,-1};

// позиция в допустимом диапазоне?
boolean onBoard(int x, int y) {
  return x>=0 && x<N && y>=0 && y<N;
}

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

/* От заданной точки `(fx,fy)` продолжить
   стек прыжков `stack`, содержащий направления.
   Если больше прыжков сделать из заданной точки
   невозможно, добавить стек в список результатов.
 */
void collectFoxJumps(int fx, int fy,
                     IntList stack,
                     ArrayList<int[]> result) {
  for (int i=0; i<4; i++) {
    int x1 = fx + dx[i];
    int y1 = fy + dy[i];
    if (onBoard(x1,y1) && b[x1][y1] == HEN) {
      int x2 = x1 + dx[i];
      int y2 = y1 + dy[i];
      if (onBoard(x2,y2) && b[x2][y2] == EMP) {
        // push state
        b[fx][fy] = EMP;
        b[x1][y1] = EMP;
        b[x2][y2] = FOX;
        stack.append(i);

        collectFoxJumps(x2,y2,stack,result);

        // pop state
        stack.remove(stack.size()-1);
        b[fx][fy] = FOX;
        b[x1][y1] = HEN;
        b[x2][y2] = EMP;
      }
    }
  }
  stack.reverse();
  result.add(stack.array());
}
