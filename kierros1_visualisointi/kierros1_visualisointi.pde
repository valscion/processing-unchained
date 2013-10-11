PFont walkway;
Menu menu;
SelectionBox selection;
DataColumn theoryColumn;
DataColumn projectColumn;
DataColumn codeColumn;
DataColumn examColumn;
DataColumn portfolioColumn;
ArrayList<ReactsToMouse> clickables;
StudentContainer studentContainer;
DataBallContainer dataBallContainer;
NumberBox[] boxes = new NumberBox[6];
CheckBox[] checkBoxes = new CheckBox[10];
int selectedGrade;
int globalGrey = 196;
int globalLightGrey = 220;

void setup() {
  size(1024, 768);
  background(255);
  selectedGrade = 5;
  walkway = loadFont("WalkwayBold-48.vlw");
  menu = new Menu(0, 0);
  selection = new SelectionBox(930, 60);
  selection.currentNumber = str(selectedGrade);
  clickables = new ArrayList<ReactsToMouse>();
  for(int i=0; i < 10; i++) {
    if (i < 5) {
      checkBoxes[i] = new CheckBox(170+i*150, 40, str(2003+i));
    } else {
      checkBoxes[i] = new CheckBox(170+(i-5)*150, 90, str(2003+i));
    }
    clickables.add(checkBoxes[i]);
  }
  checkBoxes[9].isChecked = true;
  theoryColumn = new DataColumn("theory", 1);
  projectColumn = new DataColumn("project", 2);
  codeColumn = new DataColumn("code", 3);
  examColumn = new DataColumn("exam", 4);
  portfolioColumn = new DataColumn("portfolio", 5);
  studentContainer = new StudentContainer();

  for (int i = 1; i <= 5; i++) {
    boxes[i] = new NumberBox(930, 60+((i-1)*selection.TEXT_HEIGHT), str(i));
    clickables.add(boxes[i]);
   }

  clickables.add(menu);
  clickables.add(theoryColumn);
  clickables.add(projectColumn);
  clickables.add(codeColumn);
  clickables.add(selection);

  generateDataBalls(selectedGrade);
}

void draw() {
  background(255);

  drawDataColumns();
  drawDataBalls();
  drawMenuParts();
}

void drawDataColumns() {
  theoryColumn.draw();
  projectColumn.draw();
  codeColumn.draw();
  examColumn.draw();
  portfolioColumn.draw();
}

void drawMenuParts() {
  selection.draw();
  menu.draw();
  if (menu.isMenuOpen) {
    for(int i=0; i < 10; i++) {
      checkBoxes[i].draw();
    }
  }
}

void generateDataBalls(int totalCourseGrade) {
  StudentContainer gradFiltered = studentContainer.filterByTotalGrade(totalCourseGrade);
  StudentContainer yearsFiltered = gradFiltered.filterBySelectedYears();
  dataBallContainer = new DataBallContainer(yearsFiltered);
}

void drawDataBalls() {
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

    DataBall theoryBall = dataBallContainer.theoryBallForGrade(grade);
    DataBall projectBall = dataBallContainer.projectBallForGrade(grade);
    DataBall codeBall = dataBallContainer.codeBallForGrade(grade);
    DataBall examBall = dataBallContainer.examBallForGrade(grade);
    DataBall portfolioBall = dataBallContainer.portfolioBallForGrade(grade);

    theoryBall.draw(marginX, y);
    projectBall.draw(marginX + gapX, y);
    codeBall.draw(marginX + gapX * 2, y);
    examBall.draw(marginX + gapX * 3, y);
    portfolioBall.draw(marginX + gapX * 4, y);

    if (codeColumn.isOpen) {
      for (int codeRound = 1; codeRound <= 6; codeRound++) {
        DataBall codeRoundBall = dataBallContainer.codeBallForGradeAndRound(grade, codeRound);
        if (codeRoundBall != null) {
          float drawX = marginX + gapX * 5;
          drawX += (codeRound - 1) * (gapX - 20);
          codeRoundBall.draw(drawX, y);
        }
      }
    } else if (projectColumn.isOpen) {
      DataBall architectureBall = dataBallContainer.projectBallForGradeAndArchitecture(grade);
      float drawX = marginX + gapX * 5;
      architectureBall.draw(drawX, y);
      DataBall projectCodeBall = dataBallContainer.projectBallForGradeAndCode(grade);
      drawX += gapX -20;
      projectCodeBall.draw(drawX, y);
      DataBall uxBall = dataBallContainer.projectBallForGradeAndUx(grade);
      drawX += (gapX-20);
      uxBall.draw(drawX, y);
      DataBall reportBall = dataBallContainer.projectBallForGradeAndReport(grade);
      drawX += (gapX-20);
      reportBall.draw(drawX, y);

    } else if(theoryColumn.isOpen){
      for (int theoryRound = 1; theoryRound <= 5; theoryRound++) {
        DataBall theoryRoundBall = dataBallContainer.theoryBallForGradeAndRound(grade, theoryRound);
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

boolean isYearSelected(int year) {
  IntList selectedYears = new IntList();
  for(int i = 0; i < checkBoxes.length; i++){
    int loopYear = 2003+i;
    if (year == loopYear && checkBoxes[i].isChecked) return true;
  }
  return false;
}

void onCheckboxClicked() {
  generateDataBalls(selectedGrade);
}

void mouseMoved() {
  for (int i = 0; i < clickables.size(); i++) {
    ReactsToMouse clickable = clickables.get(i);
    if (clickable.areCoordinatesInside(mouseX, mouseY)) {
      clickable.isMouseOver = true;
    } else {
      clickable.isMouseOver = false;
    }
  }
}

void mouseClicked() {
  for (int i = 0; i < clickables.size(); i++) {
    ReactsToMouse clickable = clickables.get(i);
    if (clickable.areCoordinatesInside(mouseX, mouseY)) {
      clickable.mouseClicked();
    }
  }
}
