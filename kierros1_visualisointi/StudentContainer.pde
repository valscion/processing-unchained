import java.util.LinkedList;
import java.util.Iterator;
class StudentContainer {

LinkedList<Student> students;

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
    filterByTotalGrade(4);
  }

  LinkedList<Student> filterByTotalGrade(int totalGrade){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while(iter.hasNext()){
      Student stud = iter.next();
      if(round(stud.grade) == totalGrade){
        newStudents.add(stud);
        //println(" op nro "+ stud.studentNumber);
      }
    }
    return newStudents;
  }

  int size(){
    return students.size();
  }
}
