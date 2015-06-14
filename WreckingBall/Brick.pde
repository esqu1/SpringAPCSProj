public interface Brick {
  // returns the height of the brick
  public float getHeight();

  // returns the elevation of the brick
  public float getElevation();

  // return the vertices of this brick
  // (or the vertices that approximate this brick)
  public float[][] getVertices();

  // returns the minimum x-coordinate of this brick
  public float getMinX();

  // returns the minimum y-coordinate of this brick
  public float getMinY();

  // returns the minimum x-coordinate of this brick
  public float getMaxX();

  // returns the minimum y-coordinate of this brick
  public float getMaxY();

  // adds a brick directly above this one
  public void addAbove(Brick b);

  // adds a brick directly below this one
  public void addBelow(Brick b);

  // removes a brick directly above this one
  public void removeAbove(Brick b);

  // removes a brick directly below this one
  public void removeBelow(Brick b);

  // determines whether this brick overlaps another
  public boolean overlaps(Brick b);

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

  // adds a powerup to this brick
  public void addPowerup(Powerup p);

  // draws the brick
  public void draw();
}

