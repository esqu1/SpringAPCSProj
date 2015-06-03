public class Menu {
  private float cx, cy;
  private PFont font ;
  public Menu() {
    font = loadFont("Comfortaa-Bold-72.vlw");
  }
  public void draw() {
    background(#FFFFFF);
    textSize(32);
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
}
