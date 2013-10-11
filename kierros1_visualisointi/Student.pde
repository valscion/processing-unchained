class Student{

  class Round{
    final int grade;
    final int dates_late;
    final boolean has_penalty;
    Round(JSONObject oneRound){
      int grade1;
      try{
        grade1 = round(oneRound.getFloat("grade"));
      }
      catch(RuntimeException e){
        grade1 = -1000;
      }
      grade = grade1;
      dates_late = oneRound.getInt("dates_late");
      has_penalty = oneRound.getBoolean("has_penalty");
    }
  }

  class Project{
    final float architecture;
    final float code;
    final float ux;
    final float report;
    final float grade;
    Project(JSONObject proj){
      float architecture1;
      try{
        architecture1 = proj.getFloat("architecture");
      }
      catch(RuntimeException e){
        architecture1 = -1000;
      }
      architecture = architecture1;

      float code1;
      try{
        code1 = proj.getFloat("code");
      }
      catch(RuntimeException e){
        code1 = -1000;
      }
      code = code1;

      float ux1;
      try{
        ux1 = proj.getFloat("ux");
      }
      catch(RuntimeException e){
        ux1 = -1000;
      }
      ux = ux1;

      float report1;
      try{
        report1 = proj.getFloat("report");
      }
      catch(RuntimeException e){
        report1 = -1000;
      }
      report = report1;

      float grade1;
      try{
        grade1 = proj.getFloat("grade");
      }
      catch(RuntimeException e){
        grade1 = -1000;
      }
      grade = grade1;
    }
  }

  class Exam{
    final float grade;
    final boolean has_redone;
    Exam(JSONObject exam){
      float grade1;
      try{
        grade1 = exam.getFloat("grade");
      }
      catch(RuntimeException e){
        grade1 = -1000;
      }

      grade = grade1;
      has_redone = exam.getBoolean("has_redone");
    }
  }

  final String studentNumber;
  final float grade;
  final int year;
  final Round[] coding;
  final Round[] theories;
  final Project project;
  final Exam exam;
  final float portfolio;  

  Student(JSONObject student){
    studentNumber = student.getString("studentNumber");
    grade = student.getFloat("grade");
    year = student.getInt("year");

    float gradeTemp;
    try{
      gradeTemp = student.getFloat("portfolio");
    }
    catch(RuntimeException e){
      gradeTemp = -1000;
    }
    portfolio = gradeTemp;

    project = new Project(student.getJSONObject("project"));
    exam = new Exam(student.getJSONObject("exam"));
    coding = new Round[6];
    theories = new Round[5];

    for(int i = 0; i < student.getJSONArray("coding").size(); i++){
      JSONObject thisCodingRound = student.getJSONArray("coding").getJSONObject(i);
      Round thisRound = new Round(thisCodingRound);
      coding[i] = thisRound;
    }

    for(int i = 0; i < student.getJSONArray("theories").size(); i++){
      JSONObject thisTheoryRound = student.getJSONArray("theories").getJSONObject(i);
      Round thisRound = new Round(thisTheoryRound);
      theories[i] = thisRound;
    }
  }
}
