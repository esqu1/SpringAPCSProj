public class Prism implements Brick {
  private float[][] v;
  // v must have at least two vertices
  // vertices MUST be listed in counter-clockwise order

  private float h, d;
  // height and elevation of prism

  private color c;
  // color of prism

  private PImage t;
  // texture of prism

  private float minX, minY; // for textures
  // smallest x- and y-coordinates of the vertices of the prism

  private float[] reflectionNormal; // for reflecting the ball
  // unit normal to the face that the ball bounces off of

  public Prism(
    float[][] vertices,
    float prismHeight,
    float distanceToBoard,
    color rgb
    ) {
    v = vertices;
    h = prismHeight;
    d = distanceToBoard;
    c = rgb;
  }

  public Prism(
    float[][] vertices,
    float prismHeight,
    float distanceToBoard,
    String texture
    ) {
    v = vertices;
    h = prismHeight;
    d = distanceToBoard;
    t = loadImage(texture);
    minX = v[0][0];
    minY = v[0][1];
    for (int i = 1; i < v.length; i++) {
      if (v[i][0] < minX)
        minX = v[i][0];
      if (v[i][1] < minY)
        minY = v[i][1];
    }
  }

  public void draw() {
    if (t == null)
      drawWithoutTexture();
    else
      drawWithTexture();
  }

  private void drawWithoutTexture() {
    fill(c);
    int i;
    // Draw the bottom face.
    beginShape();
    for (i = 0; i < v.length; i++)
      vertex(v[i][0], v[i][1], d);
    endShape(CLOSE);
    // Draw the top face.
    beginShape();
    for (i = 0; i < v.length; i++)
      vertex(v[i][0], v[i][1], d + h);
    endShape(CLOSE);
    // Draw the first v.length - 1 faces.
    for(i = 0; i < v.length - 1; i++) {
      beginShape();
      vertex(v[i][0], v[i][1], d + h);
      vertex(v[i + 1][0], v[i + 1][1], d + h);
      vertex(v[i + 1][0], v[i + 1][1], d);
      vertex(v[i][0], v[i][1], d);
      endShape(CLOSE);
    }
    // Draw the last face.
    if (v.length > 1) {
      beginShape();
      vertex(v[v.length - 1][0], v[v.length - 1][1], d + h);
      vertex(v[0][0], v[0][1], d + h);
      vertex(v[0][0], v[0][1], d);
      vertex(v[v.length - 1][0], v[v.length - 1][1], d);
      endShape(CLOSE);
    }
  }

  private void drawWithTexture() {
    noStroke();
    int i;
    // Draw the bottom face.
    beginShape();
    texture(t);
    for (i = 0; i < v.length; i++)
      vertex(
        v[i][0], v[i][1], d,
        v[i][0] - minX, v[i][1] - minY
        );
    endShape(CLOSE);
    // Draw the top face.
    beginShape();
    texture(t);
    for (i = 0; i < v.length; i++)
      vertex(
        v[i][0], v[i][1], d + h,
        v[i][0] - minX, v[i][1] - minY
        );
    endShape(CLOSE);
    // Draw the first v.length - 1 faces.
    for(i = 0; i < v.length - 1; i++) {
      beginShape();
      texture(t);
      vertex(
        v[i][0], v[i][1], d + h,
        0, h
        );
      vertex(
        v[i + 1][0], v[i + 1][1], d + h,
        M.dist(v[i], v[i + 1]), h
        );
      vertex(
        v[i + 1][0], v[i + 1][1], d,
        M.dist(v[i], v[i + 1]), 0
        );
      vertex(
        v[i][0], v[i][1], d,
        0, 0
        );
      endShape(CLOSE);
    }
    // Draw the last face.
    beginShape();
    texture(t);
    vertex(
      v[v.length - 1][0], v[v.length - 1][1], d + h,
      0, h);
    vertex(
      v[0][0], v[0][1], d + h,
      M.dist(v[v.length - 1], v[0]), h
      );
    vertex(
      v[0][0], v[0][1], d,
      M.dist(v[v.length - 1], v[0]), 0
      );
    vertex(
      v[v.length - 1][0], v[v.length - 1][1], d,
      0, 0
      );
    endShape(CLOSE);
    // drawNormals();
    // drawCornerLines();
    stroke(#000000);
  }

  // FOR DEBUGGING
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

  public boolean ballColliding(Ball b) {
    int i;
    float r;
    float[] normalRadius;
    if (b.getRadius() > d + h)
      // if the bottom half of the ball may hit the prism
      r = sqrt(sq(b.getRadius()) - sq(b.getRadius() - d - h));
    else if (b.getRadius() > d)
      // if the equatorial plane of the ball may hit the prism
      r = b.getRadius();
    else
      // if the top half of the ball may hit the prism
      // (will only occur if the ball hits the prism
      // as the prism is falling and there are no other
      // bricks under the prism)
      r = sqrt(sq(b.getRadius()) - sq(d - b.getRadius()));
    // Check if the ball is next to any of the first
    // v.length - 1 faces of the prism.
    for (i = 0; i < v.length - 1; i++) {
      normalRadius = M.scale(M.norm(v[i], v[i + 1]), r);
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
    normalRadius = M.scale(M.norm(v[v.length - 1], v[0]), r);
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
    if (M.dist(v[0], b.getPosition()) < r) {
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
      if (M.dist(v[i], b.getPosition()) < r) {
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
    if (M.dist(v[v.length - 1], b.getPosition()) < r) {
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
    // SHOULD I CHECK IF THE BALL IS INSIDE THE PRISM???
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
  }
}
