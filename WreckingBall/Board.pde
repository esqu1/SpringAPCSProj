public class Board {
  private color c;
  // private texture t; (to be implemented later)
  private Brick[] bricks;
  private Ball[] balls;
  private Paddle[] paddles;
  // private Powerup[] powerups; (to be implemented later)
  public Board() {
    // This is all temporary...
    c = #63F702;
    bricks = new Brick[] {
      new Prism(new float[][] {
        {.1, .15},
        {.2, .1},
        {.2, .2},
        {.1, .2}
      }, 100)
    };
    balls = new Ball[0];
    paddles = new Paddle[0];
  }
  public void draw() {
    //fill(c);
    rect(0, 0, width, height);
    for (Brick b : bricks){
      b.setTexture("texture1.jpg");
      b.draw();
    }
    /*
    for (Ball b : balls)
      b.draw();
    for (Paddle p : paddles)
      p.draw();
    */
  }
}
