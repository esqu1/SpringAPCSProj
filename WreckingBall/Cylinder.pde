public class Cylinder implements Brick {
  private float cx, cy;
  // Coordinates of the center of the cylinder.
  
  private float radius;
  // Radius of the cylinder.
  
  private float cylHeight;
  // Height of the Cylinder.
  
  private color c;
  // color of prism

  private PImage t;
  // texture of prism
  
  public Cylinder(float x, float y, float r, float h, color col){
    cx = x; 
    cy = y;
    radius = r;
    cylHeight = h;
    c = col;
  }
  
  public float getX(){
    return cx;
  }
  
  public float getY(){
    return cy;
  }

  public float getHeight(){
    return cylHeight;
  }

    
  
  public void draw(){
    // Now this is going to get complicated... going to figure out something with beginShape(QUAD_STRIP) to draw a cylinder. 
    
  }
  
  public boolean ballColliding(Ball b){
    return (x - b.getPosition().x)*(x - b.getPosition().x) + (y - b.getPosition().y)*(y - b.getPosition().y) <= b.getRadius() + radius;   
  }
}
