PFont walkway;
Menu menu;
SelectionBox box;

void setup() {
  size(800, 600);
  background(255);
  walkway = loadFont("WalkwayBold-48.vlw");
  menu = new Menu();
  box = new SelectionBox();
}

void draw() {
  menu.draw(0, 0);
  box.draw(700, 60);
}

class Menu {
  void draw(int x, int y) {
    pushMatrix();
    translate(x, y);
    drawMenu();
    drawButton(115, 25);
    popMatrix();
  }
 
  void drawMenu() {
    noStroke();
    fill(199);
    rect(0, 0, width, 50);
    
    fill(255);
    textFont(walkway);
    textSize(30);
    text("MENU", 15, 35);
  }
  
  void drawButton(int x, int y) {
    translate(x, y);
    ellipse(0, 0, 20, 20);
    fill(127);
    triangle(-5, -3, 0, 5, 5, -3);
  }
  }
  
class SelectionBox {
  void draw(int x, int y) {
    pushMatrix();
    translate(x, y);
    strokeWeight(1);
    stroke(190);
    fill(215);
    rect(0, 0, 70, 50);
    fill(190);
    rect(50, 0, 20, 50);
    noStroke();
    fill(255);
    ellipse(60, 35, 15, 15);
    fill(127);
    triangle(55, 32, 60, 40, 65, 32);
    popMatrix();
  }
}
