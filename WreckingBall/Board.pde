public class Board {
  private color c;
  private PImage t;
  private int level = 1;
  private int lives = 3;
  private boolean setup = true;
  
  public void setting(){
    if(setup){
      switch (level) {
        case 1:
          level1(); setup = false;
          break;
        case 2:
          level2(); setup = false;
          break;
        case 3:
          level3(); setup = false;
          break;
        case 4:
          level4(); setup = false;
          break;
        case 5:
          level5(); setup = false;
          break;
        case 6:
          level6(); setup = false;
          break;
        case 7:
          level7(); setup = false;
          break;
        case 8:
          level8(); setup = false;
          break;
        case 9:
          level9(); setup = false;
          break;
      }
    } 
  }

  public void draw() {
    int i,j;
    setting();
    fill(c);
    if(lives == 0){
      mode = TITLE;
      return;
    }
    if (level > 9) {
      fill(#FFFFFF);
      translate(500, 500, -10);
      box(1000, 1000, 20);
      translate(-500, -500, 10);
      fill(0);
      textSize(200);
      text("YOU WIN!", 50, 500, 50);
      return;
    }
    if(balls.get(0).dead()){
      lives--;
      balls.remove(0);
      balls.add(new Ball(30,#FFFFFF));
      if (level == 9)
        balls.get(0).defaultv *= 5;
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
    		40, 300, 60, "mr_k.jpg", 0.25 * TWO_PI
    		)
    	);
    bricks.add(
    	new Cylinder(
    		new float[] {900, 600},
    		40, 300, 60, "mr_k.jpg", -0.25 * TWO_PI
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
    bricks.add(new Cylinder(new float[] {500,500}, 40, 300, 60, "mr_k.jpg", 0.2 * PI));
    for(int i = 12; i < 16; i++){
      bricks.get(16).stack(bricks.get(i));
    }
  }
  
  public void level3(){
    load();
    for(int j = 100; j < 600; j += 200){
      for(int i = 100; i < 1000; i+= 200){
        bricks.add(new Cylinder(new float[] {i,j}, 40, 300, 60, "mr_k.jpg", 0.5 * PI));
      }
    }
    for(int i = 0; i < 3; i++){
      bricks.add(new Prism(new float[][]{ {50,50 + i * 200},{950,50 + i * 200},{950,150 + i * 200},{50,150 + i * 200}},61, "gray_brick.jpg"));
    }
    for(int i = 0; i < 15; i++){
      bricks.get(15 + (i / 5)).stack(bricks.get(i)); 
    }
    
    for(int i = 650; i <= 800; i+= 75){
      bricks.add(new Prism(new float[][] { {100,i}, {200,i}, {250,i+50},{100,i+50}},50, "colors.jpg",new float[] {50,0},200));
      bricks.add(new Prism(new float[][] { {900,i}, {750,i}, {800,i+50},{900,i+50}},50, "colors.jpg",new float[] {-50,0},200));
    }
  }
  
  public void level4(){
    load();
    bricks.add(new Sphere(new float[] {500,700}, 75, 15, 60, #FF0000, 0.5 * PI)); // 1,1
    
    bricks.add(new Sphere(new float[] {425,600}, 75, 15, 60, #FF8000, 0.5 * PI)); // 2,1
    bricks.add(new Sphere(new float[] {575,600}, 75, 15, 60, #FF8000, 0.5 * PI)); 
    bricks.add(new Sphere(new float[] {500,600}, 75, 15, 60, #FF8000, 0.5 * PI)); // 2,2
    bricks.get(3).stack(bricks.get(1));
    bricks.get(3).stack(bricks.get(2));
    
    bricks.add(new Sphere(new float[] {350,500}, 75, 15, 60, #FAFF00, 0.5 * PI)); // 3,1
    bricks.add(new Sphere(new float[] {500,500}, 75, 15, 60, #FAFF00, 0.5 * PI));
    bricks.add(new Sphere(new float[] {650,500}, 75, 15, 60, #FAFF00, 0.5 * PI));
    bricks.add(new Sphere(new float[] {425,500}, 75, 15, 60, #FAFF00, 0.5 * PI)); // 3,2
    bricks.add(new Sphere(new float[] {575,500}, 75, 15, 60, #FAFF00, 0.5 * PI)); 
    bricks.add(new Sphere(new float[] {500,500}, 75, 15, 60, #FAFF00, 0.5 * PI)); // 3,3
    bricks.get(7).stack(bricks.get(4));
    bricks.get(7).stack(bricks.get(5));
    bricks.get(8).stack(bricks.get(5));
    bricks.get(8).stack(bricks.get(6));
    bricks.get(9).stack(bricks.get(7));
    bricks.get(9).stack(bricks.get(8));
    
    bricks.add(new Sphere(new float[] {275,400}, 75, 15, 60, #00FF4A, 0.5 * PI)); // 4,1
    bricks.add(new Sphere(new float[] {425,400}, 75, 15, 60, #00FF4A, 0.5 * PI));
    bricks.add(new Sphere(new float[] {575,400}, 75, 15, 60, #00FF4A, 0.5 * PI));
    bricks.add(new Sphere(new float[] {725,400}, 75, 15, 60, #00FF4A, 0.5 * PI));
    bricks.add(new Sphere(new float[] {350,400}, 75, 15, 60, #00FF4A, 0.5 * PI)); // 4,2
    bricks.add(new Sphere(new float[] {500,400}, 75, 15, 60, #00FF4A, 0.5 * PI));
    bricks.add(new Sphere(new float[] {650,400}, 75, 15, 60, #00FF4A, 0.5 * PI));
    bricks.add(new Sphere(new float[] {425,400}, 75, 15, 60, #00FF4A, 0.5 * PI)); // 4,3
    bricks.add(new Sphere(new float[] {575,400}, 75, 15, 60, #00FF4A, 0.5 * PI));
    bricks.add(new Sphere(new float[] {500,400}, 75, 15, 60, #00FF4A, 0.5 * PI)); // 4,4
    bricks.get(14).stack(bricks.get(10));
    bricks.get(14).stack(bricks.get(11));
    bricks.get(15).stack(bricks.get(11));
    bricks.get(15).stack(bricks.get(12));
    bricks.get(16).stack(bricks.get(12));
    bricks.get(16).stack(bricks.get(13));
    bricks.get(17).stack(bricks.get(14));
    bricks.get(17).stack(bricks.get(15));
    bricks.get(18).stack(bricks.get(15));
    bricks.get(18).stack(bricks.get(16));
    bricks.get(19).stack(bricks.get(17));
    bricks.get(19).stack(bricks.get(18));
  }
  
  public void level5(){
    load();
    bricks.add(new Prism(new float[][]{ {50,50},{50,150},{150,150},{150,50}},61, "colors.jpg"));
    for(int i = 0; i < 7; i++){
      bricks.add(new Prism(new float[][]{ {50,50},{50,150},{150,150},{150,50}},61, "colors.jpg"));
      bricks.get(i+1).stack(bricks.get(i));
    } // 7
    
    bricks.add(new Prism(new float[][]{ {200,50},{200,150},{300,150},{300,50}},61, "colors.jpg")); // 8
    for(int i = 0; i < 7; i++){
      bricks.add(new Prism(new float[][]{ {200,50},{200,150},{300,150},{300,50}},61, "colors.jpg"));
      bricks.get(i+9).stack(bricks.get(i+8));
    } // 15
    bricks.add(new Prism(new float[][]{ {300,50},{300,150},{350,150},{350,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {350,50},{350,150},{400,150},{400,50}},61, "colors.jpg")); // 17
    bricks.add(new Prism(new float[][]{ {500,50},{500,150},{600,150},{600,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {425,50},{425,150},{525,150},{525,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {575,50},{575,150},{675,150},{675,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {400,50},{400,150},{500,150},{500,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {600,50},{600,150},{700,150},{700,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {400,50},{400,150},{500,150},{500,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {600,50},{600,150},{700,150},{700,50}},61, "colors.jpg")); // 24
    bricks.get(19).stack(bricks.get(18));
    bricks.get(20).stack(bricks.get(18));
    bricks.get(21).stack(bricks.get(19));
    bricks.get(22).stack(bricks.get(20));
    bricks.get(23).stack(bricks.get(21));
    bricks.get(24).stack(bricks.get(22));
      
    bricks.add(new Prism(new float[][]{ {800,50},{800,150},{900,150},{900,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {750,50},{750,150},{825,150},{825,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {875,50},{875,150},{950,150},{950,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {700,50},{700,150},{775,150},{775,50}},61, "colors.jpg"));
    bricks.add(new Prism(new float[][]{ {925,50},{925,150},{1000,150},{1000,50}},61, "colors.jpg")); // 29
    bricks.get(26).stack(bricks.get(25));
    bricks.get(27).stack(bricks.get(25));
    bricks.get(28).stack(bricks.get(26));
    bricks.get(29).stack(bricks.get(27));
    
    bricks.add(new Prism(new float[][]{ {100,450},{100,550},{500,550},{450,450}},61, "colors.jpg"));
    for(int i = 0; i < 7; i++){
      bricks.add(new Prism(new float[][]{ {100,450},{100,550},{200,550},{200,450}},61, "colors.jpg"));
      bricks.get(i+31).stack(bricks.get(i+30));
    }
    bricks.add(new Prism(new float[][]{ {100,450},{100,550},{500,550},{450,450}},61, "colors.jpg"));
    bricks.get(38).stack(bricks.get(37));
    
    bricks.add(new Prism(new float[][]{ {500,450},{500,550},{900,550},{900,450}},61, "colors.jpg")); // 39
    for(int i = 0; i < 3; i++){
      bricks.add(new Prism(new float[][]{ {800,450},{800,550},{900,550},{900,450}},61, "colors.jpg"));
      bricks.get(i+40).stack(bricks.get(i+39));
    }
    bricks.add(new Prism(new float[][]{ {500,450},{500,550},{900,550},{900,450}},61, "colors.jpg"));
    bricks.get(43).stack(bricks.get(42));
    for(int i = 0; i < 3; i++){
      bricks.add(new Prism(new float[][]{ {500,450},{500,550},{600,550},{600,450}},61, "colors.jpg"));
      bricks.get(i+44).stack(bricks.get(i+43));
    }
    bricks.add(new Prism(new float[][]{ {500,450},{500,550},{900,550},{900,450}},61, "colors.jpg"));
    bricks.get(47).stack(bricks.get(46));
  }
  
  public void level6() {
    load();
    int x, y, i;
    for (x = 100; x < 1000; x += 100)
      for (y = 100; y < 600; y += 100)
        if (random(2) < 1) {
          bricks.add(new Sphere(new float[] {x, y}, 50, 4, 3, "dennis's thing.jpg", 0.1 * TWO_PI));
          for (i = 0; i < bricks.size() - 1; i++)
            if (bricks.get(bricks.size() - 1).overlaps(bricks.get(i)))
              bricks.get(bricks.size() - 1).stack(bricks.get(i));
        }
  }
  
  public void level7() {
    load();
    int theta = 0;
    while (theta < 360) {
      bricks.add(new Cylinder(new float[] {400 + 40 * sin(radians(theta)), 400 + 40 * cos(radians(theta))}, 20, 10, 30, #000000, new float[] {500, 0}, 200));
      if (bricks.size() > 1)
        bricks.get(bricks.size() - 1).stack(bricks.get(bricks.size() - 2));
      theta += 5;
    }
  }
  
  public void level8() {
    load();
    bounciness = 0.95;
    gravity = -10;
    int i, x, y;
    for (x = 100; x < 1000; x += 100)
      for (y = 100; y < 500; y += 100)
        bricks.add(new Sphere(new float[] {x, y}, 40, 3, 60, #FF0000, new float[] {1000, 0}, 5));
    for (i = 0; i < 4; i++)
      for (x = 100; x < 1000; x += 100)
        for (y = 100; y < 500; y += 100) {
          bricks.add(new Sphere(new float[] {x, y}, 40, 3, 60, #FFFFFF, new float[] {1000, 0}, 5));
          bricks.get(bricks.size() - 1).stack(bricks.get(bricks.size() - 37));
        }
  }
  
  public void level9() {
    load();
    bounciness = 0.4;
    gravity = -300;
    bricks.add(new Sphere(new float[] {100, 100}, 100, 60, 30, "moon.jpg", 0.1 * TWO_PI));
    bricks.add(new Sphere(new float[] {900, 100}, 100, 60, 30, "moon.jpg", 0.1 * TWO_PI));
    balls.get(0).defaultv *= 5;
  }
    
}
