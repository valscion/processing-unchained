class Menu {
  PGraphics p;
  boolean menuOpen;
  float x, y;
  
  Menu(float x, float y) {
    this.x = x;
    this.y = y;
    menuOpen = false;
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
 
  void draw() {
    if (menuOpen == false) {
      noStroke();
      fill(199);
      rect(0, 0, width, 50);
      
      fill(255);
      textFont(walkway);
      textSize(30);
      text("MENU", 15, 35);
      drawButton();
    } else {
      image(p, 0, 0);
    }
  }
  
  void drawButton() {
    fill(255);
    ellipse(115, 25, 20, 20);
    fill(127);
    triangle(110, 22, 115, 30, 120, 22);
  }

  void toggleMenu() {
    if (menuOpen == false) {
      menuOpen = true;
    } else {
      menuOpen = false;
    }
  }
}
