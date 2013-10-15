// Tämä luokka handlaa kaiken varsinaisen datapallojen piirtämisen ja hauskan
// silmäkarkin yms.
class DataBallVisualizer {
  private int lastChangeTime;
  private DataBallContainer currentDataBalls;
  private DataBallContainer lastDataBalls;
  private int TRANSITION_TIME = 400; // ms

  // Väliaikainen taulu kaikkien piirrettävien pallojen oikeaa kokoa varten.
  // Aina maksimissaan 11 sarakkeellista, joten tämän avulla pallot saadaan
  // piirrettyä kivasti ja animoidusti tarpeen mukaan.
  // Rivejä puolestaan on 7 kappaletta, luvut 0-6
  float[][] ballRadii = new float[11][7];

  // Vanhat pallojen säteet otettuna talteen tässä taulukossa
  float[][] oldBallRadii = new float[11][7];

  // Tämän avulla piirretään koot
  float[][] drawBallRadii = new float[11][7];

  DataBallVisualizer() {
    currentDataBalls = null;
    lastDataBalls = null;
    // Damn, en ihan kerennyt toteuttaa tätä transitiota.
    lastChangeTime = 0;
  }

  void changeDataBalls(DataBallContainer newDataBalls) {
    // Aseta vanhoiksi palloiksi samat kuin uudet, jos tämä on eka kerta kun
    // palloja vaihdetaan.
    lastDataBalls = (currentDataBalls != null) ? currentDataBalls : newDataBalls;
    currentDataBalls = newDataBalls;
    lastChangeTime = millis();

    updateBallRadii();
  }

  // Päivittää piirrettävien pallojen säteet, ei tarvitse joka draw kierros
  // hakea aina uudelleen kaikkia palloja tämän ansiosta.
  void updateBallRadii() {
    for(int grade = 0; grade <= 6; grade++) {
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
            ballRadii[4 + codeRound][grade] = codeRoundBall.radius;
          }
        }
      } else if (projectColumn.isOpen) {
        DataBall architectureBall = currentDataBalls.projectBallForGradeAndArchitecture(grade);
        DataBall projectCodeBall = currentDataBalls.projectBallForGradeAndCode(grade);
        DataBall uxBall = currentDataBalls.projectBallForGradeAndUx(grade);
        DataBall reportBall = currentDataBalls.projectBallForGradeAndReport(grade);
        ballRadii[5][grade] = architectureBall.radius;
        ballRadii[6][grade] = projectCodeBall.radius;
        ballRadii[7][grade] = uxBall.radius;
        ballRadii[8][grade] = reportBall.radius;
      } else if(theoryColumn.isOpen){
        for (int theoryRound = 1; theoryRound <= 5; theoryRound++) {
          DataBall theoryRoundBall = currentDataBalls.theoryBallForGradeAndRound(grade, theoryRound);
          if (theoryRoundBall != null) {
            ballRadii[4 + theoryRound][grade] = theoryRoundBall.radius;
          }
        }
      }
    }

    transitionBallSizes();
  }

  private void transitionBallSizes() {
    for (int i = 0; i < 11; i++) {
      for (int j = 0; j <= 6; j++) {
        drawBallRadii[i][j] = ballRadii[i][j];
      }
    }
  }

  void draw() {
    float marginY = height - 200;
    float marginX = 120;
    float gapX = 95;
    float gapY = 85;

    for(int grade = 0; grade <= 6; grade++) {
      float y = marginY - (grade - 1) * gapY;
      fill(globalGrey);
      textFont(walkway, 30);
      text(str(grade), 20, y);
    }

    // Piirretään kaikki pallot custom-radiuksilla, täysin punaisina
    fill(255, 0, 0, 120);
    for (int column = 0; column < 11; column++) {
      // X:ää piirretään isosti jaoteltuna vain ensimmäisten viiden sarakkeen
      // osalta, muille väli on 20 pikseliä vähemmän
      float x = marginX + min(column, 5) * gapX + max(column - 5, 0) * (gapX - 20);
      for (int grade = 0; grade <= 6; grade++) {
        float y = marginY - (grade - 1) * gapY;
        float r = drawBallRadii[column][grade];
        ellipse(x, y, r * 2, r * 2);
      }
    }
  }
}
