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
    float leftX = calculateLeftX();
    if (isOpen) {
      fill(255, 0, 0);
      for (int i = 1; i <= columnsForDataType(); i++) {
        float x = leftX + (i - 1) * OPENED_WIDTH;
        text(str(i), x, Y_POSITION);
      }
    }
    else {
      fill(196);
      String typeInFinnish = mapTypeToFinnish();
      text(typeInFinnish, leftX, Y_POSITION);
    }

    float textX = calculateLeftX() - CLOSED_WIDTH / 2;
    
    //drawHitBox(textX);

    textAlign(LEFT);
  }

  float calculateLeftX() {
    float leftX = START_LEFT_X;
    if (this == codeColumn) {
      // Ainakin yksi edellisistä sarakkeista on kiinni, eli vasempaan reunaan
      // lisää tilaa AINAKIN tämän verran
      leftX += CLOSED_WIDTH;
      if (projectColumn.isOpen) {
        // Projektikolumnissa on 4 kappaletta auki olevia sarakkeita
        leftX += 4 * OPENED_WIDTH + 20;
      }
      else if (theoryColumn.isOpen) {
        // Teoriakolumnissa on 5 kappaletta auki olevia sarakkeita
        leftX += 5 * OPENED_WIDTH + 40;
      }
      else {
        // Kumpikaan edellisistä sarakkeista ei ollut auki, joten lisätään
        // vasempaan X-koordinaattiin vielä yksi suljetun sarakkeen leveys lisää
        leftX += CLOSED_WIDTH;
      }
    }
    else if (this == projectColumn) {
      if (theoryColumn.isOpen) {
        leftX += 5 * OPENED_WIDTH + 30;
      }
      else {
        leftX += CLOSED_WIDTH;
      }
    }
    return leftX;
  }

  float columnsForDataType() {
    if (type == "project") return 4;
    if (type == "theory") return 5;
    if (type == "code") return 6;
    return 0;
  }

  String mapTypeToFinnish() {
    if (type == "code") return "Koodi";
    if (type == "theory") return "Teoria";
    if (type == "project") return "Projekti";
    return "Kekkonen";
  }

  void drawHitBox(float textX) {
    noFill();
    stroke(50);
    rect(textX, Y_POSITION - TEXT_HEIGHT, CLOSED_WIDTH, TEXT_HEIGHT);
  }

  @Override
  boolean areCoordinatesInside(float x, float y) {
    float textX = calculateLeftX() - CLOSED_WIDTH / 2;
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
    if (!isOpen) {
      isOpen = true;
      if (this != theoryColumn) theoryColumn.isOpen = false;
      if (this != projectColumn) projectColumn.isOpen = false;
      if (this != codeColumn) codeColumn.isOpen = false;
    }
  }
}
