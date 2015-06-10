public class Sphere implements Brick {
  private int detailX, detailY;
  // number of points that determine any circle of latitude
  // of the sphere and any meridian of the sphere, respectively

  private float[][][] unitSphereXYZ;
  // coordinates of evenly-spaced points on a unit sphere

  private float[][][] normals;
  // normals to each of the faces of the sphere

  private float[] center;
  // center of sphere

  private float r, d;
  // radius and elevation of sphere

  private float rotationVelocity, anlgeOfRotation, angleOfRolling;
  // angular kinematics for the sphere

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

  private Brick above, below;
  // bricks directly above and below this one

  private float[] velocity;
  // velocity of the sphere

  private float maxDist, currentDist;
  // how far the sphere can go and how far it has gone

  public Sphere(
    float[] centre,
    float radius,
    int dx,
    int dy
    ) {
    center = centre;
    r = radius;
    detailX = dx;
    detailY = dy;
    velocity = new float[3];
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
    normals = new float[detailX][detailY][3];
    for (i = 0; i < detailX; i++)
      for (j = 0; j < detailY; j++)
        normals[i][j] =
          M.norm(
            unitSphereXYZ[i + 1][j],
            unitSphereXYZ[i][j],
            unitSphereXYZ[i][j + 1]
            );
  }

  public Sphere(
    float[] centre,
    float radius,
    int dx,
    int dy,
    color rgb
    ) {
    this(centre, radius, dx, dy);
    c = rgb;
  }

  public Sphere(
    float[] centre,
    float radius,
    int dx,
    int dy,
    String texture
    ) {
    this(centre, radius, dx, dy);
    t = loadImage(texture);
    int i;
    textureX = new float[detailX + 1];
    for (i = 0; i <= detailX; i++)
      textureX[i] = 1.0 * t.width * i / detailX;
    textureY = new float[detailY + 1];
    for (i = 0; i <= detailY; i++)
      textureY[i] = 1.0 * t.height * i / detailY;
  }

  public Sphere(
    float[] centre,
    float radius,
    int dx,
    int dy,
    color rgb,
    float omega
    ) {
    this(centre, radius, dx, dy, rgb);
    rotationVelocity = omega;
  }

  public Sphere(
    float[] centre,
    float radius,
    int dx,
    int dy,
    String texture,
    float omega
    ) {
    this(centre, radius, dx, dy, texture);
    rotationVelocity = omega;
  }

  public Sphere(
    float[] centre,
    float radius,
    int dx,
    int dy,
    color rgb,
    float[] sphereVelocity,
    float oscillationDistance
    ) {
    this(centre, radius, dx, dy, rgb);
    velocity[0] = sphereVelocity[0];
    velocity[1] = sphereVelocity[1];
    maxDist = oscillationDistance;
  }

  public Sphere(
    float[] centre,
    float radius,
    int dx,
    int dy,
    String texture,
    float[] sphereVelocity,
    float oscillationDistance
    ) {
    this(centre, radius, dx, dy, texture);
    velocity[0] = sphereVelocity[0];
    velocity[1] = sphereVelocity[1];
    maxDist = oscillationDistance;
  }

  public float getHeight() {
    return 2 * r;
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
    int i;
    textureX = new float[detailX + 1];
    for (i = 0; i <= detailX; i++)
      textureX[i] = 1.0 * t.width * i / detailX;
    textureY = new float[detailY + 1];
    for (i = 0; i <= detailY; i++)
      textureY[i] = 1.0 * t.height * i / detailY;
  }

  public void actOnBall(Ball b) {
    if (ballColliding(b)) {
      reflectBall(b);
      die();
    }
  }

  private boolean ballColliding(Ball b) {
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
    currentDist += sqrt(sq(velocity[0]) + sq(velocity[1]));
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
    // omega = v / r
    angleOfRolling += sqrt(sq(velocity[0] / frameRate) + sq(velocity[1] / frameRate)) / r / frameRate;
    anlgeOfRotation += rotationVelocity / frameRate;
  }

  private void drawWithoutTexture() {
    fill(c);
    noStroke();
    pushMatrix();
    translate(center[0], center[1], r + d);
    // Rotate the ball by the angle of rolling.
    rotate(angleOfRolling, -velocity[1], velocity[0], 0);
    // Rotate the ball by the angle of rotation.
    rotateZ(anlgeOfRotation);
    int i, j;
    for (j = 0; j < detailY; j++) {
      beginShape(QUAD_STRIP);
      for (i = 0; i < detailX; i++) {
        normal(
          normals[i][j][0],
          normals[i][j][1],
          normals[i][j][2]
          );
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
        vertex(
          r * unitSphereXYZ[i + 1][j + 1][0],
          r * unitSphereXYZ[i + 1][j + 1][1],
          r * unitSphereXYZ[i + 1][j + 1][2]
          );
        vertex(
          r * unitSphereXYZ[i + 1][j][0],
          r * unitSphereXYZ[i + 1][j][1],
          r * unitSphereXYZ[i + 1][j][2]
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
    // Flip the ball upside down so it's drawn correctly. // TEMP FIX
    rotateX(PI);
    // Rotate the ball by the angle of rolling.
    rotate(angleOfRolling, -velocity[1], velocity[0], 0);
    // Rotate the ball by the angle of rotation.
    rotateZ(anlgeOfRotation);
    int i, j;
    for (j = 0; j < detailY; j++) {
      beginShape(QUAD_STRIP);
      texture(t);
      for (i = 0; i < detailX; i++) {
        normal(
          normals[i][j][0],
          normals[i][j][1],
          normals[i][j][2]
          );
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
        vertex(
          r * unitSphereXYZ[i + 1][j + 1][0],
          r * unitSphereXYZ[i + 1][j + 1][1],
          r * unitSphereXYZ[i + 1][j + 1][2],
          textureX[i + 1],
          textureY[j + 1]
          );
        vertex(
          r * unitSphereXYZ[i + 1][j][0],
          r * unitSphereXYZ[i + 1][j][1],
          r * unitSphereXYZ[i + 1][j][2],
          textureX[i + 1],
          textureY[j]
          );
      }
      endShape(CLOSE);
    }
    popMatrix();
  }
}
