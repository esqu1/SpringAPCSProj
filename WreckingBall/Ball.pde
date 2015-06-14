public class Ball {
  private float[] p, v, a;
  private float r;
  private color c;
  private PImage t;
  private float defaultv;

  public Ball(float radius, color rgb) {
    p = new float[2];
    v = new float[2];
    a = new float[2];
    r = radius;
    c = rgb;
    defaultv = 240;
    // FOR DEBUGGING
    v[0] = 0;
    v[1] = -240;
    p[0] = 500;
    p[1] = 800;
  }

  public Ball(float radius, String texture) {
    p = new float[2];
    v = new float[2];
    a = new float[2];
    r = radius;
    t = loadImage(texture);
  }

  public void draw() {
    move();
    beActedUpon();
    if (t != null)
      drawWithTexture();
    else
      drawWithoutTexture();
  }

  private void drawWithoutTexture() {
    fill(c);
    noStroke();
    shininess(4.0);
    pushMatrix();
    translate(p[0], p[1], r);
    sphere(r);
    popMatrix();
    move();
  }

  private void drawWithTexture() {

  }

  private void move() {
    // bring velocity back to default
    println(dead());
    if (M.mag(v) > defaultv)
      v = M.scale(v, 0.99);
    else if (M.mag(v) < defaultv)
      v = M.scale(v, 1.01);
    // out of bounds handling
    if (mode == PLAYING && p[0] <= r || p[0] >= boardLength - r){
      v[0] *= -1;
      hit.play(0);
    }
    if (mode == PLAYING && p[1] <= r){
      v[1] *= -1;
      hit.play(0);
    }
    // x(t) = x_0 + v_0 * t + 1/2 * a * t^2
    p[0] += v[0] / 60 + a[0] / 7200;
    p[1] += v[1] / 60 + a[1] / 7200;
    // FOR DEBUGGING
    if (mode == PLAYING && mousePressed && mouseButton == LEFT) {
      p[0] = mouseX * 4 / 3.;
      p[1] = mouseY * 4 / 3.;
    }
  }

  public void beActedUpon() {
    if(mode == PLAYING){
    int i;
    for (i = 0; i < bricks.size(); i++)
      bricks.get(i).actOnBall(this);
    for (i = 0; i < paddles.size(); i++)
      if (paddles.get(i).ballColliding(this))
        paddles.get(i).reflectBall(this);
    }
  }
  
  public boolean dead(){
    return p[1] > boardLength + r; 
  }

  public float getRadius() {
    return r;
  }

  public float[] getPosition() {
    return p;
  }

  public float[] getVelocity() {
    return v;
  }

  public float[] getAcceleration() {
    return a;
  }

  public void setRadius(float radius) {
    r = radius;
  }

  public void setPosition(float[] position) {
    p = position;
  }

  public void setVelocity(float[] velocity) {
    v = velocity;
  }

  public void setAcceleration(float[] acceleration) {
    a = acceleration;
  }
}
