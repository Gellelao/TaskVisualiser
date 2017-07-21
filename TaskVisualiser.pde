String fileName = "input.txt";

// Maps courses to a list of tasks of that course
HashMap<String, ArrayList<Task>> courseMap;
// List of unsorted dates
ArrayList<Date> dates;
// Array of sorted dates
Date[] sortedDates;

int buffer = 80;
int rowHeight;
int columnWidth;
Date minDate;
Date maxDate;

// In these maps the keys are integers 1-12, for each month
HashMap<Integer, Integer> monthLengths;
HashMap<Integer, String> monthNames;

void setup(){
  size(1800, 800);
  background(255);
  strokeWeight(2);
  stroke(0);
  fill(255);
  
  // Traditional setup() stuff
  courseMap = new HashMap<String, ArrayList<Task>>();
  dates = new ArrayList<Date>();
  monthLengths = new HashMap<Integer, Integer>();
  monthNames = new HashMap<Integer, String>();
  fillMonthMaps();
  String[] lines = loadStrings(fileName);
  
  // Parse the file
  for (int i = 0 ; i < lines.length; i++) {
    parseLine(lines[i]);
  }
  
  // sort the dates from earliest to latest
  sortedDates = sortDates();
  
  // Organize the field
  minDate = sortedDates[0];
  maxDate = sortedDates[sortedDates.length-1];
  println(maxDate);
  println(numberOfDaysBetween(minDate, maxDate));
  
  // Draw smaller inner rectangle
  int newWidth = width-(buffer*2);
  int newHeight = height-(buffer*2);
  rect(buffer, buffer, newWidth, newHeight);
  
  // Draw the horizontal dividers
  rowHeight = newHeight/courseMap.keySet().size();
  for(int i = 1; i < courseMap.keySet().size(); i++){
    line(buffer, buffer+(rowHeight*i), buffer+newWidth, buffer+(rowHeight*i));
  }
  
  // Draw the vertical dividers
  fill(0);
  int dayRange = numberOfDaysBetween(minDate, maxDate);
  columnWidth = newWidth/dayRange;
  int dayToDraw = minDate.day;
  text(monthNames.get(minDate.month), buffer, buffer-30);
  int currentMonth = minDate.month;
  for(int i = 0; i <= dayRange; i++){
    if(dayToDraw > monthLengths.get(currentMonth)){
      dayToDraw = 1;
      currentMonth++;
      text(monthNames.get(currentMonth), buffer+(columnWidth*i), buffer-30);
    }
    // Add numbers along the top
    text(dayToDraw, buffer+(columnWidth*i), buffer-15);
    line(buffer+(columnWidth*i), buffer, buffer+(columnWidth*i), buffer+newHeight);
    dayToDraw++;
  }
  
  // Highlight the current day
  int daysBeforeCurrentDay = numberOfDaysBetween(minDate, new Date("now"));
  noFill();
  strokeWeight(3);
  stroke(255, 255, 0);
  rect(buffer+(daysBeforeCurrentDay*columnWidth)-3, buffer-3, columnWidth+6, newHeight+6);
  stroke(0);
  
  //Draw the course info
  int i = 0;
  for(String s : courseMap.keySet()){
    fill(0);
    text(s, 5, 15+buffer+(rowHeight*i));
    drawBars(i, courseMap.get(s));
    i++;
  }
}

//===============================================================================================
//===============================================================================================
// Helper methods
//===============================================================================================


// Parses a line of the format:
// [COURSE TITLE], [TASK NAME], ["from"], [DATE], ["to"], [DATE]
void parseLine(String line){
  String[] tokens = splitTokens(line);
  Date from = parseDate(tokens[3]);
  Date to = parseDate(tokens[5]);
  Task newTask = new Task(tokens[1], from, to);
  addToCourseMap(tokens[0], newTask);
  dates.add(from);
  dates.add(to);
}

