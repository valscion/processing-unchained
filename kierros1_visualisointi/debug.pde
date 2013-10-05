// Globals for debugging
// int debugX;
JSONArray students2009;

// Setup debug, called during setup()
void setupDebug() {
  setupData();
}

// Draw debug data, called last during draw()
void drawDebug() {
  drawTestData();
}

void setupData() {
  //json = loadJSONObject("testData.json");
  //students2009 = new ArrayList<Student>();
  //students2009 = json.getJSONArray("2009");
  //students2009 = year2009.getJSONArray();
}

void drawTestData(){
  String studNum = students2009.getJSONObject(0).getString("studentnumber");
  text(studNum, 200, 200);
  float codeGrade1 = students2009.getJSONObject(0).getJSONArray("coding").getJSONObject(0).getFloat("grade");
  text(codeGrade1, 200, 250);
}
