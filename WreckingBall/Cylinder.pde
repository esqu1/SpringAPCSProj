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

  private String texture = "";
  // texture name for use in sound effects

  // The point (textureX[i], y) will map to (unitCircleXY[i][0],
  // unitCircleXY[i][1], y) on the unit cylinder (r = 1, d = 0).

  private float minX, minY, maxX, maxY;
  // smallest and largest x- and y-coordinates of the vertices of
  // the equatorial plane of the sphere

  private float[] reflectionNormal;
  // unit normal to the face that the ball bounces off of

  private Container<Brick> above, below;
  // bricks directly above and below this one

  private Brick highestBrickBelow;
  // the brick in the below container with the
  // greatest value of getElevation() + getHeight()

  private float[] velocity;
  // velocity of the cylinder

  private float maxDist, currentDist, distIncrement;
  // how far the prism can go, how far it has gone,
  // and how far it goes each frame

  private float lastDampenedV;
  // velocity of the prism last time it bounced up

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
    minX = cylCenter[0] - r;
    minY = cylCenter[1] - r;
    maxX = cylCenter[0] + r;
    maxY = cylCenter[1] + r;
    int i;
    unitCircleXY = new float[detail + 1][2];
    for (i = 0; i <= detail; i++) {
      unitCircleXY[i][0] = cos(i * TWO_PI / detail);
      unitCircleXY[i][1] = sin(i * TWO_PI / detail);
    }
    normals = new float[detail][2];
    for (i = 0; i < detail; i++)
      normals[i] = M.norm(unitCircleXY[i], unitCircleXY[i + 1]);
    above = new Container<Brick>();
    below = new Container<Brick>();
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
    this.texture = texture;
    textureX = new float[detail + 1];
    for (int i = 0; i <= detail; i++)
      textureX[i] = (detail - i) * sqrt(2 - 2 * cos(TWO_PI / detail));
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
    distIncrement =
      sqrt(sq(velocity[0] / frameRate) +
        sq(velocity[1] / frameRate));
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
    distIncrement =
      sqrt(sq(velocity[0] / frameRate) +
        sq(velocity[1] / frameRate));
  }

  public float getHeight() {
    return h;
  }

  public float getElevation() {
    return d;
  }

  public float[][] getVertices() {
    float[][] result = new float[detail][2];
    for (int i = 0; i < detail; i++)
      result[i] = M.sum(center, M.scale(unitCircleXY[i], r));
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
    if (textureX == null) {
      textureX = new float[detail + 1];
      for (int i = 0; i <= detail; i++)
        textureX[i] = (detail - i) * sqrt(2 - 2 * cos(TWO_PI / detail));
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
