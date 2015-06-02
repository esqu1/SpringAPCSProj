public class Board {
  private color c;
  // private texture t; (to be implemented later)
  private Container<Brick> bricks;
  private Container<Ball> balls;
  private Container<Paddle> paddles;
  // private Powerup[] powerups; (to be implemented later)

  public Board() {
    // This is all temporary...
    c = #63F702;
    bricks = new Container<Brick>(15);
    bricks.add(
      new Prism(
        new float[][] {
          {50, 200},
          {150, 200},
          {150, 100},
          {50, 150}
        },
        100, 0, "texture1.jpg"
        )
      );
    bricks.add(
      new Prism(
        new float[][] {
          {250, 200},
          {350, 200},
          {350, 100},
          {250, 150}
        },
        10, 0, "texture1.jpg"
        )
      );
    bricks.add(
      new Prism(
        new float[][] {
          {450, 200},
          {550, 200},
          {550, 150},
          {500, 100},
          {450, 150}
        },
        30, 70, "texture1.jpg"
        )
      );
    bricks.add(
      new Prism(
        new float[][] {
          {650, 200},
          {750, 200},
          {750, 150},
          {650, 100}
        },
        10, 0, "texture1.jpg"
        )
      );
    bricks.add(
      new Prism(
        new float[][] {
          {850, 200},
          {950, 200},
          {950, 150},
          {850, 100}
        },
        100, 0, "texture1.jpg"
        )
      );
    bricks.add(
      new Prism(
        new float[][] {
          {500, 300},
          {500 - 150*sqrt(3)/2, 525},
          {500 + 150*sqrt(3)/2, 525},
        },
        30, 0, "texture1.jpg"
        )
      );
    bricks.add(
      new Sphere(
        new float[] {300, 450},
        50, 0, #888888
        )
      );
    bricks.add(
      new Sphere(
        new float[] {500, 450},
        75, 30, #888888
        )
      );
    bricks.add(
      new Sphere(
        new float[] {700, 450},
        50, 0, #888888
        )
      );
    balls = new Container<Ball>(1);
    balls.add(new Ball(40, #FFFFFF));
    paddles = new Container<Paddle>(0);
  }
  public void draw() {
    int i,j;
    fill(c);
    translate(500, 500, -10);
    box(1000, 1000, 20);
    translate(-500, -500, 10);
    for (i = 0; i < bricks.size(); i++)
      bricks.get(i).draw();
    for (i = 0; i < balls.size(); i++) {
      balls.get(i).draw();
      for (j = 0; j < bricks.size(); j++) {
        if (bricks.get(j).ballColliding(balls.get(i))) {
          bricks.get(j).reflectBall(balls.get(i));
          bricks.remove(j);
        }
      }
    }/*
    for (i = 0; i < paddles.size(); i++)
      paddles.get(i).draw();*/
  }
}
