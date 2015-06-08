public class Paddle {
  private float pos;
  // x-coordinate of the center of the paddle

  private float size;
  // size is half the length of the paddle

  private float h;
  // height of the paddle

  private color c;
  // color of paddle

  private PImage t;
  // texture of paddle

  private float[] reflectionNormal;
  // unit normal to the face that the ball bounces off of

  private boolean alreadyReflected;
  // determines whether the paddle needs to reflect the ball
  // if ballColliding(Ball b) returned true

  private float[][] v;
  // vertices of the default version of the paddle

  private float[][] normals;
  // normals to each of the lateral faces of the paddle

  private float[] textureX;
  // x-coordinates of points on the texture image used in
  // mapping the image to the lateral faces of the paddle

  public Paddle(float s, color rgb) {
    pos = boardLength / 2.0;
    size = s;
    c = rgb;
    h = 25;
    setVertices();
    scaleVertices();
  }

  public Paddle(float s, String texture) {
    pos = boardLength / 2.0;
    size = s;
    t = loadImage(texture);
    h = 25;
    setVertices();
    scaleVertices();
    textureVertices();
  }

  public void draw() {
    move();
    if (t == null)
      drawWithoutTexture();
    else
      drawWithTexture();
  }

  private void drawWithoutTexture() {
    fill(c);
    pushMatrix();
    translate(pos, boardLength, 0);
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
    translate(pos, boardLength, 0);
    int i;
    // Draw the bottom face.
    beginShape();
    texture(t);
    normal(0, 0, -1);
    for (i = 0; i < v.length; i++)
      vertex(v[i][0], v[i][1], 0, v[i][0] - size, v[i][1]);
    endShape(CLOSE);
    // Draw the top face.
    beginShape();
    texture(t);
    normal(0, 0, 1);
    for (i = 0; i < v.length; i++)
      vertex(v[i][0], v[i][1], h, v[i][0] - size, v[i][1]);
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

  private void setVertices() {
    v = new float[28][2];
    v[0] = f(1);
    v[1] = f(0.95);
    v[2] = f(0.9);
    v[3] = f(0.85);
    v[4] = f(0.8);
    v[5] = f(0.75);
    v[6] = f(0.7);
    v[7] = f(0.65);
    v[8] = f(0.6);
    v[9] = f(0.55);
    v[10] = f(0.5);
    v[11] = f(0.4);
    v[12] = f(0.3);
    v[13] = f(0.2);
    v[14] = f(-0.2);
    v[15] = f(-0.3);
    v[16] = f(-0.4);
    v[17] = f(-0.5);
    v[18] = f(-0.55);
    v[19] = f(-0.6);
    v[20] = f(-0.65);
    v[21] = f(-0.7);
    v[22] = f(-0.75);
    v[23] = f(-0.8);
    v[24] = f(-0.85);
    v[25] = f(-0.9);
    v[26] = f(-0.95);
    v[27] = f(-1);
    normals = new float[v.length][2];
    for (int i = 0; i < v.length - 1; i++)
      normals[i] = M.norm(v[i], v[i + 1]);
    normals[v.length - 1] = M.norm(v[v.length - 1], v[0]);
  }

  private void scaleVertices() {
    for (int i = 0; i < v.length; i++)
      v[i] = M.scale(v[i], size);
  }

  private float[] f(float x) {
    // kinda arbitrary for now, but looks good
    return
      new float[] {
        x,
        0.2 * (sq(sq(x)) * sq(x) - 1)
      };
  }

  private void move() {
    pos = mouseX;
    if (pos < size)
      pos = size;
    else if (pos > boardLength - size)
      pos = boardLength - size;
  }

  public boolean ballColliding(Ball b) {
    int i;
    float eqRadius; // equivalent ball radius
    float[] normalRadius;
    float[] ballPos = new float[] {b.getPosition()[0] - pos, b.getPosition()[1] - boardLength};
    if (b.getRadius() > h)
      // if the bottom half of the ball may hit the paddle
      eqRadius = sqrt(sq(b.getRadius()) - sq(b.getRadius() - h));
    else
      // if the equatorial plane of the ball may hit the paddle
      eqRadius = b.getRadius();
    // Check if the ball is next to any of the first
    // v.length - 1 faces of the paddle.
    for (i = 0; i < v.length - 1; i++) {
      normalRadius = M.scale(M.norm(v[i], v[i + 1]), eqRadius);
      if (
        M.sideOf(
          v[i],
          v[i + 1],
          ballPos
          ) > 0 &&
        M.sideOf(
          M.sum(v[i], normalRadius),
          M.sum(v[i + 1], normalRadius),
          ballPos
          ) < 0 &&
        M.sideOf(
          v[i],
          M.sum(v[i], normalRadius),
          ballPos
          ) <= 0 &&
        M.sideOf(
          v[i + 1],
          M.sum(v[i + 1], normalRadius),
          ballPos
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
        ballPos
        ) > 0 &&
      M.sideOf(
        M.sum(v[v.length - 1], normalRadius),
        M.sum(v[0], normalRadius),
        ballPos
        ) < 0 &&
      M.sideOf(
        v[v.length - 1],
        M.sum(v[v.length - 1], normalRadius),
        ballPos
        ) <= 0 &&
      M.sideOf(
        v[0],
        M.sum(v[0], normalRadius),
        ballPos
        ) >= 0
      ) {
      reflectionNormal = M.norm(v[v.length - 1], v[0]);
      return true;
    }
    // Check if the ball is next to the first vertex of the paddle.
    if (M.dist(v[0], ballPos) < eqRadius) {
      // Find which face the ball will hit first.
      if (
        M.sideOf(
          ballPos,
          M.sum(ballPos, b.getVelocity()),
          v[0]
          ) >= 0
        )
        reflectionNormal = M.norm(v[0], v[1]);
      else
        reflectionNormal = M.norm(v[v.length - 1], v[0]);
      return true;
    }
    // Check if the ball is next to any of the next v.length - 2
    // vertices of the paddle.
    for (i = 1; i < v.length - 1; i++)
      if (M.dist(v[i], ballPos) < eqRadius) {
        // Find which face the ball will hit first.
        if (
          M.sideOf(
            ballPos,
            M.sum(ballPos, b.getVelocity()),
            v[i]
            ) >= 0
          )
          reflectionNormal = M.norm(v[i], v[i + 1]);
        else
          reflectionNormal = M.norm(v[i - 1], v[i]);
        return true;
      }
    // Check if the ball is next to the last vertex of the paddle.
    if (M.dist(v[v.length - 1], ballPos) < eqRadius) {
      // Find which face the ball will hit first.
      if (
        M.sideOf(
          ballPos,
          M.sum(ballPos, b.getVelocity()),
          v[v.length - 1]
          ) >= 0
        )
        reflectionNormal = M.norm(v[v.length - 1], v[0]);
      else
        reflectionNormal = M.norm(v[v.length - 2], v[v.length - 1]);
      return true;
    }
    alreadyReflected = false;
    return false;
  }

  public void reflectBall(Ball b) {
    if (reflectionNormal == null)
      throw new Error(
        "ERROR: reflectBall() can only be called if ballColliding() returned true"
        );
    if (alreadyReflected)
      b.setVelocity(M.scale(b.getVelocity(), 1.2));
    else {
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
      alreadyReflected = true;
    }
  }

  public void textureVertices() {
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

