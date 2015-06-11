final int TITLE = 0, MENU = 1, PLAYING = 2, DEAD = 3, OPTIONS = 4;
int mode = TITLE;

int frameRate = 60;
// number of frames per second
float gravity = -300;
// acceleration due to gravity
float bounciness = 0.4;
// bounciness of surfaces (must be less than 1)

int level = 1;
Board board;
// The board's size is 1000 * 1000.
final int boardLength = 1000;
// The board operates on several different Containers.
Container<Brick> bricks;
Container<Ball> balls;
Container<Paddle> paddles;
// Container<Powerup> powerups;

// The default camera position is adjusted for a window
// whose sides are 3/4 the boardLength.
final float defaultCameraZ = boardLength / 2.0 / tan(PI / 6);
// The default view angle about the x-axis is PI / 3.
float viewAngleX = PI / 3;
// The default view angle about the y-axis is 0.
float viewAngleY = 0;
// The default zoom factor is 0.
int zoomFactor = 0;
// The default camera position is defaultCameraZ.
float cameraZ = defaultCameraZ;

Menu menu;
int[][] m = {{-55,-155,0},{60,-40,2},{175,75,4},{290,190,8}};
boolean mouseClicked = false;

void setup() {
  // The default shape of the window is a square.
  size(boardLength * 3 / 4, boardLength * 3 / 4, P3D);
  // If the game is running inside a web browser, the frame
  // variable will be null.  Otherwise, the frame will be
  // resizable.
  if (frame != null)
    frame.setResizable(true);
  menu = new Menu();
  board = new Board(level);
  mode = MENU;
}

void draw() {
  background(0);
  switch (mode) {
    case TITLE:
      title();
      break;
    case MENU:
      menu();
      break;
    case PLAYING:
      playing();
      //Menu menu = new Menu(this);
      //menu.draw();
      break;
    case DEAD:
      dead();
      break;
    case OPTIONS:
      options();
      break;
  }
}

void title() {
  // title stuff goes here...
  mode = MENU;
}

void menu() {
  lights();
  menu.draw();
}

void options() {
  lights();
  menu.drawOptions();
}

void playing() {
  // Set the lights.
  pointLight(
    255, 255, 255, // light color
    width / 2.0, height / 2.0, cameraZ // light position
    );
  // Set the camera.
  camera(
    width / 2.0, height / 2.0, cameraZ, // camera position
    width / 2.0, height / 2.0, 0, // center of scene
    0.0, 1.0, 0.0 // y-axis is facing upward
    );
  // Set the perspective.
  perspective(
    PI / 3, // field-of-view angle
    1.0, // aspect ratio
    cameraZ / 10.0,
    // closest z-coordinate to camera at which rendering stops
    cameraZ + boardLength
    // furthest z-coordinate from camera at which rendering stops
    );
  // Put the board in the center of the window.
  translate(
    (width - boardLength) / 2.0,
    (height - boardLength) / 2.0,
    0
    );
  // Rotate the grid according to the view angles.
  translate(boardLength / 2, boardLength, 0);
  rotateX(viewAngleX);
  rotateY(viewAngleY);
  translate(-boardLength / 2, -boardLength, 0);
  // Draw the board and everything on it.
  board.draw();
}

void dead() {
}

void mouseDragged() {
  switch(mode){
    case PLAYING:
    if (mouseButton == RIGHT) {
      // A downward swipe will bring the viewAngleX closer
      // to zero (a vertical board), while an upward
      // swipe will bring the viewAngleX closer to HALF_PI
      // (a horizontal board).  The viewAngleX cannot go
      // outside the range [0, HALF_PI].
      if (pmouseY < mouseY && viewAngleX > 0) {
        viewAngleX += (pmouseY - mouseY) / 1000.;
        if (viewAngleX < 0)
          viewAngleX = 0;
      }
      else if (pmouseY > mouseY && viewAngleX < HALF_PI) {
        viewAngleX += (pmouseY - mouseY) / 1000.;
        if (viewAngleX > HALF_PI)
          viewAngleX = HALF_PI;
      }
      // A leftward swipe will bring the viewAngleY closer
      // to -QUARTER_PI (the right edge of the board is
      // closer than the left edge), while a rightward
      // swipe will bring the viewAngleY closer to
      // QUARTER_PI (the left edge of the board is closer
      // than the right edge).  The viewAngleY cannot go
      // outside the range [-QUARTER_PI, QUARTER_PI].
      if (mouseX < pmouseX && viewAngleY > -QUARTER_PI) {
        viewAngleY += (mouseX - pmouseX) / 1000.;
        if (viewAngleY < -QUARTER_PI)
          viewAngleY = -QUARTER_PI;
      }
      else if (mouseX > pmouseX && viewAngleY < QUARTER_PI) {
        viewAngleY += (mouseX - pmouseX) / 1000.;
        if (viewAngleY > QUARTER_PI)
          viewAngleY = QUARTER_PI;
      }
    }

    case OPTIONS:
    for(int[] i : m){
      if(menu.pressed == 999 && !(mouseX <= width / 2.0 + 262.5 && mouseX >= width / 2.0 + 75 && mouseY <= height / 2.0 +337.5 && mouseY >= height / 2.0 +225)){
        menu.pressed = 0;
        return;
      }
      if(i[0] == menu.pressed && !(mouseX <= width / 2.0 + i[0] && mouseX >= width / 2.0 + i[1] && mouseY <= height / 2.0 - 50 && mouseY >= height / 2.0 - 150)){
        menu.pressed = 0;
        break;
      }
    }

    case MENU:
    if((menu.pressed2 == 1 && !(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 - 50 && mouseY >= height / 2.0 - 150)) ||
    (menu.pressed2 == 2 && !(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 + 150 && mouseY >= height / 2.0 + 50))){
      menu.pressed2 = 0;
    }
  }
}

