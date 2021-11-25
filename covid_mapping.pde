import java.util.Map;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import controlP5.*;

PShape eu;

Table table;
HashMap<String, ListElement> list = new HashMap<String, ListElement>();
String url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv";

PShape currentCountry;

LocalDate dateMin;
LocalDate dateMax;
LocalDate dateSelected;

ControlP5 cp5;
Slider slr;
DropdownList dpd;
Button btn;

BounderValues bv;
int colorMin = 0;
int colorMax = 0;

int selectedFilter = 3;

String label = "";

void setup() {
    size(1024, 768);
    eu = loadShape("eu.svg");
    
    loadCovidData();
    addControllersToPanel();
    println(colorMax);
    changeFilterHandler(selectedFilter);
    println(colorMax);
}

void draw() {
    background(220);
    
    shape(eu, 462, 0, 562, 520);
    smooth();
    fill(192, 0, 0);
    noStroke();
    
    for (Map.Entry <String, ListElement> l : list.entrySet()) {
        String key = l.getKey().toString();
        currentCountry = eu.getChild(key);
        if (currentCountry != null) {
            currentCountry.disableStyle();

            stroke(0);
            if(currentCountry.contains((mouseX-462), mouseY)){
              strokeWeight(2);
              cursor(HAND);
              fill(#002d5a);
            }else{
              strokeWeight(1);
              if(colorMax != 0){
                float percent = calculatePercent(selectedFilter, l.getValue().getDataOnDate(dateSelected));                 
                color between = lerpColor(#FFFFFF, #EC5166, percent);   
                fill(between);
              }else{
                  fill(#FFFFFF);
              }
            }

            shape(currentCountry, 462, 0, 562, 520);

        }
    }
}

void loadCovidData(){
    table = loadTable("owid-covid-data.csv", "header");
    
    for (TableRow row : table.rows()) {
        if (row.getString("continent").equals("Europe")) {
            LocalDate currentDate = LocalDate.parse(row.getString("date"));
            checkDateRange(currentDate);
            
            if (!list.containsKey(row.getString("iso_code"))) {
                list.put(row.getString("iso_code"), new ListElement(row.getString("location")));
            }
            list.get(row.getString("iso_code")).addNewData(new DataElement(
                currentDate,
                int(row.getString("new_cases")),
                int(row.getString("new_cases_smoothed")),
                int(row.getString("new_cases_per_million")),
                int(row.getString("new_cases_smoothed_per_million")),
                int(row.getString("total_cases")),
                int(row.getString("total_cases_per_million")),
                int(row.getString("new_deaths")),
                int(row.getString("new_deaths_smoothed")),
                int(row.getString("new_deaths_per_million")),
                int(row.getString("new_deaths_smoothed_per_million")),
                int(row.getString("total_deaths")),
                int(row.getString("total_deaths_per_million"))
               ));
        }
    }
    
    dateSelected = dateMax;

    calculateBounderValues(dateSelected);
}

void checkDateRange(LocalDate d) {
    if (dateMin == null || dateMax == null) {
        dateMin = d;
        dateMax = d;
    } else{
        if (d.isBefore(dateMin)) {
            dateMin = d;
        }
        if (d.isAfter(dateMax)) {
            dateMax = d;
        }
    }
}

void addControllersToPanel(){
    cp5 = new ControlP5(this);

    slr = cp5.addSlider("slider")
       .setPosition(462, 545)
       .setSize(540, 25)
       .setLabel("Dátum")
       .setValue(0)
       .setRange(0, int(ChronoUnit.DAYS.between(dateMin, dateMax)))
       .setScrollSensitivity(0.01)
       .onChange(new CallbackListener() {
          public void controlEvent(CallbackEvent theEvent) {
              theEvent.getController().setValueLabel(dateMin.plusDays(int(theEvent.getController().getValue())).toString());
              dateSelected = dateMin.plusDays(int(theEvent.getController().getValue()));
              calculateBounderValues(dateSelected);
          }
       });
    
    slr.setValueLabel(dateMin.plusDays(int(slr.getValue())).toString());
    slr.getValueLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setFont(createFont("Arial", 12)).setColor(0);
    slr.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setFont(createFont("Arial", 12)).setColor(0);

    dpd = cp5.addDropdownList("dropdown")
        .setPosition(462, 575)
        .setSize(540, 200)
        .setDefaultValue(3)
        .onChange(new CallbackListener() {
            public void controlEvent(CallbackEvent theEvent) {
              selectedFilter = int(theEvent.getController().getValue());
              changeFilterHandler(int(theEvent.getController().getValue()));
            }
          });
    
    dpd.setBarHeight(30);
    dpd.getCaptionLabel().set("Szűrő").setFont(createFont("Arial", 10)).setColor(255);
    dpd.setItemHeight(30);
    dpd.getValueLabel().setFont(createFont("Arial", 10)).setColor(255);

    
    dpd.addItem("Napi eset", 0);
    dpd.addItem("Napi eset (7 napos átlag)", 1);
    dpd.addItem("Napi eset / 1M", 2);
    dpd.addItem("Napi eset / 1M (7 napos átlag)", 3);
    dpd.addItem("Összes eset", 4);
    dpd.addItem("Összes eset / 1M", 5);
    dpd.addItem("Napi elhunyt", 6);
    dpd.addItem("Napi elhunyt (7 napos átlag)", 7);
    dpd.addItem("Napi elhunyt / 1M", 8);
    dpd.addItem("Napi elhunyt / 1M (7 napos átlag)", 9);
    dpd.addItem("Összes elhunyt", 10);
    dpd.addItem("Összes elhunyt / 1M", 11);
    
}

void calculateBounderValues(LocalDate date){
    bv = new BounderValues();
    
    for (Map.Entry <String, ListElement> l : list.entrySet()) {
        DataElement de = l.getValue().getDataOnDate(date);

        bv.compateToCurrent(
            de.getNewCases(), 
            de.getNewCasesSmoothed(), 
            de.getNewCasesPerMillion(), 
            de.getNewCasesSmoothedPerMillion(), 
            de.getTotalCases(), 
            de.getTotalCasesPerMillion(), 
            de.getNewDeaths(), 
            de.getNewDeathsSmoothed(), 
            de.getNewDeathsPerMillion(), 
            de.getNewDeathsSmoothedPerMillion(), 
            de.getTotalDeaths(), 
            de.getTotalDeathsPerMillion()
        );
    }
}

void changeFilterHandler(int numOfFilter){
  switch(numOfFilter){
    case 0:
      colorMax = bv.getMaxNewCases();
      break;
    case 1:
      colorMax = bv.getMaxNewCasesSmoothed();
      break;
    case 2:
      colorMax = bv.getMaxNewCasesPerMillion();
      break;
    case 3:
      colorMax = bv.getMaxNewCasesSmoothedPerMillion();
      break;
    case 4:
      colorMax = bv.getMaxTotalCases();
      break;
    case 5:
      colorMax = bv.getMaxTotalCasesPerMillion();
      break;
    case 6:
      colorMax = bv.getMaxNewDeaths();
      break;
    case 7:
      colorMax = bv.getMaxNewDeathsSmoothed();
      break;
    case 8:
      colorMax = bv.getMaxNewDeathsPerMillion();
      break;
    case 9:
      colorMax = bv.getMaxNewDeathsSmoothedPerMillion();
      break;
    case 10:
      colorMax = bv.getMaxTotalDeaths();
      break;
    case 11:
      colorMax = bv.getMaxTotalDeathsPerMillion();
      break;
    default:
      colorMax = bv.getMaxNewCasesSmoothedPerMillion();
      break;
  }
}

float calculatePercent(int numOfFilter, DataElement de){
  switch(numOfFilter){
    case 0:
    label = str(de.getNewCases());
      return norm(
          de.getNewCases(), 
          colorMin, 
          colorMax
      );
    case 1:
      label = str(de.getNewCasesSmoothed());
      return norm(
          de.getNewCasesSmoothed(), 
          colorMin, 
          colorMax
      );
    case 2:
      label = str(de.getNewCasesPerMillion());
      return norm(
          de.getNewCasesPerMillion(), 
          colorMin, 
          colorMax
      );
    case 3:
    label = str(de.getNewCasesSmoothedPerMillion());
      return norm(
          de.getNewCasesSmoothedPerMillion(), 
          colorMin, 
          colorMax
      );
    case 4:
      return norm(
          de.getTotalCases(), 
          colorMin, 
          colorMax
      );
    case 5:
      return norm(
          de.getTotalCasesPerMillion(), 
          colorMin, 
          colorMax
      );
    case 6:
      return norm(
          de.getNewDeaths(), 
          colorMin, 
          colorMax
      );
    case 7:
      return norm(
          de.getNewDeathsSmoothed(), 
          colorMin, 
          colorMax
      );
    case 8:
      return norm(
          de.getNewDeathsPerMillion(), 
          colorMin, 
          colorMax
      );
    case 9:
      return norm(
          de.getNewDeathsSmoothedPerMillion(), 
          colorMin, 
          colorMax
      );
    case 10:
      return norm(
          de.getTotalDeaths(), 
          colorMin, 
          colorMax
      );
    case 11:
      return norm(
          de.getTotalDeathsPerMillion(), 
          colorMin, 
          colorMax
      );
    default:
      return norm(
          de.getNewCasesSmoothedPerMillion(), 
          colorMin, 
          colorMax
      );
  }
}
