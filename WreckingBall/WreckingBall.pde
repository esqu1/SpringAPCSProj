final int TITLE = 0, MENU = 1, PLAYING = 2, DEAD = 3;
int mode = TITLE;
Board board;

// The default view angle about the x-axis is PI / 3.
float viewAngleX = PI / 3;
// The default view angle about the y-axis is 0.
float viewAngleY = 0;
// The default field of view is PI / 3.
float fov = PI / 3;

void setup() {
	// The default size of the window is 4/9 of the screen size.
	size(2 * displayWidth / 3, 2 * displayHeight / 3, P3D);
	// If the game is running inside a web browser, the frame
	// variable will be null.  Otherwise, the frame will be
	// resizable.
	if (frame != null)
		frame.setResizable(true);
	mode = MENU;
}

void draw() {
	background(0);
	switch (mode) {
		case TITLE:
		title();
		break;
		case MENU:
		menu();
		break;
		case PLAYING:
		playing();
		break;
		case DEAD:
		dead();
		break;
	}
}

void title() {
}

void menu() {
	board = new Board(#63F702);
	mode = PLAYING;
}

void playing() {
	// Rotate the grid according to the view angles.
	translate(width / 2, height, 0);
	rotateX(viewAngleX);
	rotateY(viewAngleY);
	translate(-width / 2, -height, 0);
	// Now draw the board and everything on it.
	board.draw();
}

void dead() {
}

void mouseDragged() {
	// A downward swipe will bring the viewAngleX closer
	// to zero (a vertical board), while an upward
	// swipe will bring the viewAngleX closer to HALF_PI
	// (a horizontal board).  The viewAngleX cannot go
	// outside the range [0, HALF_PI].
	if (mode == PLAYING && mouseButton == RIGHT) {
		if (pmouseY < mouseY && viewAngleX > 0) {
			viewAngleX += (pmouseY - mouseY) / 1000.;
			if (viewAngleX < 0)
				viewAngleX = 0;
		}
		else if (pmouseY > mouseY && viewAngleX < HALF_PI) {
			viewAngleX += (pmouseY - mouseY) / 1000.;
			if (viewAngleX > HALF_PI)
				viewAngleX = HALF_PI;
		}
	}
	// A leftward swipe will bring the viewAngleY closer
	// to -QUARTER_PI (the right edge of the board is
	// closer than the left edge), while a rightward
	// swipe will bring the viewAngleY closer to
	// QUARTER_PI (the left edge of the board is closer
	// than the right edge).  The viewAngleY cannot go
	// outside the range [-QUARTER_PI, QUARTER_PI].
	if (mode == PLAYING && mouseButton == RIGHT) {
		if (mouseX < pmouseX && viewAngleY > -QUARTER_PI) {
			viewAngleY += (mouseX - pmouseX) / 1000.;
			if (viewAngleY < -QUARTER_PI)
				viewAngleY = -QUARTER_PI;
		}
		else if (mouseX > pmouseX && viewAngleY < QUARTER_PI) {
			viewAngleY += (mouseX - pmouseX) / 1000.;
			if (viewAngleY > QUARTER_PI)
				viewAngleY = QUARTER_PI;
		}
	}
}

void mouseWheel(MouseEvent me) {
	if (me.getClickCount() < 0 && fov > PI / 24)
		// If the wheel was rotated up or away from the player,
		// the field of view is decreased.
		fov -= PI / 360;
	else if (fov < 3 * PI / 4)
		// If the wheel was rotated down or toward the player,
		// the field of view is increased.
		fov += PI / 360;
	perspective(
		fov, // field-of-view angle for vertical direction
		float(width) / float(height), // aspect ratio
		(height / 2.0) / tan(fov / 2.0) / 10.0,
		// z-position of nearest clipping plane
		(height / 2.0) / tan(fov / 2.0) * 10.0
		// z-position of farthest clipping plane
		);
}

void keyPressed(KeyEvent ke) {
	// View angles and fov are reset when ctrl-/alt-/cmd-R
	// is pressed.
	if (
		(ke.isControlDown() || ke.isAltDown() || ke.isMetaDown()
		) && ke.getKeyCode() == 'R') {
		viewAngleX = PI / 3;
		viewAngleY = 0;
		fov = PI / 3;
		perspective(
			fov,
			float(width) / float(height),
			(height / 2.0) / tan(fov / 2.0) / 10.0,
			(height / 2.0) / tan(fov / 2.0) * 10.0
			);
	}
}
