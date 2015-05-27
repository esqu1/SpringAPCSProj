public class Board {
  private color c;
  public Board(int rgb) {
    c = rgb;
  }
  public void draw() {
    fill(c);
    rect(0, 0, width, height);
  }
}

