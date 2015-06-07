public class Cylinder implements Brick {
  private int detail;
  // number of points that determine the top and bottom
  // faces of the cylinder

  private float[][] unitCircleXY;
  // coordinates of evenly-spaced points on a unit circle

  private float[][] normals;
  // normals to the lateral face of the cylinder

  private float[] center;
  // center of the cylinder

  private float r, h, d;
  // radius, height, and elevation of cylinder

  private color c;
  // color of cylinder

  private PImage t;
  // texture of cylinder

  private float[] textureX;
  // x-coordinates of points on the texture image that divide
  // it into detail sections

  // The point (textureX[i], y) will map to (unitCircleXY[i][0],
  // unitCircleXY[i][1], y) on the unit cylinder (r = 1, d = 0).

  private float[] reflectionNormal;
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
    detail = 60;
    int i;
    unitCircleXY = new float[detail + 1][2];
    for (i = 0; i <= detail; i++) {
      unitCircleXY[i][0] = cos(i * TWO_PI / detail);
      unitCircleXY[i][1] = sin(i * TWO_PI / detail);
    }
    normals = new float[detail][2];
    for (i = 0; i < detail; i++)
      normals[i] = M.norm(unitCircleXY[i], unitCircleXY[i + 1]);
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
    detail = 60;
    int i;
    unitCircleXY = new float[detail + 1][2];
    for (i = 0; i <= detail; i++) {
      unitCircleXY[i][0] = cos(i * TWO_PI / detail);
      unitCircleXY[i][1] = sin(i * TWO_PI / detail);
    }
    normals = new float[detail][2];
    for (i = 0; i < detail - 1; i++)
      normals[i] = M.norm(unitCircleXY[i], unitCircleXY[i + 1]);
    normals[detail - 1] =
      M.norm(
        unitCircleXY[detail - 1],
        unitCircleXY[0]
        );
    textureX = new float[detail + 1];
    for (i = 0; i <= detail; i++)
      textureX[i] = i * sqrt(2 - 2 * cos(TWO_PI / detail));
  }

  public void draw() {
    if (t == null)
      drawWithoutTexture();
    else
      drawWithTexture();
  }

  private void drawWithoutTexture() {
    fill(c);
    pushMatrix();
    translate(center[0], center[1], d);
    int i;
    // Draw the bottom face.
    beginShape();
    normal(0, 0, -1);
    for (i = 0; i < detail; i++)
      vertex(
        r * unitCircleXY[i][0],
        r * unitCircleXY[i][1],
        0
        );
    endShape(CLOSE);
    // Draw the top face.
    beginShape();
    normal(0, 0, 1);
    for (i = 0; i < detail; i++)
      vertex(
        r * unitCircleXY[i][0],
        r * unitCircleXY[i][1],
        h
        );
    endShape(CLOSE);
    // Draw the lateral face.
    noStroke();
    beginShape(QUAD_STRIP);
    for (i = 0; i < detail; i++) {
      normal(normals[i][0], normals[i][1], 0);
      vertex(r * unitCircleXY[i][0], r * unitCircleXY[i][1], h);
      vertex(r * unitCircleXY[i][0], r * unitCircleXY[i][1], 0);
      vertex(r * unitCircleXY[i + 1][0], r * unitCircleXY[i + 1][1], h);
      vertex(r * unitCircleXY[i + 1][0], r * unitCircleXY[i + 1][1], 0);
    }
    endShape(CLOSE);
    popMatrix();
  }

  private void drawWithTexture() {
    noStroke();
    pushMatrix();
    translate(center[0], center[1], d);
    int i;
    // Draw the bottom face.
    beginShape();
    texture(t);
    normal(0, 0, -1);
    for (i = 0; i < detail; i++)
      vertex(
        r * unitCircleXY[i][0], r * unitCircleXY[i][1], 0,
        r * (1 + unitCircleXY[i][0]), r * (1 + unitCircleXY[i][1])
        );
    endShape(CLOSE);
    // Draw the top face.
    beginShape();
    texture(t);
    normal(0, 0, 1);
    for (i = 0; i < detail; i++)
      vertex(
        r * unitCircleXY[i][0], r * unitCircleXY[i][1], h,
        r * (1 + unitCircleXY[i][0]), r * (1 + unitCircleXY[i][1])
        );
    endShape(CLOSE);
    // Draw the lateral face.
    beginShape(QUAD_STRIP);
    texture(t);
    for (i = 0; i < detail; i++) {
      normal(normals[i][0], normals[i][1], 0);
      vertex(
        r * unitCircleXY[i][0], r * unitCircleXY[i][1], h,
        r * textureX[i], 0
        );
      vertex(
        r * unitCircleXY[i][0], r * unitCircleXY[i][1], 0,
        r * textureX[i], h
        );
      vertex(
        r * unitCircleXY[i + 1][0], r * unitCircleXY[i + 1][1], h,
        r * textureX[i + 1], 0
        );
      vertex(
        r * unitCircleXY[i + 1][0], r * unitCircleXY[i + 1][1], 0,
        r * textureX[i + 1], h
        );
    }
    endShape(CLOSE);
    popMatrix();
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
    if (textureX == null) {
      textureX = new float[detail + 1];
      for (int i = 0; i <= detail; i++)
        textureX[i] = i * sqrt(2 - 2 * cos(TWO_PI / detail));
    }
  }
}
