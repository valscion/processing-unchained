PFont walkway;
Menu menu;
SelectionBox selection;
DataColumn theoryColumn;
DataColumn projectColumn;
DataColumn codeColumn;
ArrayList<ReactsToMouse> clickables;
StudentContainer studentContainer;
DataBallContainer dataBallContainer;
NumberBox[] boxes = new NumberBox[6];
CheckBox[] checkBoxes = new CheckBox[10];
int selectedGrade;

void setup() {
  size(1024, 768);
  background(255);
  walkway = loadFont("WalkwayBold-48.vlw");
  menu = new Menu(0, 0);
  selection = new SelectionBox(700, 60);
  clickables = new ArrayList<ReactsToMouse>();
  for(int i=0; i < 10; i++) {
    if (i < 5) {
      checkBoxes[i] = new CheckBox(20+i*150, 20, str(2003+i));
    } else {
      checkBoxes[i] = new CheckBox(20+(i-5)*150, 70, str(2003+i));
    }
    clickables.add(checkBoxes[i]);
  }
  checkBoxes[9].isChecked = true;
  theoryColumn = new DataColumn("theory", 1);
  projectColumn = new DataColumn("project", 2);
  codeColumn = new DataColumn("code", 3);
  codeColumn.isOpen = true;
  studentContainer = new StudentContainer();

  for (int i = 1; i <= 5; i++) {
    boxes[i] = new NumberBox(700, 60+((i-1)*selection.TEXT_HEIGHT), str(i));
    clickables.add(boxes[i]);
   }

  clickables.add(menu);
  clickables.add(theoryColumn);
  clickables.add(projectColumn);
  clickables.add(codeColumn);
  clickables.add(selection);

  selectedGrade = 4;
  generateDataBalls(selectedGrade);
}

void draw() {
  updateDataRelatedToMouseY();
  background(255);

  drawDataColumns();
  drawDataBalls();
  drawMenuParts();
}

void updateDataRelatedToMouseY(){
  int alkukohta = 480;
  int delta = 45;
  int newGrade = 0;
  if(mouseY > alkukohta-delta*1.5){
    newGrade = 1;
  }
  else if(mouseY > alkukohta-delta*2.5){
    newGrade = 2;
  }
  else if(mouseY > alkukohta-delta*3.5){
    newGrade = 3;
  }
  else if(mouseY > alkukohta-delta*4.5){
    newGrade = 4;
  }
  else if(mouseY > alkukohta-delta*5.5){
    newGrade = 5;
  }
  if (newGrade > 0 && newGrade != selectedGrade) {
    selectedGrade = newGrade;
    generateDataBalls(selectedGrade);
  }
}

void drawDataColumns() {
  theoryColumn.draw();
  projectColumn.draw();
  codeColumn.draw();
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
  selection.updateGradeChanged(totalCourseGrade);
}

void drawDataBalls() {
  float marginY = height - 150;
  float marginX = 120;
  float gapX = 100;
  float gapY = 100;
  stroke(0);
  strokeWeight(1);
  for(int grade = 1; grade <= 6; grade++) {
    float y = marginY - (grade - 1) * gapY;
    // Pallot piirretään osittain läpinäkyviksi
    fill(255, 0, 0, 100);
    DataBall theoryBall = dataBallContainer.theoryBallForGrade(grade);
    DataBall projectBall = dataBallContainer.projectBallForGrade(grade);
    DataBall codeBall = dataBallContainer.codeBallForGrade(grade);
    DataBall examBall = dataBallContainer.examBallForGrade(grade);

    theoryBall.draw(marginX, y);
    projectBall.draw(marginX + gapX, y);
    codeBall.draw(marginX + gapX * 2, y);
    examBall.draw(marginX + gapX * 3, y);

    for (int codeRound = 1; codeRound <= 6; codeRound++) {
      DataBall codeRoundBall = dataBallContainer.codeBallForGradeAndRound(grade, codeRound);
      if (codeRoundBall != null) {
        float drawX = marginX + gapX * 4;
        drawX += (codeRound - 1) * (gapX - 20);
        codeRoundBall.draw(drawX, y);
      }
    }

    fill(196);
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
