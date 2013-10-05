class Student{

  class Round{
    final float grade;
    final int dates_late;
    final boolean has_penalty;
    Round(JSONObject oneRound){
      grade = oneRound.getFloat("grade");
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
      architecture = proj.getFloat("architecture");
      code = proj.getFloat("code");
      ux = proj.getFloat("ux");
      report = proj.getFloat("report");
      grade = proj.getFloat("grade");
    }
  }

  class Exam{
    final float grade;
    final boolean has_redone;
    Exam(JSONObject exam){
      grade = exam.getFloat("grade");
      has_redone = exam.getBoolean("has_redone");
    }
  }

  final String studentNumber;
  final float grade;
  final Round[] coding;
  final Round[] theories;
  final Project project;
  final Exam exam;

  Student(JSONObject student){
    studentNumber = student.getString("studentnumber");
    grade = student.getFloat("grade");
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
