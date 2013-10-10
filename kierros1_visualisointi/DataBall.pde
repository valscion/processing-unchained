class DataBall {
  float radius;
  String infoTxt;

  DataBall(float radius) {
    this(radius, "?");
  }

  DataBall(float radius, String infoTxt) {
    this.radius = radius;
    this.infoTxt = infoTxt;
  }

  void draw(float x, float y) {
    ellipse(x, y, radius * 2, radius * 2);
    textSize(14);
    textAlign(CENTER);
    text(infoTxt, x, y);
    textAlign(LEFT);
  }
}
