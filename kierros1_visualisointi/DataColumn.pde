class DataColumn extends ReactsToMouse {
  String type;
  int columnOrdinal;
  boolean isOpen = false;
  float START_LEFT_X = 110;
  float Y_POSITION = 560;
  float TEXT_HEIGHT = 34;
  float OPENED_WIDTH = 75;
  float CLOSED_WIDTH = 120;

  DataColumn(String type, int columnOrdinal) {
    this.type = type;
    this.columnOrdinal = columnOrdinal;
  }

  void draw() {
    textFont(walkway);
    textSize(TEXT_HEIGHT);
    textAlign(CENTER);
    float leftX = START_LEFT_X + CLOSED_WIDTH * (columnOrdinal - 1);
    if (isOpen) {
      fill(255, 0, 0);
      for (int i = 1; i <= 6; i++) {
        float x = leftX + (i - 1) * OPENED_WIDTH;
        text(str(i), x, Y_POSITION);
      }
    }
    else {
      fill(196);
      String typeInFinnish = mapTypeToFinnish();
      text(typeInFinnish, leftX, Y_POSITION);
    }
  }

  String mapTypeToFinnish() {
    if (type == "code") return "Koodi";
    if (type == "theory") return "Teoria";
    if (type == "project") return "Projekti";
    return "Kekkonen";
  }

  @Override
  boolean areCoordinatesInside(float x, float y) {
    float textX = START_LEFT_X + (columnOrdinal - 1) * CLOSED_WIDTH;
    x = x + CLOSED_WIDTH / 2;
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
