public class RectPrism extends Brick {
  /* We need the ball radius to do anything.*/
  private final int BALLRADIUS = 50; //temporary
  private int px, py, l, w, h;

  public RectPrism(int px, int py, int l, int w, int h) {
    this.px = px;
    this.py = py;
    this.l = l;
    this.w = w;
    this.h = h;
  }  

  public boolean ballInside(Ball b) {
    float x = b.getPosition().x;
    float y = b.getPosition().y;
    if (x <= px + (l / 2.0) && x >= px - (l / 2.0) && abs(y - py) <= (w / 2.0) + BALLRADIUS) {
      b.getVelocity().set(b.getVelocity().x,-b.getVelocity().y);
    }else if (y <= py + (w / 2.0) && y >= py - (w / 2.0) && abs(x - px) <= (l / 2.0) + BALLRADIUS) {
      b.getVelocity().set(-b.getVelocity().x,b.getVelocity().y);
    }
    return true;
  }

  public void draw() {
    pushMatrix();
    translate(px - (l / 2.0), py - (w / 2.0), h / 2.0);
    box(l, w, h);
    popMatrix();
  }
}

