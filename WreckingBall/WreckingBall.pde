Brick[] bricks;
int mode;
final int PLAYING = 0, TITLESCREEN = 1, MENU = 2;

void setup(){
  size(1000,800,P3D);
}

void draw(){
  background(0);
  Paddle p = new Paddle(100,mouseX,700);
  p.draw();
}

void titleScreen(){
  // Intro to the game, go to main menu. 
}

void menu(){
  // Select options 
}
