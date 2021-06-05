/* Построение графиков */

void setup() {
  size(700,700);
 
  background(0); // черный фон

  // полуширина и полувысота
  int w2 = width/2;
  int h2 = height/2;
 
  // 0 в центре экрана
  translate(w2, h2);
  rotate(PI);
 
  stroke(100); // серый цвет
 
  // вертикальная ось
  line(0,-h2,0,h2);
 
  // горизонтальная ось
  line(-w2,0,w2,0);
 
  stroke(#3AE577); // зеленый цвет
  for (int x=-w2; x<w2; x++) {
    point(x, f1x(x));
  }
}

int fx2(int x) {
  return x*x/200;
}

int f1x(int x) {
  return x==0? 0 : 2*height/x;
}


