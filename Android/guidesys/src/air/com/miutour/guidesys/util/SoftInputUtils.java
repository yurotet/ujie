package air.com.miutour.guidesys.util;

import java.util.Timer;
import java.util.TimerTask;

import android.app.Activity;
import android.content.Context;
import android.view.inputmethod.InputMethodManager;

/**
 * 软键盘
 * @author Rex
 *
 */
public class SoftInputUtils {
	
	/**
	 * 隐藏软键盘
	 * @param acitivity
	 */
	public static void closedSoftInput(Activity acitivity){
		if(null!=acitivity && acitivity.getCurrentFocus()!=null){
            if(null!=acitivity.getWindow()){
            	acitivity.getWindow().getDecorView().clearFocus();
                InputMethodManager im = ((InputMethodManager) acitivity.getApplicationContext().getSystemService(Context.INPUT_METHOD_SERVICE));
                if(null!=im){
                    im.hideSoftInputFromWindow(acitivity.getWindow().getDecorView().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
                }
            }
        }
	}
	
	/**
	 * 打开软键盘
	 * @param acitivity
	 */
	public static void openSoftInput(final Activity acitivity){
		 Timer timer = new Timer();
	        timer.schedule(new TimerTask() {
	           @Override
	            public void run() {
	                    InputMethodManager imm = (InputMethodManager)acitivity.getSystemService(Context.INPUT_METHOD_SERVICE); 
	                    imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS); 
	            }

	         }, 300);
	}

}
