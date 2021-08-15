/**
 * Игра, одну из имплементаций которой можно найти в коллекции игр Саймона Тэтхема под названием Flip.
 * https://www.chiark.greenend.org.uk/~sgtatham/puzzles/js/flip.html
 *
 * Нужно окрасить все квадраты на доске в один цвет, переворачивая также квадраты, 
 * соседние с указанным по горизонтали и вертикали.
 * Понятно, что нажатие на один и тот же квадрат дважды приводит нас к исходному состоянию,
 * поэтому кругами мы будем обозначать нажатые квадраты.
 */

// Доска размером `n` x `n` клеток 
int n = 5;

// Помечаем перевернутые закрашенные квадраты на доске
boolean[][] filled = new boolean[n][n];

// Помечаем нажатые квадраты на доске
boolean[][] clicked = new boolean[n][n];

// Размер клетки на доске в пикселах
int step;

void setup() {
  size(800, 800);
  step = width/n;
  
  // Установим все клетки доски в начальное состояние
  for (int x=0; x<n; x++) {
    for (int y=0; y<n; y++) {
      clicked[x][y] = false;
      filled[x][y] = false;
    }
  }
}

void mouseClicked() {
  // Определим координаты нажатой клетки
  int x = floor(map(mouseX, 0, width, 0, n));
  int y = floor(map(mouseY, 0, height, 0, n));
  
  // Переключим состояния этой и соседних клеток
  clicked[x][y] = !clicked[x][y];
  flip(x-1, y);
  flip(x, y);
  flip(x+1, y);
  flip(x, y-1);
  flip(x, y+1);
}

void flip(int x, int y) {
  if (x<0 || x>=n || y<0 || y>=n) {
    return;
  }
  filled[x][y] = !filled[x][y];
}

void draw() {
  // Нарисуем клетки на доске.
  for (int x=0; x<n; x++) {
    int xp = x*step;
    for (int y=0; y<n; y++) {
      int yp = y*step;
      fill(filled[x][y]? 0:255);
      rect(xp, yp, xp+step, yp+step);
      if (clicked[x][y]) {
        fill(filled[x][y]? 255:0);
        circle(xp+step/2, yp+step/2, step*0.75);
      }
    }
  }
}
