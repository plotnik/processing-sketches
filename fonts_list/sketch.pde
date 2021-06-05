
/* Показать размеры экрана
   и список шрифтов
 */
 
int ts = 50;
int x = 30;
int y = ts;

void setup() {
  // textSize(ts);
  PFont font = createFont("Monospaced", ts);
  textFont(font);
 
  // вертикальная ось
  rect(width/2, 0, 1, height);

  // горизонтальная ось
  rect(0, height/2, width, 1);

  fill(0);

  p("width: " + width);
  p("height: " + height);
  p("--------");
  printFonts();
}

void printFonts() {
  String[] fonts = PFont.list();
  for (int i=0; i<fonts.length; i++) {
    p(fonts[i]);
  }
}

void p(String s) {
  text(s, x, y);
  y += ts;
}




