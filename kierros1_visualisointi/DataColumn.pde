class DataColumn extends ReactsToMouse {
  String type;
  int columnOrdinal;
  boolean isOpen = false;
  float START_LEFT_X = 110;
  float Y_POSITION = height - 55;
  float TEXT_HEIGHT = 24;
  float OPENED_WIDTH = 75;
  float CLOSED_WIDTH = 100;

  DataColumn(String type, int columnOrdinal) {
    this.type = type;
    this.columnOrdinal = columnOrdinal;
  }

  void draw() {
    textFont(walkway);
    textSize(TEXT_HEIGHT);
    textAlign(CENTER);
    float leftX = START_LEFT_X;
    fill(globalGrey);
    String typeInFinnish = mapTypeToFinnish();
    text(typeInFinnish, calculateLeftX(), Y_POSITION);
    if (isOpen) {
      leftX = 90+5*CLOSED_WIDTH;
      fill(255, 0 , 0);
      if (this == projectColumn) {
        String grades[] = new String[4];
        grades[0] = "Arch";
        grades[1] = "Koodi";
        grades[2] = "Ux";
        grades[3] = "Raportti";
        for (int i = 0; i <= 3; i++) {
          float x = leftX + (i) * OPENED_WIDTH;
          text(grades[i], x, Y_POSITION);
        }
      } else {
        text(typeInFinnish, calculateLeftX(), Y_POSITION);
        for (int i = 1; i <= 6; i++) {
          float x = leftX + (i - 1) * OPENED_WIDTH;
          if (i <= columnsForDataType()) {
          text(str(i), x, Y_POSITION);
          } else {
            fill(globalGrey);
            text(str(i), x, Y_POSITION);
          }
        }
      }
    }
    /*if (isOpen) {
      fill(255, 0, 0);
      for (int i = 1; i <= columnsForDataType(); i++) {
        float x = leftX + (i - 1) * OPENED_WIDTH;
        text(str(i), x, Y_POSITION);
      }
    }
    else {*/


    //float textX = calculateLeftX() - CLOSED_WIDTH / 2;

    //drawHitBox(textX);

    textAlign(LEFT);
  }

  float calculateLeftX() {
    float leftX = START_LEFT_X;
    leftX += (columnOrdinal-1)*CLOSED_WIDTH;
    return leftX;
    /*if (this == codeColumn) {
      // Ainakin yksi edellisistä sarakkeista on kiinni, eli vasempaan reunaan
      // lisää tilaa AINAKIN tämän verran
      leftX += CLOSED_WIDTH;
      if (projectColumn.isOpen) {
        // Projektikolumnissa on 4 kappaletta auki olevia sarakkeita
        leftX += 4 * OPENED_WIDTH ;
      }
      else if (theoryColumn.isOpen) {
        // Teoriakolumnissa on 5 kappaletta auki olevia sarakkeita
        leftX += 5 * OPENED_WIDTH;
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
    return leftX;*/
  }

  float columnsForDataType() {
    if (type == "project") return 4;
    if (type == "theory") return 5;
    if (type == "code") return 6;
    if (type == "exam" || type =="portfolio") return 0;
    return 0;
  }

  String mapTypeToFinnish() {
    if (type == "code") return "Koodi";
    if (type == "theory") return "Teoria";
    if (type == "project") return "Projekti";
    if (type == "exam") return "Tentti";
    if (type == "portfolio") return "Portfolio";
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
