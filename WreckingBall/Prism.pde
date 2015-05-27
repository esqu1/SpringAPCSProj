public class Prism implements Brick {
	// REMEMBER: The vertices must be for a 1 by 1 board!
	private float[][] vertices;
	private float h;
	private color c;

	public Prism(float[][] v, float prismHeight) {
		vertices = v;
		h = prismHeight;
		c = #FFFFFF; // Just make the prism white by default
	}

	public void draw() {
		fill(c);
		int i;
		// Draw the top face.
		beginShape();
		for (i = 0; i < vertices.length; i++)
			vertex(vertices[i][0] * width, vertices[i][1] * height, h);
		endShape(CLOSE);
		// Draw the bottom face.
		beginShape();
		for (i = 0; i < vertices.length; i++)
			vertex(vertices[i][0] * width, vertices[i][1] * height, 0);
		endShape(CLOSE);
		// Draw the first vertices.length - 1 faces.
		for(i = 0; i < vertices.length - 1; i++) {
			beginShape();
			vertex(vertices[i][0] * width, vertices[i][1] * height, h);
			vertex(vertices[i + 1][0] * width, vertices[i + 1][1] * height, h);
			vertex(vertices[i + 1][0] * width, vertices[i + 1][1] * height, 0);
			vertex(vertices[i][0] * width, vertices[i][1] * height, 0);
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
	}

	public float getHeight() {
		return h;
	}

	public boolean ballInside(Ball b) {
		// UMMMMMM...
		return true;
	}

	public void reflectBall(Ball b) {
		// UMMMMMM...
	}

	public void setColor(color rgb) {
		c = rgb;
	}
}
