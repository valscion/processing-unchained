class DataBall extends ReactsToMouse {
  float x;
  float y;
  float radius;
  PGraphics glow;

  DataBall(float x, float y, float radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    glow = createGraphics(round(radius*2)+5, round(radius*2)+5);
    glow.beginDraw();
    glow.strokeWeight(2);
    glow.stroke(55, 155, 232);
    glow.noFill();
    glow.filter(BLUR, 4);
    glow.ellipse(radius+2, radius+2, radius*2, radius*2);
    glow.endDraw();
  }

  void draw() {
    ellipse(x, y, radius*2, radius*2);
    if (isMouseOver) {
      image(glow, x-radius-2, y-radius-2);
    }
  }

  @Override
  boolean areCoordinatesInside(float x, float y) {
    if (x > this.x-radius && x < this.x+radius && y > this.y-radius && y < this.y+radius) {
      return true;
    }
    return false;
  }

  @Override
  void mouseClicked() {}
}
