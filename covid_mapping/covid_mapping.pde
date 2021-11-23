import java.util.Map;
import java.time.LocalDate;
/*import java.net.URL;
import java.net.URLConnection;
import java.net.HttpURLConnection;*/
import controlP5.*;

ControlP5 cp5;
PShape eu;
Table table;
Table dataTable;
LocalDate dateMin;
LocalDate dateMax;
PShape currentCountry;
HashMap<String, ListElement> list = new HashMap<String, ListElement>();
String url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv";

void setup(){
 size(1024, 768);
 eu = loadShape("eu.svg");
 
 table = loadTable("owid-covid-data2.csv", "header");
 
 for (TableRow row : table.rows()) {
   if(row.getString("continent").equals("Europe")){
     LocalDate currentDate = LocalDate.parse(row.getString("date"));
     checkDateRange(currentDate);
     
     if(!list.containsKey(row.getString("iso_code"))){
       list.put(row.getString("iso_code"), new ListElement(row.getString("location")));
     }
     list.get(row.getString("iso_code")).addNewData(new DataElement(
     currentDate,
     int(row.getString("new_cases")),
     int(row.getString("total_cases")),
     int(row.getString("new_deaths")),
     int(row.getString("total_deaths"))
     ));
   }
 }
 
 for (Map.Entry<String, ListElement> l : list.entrySet()) {
   String min = l.getValue().getDataOnDate(dateMin);
   String max = l.getValue().getDataOnDate(dateMax);
   if(min.length() > 0) println(min);
   if(max.length() > 0) println(max);
 }
 
 /*println(dateMin.toString());
 println(dateMax.toString());*/
  
}

void draw(){
  background(255);
  
  shape(eu, 462, 248, 562, 520);
  smooth();
  fill(192, 0, 0);
  noStroke();
  
  int index = 0;
  for (Map.Entry l : list.entrySet()) {
    String key = l.getKey().toString();
    currentCountry = eu.getChild(key);
    if(currentCountry != null){
      currentCountry.disableStyle();
    if(index % 2 == 0){
      fill(#333366);
    }else{
      fill(#EC5166);
    }
    shape(currentCountry, 462, 248, 562, 520);
    index++;
    }
 }
  
}

class ListElement { 
  String location;
  ArrayList<DataElement> data = new ArrayList<DataElement>();

  
  ListElement (String l) {  
    location = l;
  } 
  
  void addNewData(DataElement de) { 
     data.add(de);
  }
  
  ArrayList<DataElement> getData(){
    return data;
  }
  
  String getLocation() {
    return location;
  }
  
  String getDataOnDate(LocalDate date){
    for(DataElement d : data){
      if(d.getDate().equals(date)){
        return location + " --> " + d.toString(); 
      }
    }
    return "";
  }
  
}

class DataElement{
  LocalDate date;
  int newCases;
  int totalCases;
  int newDeaths;
  int totalDeaths;
  
  DataElement(LocalDate d, int nc, int tc, int nd, int td){
    date = d;
    newCases = nc;
    totalCases = tc;
    newDeaths = nd;
    totalDeaths = td;
  }
  
  LocalDate getDate(){
    return date;
  }
  
  String toString(){
    return date + " Új esetek: " + str(newCases) + ", Halottak: " + str(newDeaths);
  }
  
}

void checkDateRange(LocalDate d){
  if(dateMin == null || dateMax == null){
    dateMin = d;
    dateMax = d;
  }else{
    if(d.isBefore(dateMin)){
      dateMin = d;
    }
    if(d.isAfter(dateMax)){
      dateMax = d;
    }
  }
}
