void setup(){
  size(1000,800,P3D);
}

void draw(){
  background(0);
  Paddle p = new Paddle(100,mouseX,700);
  p.draw();
}
