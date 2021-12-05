import java.util.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

public class Plot{
    private float height;
    private float width;
    private float xPos;
    private float yPos;
    private int max;
    private LocalDate minDate = LocalDate.now();
    private BounderValues bv;
    private int padding = 20;
    
    private color[] colors = {#FF0000, #00FF00, #0000FF, #FFFF00, #FF00FF, #00FFFF, #000000};

    Plot(int x, int y, int w, int h){
        xPos = float(x);
        yPos = float(y);
        width = float(w);
        height = float(h);
    }
    
    int calculateMaxToFilter(int numOfFilter){
      switch(numOfFilter){
        case 0:
          return bv.getMaxNewCases();
        case 1:
          return bv.getMaxNewCasesSmoothed();
        case 2:
          return bv.getMaxNewCasesPerMillion();
        case 3:
          return bv.getMaxNewCasesSmoothedPerMillion();
        case 4:
          return bv.getMaxTotalCases();
        case 5:
          return bv.getMaxTotalCasesPerMillion();
        case 6:
          return bv.getMaxNewDeaths();
        case 7:
          return bv.getMaxNewDeathsSmoothed();
        case 8:
          return bv.getMaxNewDeathsPerMillion();
        case 9:
          return bv.getMaxNewDeathsSmoothedPerMillion();
        case 10:
          return bv.getMaxTotalDeaths();
        case 11:
          return bv.getMaxTotalDeathsPerMillion();
        default:
          return bv.getMaxNewCasesSmoothedPerMillion();
      }
    }
    
    int calculateValueToFilter(DataElement de, int numOfFilter){
      switch(numOfFilter){
        case 0:
          return de.getNewCases();
        case 1:
          return de.getNewCasesSmoothed();
        case 2:
          return de.getNewCasesPerMillion();
        case 3:
          return de.getNewCasesSmoothedPerMillion();
        case 4:
          return de.getTotalCases();
        case 5:
          return de.getTotalCasesPerMillion();
        case 6:
          return de.getNewDeaths();
        case 7:
          return de.getNewDeathsSmoothed();
        case 8:
          return de.getNewDeathsPerMillion();
        case 9:
          return de.getNewDeathsSmoothedPerMillion();
        case 10:
          return de.getTotalDeaths();
        case 11:
          return de.getTotalDeathsPerMillion();
        default:
          return de.getNewCasesSmoothedPerMillion();
      }
    }

    public void draw(ArrayList<ListElement> list, int selectedFilter){
        bv = new BounderValues();

        for (ListElement l : list) {
            for(DataElement de : l.getData()){
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
            if(minDate.isAfter(l.getStartDate())) minDate = l.getStartDate();
        }
        
        max = calculateMaxToFilter(selectedFilter);
      
        fill(255);
        noStroke();
        // Koordinata rendszer
        rect(xPos, yPos, width, height);
        // Jelmagyarázat
        rect(xPos, (yPos + height + 20), 350, list.size() * (padding * 2));
        
        // Tengely
        strokeWeight(2);
        stroke(0);
        // X-tengely
        line(xPos, yPos + (height * 2/3), xPos + width, yPos + (height * 2/3));
        // Y-tengely
        line(xPos + (padding / 2), yPos + (padding / 2), xPos + (padding / 2), yPos + height - (padding / 2));
        
        
        // Havi tengely jelölések
        strokeWeight(1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("YYYY-MM");
        int numOfMonths = int(ChronoUnit.MONTHS.between(minDate, LocalDate.now()));
        numOfMonths = numOfMonths > 0 ? numOfMonths + 1 : numOfMonths;
        
        for(int m = 1; m < numOfMonths; m++){
          line(xPos + (width / numOfMonths) * m, (height * 2/3) - 5, xPos + (width / numOfMonths) * m, (height * 2/3) + 5);
          
          pushMatrix();
          translate(xPos + (width / numOfMonths) * m, (height * 2/3));
          rotate(-HALF_PI);
          fill(0);
          textSize(16);
          text(minDate.plusMonths(m).format(formatter), -70, 7);
          popMatrix();
        }
        
        // Érték tengely jelölések
        int numOfTick= 15;
        int numOfValues = 10;
        for(int t = 0; t <  numOfTick; t++){
          line(xPos + (padding * (1.0 / 4)), yPos + (padding / 2) + (t * (height / numOfTick)), xPos + (padding * (3.0 / 4)), yPos + (padding / 2) + (t * (height / numOfTick)));
          if(t < numOfValues) text(str(max - ((max / numOfValues) * t)), xPos + padding, yPos + (padding / 2) + (t * (height / numOfTick)) + 7);
        }
        
        int numOfPoints = int(ChronoUnit.DAYS.between(minDate, LocalDate.now()));
        float pointWidth = (width - 2 * padding) / numOfPoints;
        float pointHeight = (height * 2/3) / max;
                        
        for (int i = 0; i < list.size(); i++) {
            ListElement l = list.get(i);

            stroke(this.colors[i]);
            
            strokeWeight(2);
            line(padding, (yPos + height + (i + 1) * (padding * 2)), 75, (yPos + height + (i + 1) * (padding * 2)));
            fill(0);
            textSize(16);
            text(l.getLocation(), 100, (yPos + height + (i + 1) * (padding * 2) + 7));
            strokeWeight(1);
            
            float prevX = 0.0;
            float prevY = 0.0;
            
            for(int j = 0; j < numOfPoints; j++){
                DataElement cd = l.getDataOnDate(minDate.plusDays(j));
                int value = calculateValueToFilter(cd, selectedFilter);
                if(value >= 0){
                  float pointXPos = xPos + padding + (pointWidth * j);
                  float pointYPos = (yPos + (height * 2/3)) - (pointHeight * value);
                  
                  if(j != 0){
                    line(prevX, prevY, pointXPos, pointYPos);
                  }
                  prevX = pointXPos;
                  prevY = pointYPos;
                }
            }
        }

    }
}
