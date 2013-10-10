class DataBallContainer {
  /*
  dataBalls sisältää luodut pallot seuraavanlaisen rakenteen omaavassa taulukossa:
  kierrokset->t=theories, p=project, c=coding, e=exam, g=grade (ja esim. tt = theory total)
            indeksit_0___1___2___3___4___5___6___7___8___9___10__11__12__13__14__15__16__17__18__19
    0-arvosana   0 | t1  t2  t3  t4  t5  tt  p1  p2  p3  p4  p5  pt  c1  c2  c3  c4  c5  c6  ct  e
    1-arvosana   1 | t1  t2  t3  t4  t5  tt  p1  p2  p3  p4  p5  pt  c1  c2  c3  c4  c5  c6  ct  e
    2-arvosana   2 | t1  t2  t3  t4  t5  tt  p1  p2  p3  p4  p5  pt  c1  c2  c3  c4  c5  c6  ct  e
    3-arvosana   3 | t1  t2  t3  t4  t5  tt  p1  p2  p3  p4  p5  pt  c1  c2  c3  c4  c5  c6  ct  e
    4-arvosana   4 | t1  t2  t3  t4  t5  tt  p1  p2  p3  p4  p5  pt  c1  c2  c3  c4  c5  c6  ct  e
    5-arvosana   5 | t1  t2  t3  t4  t5  tt  p1  p2  p3  p4  p5  pt  c1  c2  c3  c4  c5  c6  ct  e
    6-arvosana   6 | t1  t2  t3  t4  t5  tt  p1  p2  p3  p4  p5  pt  c1  c2  c3  c4  c5  c6  ct  e
  */
  DataBall[][] dataBalls;

  // Indeksit taulusta löytyville asioille
  private final int THEORIES_FIRST = 0;
  private final int THEORIES_LAST = 4;
  private final int THEORIES_TOTAL = 5;
  private final int PROJECT_ARCHITECTURE = 6;
  private final int PROJECT_CODE = 7;
  private final int PROJECT_UX = 8;
  private final int PROJECT_REPORT = 9;
  private final int PROJECT_GRADE = 10;
  private final int PROJECT_TOTAL = 11;
  private final int CODES_FIRST = 12;
  private final int CODES_LAST = 17;
  private final int CODES_TOTAL = 18;
  private final int EXAM = 19;
  private final int LAST_INDEX = EXAM;

  // Yksittäisen datapallon maksimisäde
  private final float MAX_R = 35;

  DataBallContainer(StudentContainer studentContainer) {
    dataBalls = new DataBall[LAST_INDEX + 1][7];
    for (int grade = 0; grade <= 6; grade++) {
      fillTheories(studentContainer, grade);
      fillProject(studentContainer, grade);
      fillCodes(studentContainer, grade);
      fillExam(studentContainer, grade);
    }
  }

  private void fillTheories(StudentContainer studentContainer, int grade) {
    int relative_max = studentContainer.size();
    int rounds_count = THEORIES_LAST - THEORIES_FIRST;
    int total_n = 0;
    for (int roundNumber = 0; roundNumber <= rounds_count; roundNumber++) {
      int index = roundNumber + THEORIES_FIRST;
      int n = studentContainer.filterByTypeRoundAndGrade("theories", roundNumber+1, grade).size();
      total_n += n;
      DataBall dataBall = createDataBall(n, relative_max, "theory-" + grade);
      storeDataBallToGradeAndIndex(dataBall, grade, index);
    }
    DataBall dataBall = createDataBall(total_n, relative_max, "theory-total");
    storeDataBallToGradeAndIndex(dataBall, grade, THEORIES_TOTAL);
  }

  private void fillProject(StudentContainer studentContainer, int grade) {
    int relative_max = studentContainer.size();
    int arch_n = studentContainer.filterByProjectArchitecture(grade).size();
    int code_n = studentContainer.filterByProjectCode(grade).size();
    int ux_n = studentContainer.filterByProjectUx(grade).size();
    int report_n = studentContainer.filterByProjectReport(grade).size();
    int total_n = studentContainer.filterByProjectGrade(grade).size();
    DataBall archBall = createDataBall(arch_n, relative_max, "proj-arch");
    DataBall codeBall = createDataBall(code_n, relative_max, "proj-code");
    DataBall uxBall = createDataBall(ux_n, relative_max, "proj-ux");
    DataBall reportBall = createDataBall(report_n, relative_max, "proj-report");
    DataBall totalBall = createDataBall(total_n, relative_max, "proj-total");
    storeDataBallToGradeAndIndex(archBall, grade, PROJECT_ARCHITECTURE);
    storeDataBallToGradeAndIndex(codeBall, grade, PROJECT_CODE);
    storeDataBallToGradeAndIndex(uxBall, grade, PROJECT_UX);
    storeDataBallToGradeAndIndex(reportBall, grade, PROJECT_REPORT);
    storeDataBallToGradeAndIndex(totalBall, grade, PROJECT_TOTAL);
  }

  private void fillCodes(StudentContainer studentContainer, int grade) {
    int relative_max = studentContainer.size();
    int rounds_count = CODES_LAST - CODES_FIRST;
    int total_n = 0;
    for (int roundNumber = 0; roundNumber <= rounds_count; roundNumber++) {
      int index = roundNumber + CODES_FIRST;
      int n = studentContainer.filterByTypeRoundAndGrade("coding", roundNumber+1, grade).size();
      total_n += n;
      DataBall dataBall = createDataBall(n, relative_max, "code-" + grade);
      storeDataBallToGradeAndIndex(dataBall, grade, index);
    }
    DataBall dataBall = createDataBall(total_n, relative_max, "code-total");
    storeDataBallToGradeAndIndex(dataBall, grade, CODES_TOTAL);
  }

  private void fillExam(StudentContainer studentContainer, int grade) {
    int relative_max = studentContainer.size();
    int n = studentContainer.filterByExamGrade(grade).size();
    DataBall dataBall = createDataBall(n, relative_max, "exam");
    storeDataBallToGradeAndIndex(dataBall, grade, EXAM);
  }


  private DataBall createDataBall(int n, int relative_max, String infoTxt) {
    float r = map(giveRadiusFromArea(n), 0, giveRadiusFromArea(relative_max), 0, MAX_R);
    DataBall dataBall = new DataBall(r, infoTxt);
    return dataBall;
  }

  private float giveRadiusFromArea(float area){
    //pi*r^2 = ympyrän pinta-ala
    //=> r=sqrt(area/PI)
    float inner = area/PI;
    float r = sqrt(inner);
    return r;
  }

  private void storeDataBallToGradeAndIndex(DataBall dataBall, int grade, int index) {
    dataBalls[index][grade] = dataBall;
  }

  private DataBall getDataBall(int grade, int index) {
    if (grade < 0 || grade > 6) {
      throw new IndexOutOfBoundsException("grade out of bounds (was " + grade + ")");
    }
    return dataBalls[index][grade];
  }

  // ---------------------------------------------------------------------------
  // Teoria
  // ---------------------------------------------------------------------------
  DataBall theoryBallForGradeAndRound(int grade, int thRound) {
    int index = THEORIES_FIRST + (thRound - 1);
    if (index < THEORIES_FIRST || index > THEORIES_LAST) {
      throw new IndexOutOfBoundsException("round out of bounds (was " + thRound + ")");
    }
    return getDataBall(grade, index);
  }

  DataBall theoryBallForGrade(int grade) {
    return getDataBall(grade, THEORIES_TOTAL);
  }

  // ---------------------------------------------------------------------------
  // Projekti
  // ---------------------------------------------------------------------------
  DataBall projectBallForGradeAndArchitecture(int grade) {
    return getDataBall(grade, PROJECT_ARCHITECTURE);
  }

  DataBall projectBallForGradeAndCode(int grade) {
    return getDataBall(grade, PROJECT_CODE);
  }

  DataBall projectBallForGradeAndUx(int grade) {
    return getDataBall(grade, PROJECT_UX);
  }

  DataBall projectBallForGradeAndReport(int grade) {
    return getDataBall(grade, PROJECT_REPORT);
  }

  DataBall projectBallForGrade(int grade) {
    return getDataBall(grade, PROJECT_TOTAL);
  }

  // ---------------------------------------------------------------------------
  // Koodi
  // ---------------------------------------------------------------------------
  DataBall codeBallForGradeAndRound(int grade, int codeRound) {
    int index = CODES_FIRST + (codeRound - 1);
    if (index < CODES_FIRST || index > CODES_LAST) {
      throw new IndexOutOfBoundsException("round out of bounds (was " + codeRound + ")");
    }
    return getDataBall(grade, index);
  }

  DataBall codeBallForGrade(int grade) {
    return getDataBall(grade, CODES_TOTAL);
  }


  // ---------------------------------------------------------------------------
  // Tentti
  // ---------------------------------------------------------------------------
  DataBall examBallForGrade(int grade) {
    return getDataBall(grade, EXAM);
  }

}
