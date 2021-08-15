/* 
Martin Gardner "Fads and Fallacies in the Name of Science"
Chapter 2. Flat and Hollow
Wilbur Voliva

____
...photograph showing twelve miles of the shoreline of 
Lake Winnebago, Wisconsin. The camera used was an 8 by 10 
Eastman view camera... reads the explanation. 
The lens was exactly three feet above the water... 
ANYONE CAN GO TO OSHKOSH AND SEE THIS SIGHT FOR THEMSELVES 
ANY CLEAR DAY. With a good pair of binoculars one can see 
small objects on the opposite shore, proving beyond any doubt 
that the surface of the lake is a plane, or a horizontal line... 
____
*/
 
size(800,800);
float xc = width/2;
float yc = height/2;
float d = width*0.9;
float r = d/2;

ellipse(xc,yc,d,d);
line(xc,yc,xc,yc-r);

textFont(createFont("Serif-Italic", 32));
fill(0);
text('C',xc+10,yc+10);

float alpha = radians(30);
float dxa = r*sin(alpha);
float dya = r*cos(alpha);
float ya = yc - dya;
line(xc,yc,xc-dxa,ya);
line(xc,yc,xc+dxa,ya);
line(xc-dxa,ya,xc+dxa,ya);
text('A',xc-dxa-30,ya+10);

float h = sqrt(r*r-dxa*dxa);

// точку мы будем рисовать окружностью размера px
int px = 10;

ellipse(xc,yc-h,px,px);
text('B',xc+10,yc-h+30);

// средний радиус Земли, км
float R = 6371.0;
float D = 12*1.609344; // 12 миль, км
float DXA = D/2;
float H = sqrt(R*R-DXA*DXA);
float Z = R - H;
println("Z",Z);
