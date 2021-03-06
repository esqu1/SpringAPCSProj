import java.util.Random;
public class Menu {
  private PFont font;
  private int count = 0;
  private Ball b1, b2;
  public int pressed, selected = 60, pressed2;
  private int[][] m = {{-55,-155},{60,-40},{175,75},{290,190}};
  public Menu() {
    font = loadFont("Comfortaa-Bold-72.vlw");
    b1 = new Ball(75,#FF050E);
    b1.setPosition(new float[] {random(width),random(height)});
    b1.setVelocity(new float[] {random(50)+50,random(50)+50});
    b2 = new Ball(75,#05FFDC);
    b2.setPosition(new float[] {random(width),random(height)});
    while(colliding()){
      b2.setPosition(new float[] {random(width),random(height)});
    }
    b2.setVelocity(new float[] {random(50)+50,random(50)+50});
  }
  
  public void draw() {
    drawDefaults();
    
    if(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 - 50 && mouseY >= height / 2.0 - 150){ //is the mouse within the play now box
      fill(#F6FF08);
    }else{
      fill(#2AF011);
    } 
    
    pushMatrix();
    textFont(font,36);
    translate(width / 2.0, height / 2.0 - 100,-12.5);
    if(pressed2 == 1){
      translate(0,0,-18.75);
      box(400,100,37.5);
      translate(0,0,18.75);
    }else{
      box(400,100,75);
    }
    fill(0);
    translate(-75,0,50);
    text("Play Now!", 0,0, pressed2 == 1 ? -30 : 0);
    popMatrix();
    
    if(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 + 150 && mouseY >= height / 2.0 + 50){ // for the options box
      fill(#F6FF08);
    }else{
      fill(#2AF011);
    }
        
    pushMatrix(); // drawing the options box
    textSize(36);
    translate(width / 2.0, height / 2.0 + 100,-12.5);
    if(pressed2 == 2){
      translate(0,0,-18.75);
      box(400,100,37.5);
      translate(0,0,18.75);
    }else{
      box(400,100,75);
    }
    fill(0);
    translate(-70,-10,50);
    text("Settings",0,0, pressed2 == 2 ? -30 : 0);
    popMatrix();

    pushMatrix();
    translate(width / 2.0 - 270, height / 2.0 + 190, 50);  
    textFont(font,20);
    text("Team YatuLin\nDennis Yatunin and Brandon Lin",-50,50);
    popMatrix();
    fill(0);
  }

  
  public void drawOptions(){
    drawDefaults();
    
    pushMatrix();
    fill(0);
    translate(width / 2.0 - 300, height / 2.0 - 100,-12.5);
    textFont(font,16);
    text("Smoothness is only available on certain devices.",200,100);
    textFont(font,20);
    text("Smoothness",0,0);
    translate(200,0);

    for(int[] i : m){
      if(mouseX <= width / 2.0 + i[0] && mouseX >= width / 2.0 + i[1] && mouseY <= height / 2.0 - 50 && mouseY >= height / 2.0 - 150){ 
        fill(#F6FF08);
      }else if(i[0] == selected){
        fill(#FF58F7);
      }else{
        fill(#045813);
      }
      if(i[0] == pressed){
        translate(0,0,-18.75);
        box(100,100,37.5);
        translate(0,0,18.75);
      }else{
        box(100,100,75);
      }
      fill(0);
      translate(110,0);
    }
    translate(0,5,38);
    text("None",-465,0, pressed == -55 ? -30 : 0 );
    text("Low",-350,0,pressed == 60 ? -30 : 0);
    text("Medium",-255,0,pressed == 175 ? -30 : 0);
    text("High",-135,0, pressed == 290 ? -30 : 0);
    translate(-175,375,-38);
    if(mouseX <= width / 2.0 + 262.5 && mouseX >= width / 2.0 + 75 && mouseY <= height / 2.0 +337.5 && mouseY >= height / 2.0 +225){ 
        fill(#F6FF08);
      }else{
        fill(#2AF011);
    }
    if(pressed == 999){
      translate(0,0,-18.75);
      box(175,100,37.5);
      translate(0,0,18.75);
    }else{
      box(175,100,75);
    }
    translate(-50,-5,38);
    fill(0);
    text("Return to\nMenu",0,0,pressed == 999 ? -30 : 0);

    popMatrix();
    
  }
  
  
  public void drawDefaults(){
    background(#FFFFFF); // white

    pushMatrix();
    textSize(32);
    translate(0,0,-200); // -200 to make sure the balls appear below the prisms
    b1.draw(); // Draw the spheres.
    b2.draw();
    popMatrix();
    reflect(); // if the balls are colliding, reflect them.
    boundReflect(b1);
    boundReflect(b2);
    fill(0);
    shininess(4.0);
    
    textFont(font,72);  // title    
    text("Wrecking Ball", width / 2.0 - 250, 100);
    
    pushMatrix(); // For drawing the team name
    translate(width / 2.0 - 270, height / 2.0 + 190, 50);  
    textFont(font,20);
    text("Team YatuLin\nDennis Yatunin and Brandon Lin",-50,50);
    popMatrix();
    
    fill(0);
  }
  
  public boolean colliding(){
    return M.dist(b1.getPosition(),b2.getPosition()) < b1.getRadius() + b2.getRadius();
  }

  public void reflect(){
    if(colliding()){ // are the balls colliding?
      float[] temp = b1.getVelocity(); // swap their velocities, I DON'T KNOW IF THIS IS HOW PHYSICS ACTUALLY WORKS
      b1.setVelocity(b2.getVelocity()); 
      b2.setVelocity(temp); 
    }
  }
  
  public void boundReflect(Ball b){
    if(b.getPosition()[0] <= 0 || b.getPosition()[0] >= width){
      b.setVelocity(new float[] {-b.getVelocity()[0], b.getVelocity()[1]}); 
    }else if(b.getPosition()[1] <= 0 || b.getPosition()[1] >= height){
      b.setVelocity(new float[] {b.getVelocity()[0], -b.getVelocity()[1]}); 
    }
  }
  
}
