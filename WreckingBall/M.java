public class M {
  // M stands for Math ¯\_(-_-)_/¯

  public static float sq(float a) {
    return a * a;
  }

  public static float sqrt(float a) {
    return (float) Math.sqrt(a);
  }

  // 2D THINGS

  public static float dist(float[] point1, float[] point2) {
    // returns the distance from point1 to point2
    return
      sqrt(sq(point2[0] - point1[0]) + sq(point2[1] - point1[1]));
  }

  public static float mag(float[] vector1) {
    // returns the magnitude of vector1
    return sqrt(sq(vector1[0]) + sq(vector1[1]));
  }

  public static float[] scale(float[] vector1, float length) {
    // returns vector1 scaled by a factor of length
    return
      new float[] {
        vector1[0] * length,
        vector1[1] * length
      };
  }

  public static float[] sum(float[] vector1, float[] vector2) {
    // returns the sum of vector1 and vector2
    return
      new float[] {
        vector1[0] + vector2[0],
        vector1[1] + vector2[1]
      };
  }

  public static float[] sum(
    float[] vector1, float[] vector2, float[] vector3
    ) {
    // returns the sum of vector1, vector2, and vector3
    return
      new float[] {
        vector1[0] + vector2[0] + vector3[0],
        vector1[1] + vector2[1] + vector3[1]
      };
  }

  public static float[] dif(float[] vector1, float[] vector2) {
    // returns the difference between vector1 and vector2
    return
      new float[] {
        vector1[0] - vector2[0],
        vector1[1] - vector2[1]
      };
  }

  public static float dot(float[] vector1, float[] vector2) {
    // returns the dot product of vector1 and vector2
    return vector1[0] * vector2[0] + vector1[1] * vector2[1];
  }

  public static float[] norm(float[] point1, float[] point2) {
    // returns one of the normals to the ray from point1 to point2
    // (this normal points to the right of the ray)
    return
      new float[] {
        (point1[1] - point2[1]) / dist(point1, point2),
        (point2[0] - point1[0]) / dist(point1, point2)
      };
  }

  public static float sideOf(
    float[] point1, float[] point2, float[] point3
    ) {
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
    // When figuring out what negative and positive values mean,
    // remember that Processing uses a left-hand coordinate system.
  }

  public static boolean linesIntersect(
    float[] point1, float[] point2, float[] point3, float[] point4
    ) {
    // returns whether the line segment between point1 and point2
    // intersects the line segment between point3 and point4
    float determinant =
      (point4[0] - point3[0]) * (point2[1] - point1[1]) -
      (point2[0] - point1[0]) * (point4[1] - point3[1]);
    if (determinant == 0) {
      // if the lines are parallel
      if (
        (point3[0] - point1[0]) / (point2[0] - point1[0]) !=
        (point3[1] - point1[1]) / (point2[1] - point1[1])
        )
        // if point1, point2, and point3 aren't collinear
        return false;
      // parametrize the line on which all four points lie
      // using the vector equation of a line:
      // v(t) = point1 + t(point2 - point1)
      // Let v(t) = point3 when t = a and v(t) = point4 when t = b.
      float a = (point3[0] - point1[0]) / (point2[0] - point1[0]);
      if (0 < a && a < 1)
        // if point3 is between point1 and point2
        return true;
      float b = (point4[0] - point1[0]) / (point2[0] - point1[0]);
      if (0 < b && b < 1)
        // if point4 is between point1 and point2
        return true;
      if (a <= 0 && b >= 1)
        // if the line segment between point1 and point2 is a subset
        // of the line segment between point3 and point4
        return true;
      return false;
    }
    float s =
      (
        (point4[0] - point3[0]) * (point3[1] - point1[1]) -
        (point4[1] - point3[1]) * (point3[0] - point1[0])
        ) / determinant;
    float t =
      (
        (point2[0] - point1[0]) * (point3[1] - point1[1]) -
        (point2[1] - point1[1]) * (point3[0] - point1[0])
        ) / determinant;
    return s > 0 && s < 1 && t > 0 && t < 1;
  }
  
  public static float[] normalize2D(float[] vector1) {
    // returns vector1 scaled so that it has a magnitude of 1
    float mag = sqrt(sq(vector1[0]) + sq(vector1[1]));
    return
      new float[] {
        vector1[0] / mag,
        vector1[1] / mag
      };
  }

  // 3D THINGS

  public static float[] normalize3D(float[] vector1) {
    // returns vector1 scaled so that it has a magnitude of 1
    float mag = sqrt(sq(vector1[0]) + sq(vector1[1]) + sq(vector1[2]));
    return
      new float[] {
        vector1[0] / mag,
        vector1[1] / mag,
        vector1[2] / mag
      };
  }

  public static float[] cross(float[] vector1, float[] vector2) {
    // returns the cross product of vector1 and vector2
    return
      new float[] {
        vector1[1] * vector2[2] - vector1[2] * vector2[1],
        vector1[2] * vector2[0] - vector1[0] * vector2[2],
        vector1[0] * vector2[1] - vector1[1] * vector2[0]
      };
  }

  public static float[] norm(
    float[] point1, float[] point2, float[] point3
    ) {
    // returns the normal to the surface defined by the three points
    return
      normalize3D(
        cross(
          new float[] {
            point1[0] - point2[0],
            point1[1] - point2[1],
            point1[2] - point2[2]
          },
          new float[] {
            point3[0] - point2[0],
            point3[1] - point2[1],
            point3[2] - point2[2]
          }
        )
      );
    // If the points are seen as being in clockwise order, the normal
    // is in the same direction as the observer's line of sight.
  }
}
