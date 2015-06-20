package air.com.miutour.guidesys.util;

import android.content.Context;

/**
 * 用于转换界面尺寸的工具类
 */
public class DisplayUtils {
    public static int convertDIP2PX(Context context, float dip) {
        float scale = context.getResources().getDisplayMetrics().density;
        return (int)(dip*scale + 0.5f*(dip>=0?1:-1));
    }

    //转换px为dip
    public static int convertPX2DIP(Context context, float px) {
        float scale = context.getResources().getDisplayMetrics().density;
        return (int)(px/scale + 0.5f*(px>=0?1:-1));
    }
    public static int dip2px(Context context,float dipValue){
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int)(dipValue * scale + 0.5f);
    }

    public static int sp2px(Context context,float spValue) {
        final float fontScale = context.getResources().getDisplayMetrics().scaledDensity;
        return (int) (spValue * fontScale + 0.5f);
    }
}
