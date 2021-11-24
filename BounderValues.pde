public class BounderValues {
    private boolean isInit;
    private int minNewCases;
    private int minNewCasesPerMillion;
    private int minTotalCases;
    private int minTotalCasesPerMillion;
    private int minNewDeaths;
    private int minNewDeathsPerMillion;
    private int minTotalDeaths;
    private int minTotalDeathsPerMillion;

    private int maxNewCases;
    private int maxNewCasesPerMillion;
    private int maxTotalCases;
    private int maxTotalCasesPerMillion;
    private int maxNewDeaths;
    private int maxNewDeathsPerMillion;
    private int maxTotalDeaths;
    private int maxTotalDeathsPerMillion;

    BounderValues(){
        isInit = false;
    } 

    public int getMinNewCases(){
        return minNewCases;
    }

    public int getMaxNewCases(){
        return maxNewCases;
    }

    public int getMinNewCasesPerMillion(){
        return minNewCasesPerMillion;
    }

    public int getMaxNewCasesPerMillion(){
        return maxNewCasesPerMillion;
    }

    public void compateToCurrent(int nc, int ncpm, int tc, int tcpm, int nd, int ndpm, int td, int tdpm){
        if(!isInit){
                minNewCases = maxNewCases = nc;
                minNewCasesPerMillion = maxNewCasesPerMillion = ncpm;
                minTotalCases = maxTotalCases = tc;
                minTotalCasesPerMillion = maxTotalCasesPerMillion = tcpm;
                minNewDeaths = maxNewDeaths = nd;
                minNewDeathsPerMillion = maxNewDeathsPerMillion = ndpm;
                minTotalDeaths = maxTotalDeaths = td;
                minTotalDeathsPerMillion = maxTotalDeathsPerMillion = tdpm;
                isInit = true;
        }else{
            if(minNewCases > nc) minNewCases = nc;
            if(maxNewCases < nc) maxNewCases = nc;
            if(minNewCasesPerMillion > ncpm) minNewCasesPerMillion = ncpm;
            if(maxNewCasesPerMillion < ncpm) maxNewCasesPerMillion = ncpm;
            if(minTotalCases > tc) minTotalCases = tc;
            if(maxTotalCases < tc) maxTotalCases = tc;
            if(minTotalCasesPerMillion > tcpm) minTotalCasesPerMillion = tcpm;
            if(maxTotalCasesPerMillion < tcpm) maxTotalCasesPerMillion = tcpm;
            if(minNewDeaths > nd) minNewDeaths = nd;
            if(maxNewDeaths < nd) maxNewDeaths = nd;
            if(minNewDeathsPerMillion > ndpm) minNewDeathsPerMillion = ndpm;
            if(maxNewDeathsPerMillion < ndpm) maxNewDeathsPerMillion = ndpm;
            if(minTotalDeaths > td) minTotalDeaths = td;
            if(maxTotalDeaths < td) maxTotalDeaths = td;
            if(minTotalDeathsPerMillion > tdpm) minTotalDeathsPerMillion = tdpm;
            if(maxTotalDeathsPerMillion < tdpm) maxTotalDeathsPerMillion = tdpm;
        }
    }

}
