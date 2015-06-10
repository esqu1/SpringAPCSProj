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

  private float[] textureX;
  // x-coordinates of points on the texture image used in
  // mapping the image to the lateral faces of the prism

  private float minX, minY;
  // smallest x- and y-coordinates of the vertices of the prism

  private float[] reflectionNormal;
  // unit normal to the face that the ball bounces off of

  private Brick above, below;
  // bricks directly above and below this one

  private float[] velocity;
  // velocity of the prism

  private float maxDist, currentDist;
  // how far the prism can go and how far it has gone

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
    for (i = 1; i < v.length; i++) {
      if (v[i][0] < minX)
        minX = v[i][0];
      if (v[i][1] < minY)
        minY = v[i][1];
    }
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
    textureX = new float[v.length + 1];
    textureX[0] = 0;
    for (int i = 1; i < v.length; i++)
      textureX[i] =
        textureX[i - 1] +
        M.dist(v[i - 1], v[i]);
    textureX[v.length] =
      textureX[v.length - 1] +
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
      textureX = new float[v.length + 1];
      textureX[0] = 0;
      for (int i = 1; i < v.length; i++)
        textureX[i] =
          textureX[i - 1] +
          M.dist(v[i - 1], v[i]);
      textureX[v.length] =
        textureX[v.length - 1] +
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
    for (int i = 0; i < v.length; i++) {
      v[i][0] += velocity[0] / frameRate;
      v[i][1] += velocity[1] / frameRate;
    }
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

  // COULD BE USEFUL?
  private void drawNormals() {
    // draws normals to each of the vertical faces of the prism
    float[] normal;
    stroke(#FFFFFF);
    strokeWeight(6);
    for (int i = 0; i < v.length - 1; i++) {
      normal = M.scale(M.norm(v[i], v[i + 1]), 100);
      line(
        v[i][0],
        v[i][1],
        M.sum(normal, v[i])[0],
        M.sum(normal, v[i])[1]
        );
    }
    normal = M.scale(M.norm(v[v.length - 1], v[0]), 100);
    line(
      v[v.length - 1][0],
      v[v.length - 1][1],
      M.sum(normal, v[v.length - 1])[0],
      M.sum(normal, v[v.length - 1])[1]
      );
    strokeWeight(1);
    stroke(#000000);
  }

  // COULD BE USEFUL?
  private void drawCornerMidlines() {
    // draws lines that are equidistant from the faces that
    // meet at each vertex
    stroke(#FFFFFF);
    strokeWeight(6);
    float[] midline;
    midline = M.sum(
      v[0],
      M.scale(
        M.dif(v[0], v[1]),
        100 / M.mag(M.dif(v[0], v[1]))
        ),
      M.scale(
        M.dif(v[0], v[v.length - 1]),
        100 / M.mag(M.dif(v[0], v[v.length - 1]))
        )
      );
    line(v[0][0], v[0][1], midline[0], midline[1]);
    for (int i = 1; i < v.length - 1; i++) {
      midline = M.sum(
        v[i],
        M.scale(
          M.dif(v[i], v[i + 1]),
          100 / M.mag(M.dif(v[i], v[i + 1]))
          ),
        M.scale(
          M.dif(v[i], v[i - 1]),
          100 / M.mag(M.dif(v[i], v[i - 1]))
          )
        );
      line(v[i][0], v[i][1], midline[0], midline[1]);
    }
    midline = M.sum(
      v[v.length - 1],
      M.scale(
        M.dif(v[v.length - 1], v[0]),
        100 / M.mag(M.dif(v[v.length - 1], v[0]))
        ),
      M.scale(
        M.dif(v[v.length - 1], v[v.length - 2]),
        100 / M.mag(M.dif(v[v.length - 1], v[v.length - 2]))
        )
      );
    line(v[v.length - 1][0], v[v.length - 1][1], midline[0], midline[1]);
    strokeWeight(1);
    stroke(#000000);
  }
}
