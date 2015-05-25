public class Paddle{
  private float length; // default width is 5
  private float px, py;
  public Paddle(float w, float px, float py){ //w represents the length
    length = w;
    this.px = px;
    this.py = py;
  }
  
  public void draw(){
    pushMatrix();
    translate(px,py);
    box(length,5,5);
    popMatrix();
  }
}
