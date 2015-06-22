package air.com.miutour.guidesys.module.base;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;

public class BaseFragment extends Fragment {
    
    /*
     *  用于子类操作异常以及进度条的字段 
     */
    /** 显示进度条 */
    protected static final int SHOW_PROGRESS = 0x44;

    /** 显示异常页面 */
    protected static final int SHOW_EXCEPTION_VIEW = 0x55;

    /** 显示空视图 */
    protected static final int SHOW_EMPTY_VIEW = 0x66;

    /** 隐藏相关视图 */
    protected static final int SHOW_NONE = 0x77;
    
	private static final String TAG = "BaseFragment";

	private boolean isNightMode = false;

	// 背景bitmap对象
	protected Drawable drawable;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}



	@Override
	public void onPause() {
		super.onStop();
		if (null != drawable) {
			drawable.setCallback(null);
			drawable = null;
		}
	}

	@Override
	public void onResume() {
		super.onResume();
	}


	@Override
	public void onDestroy() {
		super.onDestroy();
		if (null != drawable) {
			drawable.setCallback(null);
			drawable = null;
		}
	}


}
