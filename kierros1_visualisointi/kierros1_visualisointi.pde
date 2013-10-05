PFont walkway;
Menu menu;
SelectionBox box;

void setup() {
  size(800, 600);
  background(255);
  walkway = loadFont("WalkwayBold-48.vlw");
  menu = new Menu(0, 0);
  box = new SelectionBox(700, 60);

  //setupDebug();
}

void draw() {
  background(255);
  box.draw();
  menu.draw();

  //drawDebug();
}

void mouseMoved() {

}

void mouseClicked() {
  if (menu.menuOpen == false) {
    if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < 50) {
      menu.toggleMenu();
    }
    } else {
    if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < 150) {
      menu.toggleMenu();
    }
  }
}
