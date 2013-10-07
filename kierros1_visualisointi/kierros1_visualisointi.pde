PFont walkway;
Menu menu;
SelectionBox selection;
CheckBox box1;
CheckBox box2;
CheckBox box3;
CheckBox box4;
ArrayList<ReactsToMouse> clickables;
StudentContainer studentContainer;

void setup() {
  size(800, 600);
  background(255);
  walkway = loadFont("WalkwayBold-48.vlw");
  menu = new Menu(0, 0);
  selection = new SelectionBox(700, 60);
  box1 = new CheckBox(20, 20, "2009");
  box2 = new CheckBox(180, 20, "2010");
  box3 = new CheckBox(330, 20, "2011");
  box4 = new CheckBox(480, 20, "2012");
  clickables = new ArrayList<ReactsToMouse>();
  clickables.add(menu);
  clickables.add(box1);
  clickables.add(box2);
  clickables.add(box3);
  clickables.add(box4);

  //setupDebug();
  studentContainer = new StudentContainer();
}

void draw() {
  background(255);
  selection.draw();
  menu.draw();
  if (menu.isMenuOpen) {
    box1.draw();
    box2.draw();
    box3.draw();
    box4.draw();
  }

  //drawDebug();
}

void mouseMoved() {
  for (int i = 0; i < clickables.size(); i++) {
    ReactsToMouse clickable = clickables.get(i);
    if (clickable.areCoordinatesInside(mouseX, mouseY)) {
      clickable.isMouseOver = true;
    } else {
      clickable.isMouseOver = false;
    }
  }
}

void mouseClicked() {
  for (int i = 0; i < clickables.size(); i++) {
    ReactsToMouse clickable = clickables.get(i);
    if (clickable.areCoordinatesInside(mouseX, mouseY)) {
      clickable.mouseClicked();
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

