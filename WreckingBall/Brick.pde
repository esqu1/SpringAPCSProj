public class Brick {
  //This will be a parent class for Rectangular Prism, TrianglePrism, PentagonalPrism, Sphere (?)
  private float[][] vertices;
  private float prismHeight;

  public Brick(float[][] v, float h) {
    vertices = v;
    prismHeight = h;
  }
  public boolean ballInside(Ball b) {
    return true;
  }

  public void draw() {
    beginShape();
    for (float[] i : vertices) {
      vertex(i[0],i[1],prismHeight);
    }
    endShape(CLOSE);
  }
  // checks whether b is inside the brick. 
  public void reflectBall(Ball b){
    
  }
  // calculate the angle of reflection and change the ball's attributes accordingly.
  public void setTexture(){
    /* idk what arg here yet */
  }
  // sets texture 
  public void breakBrick(){
    
  }
  // breaks the brick and updates player's score
}

