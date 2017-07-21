class Date{
  int day;
  int month;
 
  Date(int day, int month){
    this.day = day;
    this.month = month;
  }
  
  Date(String alternative){
    if(alternative.equals("now")){
      this.day = day();
      this.month = month();
    }
  }
  
  int compareTo(Date d){
    if(this.month < d.month)return -1;
    else if(this.month > d.month)return 1;
    else{
      if(this.day < d.day)return -1;
      else if(this.day > d.day)return 1;
      else return 0;
    }
  }
  
  String toString(){
    return ("[" + day + ", " + month + "]");
  }
}