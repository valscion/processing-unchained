PFont walkway;
Menu menu;
SelectionBox selection;
CheckBox checkBox2009;
CheckBox checkBox2010;
CheckBox checkBox2011;
CheckBox checkBox2012;
DataBall ball;
DataColumn theoryColumn;
DataColumn projectColumn;
DataColumn codeColumn;
ArrayList<ReactsToMouse> clickables;
StudentContainer studentContainer;

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
  ball = new DataBall(400, 300, 40);
  theoryColumn = new DataColumn("theory", 1);
  projectColumn = new DataColumn("project", 2);
  codeColumn = new DataColumn("code", 3);
  codeColumn.isOpen = true;

  clickables = new ArrayList<ReactsToMouse>();
  clickables.add(menu);
  clickables.add(checkBox2009);
  clickables.add(checkBox2010);
  clickables.add(checkBox2011);
  clickables.add(checkBox2012);
  clickables.add(ball);
  clickables.add(theoryColumn);
  clickables.add(projectColumn);
  clickables.add(codeColumn);

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

void drawDataBalls(int totalCourseGrade) {
  StudentContainer gradFiltered = studentContainer.filterByTotalGrade(totalCourseGrade);
  StudentContainer yearsFiltered = studentContainer.filterByYears();
  StudentContainer filtered = yearsFiltered;
  for(int g = 6; g >= 0;g--){//arvosanat ylhäältä alas 6-0
    for(int i = 0; i < 18; i++){

      /*
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
      }*/
    }
  }
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
