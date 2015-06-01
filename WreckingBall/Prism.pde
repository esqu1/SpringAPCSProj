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
        dist(v[i], v[i + 1]), h
        );
      vertex(
        v[i + 1][0], v[i + 1][1], d,
        dist(v[i], v[i + 1]), 0
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
      dist(v[v.length - 1], v[0]), h
      );
    vertex(
      v[0][0], v[0][1], d,
      dist(v[v.length - 1], v[0]), 0
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
      normal = scale(normal(v[i], v[i + 1]), 100);
      line(v[i][0], v[i][1], sum(normal, v[i])[0], sum(normal, v[i])[1]);
    }
    normal = scale(normal(v[v.length - 1], v[0]), 100);
    line(
      v[v.length - 1][0],
      v[v.length - 1][1],
      sum(normal, v[v.length - 1])[0],
      sum(normal, v[v.length - 1])[1]
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
    midline = sum(
      v[0],
      scale(
        difference(v[0], v[1]),
        100 / mag(difference(v[0], v[1]))
        ),
      scale(
        difference(v[0], v[v.length - 1]),
        100 / mag(difference(v[0], v[v.length - 1]))
        )
      );
    line(v[0][0], v[0][1], midline[0], midline[1]);
    for (int i = 1; i < v.length - 1; i++) {
      midline = sum(
        v[i],
        scale(
          difference(v[i], v[i + 1]),
          100 / mag(difference(v[i], v[i + 1]))
          ),
        scale(
          difference(v[i], v[i - 1]),
          100 / mag(difference(v[i], v[i - 1]))
          )
        );
      line(v[i][0], v[i][1], midline[0], midline[1]);
    }
    midline = sum(
      v[v.length - 1],
      scale(
        difference(v[v.length - 1], v[0]),
        100 / mag(difference(v[v.length - 1], v[0]))
        ),
      scale(
        difference(v[v.length - 1], v[v.length - 2]),
        100 / mag(difference(v[v.length - 1], v[v.length - 2]))
        )
      );
    line(v[v.length - 1][0], v[v.length - 1][1], midline[0], midline[1]);
    strokeWeight(1);
    stroke(#000000);
  }

  public float getHeight() {
    return h;
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
      normalRadius = scale(normal(v[i], v[i + 1]), r);
      if (
        sideOf(
          v[i],
          v[i + 1],
          b.getPosition()
          ) > 0 &&
        sideOf(
          sum(v[i], normalRadius),
          sum(v[i + 1], normalRadius),
          b.getPosition()
          ) < 0 &&
        sideOf(
          v[i],
          sum(v[i], normalRadius),
          b.getPosition()
          ) <= 0 &&
        sideOf(
          v[i + 1],
          sum(v[i + 1], normalRadius),
          b.getPosition()
          ) >= 0
        ) {
        reflectionNormal = normal(v[i], v[i + 1]);
        return true;
      }
    }
    // Check if the ball is next to the last face.
    normalRadius = scale(normal(v[v.length - 1], v[0]), r);
    if (
      sideOf(
        v[v.length - 1],
        v[0],
        b.getPosition()
        ) > 0 &&
      sideOf(
        sum(v[v.length - 1], normalRadius),
        sum(v[0], normalRadius),
        b.getPosition()
        ) < 0 &&
      sideOf(
        v[v.length - 1],
        sum(v[v.length - 1], normalRadius),
        b.getPosition()
        ) <= 0 &&
      sideOf(
        v[0],
        sum(v[0], normalRadius),
        b.getPosition()
        ) >= 0
      ) {
      reflectionNormal = normal(v[v.length - 1], v[0]);
      return true;
    }
    // Check if the ball is next to the first vertex of the prism.
    if (dist(v[0], b.getPosition()) < r) {
      // Find which face the ball will hit first.
      if (
        sideOf(
          b.getPosition(),
          sum(b.getPosition(), b.getVelocity()),
          v[0]
          ) >= 0
        )
        reflectionNormal = normal(v[0], v[1]);
      else
        reflectionNormal = normal(v[v.length - 1], v[0]);
      return true;
    }
    // Check if the ball is next to any of the next v.length - 2
    // vertices of the prism.
    for (i = 1; i < v.length - 1; i++)
      if (dist(v[i], b.getPosition()) < r) {
        // Find which face the ball will hit first.
        if (
          sideOf(
            b.getPosition(),
            sum(b.getPosition(), b.getVelocity()),
            v[i]
            ) >= 0
          )
          reflectionNormal = normal(v[i], v[i + 1]);
        else
          reflectionNormal = normal(v[i - 1], v[i]);
        return true;
      }
    // Check if the ball is next to the last vertex of the prism.
    if (dist(v[v.length - 1], b.getPosition()) < r) {
      // Find which face the ball will hit first.
      if (
        sideOf(
          b.getPosition(),
          sum(b.getPosition(), b.getVelocity()),
          v[v.length - 1]
          ) >= 0
        )
        reflectionNormal = normal(v[v.length - 1], v[0]);
      else
        reflectionNormal = normal(v[v.length - 2], v[v.length - 1]);
      return true;
    }
    // SHOULD I CHECK IF THE BALL IS INSIDE THE PRISM??? WILL THAT EVER HAPPEN???
    return false;
  }

  private float dist(float[] point1, float[] point2) {
    // returns the distance from point1 to point2
    return sqrt(sq(point2[0] - point1[0]) + sq(point2[1] - point1[1]));
  }

  private float mag(float[] vector) {
    // returns the magnitude of vector
    return sqrt(sq(vector[0]) + sq(vector[1]));
  }

  private float[] scale(float[] vector, float length) {
    // scales vector by a factor of length
    return
      new float[] {
        vector[0] * length,
        vector[1] * length
      };
  }

  private float[] sum(float[] vector1, float[] vector2) {
    // returns the sum of vector1 and vector2
    return
      new float[] {
        vector1[0] + vector2[0],
        vector1[1] + vector2[1]
      };
  }

  private float[] sum(float[] vector1, float[] vector2, float[] vector3) {
    // returns the sum of vector1, vector2, and vector3
    return
      new float[] {
        vector1[0] + vector2[0] + vector3[0],
        vector1[1] + vector2[1] + vector3[1]
      };
  }

  private float[] difference(float[] vector1, float[] vector2) {
    // returns the difference between vector1 and vector2
    return
      new float[] {
        vector1[0] - vector2[0],
        vector1[1] - vector2[1]
      };
  }

  private float dot(float[] vector1, float[] vector2) {
    // returns the dot product of vector1 and vector2
    return vector1[0] * vector2[0] + vector1[1] * vector2[1];
  }

  private float[] normal(float[] point1, float[] point2) {
    // returns one of the normals to the ray from point1 to point2
    // (this normal points to the right of the ray)
    return
      new float[] {
        (point1[1] - point2[1]) / dist(point1, point2),
        (point2[0] - point1[0]) / dist(point1, point2)
      };
  }

  private float sideOf(float[] point1, float[] point2, float[] point3) {
    // returns a positive value if point3 is to the right of the line
    // from point1 to point2
    // returns a negative value if point3 is to the left of the line
    // from point1 to point2
    // returns 0 if point3 is on the line from point1 to point2
    return
      (point2[0] - point1[0]) * (point3[1] - point1[1]) -
      (point2[1] - point1[1]) * (point3[0] - point1[0]);
    // This is the z-coordinate of the cross-product of the vector
    // from point1 to point2 and the vector from point1 to point3.
    // When figuring out what's right and what's left, remember
    // that Processing uses a left-hand coordinate system.
  }

  public void reflectBall(Ball b) {
    if (reflectionNormal == null)
      throw new Error(
        "ERROR: reflectBall() can only be called if ballColliding() returned true"
        );
    // v_r = v_i - 2(v_i . n)n
    b.setVelocity(
      difference(
        b.getVelocity(),
        scale(
          reflectionNormal,
          2 * dot(b.getVelocity(), reflectionNormal)
          )
        )
      );
    reflectionNormal = null;
  }

  public void setColor(color rgb) {
    c = rgb;
    t = null;
  }

  public void setTexture(String texture) {
    t = loadImage(texture);
  }
}
