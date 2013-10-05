class SelectionBox {
    float x, y;

    SelectionBox(float x, float y) {
        this.x = x;
        this.y = y;
    }

  void draw() {
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
}
