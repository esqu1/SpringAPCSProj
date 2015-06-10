public interface Brick {
  // returns the height of the brick
  public float getHeight();

  // returns the elevation of the brick
  public float getElevation();

  // sets the brick directly above this one
  public void setAbove(Brick b);

  // sets the brick directly below this one
  public void setBelow(Brick b);

  // puts this brick on top of another one
  public void stack(Brick b);

  // sets the color of the brick
  public void setColor(color rgb);

  // sets the texture of the brick (to be implemented later)
  public void setTexture(String texture);

  // reflects the ball if collision is detected,
  // destroys the brick if necessary,
  // and releases a powerup if necessary
  public void actOnBall(Ball b);

  // draws the brick
  public void draw();
}

