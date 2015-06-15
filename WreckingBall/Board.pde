public class Board {
  private color c;
  private PImage t;
  private int level = 1;
  private int lives = 3;
  private boolean setup = true;

  public Board(int level) {
    
  }
  
  public void setting(){
    if(setup){
      switch (level) {
        case 1:
          level1(); setup = false;
          break;
        case 2:
          level2(); setup = false;
          break;
      }
    } 
  }

  public void draw() {
    int i,j;
    setting();
    fill(c);
    if(lives == 0){
      textSize(64);
      text("YOU LOSE!!!!",500,500,0); //temporary
      return;
    }
    if(balls.get(0).dead()){
      lives--;
      balls.remove(0);
      balls.add(new Ball(30,#FFFFFF));
      return;
    }
    if(bricks.size() == 0){
      level++;
      balls.remove(0);
      balls.add(new Ball(30,#FFFFFF));
      setup = true;
      return;
    }
    translate(500, 500, -10);
    box(1000, 1000, 20);
    translate(-500, -500, 10);
    for (i = 0; i < bricks.size(); i++)
      bricks.get(i).draw();
    for (i = 0; i < paddles.size(); i++)
      paddles.get(i).draw();
    for (i = 0; i < balls.size(); i++)
      balls.get(i).draw();
    fill(0);
    textSize(32);
    text("Level " + level,100,950,50);
    text("Lives: " + lives,850,950,50);
    fill(c);
  }
  
  private void load(){
    c = #63F702;
    balls = new Container<Ball>();
    balls.add(new Ball(30, #FFFFFF));
    paddles = new Container<Paddle>();
    paddles.add(new Paddle(100.0, "colors.jpg"));
    bricks = new Container<Brick>(15);
  } 
   

  private void level2() {
    load();
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
  
  public void level1(){
    load();
    bricks.add(new Prism(new float[][]{ {250,250},{250,350},{350,350},{350,250}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {750,750},{750,650},{650,650},{650,750}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {250,750},{250,650},{350,650},{350,750}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {750,250},{750,350},{650,350},{650,250}},61, "gray_brick.jpg")); //top right
    
    bricks.add(new Prism(new float[][]{ {300,300},{300,400},{400,400},{400,300}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {700,700},{700,600},{600,600},{600,700}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {300,700},{300,600},{400,600},{400,700}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {700,300},{700,400},{600,400},{600,300}},61, "gray_brick.jpg"));
    
    bricks.add(new Prism(new float[][]{ {350,350},{350,450},{450,450},{450,350}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {650,650},{650,550},{550,550},{550,650}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {350,650},{350,550},{450,550},{450,650}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {650,350},{650,450},{550,450},{550,350}},61, "gray_brick.jpg"));
    
    bricks.add(new Prism(new float[][]{ {400,400},{400,500},{500,500},{500,400}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {600,600},{600,500},{500,500},{500,600}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {400,600},{400,500},{500,500},{500,600}},61, "gray_brick.jpg"));
    bricks.add(new Prism(new float[][]{ {600,400},{600,500},{500,500},{500,400}},61, "gray_brick.jpg"));
    for(int i = 0; i < 12; i++){
      bricks.get(i+4).stack(bricks.get(i));
    }
    bricks.add(new Cylinder(new float[] {500,500}, 40, 100, 60, "mr_k.jpg"));
    for(int i = 12; i < 16; i++){
      bricks.get(16).stack(bricks.get(i));
    }
  }
}
