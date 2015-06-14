public class Powerup {
	private String name;
	// name of this powerup

	private float[] position;
	// position of this powerup

	private float radius;
	// radius of this powerup

	private int releaseFrame;
	// when this powerup was released

	private boolean isActive;
	// is this powerup doing something

	private int timeLeft;
	// how much longer this powerup will be active

  private float[][][] unitSphereXYZ;
  // coordinates of evenly-spaced points on a unit sphere

  private float[] textureX, textureY;
  // coordinates of points on each axis of the texture image that
  // divide it into a 60 by 30 grid

  private PImage t;
  // texture of sphere

	public Powerup(float[] pos) {
		name = n;
		position = pos;
		switch (name) {
			case "growBall":
				duration = 30 * frameRate;
				break;
		}
    int i, j;
    unitSphereXYZ = new float[61][31][3];
    for (i = 0; i <= 60; i++)
      for (j = 0; j <= 30; j++) {
        // polar angle = PI - j * PI / 30
        // azimuthal angle = i * TWO_PI / 60
        // x = sin(polar angle)cos(azimuthal angle)
        // y = sin(polar angle)sin(azimuthal angle)
        // z = cos(polar angle)
        unitSphereXYZ[i][j][0] =
          sin(PI - j * PI / 30) *
          cos(i * TWO_PI / 60);
        unitSphereXYZ[i][j][1] =
          sin(PI - j * PI / 30) *
          sin(i * TWO_PI / 60);
        unitSphereXYZ[i][j][2] =
          cos(PI - j * PI / 30);
      }
	}

	public void draw() {
		if (isActive) {
			move();
    	noStroke();
			pushMatrix();
			translate(position[0], position[1], position[2]);
    	int i, j;
    	for (j = 0; j < detailY; j++) {
    	  beginShape(QUAD_STRIP);
    	  texture(t);
    	  for (i = 0; i <= detailX; i++) {
    	    normal(
    	      unitSphereXYZ[i][j + 1][0],
    	      unitSphereXYZ[i][j + 1][1],
    	      unitSphereXYZ[i][j + 1][2],
    	      );
    	    vertex(
    	      r * unitSphereXYZ[i][j + 1][0],
    	      r * unitSphereXYZ[i][j + 1][1],
    	      r * unitSphereXYZ[i][j + 1][2],
    	      textureX[i],
    	      textureY[j + 1]
    	      );
    	    normal(
    	      unitSphereXYZ[i][j][0],
    	      unitSphereXYZ[i][j][1],
    	      unitSphereXYZ[i][j][2],
    	      );
    	    vertex(
    	      r * unitSphereXYZ[i][j][0],
    	      r * unitSphereXYZ[i][j][1],
    	      r * unitSphereXYZ[i][j][2],
    	      textureX[i],
    	      textureY[j]
    	      );
    	  }
    	  endShape(CLOSE);
    	}
    	popMatrix();
    }
    else
    	doStuff();
	}

	private void move() {
		position[2] = (position[2] - radius) * 0.99 + radius;
		position[1] += 0.001;
		position[0] += cos((frameCount - releaseFrame) / 1000.0);
		if (position[2] > boardLength)
			powerups.remove(this);
	}

	protected void doStuff() {
		duration--;
	}

	public void activate() {
		isActive = true;
	}

	public boolean isActive() {
		return isActive;
	}

	public void setDuration(int d) {
		duration = d;
	}
}