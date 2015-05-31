public class Ball {

  private float[] position, velocity, acceleration;
  private float radius;
  private color c;

  public Ball() {
    position = new float[3];
    velocity = new float[3];
    acceleration = new float[3];
    radius = 20;
    c = #FFFFFF;
  }

  public void draw() {
    fill(c);
    pushMatrix();
    translate(position[0], position[1], position[2]);
    sphere(radius);
    popMatrix();
  }

  public void mousePressed() {
  	position[0] = mouseX * 4 / 3.;
  	position[1] = mouseY * 4 / 3.;
  	position[2] = radius;
  }

  public float getRadius() {
  	return radius;
  }

  public float[] getPosition() {
    return position;
  }

  public float[] getVelocity() {
    return velocity;
  }

  public float[] getAcceleration() {
    return acceleration;
  }
}
