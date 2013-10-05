PFont walkway;
Menu menu;
SelectionBox box;
boolean menuOpen;

void setup() {
  size(800, 600);
  background(255);
  walkway = loadFont("WalkwayBold-48.vlw");
  menu = new Menu();
  box = new SelectionBox();
  menuOpen = false;

  setupDebug();
}

void draw() {
  background(255);
  box.draw(700, 60);
  menu.draw(0, 0);

  drawDebug();
}



class Menu {
  PGraphics p;
  
  Menu() {
    p = createGraphics(width, 150);
    p.beginDraw();
    p.noStroke();
    p.fill(199);
    p.rect(0, 0, width, 150);

    p.fill(255);
    p.textFont(walkway);
    p.textSize(30);
    p.text("MENU", 15, 135);

    p.ellipse(115, 125, 20, 20);
    p.fill(127);
    p.triangle(110, 129, 115, 119, 120, 129);
    p.endDraw();
  }

  void draw(int x, int y) {
    pushMatrix();
    translate(x, y);
    if (menuOpen == false) {
      drawMenu();
      drawButton();
    } else {
      openMenu();
    }
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
  
  void drawButton() {
    fill(255);
    ellipse(115, 25, 20, 20);
    fill(127);
    triangle(110, 22, 115, 30, 120, 22);
  }

  void openMenu() {
    image(p, 0, 0);
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

void mouseClicked() {
  if (menuOpen == false) {
    if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < 50) {
        menuOpen = true;
    }
  } else {
    if (mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < 150) {
      menuOpen = false;
    }
  }
}
