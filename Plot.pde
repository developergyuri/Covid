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

    Plot(int x, int y, int w, int h){
        xPos = float(x);
        yPos = float(y);
        width = float(w);
        height = float(h);
    }

    public void draw(ArrayList<ListElement> list){
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
        
        max = bv.getMaxNewCasesSmoothedPerMillion();
      
        fill(255);
        noStroke();
        // Koordinata rendszer
        rect(xPos, yPos, width, height);
        // Jelmagyarázat
        rect(xPos, (yPos + height + 20), 250, list.size() * (padding * 2));
        
        // Tengely
        strokeWeight(2);
        stroke(0);
        // X-tengely
        line(xPos, yPos + (height * 2/3), xPos + width - padding, yPos + (height * 2/3));
        // Y-tengely
        line(xPos + (padding / 2), yPos, xPos + (padding / 2), yPos + height);
        
        
        // Havi tengely jelölések
        strokeWeight(1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("YYYY-MM");
        int numOfMonths = int(ChronoUnit.MONTHS.between(minDate, LocalDate.now()));
        numOfMonths = numOfMonths > 0 ? numOfMonths + 1 : numOfMonths;
        
        for(int m = 0; m < numOfMonths; m++){
          line(xPos + (width / numOfMonths) * m + padding, (height * 2/3) - 5, xPos + (width / numOfMonths) * m + padding, (height * 2/3) + 5);
          
          pushMatrix();
          translate(xPos + (width / numOfMonths) * m + padding, (height * 2/3));
          rotate(-HALF_PI);
          fill(0);
          textSize(16);
          text(minDate.plusMonths(m).format(formatter), -70, 7);
          popMatrix();
        }
        
        // Érték tengely jelölések
        int numOfValues = 15;
        for(int v = 0; v <  numOfValues; v++){
          line(xPos + (padding * (1.0 / 4)), yPos + (v * (height / numOfValues)), xPos + (padding * (3.0 / 4)), yPos + (v * (height / numOfValues)));
          text(str(max - ((max / numOfValues) * v)), xPos + padding, yPos + (v * (height / numOfValues)) + 7);
        }
        
        int numOfPoints = int(ChronoUnit.DAYS.between(minDate, LocalDate.now()));
        float pointWidth = (width - 2 * padding) / numOfPoints;
        float pointHeight = (height * 2/3) / max;
        
                
        for (int i = 0; i < list.size(); i++) {
            ListElement l = list.get(i);
            randomSeed(i);
            stroke(random(255), random(255), random(255));
            
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
                int value = cd.getNewCasesSmoothedPerMillion();

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
