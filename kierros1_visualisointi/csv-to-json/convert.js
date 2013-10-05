var csv = require('csv');
var fs = require('fs');

var jsonFile = fs.openSync(__dirname+'/../data/data.json', 'w');

var output = {};
var lastYear = null;

csv()
.from.path(__dirname+'/Studio1_dataa2012-2009.csv', { delimiter: ';' })
.on('record', function(row,index){
  var recordName = row.shift().trim()
  if (recordName.length === 4) {
    lastYear = recordName;
    output[lastYear] = [];
  }
  else if (recordName.length > 4) {
    var coding = parseCodings(row);
    var theories = parseTheories(row);
    var project = parseProject(row);
    var exam = parseExam(row);
    var grade = parseGrade(row);
    if (grade !== null) {
      var student = {
        studentNumber: recordName,
        coding: coding,
        theories: theories,
        project: project,
        exam: exam,
        grade: grade
      }
      output[lastYear].push(student);
    }
  }
})
.on('end', function(count){
  console.log('Number of lines: '+count);
  fs.writeSync(jsonFile, JSON.stringify(output, null, "  "))
})
.on('error', function(error){
  console.log(error.message);
});


function parseCodings(row) {
  var codeGrades = row.slice(0, 12);
  return mapGrades(codeGrades);
}

function parseTheories(row) {
  var theoryGrades = row.slice(12, 22);
  return mapGrades(theoryGrades);
}

function mapGrades(grades) {
  var results = [], singleGrade = {};
  for (var index = 0; index < grades.length; index++) {
    var value = grades[index];
    if (index % 2 == 0) {
      var grade = parseFloat(value);
      singleGrade.grade = grade;
      singleGrade.dates_late = 0;
      singleGrade.has_penalty = false;
    }
    else {
      if (value.trim().length) {
        var numberValue = parseInt(value, 10);
        if (!isNaN(numberValue)) {
          singleGrade.dates_late = numberValue;
        }
        else {
          singleGrade.has_penalty = true;
        }
      }
      results.push(singleGrade);
      singleGrade = {};
    }
  }
  return results;
}

function parseProject(row) {
  var projectGrades = row.slice(22, 27);

  var data = {
    architecture: parseFloat(projectGrades[0]),
    code: parseFloat(projectGrades[1]),
    ux: parseFloat(projectGrades[2]),
    report: parseFloat(projectGrades[3]),
    grade: parseFloat(projectGrades[4])
  };

  return data;
}

function parseExam(row) {
  var examData = row.slice(27, 29).map(function (value) {
    return parseFloat(value) || 0;
  });
  var result = {grade: null, has_redone: false};
  if (examData[1] > examData[0]) {
    result.has_redone = true;
    result.grade = examData[1];
  }
  else {
    result.grade = examData[0];
  }
  return result;
}

function parseGrade(row) {
  var grade = parseFloat(row[29]);
  if (isNaN(grade)) {
    return null;
  }
  else {
    return grade;
  }
}
