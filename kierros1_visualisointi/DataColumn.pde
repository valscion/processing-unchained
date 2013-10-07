class DataColumn extends ReactsToMouse {
  String type;
  int columnOrdinal;
  boolean isOpen = false;
  float Y_POSITION = 560;
  float TEXT_HEIGHT = 34;
  float OPENED_WIDTH = 60;
  float CLOSED_WIDTH = 120;

  DataColumn(String type, int columnOrdinal) {
    this.type = type;
    this.columnOrdinal = columnOrdinal;
  }

  void draw() {
    textFont(walkway);
    if (isOpen) {
      fill(255, 0, 0);
    }
    else {
      fill(196);
    }
    textSize(TEXT_HEIGHT);

    float textX = 65 + (columnOrdinal - 1) * CLOSED_WIDTH;
    text(type, textX, Y_POSITION);
  }

  @Override
  boolean areCoordinatesInside(float x, float y) {
    float textX = 65 + (columnOrdinal - 1) * CLOSED_WIDTH;
    if (x < textX || x > textX + CLOSED_WIDTH) {
      return false;
    }
    if (y < Y_POSITION - TEXT_HEIGHT || y > Y_POSITION) {
      return false;
    }
    return true;
  }

  @Override
  void mouseClicked() {
    if (isOpen) {
      isOpen = false;
    }
    else {
      isOpen = true;
    }
  }
}
