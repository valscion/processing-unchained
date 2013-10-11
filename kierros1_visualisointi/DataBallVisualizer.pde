// Tämä luokka handlaa kaiken varsinaisen datapallojen piirtämisen ja hauskan
// silmäkarkin yms.
class DataBallVisualizer {
  private int lastChangeTime;
  private DataBallContainer currentDataBalls;
  private DataBallContainer lastDataBalls;
  private int TRANSITION_TIME = 400; // ms

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
    lastChangeTime = millis();
  }

  void draw() {
    float marginY = height - 200;
    float marginX = 120;
    float gapX = 95;
    float gapY = 85;
    // Väliaikainen taulu kaikkien piirrettävien pallojen kokoa varten. Niitä on
    // aina maksimissaan 11 sarakkeellista, joten tämän avulla pallot saadaan
    // piirrettyä kivasti ja animoidusti tarpeen mukaan.
    // Rivejä puolestaan on 7 kappaletta, luvut 0-6
    float[][] ballRadii = new float[11][7];

    for(int grade = 0; grade <= 6; grade++) {
      float y = marginY - (grade - 1) * gapY;
      //stroke(255, 0, 0);
      //strokeWeight(1);


      DataBall theoryBall = currentDataBalls.theoryBallForGrade(grade);
      DataBall projectBall = currentDataBalls.projectBallForGrade(grade);
      DataBall codeBall = currentDataBalls.codeBallForGrade(grade);
      DataBall examBall = currentDataBalls.examBallForGrade(grade);
      DataBall portfolioBall = currentDataBalls.portfolioBallForGrade(grade);

      ballRadii[0][grade] = theoryBall.radius;
      ballRadii[1][grade] = projectBall.radius;
      ballRadii[2][grade] = codeBall.radius;
      ballRadii[3][grade] = examBall.radius;
      ballRadii[4][grade] = portfolioBall.radius;

      //theoryBall.draw(marginX, y);
      //projectBall.draw(marginX + gapX, y);
      //codeBall.draw(marginX + gapX * 2, y);
      //examBall.draw(marginX + gapX * 3, y);
      //portfolioBall.draw(marginX + gapX * 4, y);

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

    // Piirretään kaikki pallot custom-radiuksilla
    for (int column = 0; column < 5; column++) {
      // X:ää piirretään isosti jaoteltuna vain ensimmäisten viiden sarakkeen
      // osalta, muille väli on 20 pikseliä vähemmän
      float x = marginX + min(column, 5) * gapX + max(column - 5, 0) * (gapX - 20);
      for (int grade = 0; grade <= 6; grade++) {
        float y = marginY - (grade - 1) * gapY;
        //Pallot piirretään täysin punaisiksi
        fill(255, 0, 0, 120);

        float r = ballRadii[column][grade];
        ellipse(x, y, r * 2, r * 2);
      }
    }
  }
}
