void setup(){
  size(1000,1000,P3D);
}

void draw(){
  background(0);
  Paddle p = new Paddle(100,mouseX,900);
  p.draw();
}
