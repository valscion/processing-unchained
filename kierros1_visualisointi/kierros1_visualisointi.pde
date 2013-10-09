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
DataBall[][] dataBalls;
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

  dataBalls = new DataBall[18][7];
/*
dataBalls sisältää luodut pallot seuraavanlaisen rakenteen omaavassa taulukossa:
                  kierrokset->t=theories, p=project, c=coding, e=exam, g=grade
          indeksit_0___1___2___3___4___5___6___7___8___9___10__11__12__13__14__15__16__17
  6-arvosana   0 | t1  t2  t3  t4  t5  p1  p2  p3  p4  p5  c1  c2  c3  c4  c5  c6  e   g
  5-arvosana   1 | t1  t2  t3  t4  t5  p1  p2  p3  p4  p5  c1  c2  c3  c4  c5  c6  e   g
  4-arvosana   2 | t1  t2  t3  t4  t5  p1  p2  p3  p4  p5  c1  c2  c3  c4  c5  c6  e   g
  3-arvosana   3 | t1  t2  t3  t4  t5  p1  p2  p3  p4  p5  c1  c2  c3  c4  c5  c6  e   g
  2-arvosana   4 | t1  t2  t3  t4  t5  p1  p2  p3  p4  p5  c1  c2  c3  c4  c5  c6  e   g
  1-arvosana   5 | t1  t2  t3  t4  t5  p1  p2  p3  p4  p5  c1  c2  c3  c4  c5  c6  e   g
  0-arvosana   6 | t1  t2  t3  t4  t5  p1  p2  p3  p4  p5  c1  c2  c3  c4  c5  c6  e   g
*/
  studentContainer = new StudentContainer();
  StudentContainer year2009 = studentContainer.filterByYear(2009);
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

float giveRadiusFromArea(float area){
  //pi*r^2 = ympyrän pinta-ala
  //=> r=sqrt(area/PI)
  float inner = area/PI;
  float r = sqrt(inner);
  return r;
}

void generateDataBalls(int totalCourseGrade) {
  StudentContainer gradFiltered = studentContainer.filterByTotalGrade(totalCourseGrade);
  //StudentContainer filtered = gradFiltered;
  int m = gradFiltered.size();

  StudentContainer yearsFiltered = gradFiltered.filterBySelectedYears();
  StudentContainer filtered = yearsFiltered;
  //int m = filtered.size();

  int n = 0;

  // Datapallojen luomisen apuvälineet
  float marginY = 480;
  float marginX = 30;
  float gapX = 45;
  float gapY = 45;
  String kiekkaTieto = "";
  float maxR = 35;
  //println("m:n koko on"+m);

  for(int g = 6; g >= 0;g--){//arvosanat ylhäältä alas
    float y = marginY - g * gapY;
    for(int i = 0; i < 18; i++){//kierrokset
      float x = i*gapX + marginX;
      float r = 0;

      if(i < 6){
        n = gradFiltered.filterByTypeRoundAndGrade("coding", i+1, g).size();
        r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(m), 0, maxR);
      }
      else if(i < 11){
        n = gradFiltered.filterByTypeRoundAndGrade("theories", i-5, g).size();
        r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(m), 0, maxR);
      }
      else if(i < 16){
        switch (i){
          case 11 : {n = gradFiltered.filterByProjectArchitecture(g).size();
                    r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(m), 0, maxR);
                    break;}
          case 12 : {n = gradFiltered.filterByProjectCode(g).size();
                    r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(m), 0, maxR);
                    break;}
          case 13 : {n = gradFiltered.filterByProjectUx(g).size();
                    r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(m), 0, maxR);
                    break;}
          case 14 : {n = gradFiltered.filterByProjectReport(g).size();
                    r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(m), 0, maxR);
                    break;}
          case 15 : {n = gradFiltered.filterByProjectGrade(g).size();
                    r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(m), 0, maxR);
                    break;}
          default : //ei mitään
                    break;
        }
      }
      else if(i < 17){
        n = gradFiltered.filterByExamGrade(g).size();
        r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(m), 0, maxR);
      }
      else{
        n = gradFiltered.filterByTotalGrade(g).size();
        r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(m), 0, maxR);
      }

      DataBall datBall = new DataBall(x, y, r);
      dataBalls[i][g] = datBall;
    }
  }
}

void drawDataBalls() {
  //käyttää hyväksi dataTablen sisältöä
  float marginY = 480;
  float marginX = 30;
  float gapX = 45;
  float gapY = 45;
  stroke(0);
  strokeWeight(1);
  String kiekkaTieto = "";
  for(int g = 6; g >= 0;g--){//arvosanat ylhäältä alas
    float y = -g*gapY + marginY;
    //välivaiheessa läpinäkyvyyttä
    fill(255, 0, 0, 100);
    for(int i = 0; i < 18; i++){//kierrokset
      float x = i*gapX + marginX;
      DataBall datBall = dataBalls[i][g];
      datBall.draw();

      //tästä alaspäin on vain tarkentavia tietoja joita piirretään tässä vaiheessa avuksi
      switch (i){
        case 0 : {kiekkaTieto = "teoria"; break;}
        case 5 : {kiekkaTieto = "projekti"; break;}
        case 10 : {kiekkaTieto = "koodi"; break;}
        case 16 : {kiekkaTieto = "tentti"; break;}
        case 17 : {kiekkaTieto = "kurssi"; break;}
      }
      String kiekkaNro = str(i+1);
      //fill(100, 100);
      textSize(12);
      text(kiekkaTieto + kiekkaNro, x, marginY);
      //line(x, y, x, marginY);
    }
    fill(100);
    textSize(12);
    String selite = "Arvosana " +g;
    text(selite, marginX/2, y);
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
