PFont walkway;
Menu menu;
SelectionBox selection;
CheckBox checkBox2009;
CheckBox checkBox2010;
CheckBox checkBox2011;
CheckBox checkBox2012;
DataColumn theoryColumn;
DataColumn projectColumn;
DataColumn codeColumn;
ArrayList<ReactsToMouse> clickables;
StudentContainer studentContainer;
DataBallContainer dataBallContainer;
NumberBox[] boxes = new NumberBox[6];
int selectedGrade;

void setup() {
  size(800, 600);
  background(255);
  walkway = loadFont("WalkwayBold-48.vlw");
  menu = new Menu(0, 0);
  selection = new SelectionBox(700, 60);
  checkBox2009 = new CheckBox(20, 20, "2009");
  checkBox2010 = new CheckBox(180, 20, "2010");
  checkBox2011 = new CheckBox(330, 20, "2011");
  checkBox2012 = new CheckBox(480, 20, "2012");
  checkBox2012.isChecked = true;
  theoryColumn = new DataColumn("theory", 1);
  projectColumn = new DataColumn("project", 2);
  codeColumn = new DataColumn("code", 3);
  codeColumn.isOpen = true;
  studentContainer = new StudentContainer();

  clickables = new ArrayList<ReactsToMouse>();
  for (int i = 1; i <= 5; i++) {
    boxes[i] = new NumberBox(700, 60+(i*selection.TEXT_HEIGHT), str(i));
    clickables.add(boxes[i]);
   }

  clickables.add(menu);
  clickables.add(checkBox2009);
  clickables.add(checkBox2010);
  clickables.add(checkBox2011);
  clickables.add(checkBox2012);
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
  //ball.draw();

  drawDataBalls();
  //drawRawData();
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
    checkBox2009.draw();
    checkBox2010.draw();
    checkBox2011.draw();
    checkBox2012.draw();
  }
}

void generateDataBalls(int totalCourseGrade) {
  StudentContainer gradFiltered = studentContainer.filterByTotalGrade(totalCourseGrade);
  dataBallContainer = new DataBallContainer(gradFiltered);
}

void drawDataBalls() {
  //käyttää hyväksi dataTablen sisältöä
  float marginY = 480;
  float marginX = 120;
  float gapX = 100;
  float gapY = 70;
  stroke(0);
  strokeWeight(1);
  String kiekkaTieto = "";
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

    fill(100);
    textSize(12);
    String selite = "Arvosana " + grade;
    text(selite, 20, y);
    line(0, y, width, y);
  }
}

boolean isYearSelected(int year) {
  IntList selectedYears = new IntList();
  if (year == 2009 && checkBox2009.isChecked) return true;
  if (year == 2010 && checkBox2010.isChecked) return true;
  if (year == 2011 && checkBox2011.isChecked) return true;
  if (year == 2012 && checkBox2012.isChecked) return true;
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
