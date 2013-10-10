class Menu extends ReactsToMouse {
  // Kuvat eri menun tiloja varten
  PGraphics menuOpenImg;
  PGraphics menuClosedImg;
  PGraphics menuGlowImg1;
  PGraphics menuGlowImg2;

  boolean isMenuOpen;
  float x, y;

  Menu(float x, float y) {
    this.x = x;
    this.y = y;
    isMenuOpen = false;
    menuOpenImg = createGraphics(width, 150);
    menuOpenImg.beginDraw();
    menuOpenImg.noStroke();
    menuOpenImg.fill(globalGrey);
    menuOpenImg.rect(0, 0, width, 150);

    menuOpenImg.fill(255);
    menuOpenImg.textFont(walkway);
    menuOpenImg.textSize(30);
    menuOpenImg.text("MENU", 15, 135);

    menuOpenImg.ellipse(115, 125, 20, 20);
    menuOpenImg.fill(127);
    menuOpenImg.triangle(110, 129, 115, 119, 120, 129);
    menuOpenImg.endDraw();

    menuClosedImg = createGraphics(width, 50);
    menuClosedImg.beginDraw();
    menuClosedImg.noStroke();
    menuClosedImg.fill(globalGrey);
    menuClosedImg.rect(0, 0, width, 50);

    menuClosedImg.fill(255);
    menuClosedImg.textFont(walkway);
    menuClosedImg.textSize(30);
    menuClosedImg.text("MENU", 15, 35);
    menuClosedImg.endDraw();
    drawButton();

    menuGlowImg1 = createGraphics(width, 50);
    menuGlowImg1.beginDraw();
    menuGlowImg1.strokeWeight(4);
    menuGlowImg1.stroke(55, 155, 232);
    menuGlowImg1.noFill();
    menuGlowImg1.filter(BLUR, 5);
    menuGlowImg1.rect(0, 0, width-2, 48);
    menuGlowImg1.endDraw();

    menuGlowImg2 = createGraphics(width, 150);
    menuGlowImg2.beginDraw();
    menuGlowImg2.strokeWeight(4);
    menuGlowImg2.stroke(55, 155, 232);
    menuGlowImg2.noFill();
    menuGlowImg2.filter(BLUR, 5);
    menuGlowImg2.rect(0, 0, width-2, 148);
    menuGlowImg2.endDraw();
  }

  void draw() {
    if (isMenuOpen == false) {
      image(menuClosedImg, this.x, this.y);
      if (isMouseOver) {
        image(menuGlowImg1, this.x, this.y);
      }
    } else {
      image(menuOpenImg, this.x, this.y);
      if (isMouseOver) {
        image(menuGlowImg2, this.x, this.y);
      }
    }
  }

  void drawButton() {
    menuClosedImg.beginDraw();
    menuClosedImg.fill(255);
    menuClosedImg.ellipse(115, 25, 20, 20);
    menuClosedImg.fill(127);
    menuClosedImg.triangle(110, 22, 115, 30, 120, 22);
    menuClosedImg.endDraw();
  }

  void toggleMenu() {
    if (isMenuOpen) {
      isMenuOpen = false;
    } else {
      isMenuOpen = true;
    }
  }

  @Override
  boolean areCoordinatesInside(float x, float y) {
    float topYLimit, bottomYLimit;
    if (isMenuOpen) {
      topYLimit = 105;
      bottomYLimit = 150;
    }
    else {
      topYLimit = this.y;
      bottomYLimit = 40;
    }
    if (x > this.x && x < 135 && y > topYLimit && y < bottomYLimit) {
      return true;
    }
    else {
      return false;
    }
  }

  @Override
  void mouseClicked() {
    toggleMenu();
  }

}

