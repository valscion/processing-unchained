class DataColumn extends ReactsToMouse {
  String columnText;
  float x;

  DataColumn(String columnText, float x) {
    this.columnText = columnText;
    this.x = x;
  }

  void draw() {
    //rect(x, 535, 108, 30);
    textFont(walkway);
    textSize(34);
    text(columnText, x, 560);
  }

  @Override
  boolean areCoordinatesInside(float x, float y) { return false; }
  @Override
  void mouseClicked() {}
}
