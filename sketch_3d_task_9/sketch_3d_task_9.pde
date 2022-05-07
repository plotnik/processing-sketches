/* Задача 9.
   В треугольной пирамиде все ребра основания равны `a`, 
   а все боковые ребра - `b`.
   Найдите расстояние между боковым ребром
   и ребром основания, не лежащим с ним в одной плоскости.
 */
PVector[] v = new PVector[4];

int k = 30;

void setup() {
  size(1000, 600, P3D);
  fill(204);
}

void draw() {
  stroke(255);
  lights();
  background(0);
  
  /*
  float a = float(mouseX)/width*2*PI; 
  float b = float(mouseY)/height*2*PI; 
  float R = 500;
  float eyeX = R*cos(b); 
  float eyeY = R*cos(a)*sin(b); 
  float eyeZ = R*sin(a)*sin(b);

  //print(a + " " + b + " / ");
  camera(eyeX, eyeY, eyeZ,
         0, 0, 0,  // centerX, centerY, centerZ
         0.0, 0.0, 1.0); // upX, upY, upZ 
  */       
         
  camera(200, 200, 400,
         0, 0, 0,  // centerX, centerY, centerZ
         0.0, 0.0, 1.0); // upX, upY, upZ
         
  float a = float(mouseX)/width*2*PI;
  float b = float(mouseY)/height*2*PI; 
  rotateX(a);
  rotateZ(b);         
  
  v[0] = new PVector(4,2,0);
  v[1] = new PVector(6,6,0);
  v[2] = new PVector(2,6,0);
  v[3] = new PVector(4,4,6);
   
  dots(new PVector(0,0,0), new PVector(10,0,0));
  dots(new PVector(0,0,0), new PVector(0,10,0));
 
  for (int i = 0; i < v.length; i++) {
    pushMatrix();
    translate(k*v[i].x, k*v[i].y, k*v[i].z);
    if (v[i].z==0) stroke(255,0,0); else stroke(0,255,0); 
    sphere(5);
    popMatrix();
  }
  ldots(v[0], v[1]);
  ldots(v[1], v[2]);
  ldots(v[0], v[2]);

  ldots(v[0], v[3]);
  ldots(v[1], v[3]);
  ldots(v[2], v[3]); 
 
}

void ldots(PVector v1, PVector v2) {
  line(k*v1.x, k*v1.y, k*v1.z, 
       k*v2.x, k*v2.y, k*v2.z);
}

void dots(PVector v1, PVector v2) {
  int n = 10;
  float sx = (v2.x - v1.x)/n;
  float sy = (v2.y - v1.y)/n;
  float sz = (v2.z - v1.z)/n;
  pushMatrix();
  translate(k*v1.x, k*v1.y, k*v1.z);
  for (int i = 0; i < n; i++) {
    translate(k*sx, k*sy, k*sz);
    sphere(2);
  }
  popMatrix();
}
