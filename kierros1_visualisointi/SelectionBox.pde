class SelectionBox extends ReactsToMouse {
    boolean isMenuOpen;
    float x, y;
    PGraphics menuOpenImg;
    PGraphics glow;
    PGraphics glow2;
    int TEXT_HEIGHT = 30;
    String currentNumber;

    SelectionBox(float x, float y) {
        this.x = x;
        this.y = y;
        isMenuOpen = false;

        int openH = TEXT_HEIGHT * 5 + 10;
        menuOpenImg = createGraphics(70, openH);
        menuOpenImg.beginDraw();
        menuOpenImg.strokeWeight(1);
        menuOpenImg.stroke(globalGrey);
        menuOpenImg.fill(globalLightGrey);
        menuOpenImg.rect(0,0,70,openH-1);
        menuOpenImg.fill(globalGrey);
        menuOpenImg.rect(50, 0, 20, openH);
        menuOpenImg.fill(255);
        menuOpenImg.ellipse(60, openH - 15, 15, 15);
        menuOpenImg.fill(127);
        menuOpenImg.triangle(55, openH - 13, 60, openH - 21, 65, openH - 13);

        drawOptions();
        menuOpenImg.endDraw();

        glow = createGraphics(70, 50);
        glow.beginDraw();
        glow.strokeWeight(2);
        glow.stroke(55, 155, 232);
        glow.noFill();
        glow.filter(BLUR, 5);
        glow.rect(1, 1, 19, 48);
        glow.endDraw();

        glow2 = createGraphics(70, openH);
        glow2.beginDraw();
        glow2.strokeWeight(2);
        glow2.stroke(55, 155, 232);
        glow2.noFill();
        glow2.filter(BLUR, 5);
        glow2.rect(1, 1, 19, openH - 2);
        glow2.endDraw();
    }



  void draw() {
    if(isMenuOpen == false){
      strokeWeight(1);
      stroke(globalGrey);
      fill(globalLightGrey);
      rect(x, y, 70, 50);
      fill(globalGrey);
      rect(x+50, y, 20, 50);
      noStroke();
      fill(255);
      ellipse(x+60, y+35, 15, 15);
      fill(127);
      triangle(x+55, y+32, x+60, y+40, x+65, y+32);
      if (currentNumber != null) {
        textFont(walkway, 30);
        fill(255);
        text(currentNumber, this.x+15, this.y+35);
      }
      if (isMouseOver) {
        image(glow, this.x+50, this.y);
      }
    } else{
      for (int i = 1; i < boxes.length; i++){
        if (boxes[i].isSelected){
          toggleMenu();
          currentNumber = boxes[i].number;
          boxes[i].isSelected = false;
          generateDataBalls(int(currentNumber));
        }
      }
      image(menuOpenImg, this.x, this.y);
      if (isMouseOver) {
        image(glow2, this.x+50, this.y);
      }
    }
  }

  //drawOptions piirtaa numerot 1-5
  void drawOptions() {
    for (int i = 1; i <= 5; i++) {
      menuOpenImg.fill(255);
      menuOpenImg.textFont(walkway, TEXT_HEIGHT);
      menuOpenImg.text(str(i), 10, i*TEXT_HEIGHT);

    }
  }

  void updateGradeChanged(int newGrade) {
    // Emmi ja Justus, teiän homma täyttää tää
  }

   @Override
  boolean areCoordinatesInside(float x, float y){
    if (isMenuOpen) {
      if (x > this.x+50 && x < this.x+70 && y > this.y && y < this.y+150) {
        return true;
      }
    }
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
