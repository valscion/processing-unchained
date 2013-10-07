PFont walkway;
Menu menu;
SelectionBox selection;
CheckBox box1;
CheckBox box2;
CheckBox box3;
CheckBox box4;
DataBall ball;
DataColumn[] dataColumns;
ArrayList<ReactsToMouse> clickables;
StudentContainer studentContainer;

void setup() {
  size(800, 600);
  background(255);
  walkway = loadFont("WalkwayBold-48.vlw");
  menu = new Menu(0, 0);
  selection = new SelectionBox(700, 60);
  box1 = new CheckBox(20, 20, "2009");
  box2 = new CheckBox(180, 20, "2010");
  box3 = new CheckBox(330, 20, "2011");
  box4 = new CheckBox(480, 20, "2012");
  ball = new DataBall(400, 300, 40);
  clickables = new ArrayList<ReactsToMouse>();
  dataColumns = new DataColumn[8];
  dataColumns[0] = new DataColumn("Teoria", 65);
  dataColumns[1] = new DataColumn("Projekti", 65 + 120);
  for (int i = 2; i < 8; i++) {
    DataColumn column = new DataColumn(str(i - 1), 65 + 120 + 75*i);
    dataColumns[i] = column;
  }
  for (int i = 0; i < dataColumns.length; i++) {
    clickables.add(dataColumns[i]);
  }
  clickables.add(menu);
  clickables.add(box1);
  clickables.add(box2);
  clickables.add(box3);
  clickables.add(box4);
  clickables.add(ball);

  studentContainer = new StudentContainer();
  StudentContainer year2009 = studentContainer.filterByYear(2009);
  //println(studentContainer.size());
  //println(year2009.size());
  //int kokArv = 5;
  //int kierros = 1;
  //println("henkilöitä joilla kurssista arvosana:"+5+" koodauksen kiekka:"+kierros+" arvosana:5 \n"+studentContainer.filterByTotalGrade(kokArv).filterByTypeRoundAndGrade("coding", kierros, 5).size());
  //println("yhteensä arvosanan "+kokArv+" saaneita: " +studentContainer.filterByTotalGrade(kokArv).size());

}

void draw() {
  background(255);

  drawDataColumns();
  ball.draw();

  drawMenuParts();
}

void drawDataColumns() {
  for (int i = 0; i < dataColumns.length; i++) {
    DataColumn column = dataColumns[i];
    column.draw();
  }
}

void drawMenuParts() {
  selection.draw();
  menu.draw();
  if (menu.isMenuOpen) {
    box1.draw();
    box2.draw();
    box3.draw();
    box4.draw();
  }

  drawRawData(3);
}

void drawRawData(int totalCourseGrade) {
  StudentContainer gradFiltered = studentContainer.filterByTotalGrade(totalCourseGrade);
  String printText = "";
  for(int g = 6; g >= 0;g--){//arvosanat ylhäältä alas
    printText += "Arvosana "+g+" ---";
    for(int i = 0; i < 18; i++){
      if(i < 6){
        printText += gradFiltered.filterByTypeRoundAndGrade("coding", i+1, g).size() + " | ";
      }
      else if(i < 11){
        printText += gradFiltered.filterByTypeRoundAndGrade("theories", i-5, g).size() + " | ";
      }
      else if(i < 16){
        switch (i){
          case 11 : printText += gradFiltered.filterByProjectArchitecture(g).size() + " | ";
                    break;
          case 12 : printText += gradFiltered.filterByProjectCode(g).size() + " | ";
                    break;
          case 13 : printText += gradFiltered.filterByProjectUx(g).size() + " | ";
                    break;
          case 14 : printText += gradFiltered.filterByProjectReport(g).size() + " | ";
                    break;
          case 15 : printText += gradFiltered.filterByProjectGrade(g).size() + " | ";
                    break;
          default : //ei mitään
                    break;
        }
      }
      else if(i < 17){
        printText += gradFiltered.filterByExamGrade(g).size() + " | ";
      }
      else{
        printText += gradFiltered.filterByTotalGrade(g).size() + " | ";
      }
    }
    printText += "\n";
  }
  text(printText, 100, 100);
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
