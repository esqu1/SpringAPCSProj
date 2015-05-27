import java.util.*;
public class Brick {
  //This will be a parent class for Rectangular Prism, TrianglePrism, PentagonalPrism, Sphere (?)
  private float[][] vertices;
  private float prismHeight;

  public Brick(float[][] v, float h) {
    vertices = v;
    prismHeight = h;
  }
  public boolean ballInside(Ball b) {
    return true;
  }

  public void draw() {
    beginShape();
    for (float[] i : vertices) {
      vertex(i[0],i[1],prismHeight);
    }
    endShape(CLOSE);
    beginShape();
    for (float[] i : vertices) {
      vertex(i[0],i[1],0);
    }
    endShape(CLOSE);
    for(int i = 0; i < vertices.length - 1; i++){
      println(Arrays.toString(vertices[i]));
      beginShape();
      vertex(vertices[i][0],vertices[i][1],prismHeight);
      vertex(vertices[i+1][0],vertices[i+1][1],prismHeight);
      vertex(vertices[i+1][0],vertices[i+1][1],0);
      vertex(vertices[i][0],vertices[i][1],0);
      endShape();
    }
    beginShape();
    vertex(vertices[vertices.length - 1][0], vertices[vertices.length - 1][1],prismHeight);
    vertex(vertices[0][0],vertices[0][1],prismHeight);
    vertex(vertices[0][0],vertices[0][1],0);
    vertex(vertices[vertices.length - 1][0], vertices[vertices.length - 1][1],0);
    endShape();
  }
  // checks whether b is inside the brick. 
  public void reflectBall(Ball b){
    
  }
  // calculate the angle of reflection and change the ball's attributes accordingly.
  public void setTexture(){
    /* idk what arg here yet */
  }
  // sets texture 
  public void breakBrick(){
    
  }
  // breaks the brick and updates player's score
}

