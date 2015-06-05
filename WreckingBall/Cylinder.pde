public class Cylinder implements Brick {
  private final int detail = 36;
  // number of quadrilaterals used to draw cylinder

  private float[] unitCircleX = new float[detail];
  private float[] unitCircleY = new float[detail];
  // store the vertices of a regular polygon with detail
  // sides inscribed in the unit circle (slight improvement
  // in efficiency)

  private float unitSideLength;
  // stores the side length of a regular polygon with
  // detail sides inscribed in the unit circle (another
  // slight improvement in efficiency)

  private float[] center;
  // center of the prism

  private float r, h, d;
  // radius, height, and elevation of prism

  private color c;
  // color of prism

  private PImage t;
  // texture of prism

  private float[] reflectionNormal; // for reflecting the ball
  // unit normal to the face that the ball bounces off of

  public Cylinder(
    float[] cylCenter,
    float radius,
    float cylHeight,
    float distanceToBoard,
    color rgb
    ) {
    center = cylCenter;
    r = radius;
    h = cylHeight;
    d = distanceToBoard;
    c = rgb;
    for (int i = 0; i < detail; i++) {
      unitCircleX[i] = cos(i * TWO_PI / detail);
      unitCircleY[i] = sin(i * TWO_PI / detail);
    }
    unitSideLength = sqrt(2 - 2 * cos(TWO_PI / detail));
  }

  public Cylinder(
    float[] cylCenter,
    float radius,
    float cylHeight,
    float distanceToBoard,
    String texture
    ) {
    center = cylCenter;
    r = radius;
    h = cylHeight;
    d = distanceToBoard;
    t = loadImage(texture);
    for (int i = 0; i < detail; i++) {
      unitCircleX[i] = cos(i * TWO_PI / detail);
      unitCircleY[i] = sin(i * TWO_PI / detail);
    }
    unitSideLength = sqrt(2 - 2 * cos(TWO_PI / detail));
  }

  public void draw() {
    if (t == null)
      drawWithoutTexture();
    else
      drawWithTexture();
  }

  private void drawWithoutTexture() {
    fill(c);
    int i;
    // Draw the bottom face.
    beginShape();
    for (i = 0; i < detail; i++)
      vertex(
        center[0] + r * unitCircleX[i],
        center[1] + r * unitCircleY[i],
        d
        );
    endShape(CLOSE);
    // Draw the top face.
    beginShape();
    for (i = 0; i < detail; i++)
      vertex(
        center[0] + r * unitCircleX[i],
        center[1] + r * unitCircleY[i],
        d + h
        );
    endShape(CLOSE);
    // Draw the lateral face.
    noStroke();
    beginShape(QUAD_STRIP);
    for (i = 0; i < detail; i++) {
      vertex(
        center[0] + r * unitCircleX[i],
        center[1] + r * unitCircleY[i],
        d
        );
      vertex(
        center[0] + r * unitCircleX[i],
        center[1] + r * unitCircleY[i],
        d + h
        );
    }
    vertex(
      center[0] + r * unitCircleX[0],
      center[1] + r * unitCircleY[0],
      d
      );
    vertex(
      center[0] + r * unitCircleX[0],
      center[1] + r * unitCircleY[0],
      d + h
      );
    endShape(CLOSE);
  }

  private void drawWithTexture() {
    noStroke();
    int i;
    // Draw the bottom face.
    beginShape();
    texture(t);
    for (i = 0; i < detail; i++)
      vertex(
        center[0] + r * unitCircleX[i],
        center[1] + r * unitCircleY[i],
        d,
        r * (1 + unitCircleX[i]),
        r * (1 + unitCircleY[i])
        );
    endShape(CLOSE);
    // Draw the top face.
    beginShape();
    texture(t);
    for (i = 0; i < detail; i++)
      vertex(
        center[0] + r * unitCircleX[i],
        center[1] + r * unitCircleY[i],
        d + h,
        r * (1 + unitCircleX[i]),
        r * (1 + unitCircleY[i])
        );
    endShape(CLOSE);
    // Draw the lateral face.
    beginShape(QUAD_STRIP);
    texture(t);
    for (i = 0; i < detail; i++) {
      vertex(
        center[0] + r * unitCircleX[i],
        center[1] + r * unitCircleY[i],
        d,
        i * r * unitSideLength,
        0
        );
      vertex(
        center[0] + r * unitCircleX[i],
        center[1] + r * unitCircleY[i],
        d + h,
        i * r * unitSideLength,
        h
        );
    }
    vertex(
      center[0] + r * unitCircleX[0],
      center[1] + r * unitCircleY[0],
      d,
      (detail + 1) * r * unitSideLength,
      0
      );
    vertex(
      center[0] + r * unitCircleX[0],
      center[1] + r * unitCircleY[0],
      d + h,
      (detail + 1) * r * unitSideLength,
      h
      );
    endShape(CLOSE);
  }

  public boolean ballColliding(Ball b) {
    float eqRadius; // equivalent ball radius
    if (b.getRadius() > d + h)
      // if the bottom half of the ball may hit the prism
      eqRadius = sqrt(sq(b.getRadius()) - sq(b.getRadius() - d - h));
    else if (b.getRadius() > d)
      // if the equatorial plane of the ball may hit the prism
      eqRadius = b.getRadius();
    else
      // if the top half of the ball may hit the prism
      // (will only occur if the ball hits the prism
      // as the prism is falling and there are no other
      // bricks under the prism)
      eqRadius = sqrt(sq(b.getRadius()) - sq(d - b.getRadius()));
    if (M.dist(b.getPosition(), center) < eqRadius + r) {
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
    return h;
  }

  public void setColor(color rgb) {
    c = rgb;
    t = null;
  }

  public void setTexture(String texture) {
    t = loadImage(texture);
  }
}
