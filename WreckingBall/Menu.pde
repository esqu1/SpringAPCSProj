public class Menu {
  private PFont font;
  private Ball b1, b2;
  public Menu() {
    font = loadFont("Comfortaa-Bold-72.vlw");
    b1 = new Ball(100,#FF050E);
    b1.setPosition(new float[] {400,900});
    b2 = new Ball(100,#05FFDC);
    b2.setPosition(new float[] {500,900});
  }
  public void draw() {
    background(#FFFFFF);
    textSize(32);
    pushMatrix();
    translate(0,0,-200);
    b1.draw();
    b2.draw();
    popMatrix();
    fill(0);
    textFont(font,72);
    text("Wrecking Ball", width / 2.0 - 250, 100);
    if(mouseX <= width / 2.0 + 200 && mouseX >= width / 2.0 - 200 && mouseY <= height / 2.0 - 100 && mouseY >= height / 2.0 - 200){
      fill(#F6FF08);
    }else{
      fill(#2AF011);
    }      
    strokeWeight(5);
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
  
  
}
