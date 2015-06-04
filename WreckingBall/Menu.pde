public class Menu {
  private PFont font;
  private Ball b1, b2;
  public Menu() {
    font = loadFont("Comfortaa-Bold-72.vlw");
    b1 = new Ball(100,#FF050E);
    b1.setPosition(new float[] {200,700});
    b1.setVelocity(new float[] {10,-60});
    b2 = new Ball(100,#05FFDC);
    b2.setPosition(new float[] {500,700});
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
    textFont(font,72);
    text("Wrecking Ball", width / 2.0 - 250, 100);
    if(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 - 100 && mouseY >= height / 2.0 - 200){
      fill(#F6FF08);
    }else{
      fill(#2AF011);
    }      
    strokeWeight(6);
    rect(width / 2.0 - 200, height / 2.0 - 200,400,100);
    fill(#2AF011);
    rect(width / 2.0 - 200, height / 2.0 - 50, 400,100);
    textFont(font,36);
    fill(0);
    text("Play Now!", width / 2.0 - 75, height / 2.0 - 150);
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
