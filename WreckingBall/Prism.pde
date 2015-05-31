public class Prism implements Brick {
	private float[][] v;
	// v must have at least two vertices
	// vertices must be listed in counter-clockwise order
	private float h, d;
	private color c;
	private PImage t;
	private float minX, minY; // for textures...
	private float[] reflectionNorm; // for reflecting the ball

	public Prism(
		float[][] vertices,
		float prismHeight,
		float distanceToBoard,
		color rgb
		) {
		v = vertices;
		h = prismHeight;
		d = distanceToBoard;
		c = rgb;
	}

	public Prism(
		float[][] vertices,
		float prismHeight,
		float distanceToBoard,
		String texture
		) {
		v = vertices;
		h = prismHeight;
		d = distanceToBoard;
		t = loadImage(texture);
		minX = v[0][0];
		minY = v[0][1];
		for (int i = 1; i < v.length; i++) {
			if (v[i][0] < minX)
				minX = v[i][0];
			if (v[i][1] < minY)
				minY = v[i][1];
		}
	}

	public void draw() {
		if (t == null)
			drawWithoutTexture();
		else
			drawWithTexture();
	}

	private void drawWithoutTexture() {
		fill(c);
		int i;
		// Draw the bottom face.
		beginShape();
		for (i = 0; i < v.length; i++)
			vertex(v[i][0], v[i][1], d);
		endShape(CLOSE);
		// Draw the top face.
		beginShape();
		for (i = 0; i < v.length; i++)
			vertex(v[i][0], v[i][1], d + h);
		endShape(CLOSE);
		// Draw the first v.length - 1 faces.
		for(i = 0; i < v.length - 1; i++) {
			beginShape();
			vertex(v[i][0], v[i][1], d + h);
			vertex(v[i + 1][0], v[i + 1][1], d + h);
			vertex(v[i + 1][0], v[i + 1][1], d);
			vertex(v[i][0], v[i][1], d);
			endShape(CLOSE);
		}
		// Draw the last face.
		if (v.length > 1) {
			beginShape();
			vertex(v[v.length - 1][0], v[v.length - 1][1], d + h);
			vertex(v[0][0], v[0][1], d + h);
			vertex(v[0][0], v[0][1], d);
			vertex(v[v.length - 1][0], v[v.length - 1][1], d);
			endShape(CLOSE);
		}
	}

	private void drawWithTexture() {
		noStroke();
		int i;
		// Draw the bottom face.
		beginShape();
		texture(t);
		for (i = 0; i < v.length; i++)
			vertex(
				v[i][0], v[i][1], d,
				v[i][0] - minX, v[i][1] - minY
				);
		endShape(CLOSE);
		// Draw the top face.
		beginShape();
		texture(t);
		for (i = 0; i < v.length; i++)
			vertex(
				v[i][0], v[i][1], d + h,
				v[i][0] - minX, v[i][1] - minY
				);
		endShape(CLOSE);
		// Draw the first v.length - 1 faces.
		for(i = 0; i < v.length - 1; i++) {
			beginShape();
			texture(t);
			vertex(
				v[i][0], v[i][1], d + h,
				0, h
				);
			vertex(
				v[i + 1][0], v[i + 1][1], d + h,
				dist(v[i], v[i + 1]), h
				);
			vertex(
				v[i + 1][0], v[i + 1][1], d,
				dist(v[i], v[i + 1]), 0
				);
			vertex(
				v[i][0], v[i][1], d,
				0, 0
				);
			endShape(CLOSE);
		}
		// Draw the last face.
		beginShape();
		texture(t);
		vertex(
			v[v.length - 1][0], v[v.length - 1][1], d + h,
			0, h);
		vertex(
			v[0][0], v[0][1], d + h,
			dist(v[v.length - 1], v[0]), h
			);
		vertex(
			v[0][0], v[0][1], d,
			dist(v[v.length - 1], v[0]), 0
			);
		vertex(
			v[v.length - 1][0], v[v.length - 1][1], d,
			0, 0
			);
		endShape(CLOSE);
		// drawNormals();
		stroke(#000000);
	}

	// FOR DEBUGGING
	private void drawNormals() {
		// draws normals to each of the vertical faces of the prism
		float[] n;
		stroke(#FFFFFF);
		strokeWeight(6);
		for (int i = 0; i < v.length - 1; i++) {
			n = scale(normal(v[i], v[i + 1]), 100);
			line(v[i][0], v[i][1], sum(n, v[i])[0], sum(n, v[i])[1]);
		}
		n = scale(normal(v[v.length - 1], v[0]), 100);
		line(
			v[v.length - 1][0],
			v[v.length - 1][1],
			sum(n, v[v.length - 1])[0],
			sum(n, v[v.length - 1])[1]
			);
		strokeWeight(1);
		stroke(#000000);
	}

	public float getHeight() {
		return h;
	}

	public boolean ballColliding(Ball b) {
		int i;
		float r;
		if (b.getRadius() > d + h)
			// if the bottom half of the ball may hit the prism
			r = sqrt(sq(b.getRadius()) - sq(b.getRadius() - d - h));
		else if (b.getRadius() > d)
			// if the equatorial plane of the ball may hit the prism
			r = b.getRadius();
		else
			// if the top half of the ball may hit the prism
			// (will only occur if the ball hits the prism
			// as the prism is falling and there are no other
			// bricks under the prism)
			r = sqrt(sq(b.getRadius()) - sq(d - b.getRadius()));
		// Check if the ball is next to the first vertex of the prism.
		if (dist(v[0], b.getPosition()) <= r) {
			if (
				sideOf(
					v[0],
					sum(
						v[0],
						difference(v[1], v[0]),
						difference(v[0], v[v.length - 1])
						),
					b.getPosition()
					) > 0
				)
				reflectionNorm = difference(v[1], v[0]);
			else
				reflectionNorm = difference(v[0], v[v.length - 1]);
			return true;
		}
		// Check if the ball is next to any of the next v.length - 2
		// vertices of the prism.
		for (i = 1; i < v.length - 1; i++)
			if (dist(v[i], b.getPosition()) <= r) {
				if (
					sideOf(
						v[i],
						sum(
							v[i],
							difference(v[i + 1], v[i]),
							difference(v[i], v[i - 1])
							),
						b.getPosition()
						) > 0
					)
					reflectionNorm = difference(v[i + 1], v[i]);
				else
					reflectionNorm = difference(v[i], v[i - 1]);
				return true;
			}
		// Check if the ball is next to the last vertex of the prism.
		if (dist(v[v.length - 1], b.getPosition()) <= r) {
			if (
				sideOf(
					v[v.length - 1],
					sum(
						v[v.length - 1],
						difference(v[0], v[v.length - 1]),
						difference(v[v.length - 1], v[v.length - 2])
						),
					b.getPosition()
					) > 0
				)
				reflectionNorm = difference(v[0], v[v.length - 1]);
			else
				reflectionNorm = difference(v[v.length - 1], v[v.length - 2]);
			return true;
		}
		float[] n;
		// Check if the ball is next to any of the first
		// v.length - 1 faces of the prism.
		for (i = 0; i < v.length - 1; i++) {
			n = scale(normal(v[i], v[i + 1]), r);
			if (
				sideOf(v[i], v[i + 1], b.getPosition()) >= 0 &&
				sideOf(sum(v[i], n), sum(v[i + 1], n), b.getPosition()) <= 0 &&
				sideOf(v[i], sum(v[i], n), b.getPosition()) < 0 &&
				sideOf(v[i + 1], sum(v[i + 1], n), b.getPosition()) > 0
				) {
				reflectionNorm = difference(v[i + 1], v[i]);
				return true;
			}
		}
		// Check if the ball is next to the last face.
		n = scale(normal(v[v.length - 1], v[0]), r);
		if (
			sideOf(v[v.length - 1], v[0], b.getPosition()) >= 0 &&
			sideOf(sum(v[v.length - 1], n), sum(v[0], n), b.getPosition()) <= 0 &&
			sideOf(v[v.length - 1], sum(v[v.length - 1], n), b.getPosition()) < 0 &&
			sideOf(v[0], sum(v[0], n), b.getPosition()) > 0
			) {
			reflectionNorm = difference(v[0], v[v.length - 1]);
			return true;
		}
		// SHOULD I CHECK IF THE BALL IS INSIDE THE PRISM??? WILL THAT EVER HAPPEN???
		return false;
	}

	private float dist(float[] point1, float[] point2) {
		// returns the distance from point1 to point2
		return
			sqrt(sq(point2[0] - point1[0]) + sq(point2[1] - point1[1]));
	}

	private float mag(float[] vector) {
		// returns the magnitude of vector
		return sqrt(sq(vector[0]) + sq(vector[1]));
	}

	private float[] scale(float[] vector, float length) {
		// scales vector by a factor of length
		return
			new float[] {
				vector[0] * length,
				vector[1] * length
			};
	}

	private float[] sum(float[] vector1, float[] vector2) {
		// returns the sum of vector1 and vector2
		return
			new float[] {
				vector1[0] + vector2[0],
				vector1[1] + vector2[1]
			};
	}

	private float[] sum(float[] vector1, float[] vector2, float[] vector3) {
		// returns the sum of vector1, vector2, and vector3
		return
			new float[] {
				vector1[0] + vector2[0] + vector3[0],
				vector1[1] + vector2[1] + vector3[1]
			};
	}

	private float[] difference(float[] vector1, float[] vector2) {
		// returns the difference between vector1 and vector2
		return
			new float[] {
				vector1[0] - vector2[0],
				vector1[1] - vector2[1]
			};
	}

	private float dot(float[] vector1, float[] vector2) {
		// returns the dot product of vector1 and vector2
		return vector1[0] * vector2[0] + vector1[1] * vector2[1];
	}

	private float[] normal(float[] point1, float[] point2) {
		// returns one of the normals to the line from point1 to point2
		// (this normal points to the right of the line)
		return
			new float[] {
				(point1[1] - point2[1]) / dist(point1, point2),
				(point2[0] - point1[0]) / dist(point1, point2)
			};
	}

	private float sideOf(float[] point1, float[] point2, float[] point3) {
		// returns a positive value if point3 is to the right of the line
		// from point1 to point2
		// returns a negative value of point3 is to the left of the line
		// from point1 to point2
		// returns 0 if point3 is on the line from point1 to point2
		return
			(point2[0] - point1[0]) * (point3[1] - point1[1]) -
			(point2[1] - point1[1]) * (point3[0] - point1[0]);
		// This is the z-coordinate of the cross-product of the vector
		// from point1 to point2 and the vector from point1 to point3.
		// When figuring out what's right and what's left, remember
		// that Processing uses a left-hand coordinate system.
	}

	private float[] rotate(float[] vector, float theta) {
		// rotates vector by theta degrees in a clockwise direction
		return
			new float[] {
				vector[0] * cos(theta) - vector[1] * sin(theta),
				vector[0] * sin(theta) + vector[1] * cos(theta)
			};
	}

	public void reflectBall(Ball b) {
		reflectBall(b, reflectionNorm);
	}

	private void reflectBall(Ball b, float[] reflectionNorm) {
		if (reflectionNorm == null)
			throw new Error(
				"ERROR: reflectBall() can only be called after ballColliding()"
				);
		// v_r = v_i - 2(v_i . n)n
		b.setVelocity(
			difference(
				b.getVelocity(),
				scale(
					rotate(scale(reflectionNorm, 1 / mag(reflectionNorm)), PI / 2),
					2 * dot(
						b.getVelocity(),
						rotate(
							scale(reflectionNorm, 1 / mag(reflectionNorm)),
							PI / 2
							)
						)
					)
				)
			);
		reflectionNorm = null;
	}

	public void setColor(color rgb) {
		c = rgb;
		t = null;
	}

	public void setTexture(String texture) {
		t = loadImage(texture);
	}
}
