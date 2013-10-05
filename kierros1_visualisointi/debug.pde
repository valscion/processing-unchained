// Globals for debugging
// int debugX;
JSONArray students2009;
Student testStud;

// Setup debug, called during setup()
void setupDebug() {
  setupData();
}

// Draw debug data, called last during draw()
void drawDebug() {
  drawTestData();
}

void setupData() {
  json = loadJSONObject("testData.json");
  students2009 = json.getJSONArray("2009");
  testStud = new Student(students2009.getJSONObject(0));

}

void drawTestData(){
  //kirjoittelee asioita ruudulle
  text(testStud.studentNumber, 290, 200);
  text(testStud.grade, 400, 250);
  text(testStud.project.code, 300, 300);
  text(testStud.project.ux, 300, 310);
  text(testStud.project.grade, 300, 320);
  int ysij = 350;
  if(testStud.exam.has_redone){
    text("tentti uusittu", 300, ysij);
  }
  else{
    text("tentti läpi ekalla", 300, ysij);
  }
  //koodauskierrokset
  for(int i = 0; i <= 5; i++){
    ysij = ysij+20;
    text("koodaus"+i+" on "+testStud.coding[i].grade, 300, ysij);
  }
  //teoriakierrokset
  for(int i = 0; i <= 4; i++){
    ysij = ysij+20;
    text("teoria"+i+" on "+testStud.theories[i].grade, 300, ysij);
  }
}