void mouseWheel(MouseEvent me) {
  if (mode == PLAYING) {
    if (me.getClickCount() < 0 && cameraZ > 5)
      // If the wheel was rotated up or away from the player,
      // move the camera closer to the board.
      zoomFactor--;
    else if (cameraZ < boardLength * 5)
      // If the wheel was rotated down or toward the player,
      // move the camera away from the board.
      zoomFactor++;
    // Zoom out slowly at first, then faster and faster, or
    // zoom in quicly at first, then slower and slower.
    // (This function is pretty much arbitrary,
    // but it works nicely.)
    cameraZ =
      defaultCameraZ * pow(1.12, zoomFactor / 4.0) +
      2.5 * zoomFactor;
  }
}

public void mousePressed(){
  switch(mode){
  case OPTIONS:
    for(int[] i : m){
      if(mouseX <= width / 2.0 + 262.5 && mouseX >= width / 2.0 + 75 && mouseY <= height / 2.0 +337.5 && mouseY >= height / 2.0 +225){
        menu.pressed = 999;
        break;
      }
      if(mouseX <= width / 2.0 + i[0] && mouseX >= width / 2.0 + i[1] && mouseY <= height / 2.0 - 50 && mouseY >= height / 2.0 - 150){ //is the mouse within the appropriate smoothness box
        menu.pressed = i[0];
        break;
      }
    }
  case MENU:
    if(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 - 50 && mouseY >= height / 2.0 - 150){
      menu.pressed2 = 1;
    }else if(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 + 150 && mouseY >= height / 2.0 + 50){
      menu.pressed2 = 2;
    }
  }
}

public void mouseReleased(){
  switch(mode){
    case OPTIONS:
      for(int[] i : m){
      if(menu.pressed == 999 && mouseX <= width / 2.0 + 262.5 && mouseX >= width / 2.0 + 75 && mouseY <= height / 2.0 +337.5 && mouseY >= height / 2.0 +225){
        menu.pressed = 0;
        menu.pressed2 = 0;
        mode = MENU;
        return;
      }
      if(menu.pressed == i[0] && mouseX <= width / 2.0 + i[0] && mouseX >= width / 2.0 + i[1] && mouseY <= height / 2.0 - 50 && mouseY >= height / 2.0 - 150){ //is the mouse within the appropriate smoothness box
        menu.selected = i[0];
        menu.pressed = 0;
        smooth(i[2]);
        break;
      }
    }
  case MENU:
    if(mode == MENU && mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 - 50 && mouseY >= height / 2.0 - 150){
      menu.pressed2 = 0;
      mode = PLAYING;
    }else if(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 + 150 && mouseY >= height / 2.0 + 50){
      menu.pressed2 = 0;
      mode = OPTIONS;
    }
  }
}

void keyPressed(KeyEvent ke) {
  if (mode == PLAYING) {
    if (
      (ke.isControlDown() || ke.isAltDown() || ke.isMetaDown()) &&
      ke.getKeyCode() == 'R'
      ) {
      // View angles and camera position are reset when
      // ctrl-/alt-/cmd-R is pressed.
      viewAngleX = PI / 3;
      viewAngleY = 0;
      zoomFactor = 0;
      cameraZ = defaultCameraZ;
    }
    if (ke.getKeyCode() == 'A')
      gravity *= -1;
  }
}
