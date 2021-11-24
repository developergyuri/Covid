public class ListElement { 
    private String location;
    private ArrayList<DataElement> data = new ArrayList<DataElement>();
    
    
    ListElement(String l) {  
        location = l;
    } 
    
    public void addNewData(DataElement de) { 
        data.add(de);
    }
    
    public ArrayList<DataElement> getData() {
        return data;
    }
    
    public String getLocation() {
        return location;
    }
    
    /* public String getDataOnDate(LocalDate date) {
        for (DataElement d : data) {
            if (d.getDate().equals(date)) {
                return location + " --> " + d.toString(); 
            }
        }
        return location;
    } */

    public DataElement getDataOnDate(LocalDate date) {
        for (DataElement d : data) {
            if (d.getDate().equals(date)) {
                return d;
            }
        }
        return new DataElement(date, 0, 0, 0, 0, 0, 0, 0, 0);
    }
    
}