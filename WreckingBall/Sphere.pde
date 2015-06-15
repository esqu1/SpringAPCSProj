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
  private float[] axisOfRolling;
  // angular kinematics for the sphere

  private color c;
  // color of sphere

  private PImage t;
  // texture of sphere

  private float[] textureX, textureY;
  // coordinates of points on each axis of the texture image that
  // divide it into a detailX by detailY grid
  
  private String texture = "";
  // texture name for use in sound effects

  // The point (textureX[i], textureY[j]) on the texture image will
  // map to the point (unitSphereXYZ[i][j][0], unitSphereXYZ[i][j][1],
  // unitSphereXYZ[i][j][2]) on the unit sphere (r = 1, d = 0).

  private float minX, minY, maxX, maxY;
  // smallest and largest x- and y-coordinates of the vertices of
  // the equatorial plane of the sphere

  private float[] reflectionNormal;
  // normal to the point on the sphere that the ball bounces off of

  private Container<Brick> above, below;
  // bricks directly above and below this one

  private Brick highestBrickBelow;
  // the brick in the below container with the
  // greatest value of getElevation() + getHeight()

  private float[] velocity;
  // velocity of the sphere

  private float maxDist, currentDist, distIncrement;
  // how far the prism can go, how far it has gone,
  // and how far it goes each frame

  private float lastDampenedV;
  // velocity of the prism last time it bounced up

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
    axisOfRolling = new float[2];
    minX = centre[0] - r;
    minY = centre[1] - r;
    maxX = centre[0] + r;
    maxY = centre[1] + r;
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
    above = new Container<Brick>();
    below = new Container<Brick>();
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
    this.texture = texture;
    int i;
    textureX = new float[detailX + 1];
    for (i = 0; i <= detailX; i++)
      textureX[i] = 1.0 * t.width * (detailX - i) / detailX;
    textureY = new float[detailY + 1];
    for (i = 0; i <= detailY; i++)
      textureY[i] = 1.0 * t.height * (detailY - i) / detailY;
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
    axisOfRolling[0] = sphereVelocity[0];
    axisOfRolling[1] = sphereVelocity[1];
    maxDist = oscillationDistance;
    distIncrement =
      sqrt(sq(velocity[0] / frameRate) +
        sq(velocity[1] / frameRate));
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
    axisOfRolling[0] = sphereVelocity[0];
    axisOfRolling[1] = sphereVelocity[1];
    maxDist = oscillationDistance;
    distIncrement =
      sqrt(sq(velocity[0] / frameRate) +
        sq(velocity[1] / frameRate));
  }

  public float getHeight() {
    return 2 * r;
  }

  public float getElevation() {
    return d;
  }

  public float[][] getVertices() {
    float[][] result = new float[detailX][2];
    for (int i = 0; i < detailX; i++) {
      result[i] =
        M.sum(
          center,
          M.scale(unitSphereXYZ[detailY / 2][i], r)
          );
    }
    return result;
  }

  public float getMinX() {
    return minX;
  }

  public float getMinY() {
    return minY;
  }

  public float getMaxX() {
    return maxX;
  }

  public float getMaxY() {
    return maxY;
  }

  public void addAbove(Brick b) {
    above.add(b);
  }

  public Container<Brick> getAbove() {
    return above;
  }

  public void addBelow(Brick b) {
    below.add(b);
    if (highestBrickBelow == null)
      highestBrickBelow = b;
    else if (
      b.getElevation() +
      b.getHeight() >
      highestBrickBelow.getElevation() +
      highestBrickBelow.getHeight()
      )
      highestBrickBelow = b;
  }

  public void removeAbove(Brick b) {
    above.remove(b);
  }

  public void removeBelow(Brick b) {
    below.remove(b);
    highestBrickBelow = null;
    if (below.size() > 0)
      highestBrickBelow = below.get(0);
    for (int i = 1; i < below.size(); i++)
      if (
        b.getElevation() +
        b.getHeight() >
        highestBrickBelow.getElevation() +
        highestBrickBelow.getHeight()
        )
        highestBrickBelow = below.get(i);
  }

  public boolean overlaps(Brick b) {
    if (
      minX > b.getMaxX() ||
      minY > b.getMaxY() ||
      maxX < b.getMinX() ||
      maxY < b.getMinY()
      )
      // if the bounding boxes do not overlap
      return false;
    // Check if there are at least two intersection points.
    int intersectionCount = 0;
    int i, j;
    float[][] v = getVertices();
    for (i = 0; i < v.length - 1; i++) {
      for (j = 0; j < b.getVertices().length - 1; j++) {
        if (
          M.linesIntersect(
            v[i],
            v[i + 1],
            b.getVertices()[j],
            b.getVertices()[j + 1]
            )
          ) {
          intersectionCount++;
          if (intersectionCount > 1)
            return true;
        }
      }
      if (
        M.linesIntersect(
          v[i],
          v[i + 1],
          b.getVertices()[j],
          b.getVertices()[0]
          )
        ) {
        intersectionCount++;
        if (intersectionCount > 1)
          return true;
      }
    }
    for (j = 0; j < b.getVertices().length - 1; j++) {
      if (
        M.linesIntersect(
          v[i],
          v[0],
          b.getVertices()[j],
          b.getVertices()[j + 1]
          )
        ) {
        intersectionCount++;
        if (intersectionCount > 1)
          return true;
      }
    }
    if (
      M.linesIntersect(
        v[i],
        v[0],
        b.getVertices()[j],
        b.getVertices()[0]
        )
      ) {
      intersectionCount++;
      if (intersectionCount > 1)
        return true;
    }
    // Check if b is entirely contained within this brick.
    boolean contained = true;
    for (i = 0; i < v.length - 1; i++) {
      if (!contained)
        break;
      for (j = 0; j < b.getVertices().length; j++)
        if (M.sideOf(v[i], v[i + 1], b.getVertices()[j]) > 0) {
          contained = false;
          break;
        }
    }
    if (contained)
      for (j = 0; j < b.getVertices().length; j++)
        if (M.sideOf(v[i], v[0], b.getVertices()[j]) > 0) {
          contained = false;
          break;
        }
    if (contained)
      return true;
    // Check if this brick is entirely contained within b.
    contained = true;
    for (j = 0; j < b.getVertices().length - 1; j++) {
      if (!contained)
        break;
      for (i = 0; i < v.length; i++)
        if (M.sideOf(b.getVertices()[j], b.getVertices()[j + 1], v[i]) > 0) {
          contained = false;
          break;
        }
    }
    if (contained)
      for (i = 0; i < v.length; i++)
        if (M.sideOf(b.getVertices()[j], b.getVertices()[0], v[i]) > 0) {
          contained = false;
          break;
        }
    if (contained)
      return true;
    return false;
  }

  public void stack(Brick b) {
    addBelow(b);
    b.addAbove(this);
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
      textureX[i] = 1.0 * t.width * (detailX - i) / detailX;
    textureY = new float[detailY + 1];
    for (i = 0; i <= detailY; i++)
      textureY[i] = 1.0 * t.height * (detailY - i) / detailY;
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
    if(texture.equals("gray_brick.jpg")){
      metal.play(0);
    }else if(texture.equals("mr_k.jpg")){
      heylisten.play(0);
    }else{
      hit.play(0);
    } 
    reflectionNormal = null;
  }

  private void die() {
    bricks.remove(this);
    int i, j;
    for (i = 0; i < above.size(); i++) {
      above.get(i).removeBelow(this);
      for (j = 0; j < below.size(); j++)
       if (above.get(i).overlaps(below.get(j)))
        above.get(i).addBelow(below.get(j));
    }
    for (i = 0; i < below.size(); i++) {
      below.get(i).removeAbove(this);
      for (j = 0; j < above.size(); j++)
       if (below.get(i).overlaps(above.get(j)))
        below.get(i).addAbove(above.get(j));
    }
    for (i = 0; i < above.size(); i++) {
      recursiveResetAbove(above.get(i));
    }
  }
  
  private void recursiveResetAbove(Brick b) {
    for (int i = 0; i < b.getAbove().size(); i++) {
      b.getAbove().get(i).removeBelow(b);
      b.getAbove().get(i).addBelow(b);
      recursiveResetAbove(b.getAbove().get(i));
    }
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
    currentDist += distIncrement;
    if (currentDist > maxDist) {
      velocity[0] *= -1;
      velocity[1] *= -1;
      currentDist = 0;
    }
    // x(t) = x_0 + v * t
    d += velocity[2] / frameRate;
    if (gravity > 0)
      // always float if there is anti-gravity
      // v(t) = v_0 + a * t
      velocity[2] += gravity / frameRate;
    float highestPointBelow;
    if (highestBrickBelow == null)
      highestPointBelow = 0;
    else
      highestPointBelow =
        highestBrickBelow.getElevation() +
        highestBrickBelow.getHeight();
    if (d > highestPointBelow && gravity < 0)
      // if the brick is too high, it should fall down
      velocity[2] += gravity / frameRate;
    if (d < highestPointBelow) {
      // if the brick is too low, it should
      // bounce up with dampened motion
      velocity[2] *= -bounciness;
      if (
        (int) (velocity[2] * 10000) ==
        (int) (lastDampenedV * 10000)
        )
        // motion will eventually become constant by this
        // algorithm, but there may be floating-point error
        velocity[2] = 0;
      else
        lastDampenedV = velocity[2];
      d = highestPointBelow;
    }
    // theta(t) = theta_0 + omega * t
    // omega = v / r
    if (velocity[0] != 0)
      angleOfRolling +=
        sqrt(sq(velocity[0]) + sq(velocity[1])) / r / frameRate *
        velocity[0]/axisOfRolling[0];
    else if (velocity[1] != 0)
      angleOfRolling +=
        sqrt(sq(velocity[0]) + sq(velocity[1])) / r / frameRate *
        velocity[1]/axisOfRolling[1];
    anlgeOfRotation += rotationVelocity / frameRate;
  }

  private void drawWithoutTexture() {
    fill(c);
    noStroke();
    pushMatrix();
    translate(center[0], center[1], r + d);
    // Rotate the ball by the angle of rolling.
    rotate(angleOfRolling, -axisOfRolling[1], axisOfRolling[0], 0);
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
    //rotateX(PI);
    // Rotate the ball by the angle of rolling.
    rotate(angleOfRolling, -axisOfRolling[1], axisOfRolling[0], 0);
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
