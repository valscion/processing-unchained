class DataBall {
  float radius;

  DataBall(float radius) {
    this.radius = radius;
  }

  void draw(float x, float y) {
    ellipse(x, y, radius * 2, radius * 2);
  }
}
