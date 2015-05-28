public class Prism implements Brick {
  // REMEMBER: The vertices must be for a 1 by 1 board!
  private float[][] vertices;
  private float h;
  private color c;
  private String texture;

  public Prism(float[][] v, float prismHeight) {
    vertices = v;
    h = prismHeight;
    c = #FFFFFF; // Just make the prism white by default
  }

  public void draw() {
    PImage p = loadImage(texture);
    int i;
    // Draw the top face.
    beginShape();
    texture(p);
    for (i = 0; i < vertices.length; i++)
      vertex(vertices[i][0] * width, vertices[i][1] * height, h,vertices[i][0] * width, vertices[i][1] * height);
    endShape(CLOSE);
    // Draw the bottom face.
    beginShape();
    for (i = 0; i < vertices.length; i++)
      vertex(vertices[i][0] * width, vertices[i][1] * height, 0);
    endShape(CLOSE);
    // Draw the first vertices.length - 1 faces.
    for (i = 0; i < vertices.length - 1; i++) {
      beginShape();
      texture(p);
      //textureMode(NORMAL);
      vertex(vertices[i][0] * width, vertices[i][1] * height, h,0,0);
      vertex(vertices[i + 1][0] * width, vertices[i + 1][1] * height, h,100,0);
      vertex(vertices[i + 1][0] * width, vertices[i + 1][1] * height, 0,100,100);
      vertex(vertices[i][0] * width, vertices[i][1] * height, 0,0,100);
      endShape(); // do we need a "CLOSE" here?
    }
    // Draw the last face.
    if (vertices.length > 1) {     
      beginShape();
      vertex(vertices[vertices.length - 1][0] * width, vertices[vertices.length - 1][1] * height, h);
      vertex(vertices[0][0] * width, vertices[0][1] * height, h);
      vertex(vertices[0][0] * width, vertices[0][1] * height, 0);
      vertex(vertices[vertices.length - 1][0] * width, vertices[vertices.length - 1][1] * height, 0);
      endShape(); // do we need a "CLOSE" here?
    }
    //texture();
  }

  public float getHeight() {
    return h;
  }

  public boolean ballInside(Ball b) {
    // UMMMMMM...
    for (int i = 0; i < vertices.length - 1; i++) {
    }
    return true;
  }

  public void reflectBall(Ball b) {
    // UMMMMMM...
  }

  public void setColor(color rgb) {
    c = rgb;
  }

  public void setTexture(String s) {
    texture = s;
  }
}

