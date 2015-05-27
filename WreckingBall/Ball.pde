public class Ball {
  private PVector position, velocity, acceleration;
  private final int BALLRADIUS = 100; //temporary
  public Ball(float x, float y) {
    position = new PVector(x,y,BALLRADIUS);
    velocity = new PVector();
    acceleration = new PVector();
  }
  public void applyForce(double[] force) {
    
  }
  
  public void draw(){ // ************************** TEMPORARY *************************
    fill(128);
    pushMatrix();
    translate(position.x - BALLRADIUS,position.y - BALLRADIUS, BALLRADIUS);
    sphere(BALLRADIUS);
    popMatrix();
  }

  public PVector getPosition() {
    return position;
  }

  public PVector getVelocity() {
    return velocity;
  }

  public PVector getAcceleration() {
    return acceleration;
  }
}

