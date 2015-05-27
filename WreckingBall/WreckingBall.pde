final int TITLE = 0, MENU = 1, PLAYING = 2, DEAD = 3;
int mode = TITLE;
Board board;
float viewAngle = PI/3;

void setup() {
	size(1000, 800, P3D);
	// FOR NOW
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
	translate(0, height, 0);
	rotateX(viewAngle);
	translate(0, -height, 0);
	board.draw();
}

void dead() {
}

void mouseDragged() {
	if (mouseButton == RIGHT && ((pmouseY > mouseY && viewAngle < HALF_PI) || (pmouseY < mouseY && viewAngle > 0))) {
		viewAngle += (pmouseY - mouseY) / 1000.;
		if (viewAngle < 0)
			viewAngle = 0;
		if (viewAngle > HALF_PI)
			viewAngle = HALF_PI;
	}
}
