public class Sphere implements Brick {
  private final int detailX = 24;
  private final int detailY = 13;
  // number of subdivisions along each axis of the texture image

  private float[] xCoords, yCoords;
  // coordinates of subdivisions of the texture image

  private float[] unitCircleX, unitCircleY;
  // store the vertices of a regular polygon with detailX
  // sides inscribed in the unit circle (slight improvement
  // in efficiency)

  private float[] unitCircleZ;
  // stores the z-coordinates of the points on each circle of
  // latitude on the sphere (slight improvement in efficiency)

  private float[] scaleFactors;
  // stores the scale factors for transforming unit circles in
  // the xy-plane into circles of latitude on the sphere
  // (slight improvement in efficiency)

  private float[] center;
  // center of sphere

  private float r, d;
  // radius and elevation of sphere

  private float aX, aY, aZ;
  // angles about the x-, y-, and z-axes

  private color c;
  // color of sphere

  private PImage t;
  // texture of sphere

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
    int i;
    xCoords = new float[detailX + 1];
    for (i = 0; i <= detailX; i++)
      xCoords[i] = 1.0 * i * t.width / detailX;
    yCoords = new float[detailY];
    for (i = 0; i < detailY; i++)
      yCoords[i] = i * t.height / (detailY - 1);
    unitCircleX = new float[detailX];
    unitCircleY = new float[detailX];
    for (i = 0; i < detailX; i++) {
      unitCircleX[i] = cos(i * TWO_PI / detailX);
      unitCircleY[i] = sin(-i * TWO_PI / detailX);
    }
    unitCircleZ = new float[detailY];
    scaleFactors = new float[detailY];
    for (i = 0; i < detailY; i++) {
      unitCircleZ[i] = sin((detailY / 2.0 - 0.5 - i) * PI / (detailY - 1));
      scaleFactors[i] = sqrt(1 - unitCircleZ[i] * unitCircleZ[i]);
    }
  }

  public void draw() {
    rotate(0, 0, TWO_PI / 720);
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
    // Using equirectangular projection...
    noStroke();
    pushMatrix();
    translate(center[0], center[1], r + d);
    rotateX(aX);
    rotateY(aY);
    rotateZ(aZ);
    int i, j;
    // Draw the first detailX - 1 slices of the sphere.
    for (i = 0; i < detailX - 1; i++) {
      beginShape();
      texture(t);
      for (j = 0; j < detailY; j++)
        vertex(
          r * unitCircleX[i] * scaleFactors[j],
          r * unitCircleY[i] * scaleFactors[j],
          r * unitCircleZ[j],
          xCoords[i],
          yCoords[j]
          );
      for (j = detailY - 1; j >= 0; j--)
        vertex(
          r * unitCircleX[i + 1] * scaleFactors[j],
          r * unitCircleY[i + 1] * scaleFactors[j],
          r * unitCircleZ[j],
          xCoords[i + 1],
          yCoords[j]
          );
      endShape(CLOSE);
    }
    // Draw the last slice of the sphere.
    beginShape();
    texture(t);
    for (j = 0; j < detailY; j++)
      vertex(
        r * unitCircleX[detailX - 1] * scaleFactors[j],
        r * unitCircleY[detailX - 1] * scaleFactors[j],
        r * unitCircleZ[j],
        xCoords[detailX - 1],
        yCoords[j]
        );
    for (j = detailY - 1; j >= 0; j--)
      vertex(
        r * unitCircleX[0] * scaleFactors[j],
        r * unitCircleY[0] * scaleFactors[j],
        r * unitCircleZ[j],
        xCoords[detailX],
        yCoords[j]
        );
    endShape(CLOSE);
    popMatrix();
  }

  public void rotate(float angleX, float angleY, float angleZ) {
    aX += angleX;
    aY += angleY;
    aZ += angleZ;
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
