public class Brick{
  //This will be a parent class for Rectangular Prism, TrianglePrism, PentagonalPrism, Sphere (?)
  private float[][] vertices;
  private float prismHeight;
  
  public Brick(float[][] v, float h){
    vertices = v;
    prismHeight = h;
  }
  public boolean ballInside(Ball b);
    // checks whether b is inside the brick. 
  //public abstract void reflectBall(Ball b);
    // calculate the angle of reflection and change the ball's attributes accordingly.
  //public abstract void setTexture();/* idk what arg here yet */
   // sets texture 
  //public abstract void breakBrick();
    // breaks the brick and updates player's score 
  
  
  
}
