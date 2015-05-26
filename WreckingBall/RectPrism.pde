public class RectPrism extends Brick{
  /* We need the ball radius to do anything.*/
  private final int BALLRADIUS = 2; //temporary
  private int px,py,l,w,h;
  
  public RectPrism(int px, int py, int l, int w, int h){
    this.px = px;
    this.py = py;
    this.l = l;
    this.w = w;
    this.h = h;
  }  
  
  public boolean ballInside(Ball b){
    return true;
  }
  
  public void draw(){
   pushMatrix();
   translate(px - (l / 2.0), py - (w / 2.0), h / 2.0);
   box(l,w,h);
   popMatrix();
   
  }
  
  
  
}
