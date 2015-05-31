public interface Brick {

	// draws the brick
	public void draw();

	// returns the height of the brick
	public float getHeight();

	// checks if Ball b is inside (or tangent to) the brick
	public boolean ballColliding(Ball b);

	// changes velocity of Ball b assuming ballInside(b) returns true
	public void reflectBall(Ball b);

	// releases any powerups the brick has (to be implemented later)
	// public void releasePowerup();

	// sets the color of the brick
	public void setColor(color rgb);

	// sets the texture of the brick (to be implemented later)
	public void setTexture(String texture);
	
}
