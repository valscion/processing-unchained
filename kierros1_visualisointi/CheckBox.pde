class CheckBox extends ReactsToMouse {
  float x;
  float y;
  boolean isChecked;
  String year;
  PGraphics glow;

  CheckBox(float x, float y, String year) {
    this.x = x;
    this.y = y;
    isChecked = false;
    this.year = year;
    glow = createGraphics(30, 30);
    glow.beginDraw();
    glow.strokeWeight(2);
    glow.stroke(55, 155, 232);
    glow.noFill();
    glow.filter(BLUR, 4);
    glow.rect(2, 2, 26, 26);
    glow.endDraw();
  }

  void draw() {
    fill(255);
    rect(x+2, y+2, 26, 26);
    textFont(walkway);
    textSize(30);
    text(year, x+40, y+25);
    if (isMouseOver) {
      image(glow, this.x, this.y);
    }
    if (isChecked) {
      stroke(0);
      line(x+2, y+2, x+28, y+28);
      line(x+28, y+2, x+2, y+28);
      noStroke();
    }
  }

  @Override
  boolean areCoordinatesInside(float x, float y){
    if (x > this.x && x < this.x+30 && y > this.y && y < this.y+30) {
      return true;
    }
    return false;
  }

  @Override
  void mouseClicked(){
    if (isChecked) {
      isChecked = false;
    } else {
      isChecked = true;
    }
    onCheckboxClicked();
  }

}
