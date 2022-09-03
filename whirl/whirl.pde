/**
 * Эффект вихря.
 *
 * Загадка на одном из тайников с сайта geocaching.com
 * https://www.imageeprocessing.com/2011/06/swirl-effect-in-matlab.html
 */

int midx = 541;
int midy = 563;
int k = -30;

PImage im, img;

void setup() {
  size(1200, 1200); 
  im = loadImage("whirl.jpg");
  img = createImage(im.width, im.height, ARGB);
  //println("w1="+im.width+", h1="+im.height+", w2="+img.width+", h2="+img.height);
  //midx = ceil((img.width+1)/2);
  //midy = ceil((img.height+1)/2);
  imageMode(CENTER);
  whirlpool();
}

void whirlpool() {
  for (int i=0; i<img.width; i++) {
    int x = i - midx;
    for (int j=0; j<img.height; j++) {
      int y = j - midy;
      // Cartesian to Polar
      float theta1 = atan2(y,x);
      float rho1 = dist(x,y,0,0);
      float phi = theta1+(rho1/k);
      // Polar to Cartesian
      int x2 = ceil(rho1*cos(phi)) + midx;
      int y2 = ceil(rho1*sin(phi)) + midy;
      x2 = constrain(x2, 0,img.width-1);
      y2 = constrain(y2, 0,img.height-1);
      color c = im.get(x2,y2);
      img.set(i,j,c); //<>//
    }
  }
  println(midx,"x",midy,":",k);
}

void draw() {
  image(img, midx,midy);
  
  // нарисовать оси координат и окружность
  //pushStyle();
  line(0,midy,2*midx,midy);
  line(midx,0,midx,2*midy);
  //fill(0, 0);
  //stroke(#1634F0);
  //strokeWeight(8);
  //circle(xc,yc,700);
  //popStyle();
}

// Попробуем визуально с помощью стрелок определить 
// центр вихря и скорость закручивания.
void keyPressed() {
  boolean redraw = true;
  if (key == CODED) {
    if (keyCode == DOWN) {
      midy++;
    } else
    if (keyCode == UP) {
      midy--;
    } else
    if (keyCode == RIGHT) {
      k += 1;
    } else
    if (keyCode == LEFT) {
      k -= 1;
    } else {
      print(keyCode);
      redraw = false;
    }
  } else {
    if (key == ',') {
      midx--;
    } else
    if (key == '.') {
      midx++;
    } else {
      print(key);
      redraw = false;
    }
  }
  if (redraw) {
    whirlpool();
  }
}
