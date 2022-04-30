/* Задача 8.
   Основанием пирамиды служит треугольник со сторонами
   13 см, 14 см, 15 см.
   Боковое ребро напротив средней по величине стороны основания
   перпендикулярно плоскости основания и равно 16 см.
   Найдите величины двугранных углов при основании этой пирамиды.
 */
int k = 20;

void setup() {
  size(1600, 800, P3D);
  fill(204);
  PFont font = createFont("Monospaced", 16);
  textFont(font);
}

void draw() {
  stroke(0);
  lights();
  background(204);
    
  camera(200, 200, 200, // eyeX, eyeY, eyeZ
         mouseY-400, mouseY-400, 0,  // centerX, centerY, centerZ
         0, 2, 0); // upX, upY, upZ
         
  PVector pA = new PVector(2,5,0); point3d(pA, "A");
  PVector pB = new PVector(5,1,0); point3d(pB, "B");
  PVector pC = new PVector(11,5,0); point3d(pC, "C");
  PVector pH = new PVector(8,3,0); point3d(pH, "H");
  PVector pD = new PVector(2,5,6); point3d(pD, "D");
  
  line3d(pA, pB);
  line3d(pB, pC);
  line3d(pA, pC);
  
  line3d(pA, pD);
  line3d(pB, pD);
  line3d(pC, pD);
  
  line3d(pH, pD);
  line3d(pH, pA);

  axis(new PVector(0,0,0), new PVector(10,0,0), 10, "x", color(255, 0, 0));
  axis(new PVector(0,0,0), new PVector(0,10,0), 10, "y", color(0, 127, 0));
  axis(new PVector(0,0,0), new PVector(0,0,10), 10, "z", color(0, 0, 255));
}

void line3d(PVector v1, PVector v2) {
  line(k*v1.x, k*v1.y, k*v1.z, 
       k*v2.x, k*v2.y, k*v2.z);
}

void point3d(PVector v, String label) {
  pushMatrix();
  stroke(0);
  translate(k*v.x, k*v.y, k*v.z);
  sphere(2);
  fill(0);
  float s = 10;
  text(label, s, s, s);
  popMatrix();     
}

void axis(PVector v1, PVector v2, int n, String label, color c) {
  float sx = (v2.x - v1.x)/n;
  float sy = (v2.y - v1.y)/n;
  float sz = (v2.z - v1.z)/n;
  pushMatrix();
  stroke(c);
  translate(k*v1.x, k*v1.y, k*v1.z);
  for (int i = 0; i < n; i++) {
    translate(k*sx, k*sy, k*sz);
    sphere(2);
  }
  fill(255);
  text(label, k*sx, k*sy, k*sz);
  popMatrix();
}
