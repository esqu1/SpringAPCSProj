public class GrowBall extends Powerup {
	float originalRadius;
	public GrowBall() {
		t = loadImage(name + ".jpg");
    textureX = new float[61];
    for (i = 0; i <= 60; i++)
      textureX[i] = 1.0 * t.width * (60 - i) / 60;
    textureY = new float[31];
    for (i = 0; i <= 30; i++)
      textureY[i] = 1.0 * t.height * (30 - i) / 30;
    originalRadius = balls.get(0).getRadius();
    // if there are any other active GrowBall powerups,
    // make them wait until this one ends
		for (int i = 0; i < powerups.size(); i++) {
			if (powerups.get(i).equals(this))
				return;
			if (
				powerups.get(i) instanceOf GrowBall &&
				powerups.get(i).isActive()
				)
				powerups.get(i).setDuration(duration + 1);
		}
	}
	protected void doStuff() {
		for (Ball b : balls)
			b.setRadius(2 * originalRadius);
		if (--duration == 0) {
			for (Ball b : balls)
				b.setRadius(originalRadius);
			powerups.remove(this);
		}
	}
}