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
        {
          100, 200
        }
        , 
        {
          200, 200
        }
        , 
        {
          200, 100
        }
        , 
        {
          100, 150
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          300, 200
        }
        , 
        {
          400, 200
        }
        , 
        {
          400, 100
        }
        , 
        {
          300, 150
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          500, 200
        }
        , 
        {
          600, 200
        }
        , 
        {
          600, 100
        }
        , 
        {
          500, 150
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          700, 200
        }
        , 
        {
          800, 200
        }
        , 
        {
          800, 100
        }
        , 
        {
          700, 150
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          900, 200
        }
        , 
        {
          1000, 200
        }
        , 
        {
          1000, 100
        }
        , 
        {
          900, 150
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          100, 400
        }
        , 
        {
          200, 400
        }
        , 
        {
          200, 300
        }
        , 
        {
          100, 350
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          300, 400
        }
        , 
        {
          400, 400
        }
        , 
        {
          400, 300
        }
        , 
        {
          300, 350
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          500, 400
        }
        , 
        {
          600, 400
        }
        , 
        {
          600, 300
        }
        , 
        {
          500, 350
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          700, 400
        }
        , 
        {
          800, 400
        }
        , 
        {
          800, 300
        }
        , 
        {
          700, 350
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          900, 400
        }
        , 
        {
          1000, 400
        }
        , 
        {
          1000, 300
        }
        , 
        {
          900, 350
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          100, 600
        }
        , 
        {
          200, 600
        }
        , 
        {
          200, 500
        }
        , 
        {
          100, 550
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          300, 600
        }
        , 
        {
          400, 600
        }
        , 
        {
          400, 500
        }
        , 
        {
          300, 550
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          500, 600
        }
        , 
        {
          600, 600
        }
        , 
        {
          600, 500
        }
        , 
        {
          500, 550
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          700, 600
        }
        , 
        {
          800, 600
        }
        , 
        {
          800, 500
        }
        , 
        {
          700, 550
        }
      }
      , 100, 0, "texture1.jpg"), 
      new Prism(new float[][] {
        {
          900, 600
        }
        , 
        {
          1000, 600
        }
        , 
        {
          1000, 500
        }
        , 
        {
          900, 550
        }
      }
      , 100, 0, "texture1.jpg"),
    };
    balls = new Ball[] {
      new Ball(40, #FFFFFF)
      };
      paddles = new Paddle[0];
  }
  public void draw() {
    fill(c);
    translate(500, 500, -10);
    box(1000, 1000, 20);
    translate(-500, -500, 10);
    for (Brick brick : bricks)
      if (brick != null)
        brick.draw();
    for (Ball ball : balls) {
      ball.draw();
      for (int i = 0; i < bricks.length; i++)
        if (bricks[i] != null && bricks[i].ballColliding(ball)) {
          bricks[i].reflectBall(ball);
          bricks[i] = null;
        }
    }
    /*
		for (Paddle p : paddles)
     			p.draw();
     		*/
  }
}