// Adds tasks to their corresponding course
// If the courseMap contains that course already, the task is added to that course's list of tasks
void addToCourseMap(String course, Task task){
  if(courseMap.keySet().contains(course)){
    courseMap.get(course).add(task);    
  }
  else{
    ArrayList<Task> newList = new ArrayList<Task>();
    newList.add(task);
    courseMap.put(course, newList);  
  }
}

Date parseDate(String date){
  // Dates should be in the format DD/MM
  // Alternatively, could just be the word "now"
  if(date.equals("now"))return new Date("now");
  int[] dayMonth = int(split(date, '/'));
  return new Date(dayMonth[0], dayMonth[1]);
}

// returns an array of dates sorted chronologically
// uses the "dates" field, which is an arrayList
Date[] sortDates(){
  Date[] dateArr = new Date[dates.size()];
  dateArr = dates.toArray(dateArr);
  
  for (int i = 0; i < dateArr.length - 1; i++){
    int index = i;
    for (int j = i + 1; j < dateArr.length; j++)
      if (dateArr[j].compareTo(dateArr[index]) < 0) index = j;
      Date smallerDate = dateArr[index];  
      dateArr[index] = dateArr[i];
      dateArr[i] = smallerDate;
    }
  return dateArr;
  
}

// Draw the coloured segments representing the tasks
void drawBars(int level, ArrayList<Task> tasks){
  int r = (int)random(100, 255);
  int g = (int)random(100, 255);
  int b = (int)random(100, 255);
  int baseY = buffer+(rowHeight*level);
  int increment = min(rowHeight/tasks.size(), rowHeight/2);
  int i = 0;
  for(Task t : tasks){
    int dayOffset = numberOfDaysBetween(minDate, t.from);
    int dayLength = numberOfDaysBetween(t.from, t.to);
    fill(r, g, b);
    rect(buffer+(dayOffset*columnWidth), baseY+(increment*i), dayLength*columnWidth, increment);
    fill(0);
    text(t.name, buffer+(dayOffset*columnWidth)+5, baseY+(increment*i)+15);
    i++;
  }
}

// Returns the number of days between two dates
int numberOfDaysBetween(Date start, Date end){
  if(start.month != end.month){
    int daysTillEndOfFirstMonth = monthLengths.get(start.month)-start.day;
    int daysInBetween = 0;
    int daysFromStartOfLastMonthTillEnd = end.day;
    int i = start.month;
    while(++i != end.month){
      daysInBetween += monthLengths.get(i);
    }
    return daysTillEndOfFirstMonth + daysInBetween + daysFromStartOfLastMonthTillEnd;
  }
  else {
    return end.day-start.day;}
}

// Fill in the map fields
void fillMonthMaps(){
  monthLengths.put(1, 31);
  // Check for leap year
  if(isLeapYear(year()))monthLengths.put(2, 29);
  else monthLengths.put(2, 28);
  monthLengths.put(3, 31);
  monthLengths.put(4, 30);
  monthLengths.put(5, 31);
  monthLengths.put(6, 31);
  monthLengths.put(7, 31);
  monthLengths.put(8, 31);
  monthLengths.put(9, 31);
  monthLengths.put(10, 31);
  monthLengths.put(11, 31);
  monthLengths.put(12, 31);
  
  monthNames.put(1, "JAN");
  monthNames.put(2, "FEB");
  monthNames.put(3, "MAR");
  monthNames.put(4, "APR");
  monthNames.put(5, "MAY");
  monthNames.put(6, "JUN");
  monthNames.put(7, "JUL");
  monthNames.put(8, "AUG");
  monthNames.put(9, "SEP");
  monthNames.put(10, "OCT");
  monthNames.put(11, "NOV");
  monthNames.put(12, "JDEC");
}

boolean isLeapYear(int year) {
  if (year % 4 != 0) {
    return false;
  } else if (year % 400 == 0) {
    return true;
  } else if (year % 100 == 0) {
    return false;
  } else {
    return true;
  }
}