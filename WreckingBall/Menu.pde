public class Menu {
  private float cx, cy;
  private PFont font = loadFont("Comfortaa-Bold-72.vlw");
  public Menu(WreckingBall wb) {}
  public void draw() {
    background(#FFFFFF);
    textSize(32);
    fill(0);
    textFont(font,72);
    text("Wrecking Ball", width / 2.0 - 250, 100);
    rect(width / 2.0 - 100, height / 2.0 - 100,200,100);
  }
}
