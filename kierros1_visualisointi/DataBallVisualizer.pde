// Tämä luokka handlaa kaiken varsinaisen datapallojen piirtämisen ja hauskan
// silmäkarkin yms.
class DataBallVisualizer {
  private int lastChangeTime;
  private DataBallContainer currentDataBalls;
  private DataBallContainer lastDataBalls;

  DataBallVisualizer() {
    currentDataBalls = null;
    lastDataBalls = null;
    lastChangeTime = 0;
  }

  void changeDataBalls(DataBallContainer newDataBalls) {
    // Aseta vanhoiksi palloiksi samat kuin uudet, jos tämä on eka kerta kun
    // palloja vaihdetaan.
    lastDataBalls = (currentDataBalls != null) ? currentDataBalls : newDataBalls;
    currentDataBalls = newDataBalls;
  }

  void draw() {
    float marginY = height - 200;
    float marginX = 120;
    float gapX = 95;
    float gapY = 85;

    for(int grade = 0; grade <= 6; grade++) {
      float y = marginY - (grade - 1) * gapY;
      //stroke(255, 0, 0);
      //strokeWeight(1);
      //Pallot piirretään täysin punaisiksi
      fill(255, 0, 0, 120);

      DataBall theoryBall = currentDataBalls.theoryBallForGrade(grade);
      DataBall projectBall = currentDataBalls.projectBallForGrade(grade);
      DataBall codeBall = currentDataBalls.codeBallForGrade(grade);
      DataBall examBall = currentDataBalls.examBallForGrade(grade);
      DataBall portfolioBall = currentDataBalls.portfolioBallForGrade(grade);

      theoryBall.draw(marginX, y);
      projectBall.draw(marginX + gapX, y);
      codeBall.draw(marginX + gapX * 2, y);
      examBall.draw(marginX + gapX * 3, y);
      portfolioBall.draw(marginX + gapX * 4, y);

      if (codeColumn.isOpen) {
        for (int codeRound = 1; codeRound <= 6; codeRound++) {
          DataBall codeRoundBall = currentDataBalls.codeBallForGradeAndRound(grade, codeRound);
          if (codeRoundBall != null) {
            float drawX = marginX + gapX * 5;
            drawX += (codeRound - 1) * (gapX - 20);
            codeRoundBall.draw(drawX, y);
          }
        }
      } else if (projectColumn.isOpen) {
        DataBall architectureBall = currentDataBalls.projectBallForGradeAndArchitecture(grade);
        float drawX = marginX + gapX * 5;
        architectureBall.draw(drawX, y);
        DataBall projectCodeBall = currentDataBalls.projectBallForGradeAndCode(grade);
        drawX += gapX -20;
        projectCodeBall.draw(drawX, y);
        DataBall uxBall = currentDataBalls.projectBallForGradeAndUx(grade);
        drawX += (gapX-20);
        uxBall.draw(drawX, y);
        DataBall reportBall = currentDataBalls.projectBallForGradeAndReport(grade);
        drawX += (gapX-20);
        reportBall.draw(drawX, y);

      } else if(theoryColumn.isOpen){
        for (int theoryRound = 1; theoryRound <= 5; theoryRound++) {
          DataBall theoryRoundBall = currentDataBalls.theoryBallForGradeAndRound(grade, theoryRound);
          if (theoryRoundBall != null) {
            float drawX = marginX + gapX * 5;
            drawX += (theoryRound - 1) * (gapX - 20);
            theoryRoundBall.draw(drawX, y);
          }
        }

      }

      fill(globalGrey);
      textFont(walkway, 30);
      text(str(grade), 20, y);

    }
  }
}
