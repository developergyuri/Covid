import java.util.Map;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
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
LocalDate dateSelected;
PShape currentCountry;
HashMap<String, ListElement> list = new HashMap<String, ListElement>();
String url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv";
int slider = 0;

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
     int(row.getString("new_cases_per_million")),
     int(row.getString("total_cases")),
     int(row.getString("total_cases_per_million")),
     int(row.getString("new_deaths")),
     int(row.getString("new_deaths_per_million")),
     int(row.getString("total_deaths")),
     int(row.getString("total_deaths_per_million"))
     ));
   }
 }
 
 dateSelected = dateMin;
 
 
  cp5 = new ControlP5(this);
  
  cp5.addSlider("slider")
     .setPosition(50,50)
     .setSize(500, 25)
     .setLabel("Dátum")
     .setValueLabel(dateMin.plusDays((int)cp5.getController("slider").getValue()).toString())
     .setValue(slider)
     //.setNumberOfTickMarks((int)ChronoUnit.MONTHS.between(dateMin, dateMax))
     .setRange(0, (int)ChronoUnit.DAYS.between(dateMin, dateMax))
     .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
          theEvent.getController().setValueLabel(dateMin.plusDays((int)theEvent.getController().getValue()).toString());
          dateSelected = dateMin.plusDays((int)theEvent.getController().getValue());
      }
    }
    );
    
    cp5.getController("slider").setValueLabel(dateMin.plusDays((int)cp5.getController("slider").getValue()).toString());
    cp5.getController("slider").getValueLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    cp5.getController("slider").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  
  
  cp5.addButton("OK")
     .setPosition(50,100)
     .setSize(250,25)
     .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        printSelectedDate(dateSelected);
      }
    });
  
}

void draw(){
  background(220);
  
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
  int newCasesPerMillion;
  int totalCases;
  int totalCasesPerMillion;
  int newDeaths;
  int newDeathsPerMillion;
  int totalDeaths;
  int totalDeathsPerMillion;
  
  
  DataElement(LocalDate d, int nc, int ncpm, int tc, int tcpm, int nd, int ndpm, int td, int tdpm){
    date = d;
    newCases = nc;
    newCasesPerMillion = ncpm;
    totalCases = tc;
    totalCasesPerMillion = tcpm;
    newDeaths = nd;
    newDeathsPerMillion = ndpm;
    totalDeaths = td;
    totalDeathsPerMillion = tdpm;
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

void printSelectedDate(LocalDate date){
  println(date);
  for (Map.Entry<String, ListElement> l : list.entrySet()) {
    println(l.getValue().getDataOnDate(date));
  }
}
