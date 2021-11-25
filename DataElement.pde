import java.util.*;
import java.time.LocalDate;

public class DataElement{
    private LocalDate date;
    private int newCases;
    private int newCasesSmoothed;
    private int newCasesPerMillion;
    private int newCasesSmoothedPerMillion;
    private int totalCases;
    private int totalCasesPerMillion;
    private int newDeaths;
    private int newDeathsSmoothed;
    private int newDeathsPerMillion;
    private int newDeathsSmoothedPerMillion;
    private int totalDeaths;
    private int totalDeathsPerMillion;
    
    
    DataElement(LocalDate d, int nc, int ncs, int ncpm, int ncspm, int tc, int tcpm, int nd, int nds, int ndpm, int ndspm, int td, int tdpm) {
        date = d;
        newCases = nc;
        newCasesSmoothed = ncs;
        newCasesPerMillion = ncpm;
        newCasesSmoothedPerMillion = ncspm;
        totalCases = tc;
        totalCasesPerMillion = tcpm;
        newDeaths = nd;
        newDeathsSmoothed = nds;
        newDeathsPerMillion = ndpm;
        newDeathsSmoothedPerMillion = ndspm;
        totalDeaths = td;
        totalDeathsPerMillion = tdpm;
    }
    
    public LocalDate getDate() {
        return date;
    }

    public int getNewCases() {
        return newCases;
    }

    public int getNewCasesSmoothed(){
        return newCasesSmoothed;
    }

    public int getNewCasesPerMillion(){
        return newCasesPerMillion;
    }

    public int getNewCasesSmoothedPerMillion(){
        return newCasesSmoothedPerMillion;
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

    public int getNewDeathsSmoothed(){
        return newDeathsSmoothed;
    }

    public int getNewDeathsPerMillion(){
        return newDeathsPerMillion;
    }

    public int getNewDeathsSmoothedPerMillion(){
        return newDeathsSmoothedPerMillion;
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
