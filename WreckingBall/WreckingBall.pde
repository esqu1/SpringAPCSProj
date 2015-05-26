Brick[] bricks;
int mode;
final int PLAYING = 0, TITLESCREEN = 1, MENU = 2;

void setup() {
  size(1000, 800, P3D);
}

void draw() {
  background(0);
  rotateX(PI/6);
  Paddle p = new Paddle(100, mouseX, 500);
  p.draw();
  mode = PLAYING;
  switch(mode) {
  case PLAYING:
    driver();
  case TITLESCREEN:
    titleScreen();
  case MENU:
    menu();
  }
}

void titleScreen() {
  // Intro to the game, go to main menu.
}

void menu() {
  // Select options 
  // Start Game, Setting (Change Music, Volume), Quit, Choose Level
}

void driver() {
  //plays the game and stuff y'know 
  fill(#63F702);
  rect(100, 100, 700, 500);
}

