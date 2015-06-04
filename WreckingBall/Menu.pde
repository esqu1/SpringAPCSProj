import java.util.Random;
public class Menu {
  private PFont font;
  private int count = 0;
  private Ball b1, b2;
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
    background(#FFFFFF);
    textSize(32);
    pushMatrix();
    translate(0,0,-200);
    b1.draw();
    b2.draw();
    popMatrix();
    reflect();
    boundReflect(b1);
    boundReflect(b2);
    fill(0);
    shininess(4.0);
    textFont(font,72);
    text("Wrecking Ball", width / 2.0 - 250, 100);
    if(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 - 50 && mouseY >= height / 2.0 - 150){
      fill(#F6FF08);
    }else{
      fill(#2AF011);
    }      
    strokeWeight(6);
    pushMatrix();
    textFont(font,36);
    translate(width / 2.0, height / 2.0 - 100);
    box(400,100,50);
    fill(0);
    translate(-75,0,50);
    text("Play Now!", 0,0);
    popMatrix();
    if(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 + 150 && mouseY >= height / 2.0 + 50){
      fill(#F6FF08);
    }else{
      fill(#2AF011);
    }
    pushMatrix();
    translate(width / 2.0, height / 2.0 + 100);
    box(400,100,50);
    fill(0);
    translate(-37,0,50);
    text("Exit",0,0);
    translate(-200,100);
    textFont(font,20);
    text("Team YatuLin\nBrandon Lin and Dennis Yatunin",-50,50);
    popMatrix();
    fill(0);
    //text("Play Now!", width / 2.0 - 75, height / 2.0 - 150);
    //text("Exit", width / 2.0 - 25, height / 2.0);
  }
  
  public boolean colliding(){
    return M.dist(b1.getPosition(),b2.getPosition()) < b1.getRadius() + b2.getRadius();
  }
  
  public void reflect(){
    if(colliding()){
      float[] temp = b1.getVelocity();
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
