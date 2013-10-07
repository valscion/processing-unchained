class SelectionBox extends ReactsToMouse {
    boolean isMenuOpen;
    float x, y;
    PGraphics menuOpenImg;

    SelectionBox(float x, float y) {
        this.x = x;
        this.y = y;
        isMenuOpen = false;

        menuOpenImg = createGraphics(70, 150);
        menuOpenImg.beginDraw();
        menuOpenImg.noStroke();
        menuOpenImg.fill(127);
        menuOpenImg.rect(0,0,70,150);
        menuOpenImg.endDraw();
    }


  void draw() {
    if(isMenuOpen == false){
    strokeWeight(1);
    stroke(190);
    fill(215);
    rect(x, y, 70, 50);
    fill(190);
    rect(x+50, y, 20, 50);
    noStroke();
    fill(255);
    ellipse(x+60, y+35, 15, 15);
    fill(127);
    triangle(x+55, y+32, x+60, y+40, x+65, y+32);
    }
    else{
        println("tanne pitas paatyy");
      image(menuOpenImg, this.x, this.y);
    }
  }
   @Override
  boolean areCoordinatesInside(float x, float y){
    if (x > this.x+50 && x < this.x+70 && y > this.y && y < this.y+50) {
      return true;
    }
    return false;
  }
  void toggleMenu() {
    if (isMenuOpen) {
      isMenuOpen = false;
    } else {
      isMenuOpen = true;
    }
  }

  @Override
  void mouseClicked(){
    toggleMenu();
  }
}
