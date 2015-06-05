public class Sphere implements Brick {
  private float[] center;
  // center of sphere

  private float r, d;
  // radius and elevation of sphere

  private color c;
  // color of prism

  private PImage t;
  // texture of prism

  private float[] reflectionNormal; // for reflecting the ball
  // normal to the point on the sphere that the ball bounces off of

  public Sphere(
    float[] centre,
    float radius,
    float distanceToBoard,
    color rgb
    ) {
    center = centre;
    r = radius;
    d = distanceToBoard;
    c = rgb;
  }

  public Sphere(
    float[] centre,
    float radius,
    float distanceToBoard,
    String texture
    ) {
    center = centre;
    r = radius;
    d = distanceToBoard;
    t = loadImage(texture);
  }

  public void draw() {
    if (t == null)
      drawWithoutTexture();
    else
      drawWithTexture();
  }

  private void drawWithoutTexture() {
    fill(c);
    noStroke();
    pushMatrix();
    translate(center[0], center[1], r + d);
    sphere(r);
    popMatrix();
  }

  private void drawWithTexture() {

  }

  public boolean ballColliding(Ball b) {
    if (
      sq(b.getPosition()[0] - center[0]) +
      sq(b.getPosition()[1] - center[1]) <
      (d + 2 * r) * (2 * b.getRadius() - d)
      ) {
      reflectionNormal =
        M.scale(
          M.dif(b.getPosition(), center),
          1 / M.mag(M.dif(b.getPosition(), center))
          );
      return true;
    }
    return false;
  }

  public void reflectBall(Ball b) {
    if (reflectionNormal == null)
      throw new Error(
        "ERROR: reflectBall() can only be called if ballColliding() returned true"
        );
    // v_r = v_i - 2(v_i . n)n
    b.setVelocity(
      M.dif(
        b.getVelocity(),
        M.scale(
          reflectionNormal,
          2 * M.dot(b.getVelocity(), reflectionNormal)
          )
        )
      );
    reflectionNormal = null;
  }

  public float getHeight() {
    return 2 * r;
  }

  public void setColor(color rgb) {
    c = rgb;
    t = null;
  }

  public void setTexture(String texture) {
    t = loadImage(texture);
  }
}
