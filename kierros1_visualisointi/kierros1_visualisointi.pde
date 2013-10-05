PFont walkway;
Menu menu;
SelectionBox box;
ArrayList<ReactsToMouse> clickables;

void setup() {
  size(800, 600);
  background(255);
  walkway = loadFont("WalkwayBold-48.vlw");
  menu = new Menu(0, 0);
  box = new SelectionBox(700, 60);
  clickables = new ArrayList<ReactsToMouse>();
  clickables.add(menu);

  setupDebug();
}

void draw() {
  background(255);
  box.draw();
  menu.draw();

  drawDebug();
}

void mouseMoved() {
  for (int i = 0; i < clickables.size(); i++) {
    if (clickables.get(i).areCoordinatesInside(mouseX, mouseY)) {
      clickables.get(i).mouseOver();
    }
  }
}

void mouseClicked() {
for (int i = 0; i < clickables.size(); i++) {
    if (clickables.get(i).areCoordinatesInside(mouseX, mouseY)) {
      clickables.get(i).mouseClicked();
    }
  }
}

  /*if (menu.menuOpen == false) {
    if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < 50) {
      menu.toggleMenu();
    }
    } else {
    if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < 150) {
      menu.toggleMenu();
    }
  }*/

