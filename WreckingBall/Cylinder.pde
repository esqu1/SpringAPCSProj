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

  private float rotationVelocity, anlgeOfRotation;
  // angular kinematics for the cylinder

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

  private Brick above, below;
  // bricks directly above and below this one

  private float[] velocity;
  // velocity of the cylinder

  private float maxDist, currentDist;
  // how far the cylinder can go and how far it has gone

  public Cylinder(
    float[] cylCenter,
    float radius,
    float cylHeight,
    int d
    ) {
    center = cylCenter;
    r = radius;
    h = cylHeight;
    detail = d;
    velocity = new float[3];
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
    int d,
    color rgb
    ) {
    this(cylCenter, radius, cylHeight, d);
    c = rgb;
  }

  public Cylinder(
    float[] cylCenter,
    float radius,
    float cylHeight,
    int d,
    String texture
    ) {
    this(cylCenter, radius, cylHeight, d);
    t = loadImage(texture);
    textureX = new float[detail + 1];
    for (int i = 0; i <= detail; i++)
      textureX[i] = i * sqrt(2 - 2 * cos(TWO_PI / detail));
  }

  public Cylinder(
    float[] cylCenter,
    float radius,
    float cylHeight,
    int d,
    color rgb,
    float omega
    ) {
    this(cylCenter, radius, cylHeight, d, rgb);
    rotationVelocity = omega;
  }

  public Cylinder(
    float[] cylCenter,
    float radius,
    float cylHeight,
    int d,
    String texture,
    float omega
    ) {
    this(cylCenter, radius, cylHeight, d, texture);
    rotationVelocity = omega;
  }

  public Cylinder(
    float[] cylCenter,
    float radius,
    float cylHeight,
    int d,
    color rgb,
    float[] cylVelocity,
    float oscillationDistance
    ) {
    this(cylCenter, radius, cylHeight, d, rgb);
    velocity[0] = cylVelocity[0];
    velocity[1] = cylVelocity[1];
    maxDist = oscillationDistance;
  }

  public Cylinder(
    float[] cylCenter,
    float radius,
    float cylHeight,
    int d,
    String texture,
    float[] cylVelocity,
    float oscillationDistance
    ) {
    this(cylCenter, radius, cylHeight, d, texture);
    velocity[0] = cylVelocity[0];
    velocity[1] = cylVelocity[1];
    maxDist = oscillationDistance;
  }

  public float getHeight() {
    return h;
  }

  public float getElevation() {
    return d;
  }

  public void setAbove(Brick b) {
    above = b;
  }

  public void setBelow(Brick b) {
    below = b;
  }

  public void stack(Brick b) {
    below = b;
    b.setAbove(this);
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

  public void actOnBall(Ball b) {
    if (ballColliding(b)) {
      reflectBall(b);
      die();
    }
  }

  private boolean ballColliding(Ball b) {
    float eqRadius; // equivalent ball radius
    if (b.getRadius() > d + h)
      // if the bottom half of the ball may hit the cylinder
      eqRadius = sqrt(sq(b.getRadius()) - sq(b.getRadius() - d - h));
    else if (b.getRadius() > d)
      // if the equatorial plane of the ball may hit the cylinder
      eqRadius = b.getRadius();
    else
      // if the top half of the ball may hit the cylinder
      // (will only occur if the ball hits the cylinder
      // as the cylinder is falling and there are no other
      // bricks under the cylinder)
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

  private void reflectBall(Ball b) {
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

  private void die() {
    bricks.remove(this);
    if (above != null)
      above.setBelow(below);
  }

  public void draw() {
    move();
    if (t == null)
      drawWithoutTexture();
    else
      drawWithTexture();
  }

  private void move() {
    // x(t) = x_0 + v * t
    center[0] += velocity[0] / frameRate;
    center[1] += velocity[1] / frameRate;
    currentDist += sqrt(sq(velocity[0] / frameRate) + sq(velocity[1] / frameRate));
    if (currentDist > maxDist) {
      velocity[0] *= -1;
      velocity[1] *= -1;
      currentDist = 0;
    }
    if (below == null) {
      if (d > 0)
        // v(t) = v_0 + a * t
        velocity[2] += g / frameRate;
      else {
        // bounce back up with dampened motion
        velocity[2] /= -3;
        d = velocity[2] / frameRate;
      }
      if (velocity[2] < 0.01 && velocity[2] > -0.01) {
        // if motion has been dampened enough, stop
        velocity[2] = 0;
        d = 0;
      }
    }
    else {
      if (d > below.getElevation() + below.getHeight())
        // v(t) = v_0 + a * t
        velocity[2] += g / frameRate;
      else {
        // bounce back up with dampened motion
        velocity[2] /= -3;
        d = below.getElevation() + below.getHeight() + velocity[2] / frameRate;
      }
      if (velocity[2] < 0.01 && velocity[2] > -0.01) {
        // if motion has been dampened enough, stop
        velocity[2] = 0;
        d = below.getElevation() + below.getHeight();
      }
    }
    d += velocity[2] / frameRate;
    // theta(t) = theta_0 + omega * t
    anlgeOfRotation += rotationVelocity / frameRate;
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
    // Rotate the ball by the angle of rotation.
    rotateZ(anlgeOfRotation);
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
}
