public class Ball {
  private float[] position, velocity, acceleration;
  private float r;
  private color c;
  private PImage t;

  public Ball(float radius, color rgb) {
    position = new float[2];
    velocity = new float[2];
    acceleration = new float[2];
    r = radius;
    c = rgb;
    // FOR DEBUGGING
    velocity[0] = 0;
    velocity[1] = -60;
    position[0] = 500;
    position[1] = 800;
  }

  public Ball(float radius, String texture) {
    position = new float[2];
    velocity = new float[2];
    acceleration = new float[2];
    r = radius;
    t = loadImage(texture);
  }

  public void draw() {
    move();
    if (t != null)
      drawWithTexture();
    else
      drawWithoutTexture();
  }

  private void drawWithoutTexture() {
    fill(c);
    //shininess(4.0);
    pushMatrix();
    translate(position[0], position[1], r);
    sphere(r);
    popMatrix();
    move();
  }

  private void drawWithTexture() {
  }

  private void move() {
    // x(t) = x_0 + v_0 * t + 1/2 * a * t^2
    position[0] += velocity[0] / 60 + acceleration[0] / 7200;
    position[1] += velocity[1] / 60 + acceleration[1] / 7200;
    // FOR DEBUGGING
    if (mousePressed) {
      position[0] = mouseX * 4 / 3.;
      position[1] = mouseY * 4 / 3.;
    }
  }

  public float getRadius() {
    return r;
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

  public float setRadius(float radius) {
    return r;
  }

  public void setPosition(float[] p) {
    position = p;
  }

  public void setVelocity(float[] v) {
    velocity = v;
  }

  public void setAcceleration(float[] a) {
    acceleration = a;
  }
}

