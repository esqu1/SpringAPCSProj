public class Prism implements Brick {
  private float[][] v;
  // v must have at least two vertices
  // vertices MUST be listed in counter-clockwise order

  private float[][] normals;
  // normals to each of the lateral faces of the prism

  private float h, d;
  // height and elevation of prism

  private color c;
  // color of prism

  private PImage t;
  // texture of prism

  private String texture = "";
  // texture name for use in sound effects

  private float[] textureX;
  // x-coordinates of points on the texture image used in
  // mapping the image to the lateral faces of the prism

  private float minX, minY, maxX, maxY;
  // smallest and largest x- and y-coordinates of the vertices
  // of the prism

  private float[] reflectionNormal;
  // unit normal to the face that the ball bounces off of

  private Container<Brick> above, below;
  // bricks directly above and below this one

  private Brick highestBrickBelow;
  // the brick in the below container with the
  // greatest value of getElevation() + getHeight()

  private float[] velocity;
  // velocity of the prism

  private float maxDist, currentDist, distIncrement;
  // how far the prism can go, how far it has gone,
  // and how far it goes each frame

  private float lastDampenedV;
  // velocity of the prism last time it bounced up

  public Prism(
    float[][] vertices,
    float prismHeight
    ) {
    v = vertices;
    h = prismHeight;
    velocity = new float[3];
    int i;
    normals = new float[v.length][2];
    for (i = 0; i < v.length - 1; i++)
      normals[i] = M.norm(v[i], v[i + 1]);
    normals[v.length - 1] = M.norm(v[v.length - 1], v[0]);
    minX = v[0][0];
    minY = v[0][1];
    maxX = v[0][0];
    maxY = v[0][1];
    for (i = 1; i < v.length; i++) {
      if (v[i][0] < minX)
        minX = v[i][0];
      if (v[i][1] < minY)
        minY = v[i][1];
      if (v[i][0] > maxX)
        maxX = v[i][0];
      if (v[i][1] > maxY)
        maxY = v[i][1];
    }
    above = new Container<Brick>();
    below = new Container<Brick>();
  }

  public Prism(
    float[][] vertices,
    float prismHeight,
    color rgb
    ) {
    this(vertices, prismHeight);
    c = rgb;
  }

  public Prism(
    float[][] vertices,
    float prismHeight,
    String texture
    ) {
    this(vertices, prismHeight);
    t = loadImage(texture);
    this.texture = texture;
    textureX = new float[v.length + 1];
    textureX[0] = t.width;
    for (int i = 1; i < v.length; i++)
      textureX[i] =
        textureX[i - 1] -
        M.dist(v[i - 1], v[i]);
    textureX[v.length] =
      textureX[v.length - 1] -
      M.dist(v[v.length - 1], v[0]);
  }

  public Prism(
    float[][] vertices,
    float prismHeight,
    color rgb,
    float[] prismVelocity,
    float oscillationDistance
    ) {
    this(vertices, prismHeight, rgb);
    velocity[0] = prismVelocity[0];
    velocity[1] = prismVelocity[1];
    maxDist = oscillationDistance;
    distIncrement =
      sqrt(sq(velocity[0] / frameRate) +
        sq(velocity[1] / frameRate));
  }

  public Prism(
    float[][] vertices,
    float prismHeight,
    String texture,
    float[] prismVelocity,
    float oscillationDistance
    ) {
    this(vertices, prismHeight, texture);
    velocity[0] = prismVelocity[0];
    velocity[1] = prismVelocity[1];
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
    return v;
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
      textureX = new float[v.length + 1];
      textureX[0] = t.width;
      for (int i = 1; i < v.length; i++)
        textureX[i] =
          textureX[i - 1] -
          M.dist(v[i - 1], v[i]);
      textureX[v.length] =
        textureX[v.length - 1] -
        M.dist(v[v.length - 1], v[0]);
    }
  }

  public void actOnBall(Ball b) {
    if (ballColliding(b)) {
      reflectBall(b);
      die();
    }
  }

  private boolean ballColliding(Ball b) {
    int i;
    float eqRadius; // equivalent ball radius
    float[] normalRadius;
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
    // Check if the ball is next to any of the first
    // v.length - 1 faces of the prism.
    for (i = 0; i < v.length - 1; i++) {
      normalRadius = M.scale(M.norm(v[i], v[i + 1]), eqRadius);
      if (
        M.sideOf(
          v[i],
          v[i + 1],
          b.getPosition()
          ) > 0 &&
        M.sideOf(
          M.sum(v[i], normalRadius),
          M.sum(v[i + 1], normalRadius),
          b.getPosition()
          ) < 0 &&
        M.sideOf(
          v[i],
          M.sum(v[i], normalRadius),
          b.getPosition()
          ) <= 0 &&
        M.sideOf(
          v[i + 1],
          M.sum(v[i + 1], normalRadius),
          b.getPosition()
          ) >= 0
        ) {
        reflectionNormal = M.norm(v[i], v[i + 1]);
        return true;
      }
    }
    // Check if the ball is next to the last face.
    normalRadius = M.scale(M.norm(v[v.length - 1], v[0]), eqRadius);
    if (
      M.sideOf(
        v[v.length - 1],
        v[0],
        b.getPosition()
        ) > 0 &&
      M.sideOf(
        M.sum(v[v.length - 1], normalRadius),
        M.sum(v[0], normalRadius),
        b.getPosition()
        ) < 0 &&
      M.sideOf(
        v[v.length - 1],
        M.sum(v[v.length - 1], normalRadius),
        b.getPosition()
        ) <= 0 &&
      M.sideOf(
        v[0],
        M.sum(v[0], normalRadius),
        b.getPosition()
        ) >= 0
      ) {
      reflectionNormal = M.norm(v[v.length - 1], v[0]);
      return true;
    }
    // Check if the ball is next to the first vertex of the prism.
    if (M.dist(v[0], b.getPosition()) < eqRadius) {
      // Find which face the ball will hit first.
      if (
        M.sideOf(
          b.getPosition(),
          M.sum(b.getPosition(), b.getVelocity()),
          v[0]
          ) >= 0
        )
        reflectionNormal = M.norm(v[0], v[1]);
      else
        reflectionNormal = M.norm(v[v.length - 1], v[0]);
      return true;
    }
    // Check if the ball is next to any of the next v.length - 2
    // vertices of the prism.
    for (i = 1; i < v.length - 1; i++)
      if (M.dist(v[i], b.getPosition()) < eqRadius) {
        // Find which face the ball will hit first.
        if (
          M.sideOf(
            b.getPosition(),
            M.sum(b.getPosition(), b.getVelocity()),
            v[i]
            ) >= 0
          )
          reflectionNormal = M.norm(v[i], v[i + 1]);
        else
          reflectionNormal = M.norm(v[i - 1], v[i]);
        return true;
      }
    // Check if the ball is next to the last vertex of the prism.
    if (M.dist(v[v.length - 1], b.getPosition()) < eqRadius) {
      // Find which face the ball will hit first.
      if (
        M.sideOf(
          b.getPosition(),
          M.sum(b.getPosition(), b.getVelocity()),
          v[v.length - 1]
          ) >= 0
        )
        reflectionNormal = M.norm(v[v.length - 1], v[0]);
      else
        reflectionNormal = M.norm(v[v.length - 2], v[v.length - 1]);
      return true;
    }
    // Check if the ball is inside the prism (will only happen if
    // the prism falls right on top of the ball).
    if (d < 2 * b.getRadius()) {
      for (i = 0; i < v.length - 1; i++)
        if (M.sideOf(v[i], v[i + 1], b.getPosition()) > 0)
          return false;
      if (M.sideOf(v[i], v[0], b.getPosition()) > 0)
        return false;
      reflectionNormal = M.normalize2D(b.getVelocity());
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
    for (int i = 0; i < v.length; i++) {
      v[i][0] += velocity[0] / frameRate;
      v[i][1] += velocity[1] / frameRate;
    }
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
  }

  private void drawWithoutTexture() {
    fill(c);
    pushMatrix();
    translate(0, 0, d);
    int i;
    // Draw the bottom face.
    beginShape();
    normal(0, 0, -1);
    for (i = 0; i < v.length; i++)
      vertex(v[i][0], v[i][1], 0);
    endShape(CLOSE);
    // Draw the top face.
    beginShape();
    normal(0, 0, 1);
    for (i = 0; i < v.length; i++)
      vertex(v[i][0], v[i][1], h);
    endShape(CLOSE);
    // Draw the lateral faces.
    beginShape(QUAD_STRIP);
    for(i = 0; i < v.length - 1; i++) {
      normal(normals[i][0], normals[i][1], 0);
      vertex(v[i][0], v[i][1], h);
      vertex(v[i][0], v[i][1], 0);
      vertex(v[i + 1][0], v[i + 1][1], h);
      vertex(v[i + 1][0], v[i + 1][1], 0);
    }
    normal(normals[v.length - 1][0], normals[v.length - 1][1], 0);
    vertex(v[v.length - 1][0], v[v.length - 1][1], h);
    vertex(v[v.length - 1][0], v[v.length - 1][1], 0);
    vertex(v[0][0], v[0][1], h);
    vertex(v[0][0], v[0][1], 0);
    endShape(CLOSE);
    popMatrix();
  }

  private void drawWithTexture() {
    noStroke();
    pushMatrix();
    translate(0, 0, d);
    int i;
    // Draw the bottom face.
    beginShape();
    texture(t);
    normal(0, 0, -1);
    for (i = 0; i < v.length; i++)
      vertex(v[i][0], v[i][1], 0, v[i][0] - minX, v[i][1] - minY);
    endShape(CLOSE);
    // Draw the top face.
    beginShape();
    texture(t);
    normal(0, 0, 1);
    for (i = 0; i < v.length; i++)
      vertex(v[i][0], v[i][1], h, v[i][0] - minX, v[i][1] - minY);
    endShape(CLOSE);
    // Draw the lateral faces.
    beginShape(QUAD_STRIP);
    texture(t);
    for(i = 0; i < v.length - 1; i++) {
      normal(normals[i][0], normals[i][1], 0);
      vertex(v[i][0], v[i][1], h, textureX[i], 0);
      vertex(v[i][0], v[i][1], 0, textureX[i], h);
      vertex(v[i + 1][0], v[i + 1][1], h, textureX[i + 1], 0);
      vertex(v[i + 1][0], v[i + 1][1], 0, textureX[i + 1], h);
    }
    normal(normals[v.length - 1][0], normals[v.length - 1][1], 0);
    vertex(v[v.length - 1][0], v[v.length - 1][1], h, textureX[v.length - 1], 0);
    vertex(v[v.length - 1][0], v[v.length - 1][1], 0, textureX[v.length - 1], h);
    vertex(v[0][0], v[0][1], h, textureX[v.length], 0);
    vertex(v[0][0], v[0][1], 0, textureX[v.length], h);
    endShape(CLOSE);
    popMatrix();
  }
}
