import java.util.Map;
import java.time.LocalDate; 

PShape eu;
Table table;
Table dataTable;
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
PShape currentCountry;
HashMap<String, ListElement> list = new HashMap<String, ListElement>();

void setup(){
 size(1024, 768);
 eu = loadShape("eu.svg");
 
 table = loadTable("owid-covid-data.csv", "header");
 
 for (TableRow row : table.rows()) {
   if(row.getString("continent").equals("Europe")){
     if(!list.containsKey(row.getString("iso_code"))){
       list.put(row.getString("iso_code"), new ListElement(row.getString("location")));
     }
     list.get(row.getString("iso_code")).addNewData(new DataElement(
     row.getString("date"),
     int(row.getString("new_cases")),
     int(row.getString("total_cases")),
     int(row.getString("new_deaths")),
     int(row.getString("total_deaths"))
     ));
   }
 }
 
 for (Map.Entry<String, ListElement> l : list.entrySet()) {
    println(l.getValue().getLocation());
  }
  
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
  
  /*String toString(){
    return data.get(100).toString();
  }*/
  
}

class DataElement{
  LocalDate date;
  int newCases;
  int totalCases;
  int newDeaths;
  int totalDeaths;
  
  DataElement(String d, int nc, int tc, int nd, int td){
    date = LocalDate.parse(d);
    newCases = nc;
    totalCases = tc;
    newDeaths = nd;
    totalDeaths = td;
  }
  
  String toString(){
    return date + "Uj esetek: " + str(newCases) + ", Halottak: " + str(newDeaths);
  }
  
}
