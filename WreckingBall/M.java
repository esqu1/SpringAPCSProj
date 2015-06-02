public class M {
  // M stands for Math ¯\_(-_-)_/¯

  public static float dist(float[] point1, float[] point2) {
    // returns the distance from point1 to point2
    return
      (float) Math.sqrt(
        (point2[0] - point1[0]) * (point2[0] - point1[0]) +
        (point2[1] - point1[1]) * (point2[1] - point1[1])
        );
  }

  public static float mag(float[] vector) {
    // returns the magnitude of vector
    return (float) Math.sqrt(vector[0] * vector[0] + vector[1] * vector[1]);
  }

  public static float[] scale(float[] vector, float length) {
    // scales vector by a factor of length
    return
      new float[] {
        vector[0] * length,
        vector[1] * length
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

  public static float[] sum(float[] vector1, float[] vector2, float[] vector3) {
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

  public static float sideOf(float[] point1, float[] point2, float[] point3) {
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
}
