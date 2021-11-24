import java.util.Map;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import controlP5.*;

PShape eu;

Table table;
HashMap<String, ListElement> list = new HashMap<String, ListElement>();
String url = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv";

LocalDate dateMin;
LocalDate dateMax;
LocalDate dateSelected;

ControlP5 cp5;

PShape currentCountry;

BounderValues bv;

void setup() {
    size(1024, 768);
    eu = loadShape("eu.svg");
    
    loadCovidData();
    addControllersToPanel();
}

void draw() {
    background(220);
    
    shape(eu, 462, 248, 562, 520);
    smooth();
    fill(192, 0, 0);
    noStroke();
    
    for (Map.Entry <String, ListElement> l : list.entrySet()) {
        String key = l.getKey().toString();
        currentCountry = eu.getChild(key);
        if (currentCountry != null) {
            currentCountry.disableStyle();
            strokeWeight(1);
            stroke(0);
            
            int min = 0;
            int max = bv.getMaxNewCasesPerMillion();

            float percent = norm(
                l.getValue().getDataOnDate(dateSelected).getNewCasesPerMillion(), 
                min, 
                max
            );
            color between = lerpColor(#FFFFFF, #EC5166, percent);   
            fill(between);
            
            shape(currentCountry, 462, 248, 562, 520);
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

    cp5.addSlider("slider")
       .setPosition(50,50)
       .setSize(500, 25)
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
    }
   );
    
    cp5.getController("slider").setValueLabel(dateMin.plusDays(int(cp5.getController("slider").getValue())).toString());
    cp5.getController("slider").getValueLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setFont(createFont("Arial", 12)).setColor(0);
    cp5.getController("slider").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE).setPaddingX(0).setFont(createFont("Arial", 12)).setColor(0);
    
    cp5.addButton("OK")
       .setPosition(50, 100)
       .setSize(250, 25)
       .setFont(createFont("Arial", 12))
       .onClick(new CallbackListener() {
        public void controlEvent(CallbackEvent theEvent) {
            //dateSelected = dateMin.plusDays(int(cp5.getController("slider").getValue()));
            //calculateBounderValues(dateSelected);
            //printSelectedDate(dateSelected);
        }
    });

}

void printSelectedDate(LocalDate date) {
    println(date);
    /*for (Map.Entry <String, ListElement> l : list.entrySet()) {
        println(l.getValue().getLocation() + ": " + l.getValue().getDataOnDate(date));
    }*/
    float percent = norm(
                300, 
                bv.getMinNewCasesPerMillion(), 
               bv.getMaxNewCasesPerMillion()
    );
    println(bv.getMinNewCasesPerMillion());
    println(bv.getMaxNewCasesPerMillion());
    println(percent);
}

void calculateBounderValues(LocalDate date){
    bv = new BounderValues();
    
    for (Map.Entry <String, ListElement> l : list.entrySet()) {
        DataElement de = l.getValue().getDataOnDate(date);
        
        bv.compateToCurrent(
            de.getNewCases(), 
            de.getNewCasesPerMillion(), 
            de.getTotalCases(), 
            de.getTotalCasesPerMillion(), 
            de.getNewDeaths(), 
            de.getNewDeathsPerMillion(), 
            de.getTotalDeaths(), 
            de.getTotalDeathsPerMillion()
        );
    }
}
