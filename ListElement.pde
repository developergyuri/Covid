import java.util.*;
import java.time.LocalDate;

public class ListElement { 
    private String location;
    private LocalDate startDate = LocalDate.now();;
    private ArrayList<DataElement> data = new ArrayList<DataElement>();
    
    
    ListElement(String l) {  
        location = l;
    } 
    
    public void addNewData(DataElement de) { 
        if(startDate.isAfter(de.getDate())) startDate = de.getDate();
        data.add(de);
    }
    
    public ArrayList<DataElement> getData() {
        return data;
    }
    
    public String getLocation() {
        return location;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public DataElement getDataOnDate(LocalDate date) {
        for (DataElement d : data) {
            if (d.getDate().equals(date)) {
                return d;
            }
        }
        return new DataElement(date, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    }
    
}
