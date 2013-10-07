class Menu implements ReactsToMouse {
  PGraphics menuOpenImg;
  PGraphics menuClosedImg;
  PGraphics menuGlowImg1;
  PGraphics menuGlowImg2;
  boolean menuOpen;
  boolean mouseIsOver;
  float x, y;
  
  Menu(float x, float y) {
    this.x = x;
    this.y = y;
    mouseIsOver = false;
    menuOpen = false;
    menuOpenImg = createGraphics(width, 150);
    menuOpenImg.beginDraw();
    menuOpenImg.noStroke();
    menuOpenImg.fill(199);
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
    menuClosedImg.fill(199);
    menuClosedImg.rect(0, 0, width, 50);
      
    menuClosedImg.fill(255);
    menuClosedImg.textFont(walkway);
    menuClosedImg.textSize(30);
    menuClosedImg.text("MENU", 15, 35);
    menuClosedImg.endDraw();
    drawButton();

    menuGlowImg1 = createGraphics(width, 50);
    menuGlowImg1.beginDraw();
    menuGlowImg1.strokeWeight(5);
    menuGlowImg1.stroke(55, 155, 232);
    menuGlowImg1.noFill();
    menuGlowImg1.filter(BLUR, 5);
    menuGlowImg1.rect(0, 0, width, 50);
    menuGlowImg1.endDraw();

    menuGlowImg2 = createGraphics(width, 150);
    menuGlowImg2.beginDraw();
    menuGlowImg2.strokeWeight(5);
    menuGlowImg2.stroke(55, 155, 232);
    menuGlowImg2.noFill();
    menuGlowImg2.filter(BLUR, 5);
    menuGlowImg2.rect(0, 0, width, 150);
    menuGlowImg2.endDraw();
  }
 
  void draw() {
    if (menuOpen == false) {
      image(menuClosedImg, this.x, this.y);
      if (mouseIsOver) {
        image(menuGlowImg1, this.x, this.y);
      }
    } else {
      image(menuOpenImg, this.x, this.y);
      if (mouseIsOver) {
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
    if (menuOpen == false) {
      menuOpen = true;
    } else {
      menuOpen = false;
    }
  }

  boolean areCoordinatesInside(float x, float y) {
    if (menuOpen == false) {
        if (x > this.x && x < 135 && y > this.y && y < 40) {
          println("koordinaatit pienen sisal");
          return true;
        }
    } else {
      if (x > this.x && x < 135 && y > 105 && y < 150) {
        println("koordinaatit ison sisal");
        return true;
      }
    }
    return false;
  }

  void mouseOver() {
    println("ja tanne");
    mouseIsOver = true;
      
  }

  void mouseNotOver() {
    mouseIsOver = false;
  }

  void mouseClicked() {
    println("klikattiin");
      println("klikkaus toimii");
      toggleMenu();
    
  }


}

