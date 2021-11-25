public class BounderValues {
    private boolean isInit;

    private int maxNewCases;
    private int maxNewCasesSmoothed;
    private int maxNewCasesPerMillion;
    private int maxNewCasesSmoothedPerMillion;
    private int maxTotalCases;
    private int maxTotalCasesPerMillion;
    private int maxNewDeaths;
    private int maxNewDeathsSmoothed;
    private int maxNewDeathsPerMillion;
    private int maxNewDeathsSmoothedPerMillion;
    private int maxTotalDeaths;
    private int maxTotalDeathsPerMillion;

    BounderValues(){
        isInit = false;
    } 

    public int getMaxNewCases(){
        return maxNewCases;
    }

    public int getMaxNewCasesSmoothed(){
        return maxNewCasesSmoothed;
    }

    public int getMaxNewCasesPerMillion(){
        return maxNewCasesPerMillion;
    }

    public int getMaxNewCasesSmoothedPerMillion(){
        return maxNewCasesSmoothedPerMillion;
    }

    public int getMaxTotalCases(){
        return maxTotalCases;
    }

    public int getMaxTotalCasesPerMillion(){
        return maxTotalCasesPerMillion;
    }

    public int getMaxNewDeaths(){
        return maxNewDeaths;
    }

    public int getMaxNewDeathsSmoothed(){
        return maxNewDeathsSmoothed;
    }

    public int getMaxNewDeathsPerMillion(){
        return maxNewDeathsPerMillion;
    }
    
    public int getMaxNewDeathsSmoothedPerMillion(){
        return maxNewDeathsSmoothedPerMillion;
    }

    public int getMaxTotalDeaths(){
        return maxTotalDeaths;
    }

    public int getMaxTotalDeathsPerMillion(){
        return maxTotalDeathsPerMillion;
    }


    public void compateToCurrent(int nc, int ncs, int ncpm, int ncspm, int tc, int tcpm, int nd, int nds, int ndpm, int ndspm, int td, int tdpm){
        if(!isInit){
                maxNewCases = nc;
                maxNewCasesSmoothed = ncs;
                maxNewCasesPerMillion = ncpm;
                maxNewCasesSmoothedPerMillion = ncspm;
                maxTotalCases = tc;
                maxTotalCasesPerMillion = tcpm;
                maxNewDeaths = nd;
                maxNewDeathsSmoothed = nds;
                maxNewDeathsPerMillion = ndpm;
                maxNewDeathsSmoothedPerMillion = ndspm;
                maxTotalDeaths = td;
                maxTotalDeathsPerMillion = tdpm;
                isInit = true;
        }else{
            if(maxNewCases < nc) maxNewCases = nc;
            if(maxNewCasesSmoothed < ncs) maxNewCases = ncs;
            if(maxNewCasesPerMillion < ncpm) maxNewCasesPerMillion = ncpm;
            if(maxNewCasesSmoothedPerMillion < ncspm) maxNewCasesSmoothedPerMillion = ncspm;
            if(maxTotalCases < tc) maxTotalCases = tc;
            if(maxTotalCasesPerMillion < tcpm) maxTotalCasesPerMillion = tcpm;
            if(maxNewDeaths < nd) maxNewDeaths = nd;
            if(maxNewDeathsSmoothed < nds) maxNewDeathsSmoothed = nds;
            if(maxNewDeathsPerMillion < ndpm) maxNewDeathsPerMillion = ndpm;
            if(maxNewDeathsSmoothedPerMillion < ndspm) maxNewDeathsSmoothedPerMillion = ndspm;
            if(maxTotalDeaths < td) maxTotalDeaths = td;
            if(maxTotalDeathsPerMillion < tdpm) maxTotalDeathsPerMillion = tdpm;
        }
    }

}
