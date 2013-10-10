import java.util.LinkedList;
import java.util.Iterator;

class StudentContainer {
  private LinkedList<Student> students;

  StudentContainer() {
    JSONObject json = loadJSONObject("data.json");
    students = new LinkedList<Student>();
    //lataa students-listaan vuodesta y, vuoteen 2012 kaikki oppilaat
    for(int y = 2003; y <= 2012; y++){
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

  private StudentContainer(LinkedList<Student> givenList){
    students = givenList;
  }

  StudentContainer filterByTotalGrade(int totalGrade){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (round(stud.grade) == totalGrade) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }

  StudentContainer filterByYear(int year){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (stud.year == year) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }

  StudentContainer filterBySelectedYears(){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (isYearSelected(stud.year)) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }

  //type String on "coding" tai mitä tahansa muuta -> theories, wantedRound on kokonaisluku 1-6 jos 6 ja theories niin kusee, int wantedGrade on haluttu arvosana millä rajataan
  StudentContainer filterByTypeRoundAndGrade(String type, int wantedRound, int wantedGrade) {
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    if(type == "coding"){
      while(iter.hasNext()){
        Student stud = iter.next();
        if(wantedGrade == stud.coding[wantedRound - 1].grade) {
          newStudents.add(stud);
        }
      }
    }
    else {
      while(iter.hasNext()){
        Student stud = iter.next();
        if(wantedGrade == stud.theories[wantedRound - 1].grade) {
          newStudents.add(stud);
        }
      }
    }
    return new StudentContainer(newStudents);
  }

  StudentContainer filterByProjectArchitecture(int partGrade){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (round(stud.project.architecture) == partGrade) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }

  StudentContainer filterByProjectCode(int partGrade){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (round(stud.project.code) == partGrade) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }

    StudentContainer filterByProjectUx(int partGrade){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (round(stud.project.ux) == partGrade) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }

  StudentContainer filterByProjectReport(int partGrade){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (round(stud.project.report) == partGrade) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }

  StudentContainer filterByProjectGrade(int totalGrade){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (round(stud.project.grade) == totalGrade) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }

  StudentContainer filterByExamGrade(int examGrade){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (round(stud.exam.grade) == examGrade) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }
/*pohja muille filttereille
  StudentContainer filterBy tyh(int partGrade){
    LinkedList<Student> newStudents = new LinkedList<Student>();
    Iterator<Student> iter = students.iterator();
    while (iter.hasNext()) {
      Student stud = iter.next();
      if (round(stud. tyh) == partGrade) {
        newStudents.add(stud);
      }
    }
    return new StudentContainer(newStudents);
  }
*/
  int size() {
    return students.size();
  }
}
