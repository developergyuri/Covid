public class DataElement{
    private LocalDate date;
    private int newCases;
    private int newCasesPerMillion;
    private int totalCases;
    private int totalCasesPerMillion;
    private int newDeaths;
    private int newDeathsPerMillion;
    private int totalDeaths;
    private int totalDeathsPerMillion;
    
    
    DataElement(LocalDate d, int nc, int ncpm, int tc, int tcpm, int nd, int ndpm, int td, int tdpm) {
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
    
    public LocalDate getDate() {
        return date;
    }

    public int getNewCases() {
        return newCases;
    }

    public int getNewCasesPerMillion(){
        return newCasesPerMillion;
    }

    public int getTotalCases(){
        return totalCases;
    }

    public int getTotalCasesPerMillion(){
        return totalCasesPerMillion;
    }

    public int getNewDeaths(){
        return newDeaths;
    }

    public int getNewDeathsPerMillion(){
        return newDeathsPerMillion;
    }

    public int getTotalDeaths(){
        return totalDeaths;
    }

    public int getTotalDeathsPerMillion(){
        return totalDeathsPerMillion;
    }
    
    public String toString() {
        return date + " Uj esetek: " + str(newCases) + ", Halottak: " + str(newDeaths);
    }
    
}