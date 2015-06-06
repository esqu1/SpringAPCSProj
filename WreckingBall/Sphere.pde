public class Sphere implements Brick {
  private int detailX = 24;
  private int detailY = 12;
  // number of points that determine any circle of latitude
  // of the sphere and any meridian of the sphere, respectively

  private float[][][] unitSphereXYZ;
  // coordinates of evenly-spaced points on a unit sphere

  private float[] center;
  // center of sphere

  private float r, d;
  // radius and elevation of sphere

  private float anlgeOfRevolution, angleOfRolling;
  // anlges for drawing the sphere

  private color c;
  // color of sphere

  private PImage t;
  // texture of sphere

  private float[] textureX, textureY;
  // coordinates of points on each axis of the texture image that
  // divide it into a detailX by detailY grid

  // The point (textureX[i], textureY[j]) on the texture image will
  // map to the point (unitSphereXYZ[i][j][0], unitSphereXYZ[i][j][1],
  // unitSphereXYZ[i][j][2]) on the unit sphere (r = 1, d = 0).

  private float[] reflectionNormal;
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
    int i, j;
    unitSphereXYZ = new float[detailX + 1][detailY + 1][3];
    for (i = 0; i <= detailX; i++)
      for (j = 0; j <= detailY; j++) {
        // polar angle = PI - j * PI / detailY
        // azimuthal angle = i * TWO_PI / detailX
        // x = sin(polar angle)cos(azimuthal angle)
        // y = sin(polar angle)sin(azimuthal angle)
        // z = cos(polar angle)
        unitSphereXYZ[i][j][0] =
          sin(PI - j * PI / detailY) *
          cos(i * TWO_PI / detailX);
        unitSphereXYZ[i][j][1] =
          sin(PI - j * PI / detailY) *
          sin(i * TWO_PI / detailX);
        unitSphereXYZ[i][j][2] =
          cos(PI - j * PI / detailY);
      }
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
    int i, j;
    unitSphereXYZ = new float[detailX + 1][detailY + 1][3];
    for (i = 0; i <= detailX; i++)
      for (j = 0; j <= detailY; j++) {
        // polar angle = PI - j * PI / detailY
        // azimuthal angle = i * TWO_PI / detailX
        // x = sin(polar angle)cos(azimuthal angle)
        // y = sin(polar angle)sin(azimuthal angle)
        // z = cos(polar angle)
        unitSphereXYZ[i][j][0] =
          sin(PI - j * PI / detailY) *
          cos(i * TWO_PI / detailX);
        unitSphereXYZ[i][j][1] =
          sin(PI - j * PI / detailY) *
          sin(i * TWO_PI / detailX);
        unitSphereXYZ[i][j][2] =
          cos(PI - j * PI / detailY);
      }
    textureX = new float[detailX + 1];
    for (i = 0; i <= detailX; i++)
      textureX[i] = 1.0 * t.width * i / detailX;
    textureY = new float[detailY + 1];
    for (i = 0; i <= detailY; i++)
      textureY[i] = 1.0 * t.height * i / detailY;
  }

  public void draw() {
    revolve(PI / 20);
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
    int i, j;
    for (j = 0; j < detailY; j++) {
      beginShape(QUAD_STRIP);
      for (i = 0; i <= detailX; i++) {
        vertex(
          r * unitSphereXYZ[i][j + 1][0],
          r * unitSphereXYZ[i][j + 1][1],
          r * unitSphereXYZ[i][j + 1][2]
          );
        vertex(
          r * unitSphereXYZ[i][j][0],
          r * unitSphereXYZ[i][j][1],
          r * unitSphereXYZ[i][j][2]
          );
      }
      endShape(CLOSE);
    }
    popMatrix();
  }

  private void drawWithTexture() {
    // Using equirectangular projection ... no Mercator or
    // Gall-Peters or anything of that sort.
    noStroke();
    pushMatrix();
    translate(center[0], center[1], r + d);
    // Flip the ball upside down because the z-axis
    // is pointing downward.
    rotateX(PI);
    // Rotate the ball by the angle of revolution.
    rotateZ(anlgeOfRevolution);
    int i, j;
    for (j = 0; j < detailY; j++) {
      beginShape(QUAD_STRIP);
      texture(t);
      for (i = 0; i <= detailX; i++) {
        vertex(
          r * unitSphereXYZ[i][j + 1][0],
          r * unitSphereXYZ[i][j + 1][1],
          r * unitSphereXYZ[i][j + 1][2],
          textureX[i],
          textureY[j + 1]
          );
        vertex(
          r * unitSphereXYZ[i][j][0],
          r * unitSphereXYZ[i][j][1],
          r * unitSphereXYZ[i][j][2],
          textureX[i],
          textureY[j]
          );
      }
      endShape(CLOSE);
    }
    popMatrix();
  }

  public void revolve(float omega) {
    // theta(t) = theta_0 + omega * t
    // omega is in rad/second
    anlgeOfRevolution += omega / 30;
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
    textureX = null;
    textureY = null;
  }

  public void setTexture(String texture) {
    t = loadImage(texture);
    int i;
    textureX = new float[detailX + 1];
    for (i = 0; i <= detailX; i++)
      textureX[i] = 1.0 * t.width * i / detailX;
    textureY = new float[detailY + 1];
    for (i = 0; i <= detailY; i++)
      textureY[i] = 1.0 * t.height * i / detailY;
  }
}
