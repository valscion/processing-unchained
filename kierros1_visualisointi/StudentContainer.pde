import java.util.LinkedList;
LinkedList<Student> students;

class StudentContainer {

  StudentContainer(){
    JSONObject json = loadJSONObject("data.json");
    students = new LinkedList<Student>();
    //lataa students-listaan vuodesta y, vuoteen 2012 kaikki oppilaat
    for(int y = 2009; y <= 2012; y++){
      String yearString = str(y);
      JSONArray studentsYearX = json.getJSONArray(yearString);
      for(int i = 0; i < studentsYearX.size(); i++){
        Student stud = new Student(studentsYearX.getJSONObject(i));
        students.add(stud);
        //printti tulostaa kaikki listassa olevat tässä vaiheessa
        //println("lisättiin uusi vuoden "+y+" oppilas (indeksi " +i +") op nro "+ stud.studentNumber);
      }
    }
  }

  int size(){
    return students.size();
  }
}
