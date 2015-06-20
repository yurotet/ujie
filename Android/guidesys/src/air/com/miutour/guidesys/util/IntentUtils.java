package air.com.miutour.guidesys.util;
import air.com.miutour.R;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

/**
 * 公用Intent跳转类
 * @author
 *
 */
public class IntentUtils {
    private static final String TAG = "IntentUtils";
    /**
     * 跳转方法
     * @param activity  当前Activity
     * @param cls       要跳转的class 
     * @param bundle    传递的参数
     */
    public static void startActivity(Activity activity,Class<?> cls,Bundle bundle){
        if(null!=activity){
            Intent intent = new Intent(activity,cls);
            intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            if (bundle != null) {
                intent.putExtras(bundle);
            } 
            activity.startActivity(intent);
            activity.overridePendingTransition(R.anim.right_fade_in, R.anim.sham_translate);
        }
    }
    
    
    public static void startActivity4OtherCenter(Activity activity,Class<?> cls,Bundle bundle){
        if(null!=activity){
            Intent intent = new Intent(activity,cls);
            if (bundle != null) {
                intent.putExtras(bundle);
            } 
            activity.startActivity(intent);
            activity.overridePendingTransition(R.anim.right_fade_in, R.anim.sham_translate);
        }
    }
    
    /**
     * 同一个Actiity之间的跳转方法
     * @param activity
     * @param cls
     * @param bundle
     */
    public static void startSameActivity(Activity activity,Class<?> cls,Bundle bundle){
        if(null!=activity){
            Intent intent = new Intent(activity,cls);
            if (bundle != null) {
                intent.putExtras(bundle);
            } 
            activity.startActivity(intent);
            activity.overridePendingTransition(R.anim.right_fade_in, R.anim.sham_translate);
            activity.finish();
        }
    }
    
    public static void startActivity(Activity activity,Intent intent){
        if(null!=activity && null!=intent){
            activity.startActivity(intent);
            activity.overridePendingTransition(R.anim.right_fade_in, R.anim.sham_translate);
        }
    }

    
    /**
     * 跳转方法
     * @param activity  当前Activity
     * @param cls       要跳转的class 
     * @param bundle    传递的参数
     *  @param requestCode   请求code
     */
    public static void startActivityForResult(Activity activity,Class<? extends Activity> cls,Bundle bundle,int requestCode){
        Intent intent = new Intent(activity,cls);
        if (bundle != null) {
            intent.putExtras(bundle);
        }
        activity.startActivityForResult(intent, requestCode);
        activity.overridePendingTransition(R.anim.right_fade_in, R.anim.sham_translate);
    }
}
