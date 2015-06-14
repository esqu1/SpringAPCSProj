public class Board {
  private color c;
  private PImage t;

  public Board(int level) {
    switch (level) {
    	case 1:
    		level1();
    		break;
    }
  }

  public void draw() {
    int i,j;
    fill(c);
    translate(500, 500, -10);
    box(1000, 1000, 20);
    translate(-500, -500, 10);
    for (i = 0; i < bricks.size(); i++)
      bricks.get(i).draw();
    for (i = 0; i < paddles.size(); i++)
      paddles.get(i).draw();
    for (i = 0; i < balls.size(); i++)
      balls.get(i).draw();
  }

  private void level1() {
    c = #63F702;
    balls = new Container<Ball>();
    balls.add(new Ball(30, #FFFFFF));
    paddles = new Container<Paddle>();
    paddles.add(new Paddle(100.0, "colors.jpg"));
    bricks = new Container<Brick>(15);
    // stack of three trapezoids in top left
    bricks.add(
      new Prism(
        new float[][] {
          {50, 200},
          {150, 200},
          {150, 100},
          {50, 150}
        },
        100, "gray_brick.jpg"
        )
      );
    bricks.add(
      new Prism(
        new float[][] {
          {100, 150},
          {150, 150},
          {150, 100},
          {100, 125}
        },
        100, "gray_brick.jpg"
        )
      );
    bricks.get(1).stack(bricks.get(0));
    bricks.add(
      new Prism(
        new float[][] {
          {125, 125},
          {150, 125},
          {150, 100},
          {125, 112.5}
        },
        100, "gray_brick.jpg"
        )
      );
    bricks.get(2).stack(bricks.get(1));
    // stack of three trapezoids in top right
    bricks.add(
      new Prism(
        new float[][] {
          {850, 200},
          {850, 100},
          {950, 150},
          {950, 200}
        },
        100, "gray_brick.jpg"
        )
      );
    bricks.add(
      new Prism(
        new float[][] {
          {850, 150},
          {850, 100},
          {900, 125},
          {900, 150}
        },
        100, "gray_brick.jpg"
        )
      );
    bricks.get(4).stack(bricks.get(3));
    bricks.add(
      new Prism(
        new float[][] {
          {850, 125},
          {850, 100},
          {875, 112.5},
          {875, 125}
        },
        100, "gray_brick.jpg"
        )
      );
    bricks.get(5).stack(bricks.get(4));
    // two cylinders rotating at 0.25 rev/sec
    bricks.add(
    	new Cylinder(
    		new float[] {100, 600},
    		75, 300, 60, "mr_k.jpg", 0.25 * TWO_PI
    		)
    	);
    bricks.add(
    	new Cylinder(
    		new float[] {900, 600},
    		75, 300, 60, "mr_k.jpg", -0.25 * TWO_PI
    		)
    	);
    // pentagon in the center moving up and down,
    // each cycle lasting 20 seconds
    bricks.add(
      new Sphere(
        new float[] {500, 150},
        30, 60, 60, "pluto.jpg",
        new float[] {0, 50}, 100
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
        30, #FF0000,
        new float[] {0, 50}, 100
        )
      );
    bricks.get(9).stack(bricks.get(8));
    // two spinning tops rotating at 2 rev/sec
    bricks.add(
      new Sphere(
        new float[] {300, 450},
        50, 60, 4, "colors.jpg", 2 * TWO_PI
        )
      );
    bricks.add(
      new Sphere(
        new float[] {700, 450},
        50, 60, 4, "colors.jpg", -2 * TWO_PI
        )
      );
    // model Earth rotating at 0.1 rev/sec
    bricks.add(
      new Sphere(
        new float[] {500, 450},
        100, 120, 60, "world.jpg", 0.1 * TWO_PI
        )
      );
    bricks.add(
    	new Prism(
    		new float[][] {
    			{50, 150},
    			{50, 200},
    			{950, 200},
    			{950, 150}
    		},
        100, "gray_brick.jpg"
        )
    	);
    bricks.get(13).stack(bricks.get(0));
    bricks.get(13).stack(bricks.get(3));
    bricks.get(13).stack(bricks.get(9));
    bricks.add(
    	new Prism(
    		new float[][] {
    			{450, 150},
    			{450, 200},
    			{550, 200},
    			{550, 150}
    		},
        100, "gray_brick.jpg"
        )
    	);
    bricks.get(14).stack(bricks.get(13));
  }
}
