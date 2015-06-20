package air.com.miutour.guidesys.util;

import air.com.miutour.R;
import android.content.Context;
import android.widget.Toast;

import java.util.HashMap;
//Toast 工具类
public class ToastUtils {
    private static Toast toast;
    public synchronized static void show(Context context, String msg, int duration) {
        try {
        	if(context==null) return;
            if(toast == null){
                toast = Toast.makeText(context, msg, duration);    
            } else {
                toast.setText(msg);
                toast.setDuration(duration);    
            }    
            toast.show();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    /**
     * onPause()页面被遮挡的时候调用这个方法取消toast
     */
    public static void onActivityPaused(){
        if(toast != null){
            toast.cancel();
        }
    }
    
//    /**
//     * 提示网络异常(异常类型：UnknownHostException，SocketException)
//     * @param context
//     */
//    public static void showNetworkException(Context context){
//    	if(context==null) return;
//        show(context,context.getString(R.string.hit_network_failure),Toast.LENGTH_SHORT);
//    }
//    
//    /**
//     * 提示数据为空(异常类型:NullPointerException)
//     * @param context
//     */
//    public static void getDataFailure(Context context){
//    	if(context==null) return;
//        show(context,context.getString(R.string.hit_no_data),Toast.LENGTH_SHORT);
//    }
//    
//    /**
//     * 加载失败（异常类型:JosnException,SocketTimeoutException,其他异常）
//     * @param context
//     */
//    public static void showLoadFailure(Context context){
//    	if(context==null) return;
//        show(context,context.getString(R.string.hit_load_data_failure),Toast.LENGTH_SHORT);
//    }
//
//    /**
//     * 网络不给力
//     * @param context
//     */
//    public static void showBadNetWork(Context context){
//        if(context == null) return;;
//        show(context,context.getString(R.string.hit_network_failure),Toast.LENGTH_SHORT);
//    }
//
//    /**
//     * 网络未连接
//     * @param context
//     */
//    public static void showNoNetWork(Context context){
//        if(context == null) return;;
//        show(context,context.getString(R.string.hit_no_network),Toast.LENGTH_SHORT);
//    }
//
//    /**
//     * 网络未连接
//     * @param context
//     */
//    public static void showLoadingToast(Context context){
//        if(context == null) return;;
//        show(context,context.getString(R.string.hit_in_business),Toast.LENGTH_SHORT);
//    }
    
    private static HashMap<String, Boolean> saveFlowModes = new HashMap<String, Boolean>();
    /**
     * 在onResume中执行该方法。
     * @param className  不同页面的标志建议以类名为标志
     * @param currentSaveFlow 当前全局的无图模式状态
     */
    public static void showSaveFlow(String className,boolean currentSaveFlow,Context context){
    	if(context==null) return;
        if(NetworkUtils.getNetworkState(context)== NetworkUtils.WIFI){
            return;
        }
    	if(NetworkUtils.getNetworkState(context) != NetworkUtils.WIFI){
    		if(saveFlowModes.containsKey(className)){
    			if(saveFlowModes.get(className)!=currentSaveFlow && currentSaveFlow){
    				show(context, "无图模式", 1);
    			}
    		}else{
    			if(currentSaveFlow){
    				show(context, "无图模式", 1);
    			}
    		}
    		saveFlowModes.put(className, currentSaveFlow);
    	}
    }
}
