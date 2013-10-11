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
DataBallVisualizer visualizer;
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

  visualizer = new DataBallVisualizer();
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
  visualizer.changeDataBalls(new DataBallContainer(yearsFiltered));
}

void drawDataBalls() {
  visualizer.draw();
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
  boolean someoneReacted = false;
  for (int i = 0; i < clickables.size(); i++) {
    ReactsToMouse clickable = clickables.get(i);
    if (clickable.areCoordinatesInside(mouseX, mouseY)) {
      clickable.mouseClicked();
      someoneReacted = true;
    }
  }

  // Jos kuka tahansa vastasi hiiren klikkaukseen, oletetaan että piirrettävien
  // pallojen säteet pitää päivittää.
  if (someoneReacted) {
    visualizer.updateBallRadii();
  }
}
