package com.chartboost.plugin.air;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class ChartboostExtension implements FREExtension {

    @Override
    public FREContext createContext(String extId) {
        return new ChartboostContext();
    }

    @Override
    public void initialize() {
        //
    }

    @Override
    public void dispose() {
        //
    }

}
