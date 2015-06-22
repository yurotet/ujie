package air.com.miutour.guidesys.widget.pulltorefreshlistview;

/**
 * @file XListViewHeader.java
 * @create Apr 18, 2012 5:22:27 PM
 * @author Maxwin
 * @description XListView's header
 */

import air.com.miutour.R;
import android.content.Context;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;


public class PullToRefreshListViewHeader extends LinearLayout {
	private LinearLayout mContainer;
	private ImageView mLeftImageView;
	private ImageView mRightImageView;
	private int mState = STATE_NORMAL;

	private TranslateAnimation leftViewAnim;
	private TranslateAnimation rightViewAnim;

	public final static int STATE_NORMAL = 0;
	public final static int STATE_ALMOST_READY = -1;
	public final static int STATE_READY = 1;
	public final static int STATE_REFRESHING = 2;
	public final static int STATE_COMPLETE = 3;

	private int containerHeight;
	private int imgWidth;
	private int imgHeight;
	
	public PullToRefreshListViewHeader(Context context) {
		super(context);
		initView(context);
	}

	/**
	 * @param context
	 * @param attrs
	 */
	public PullToRefreshListViewHeader(Context context, AttributeSet attrs) {
		super(context, attrs);
		initView(context);
	}

	private void initView(Context context) {
		// 初始情况，设置下拉刷新view高度为0
		LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
				android.view.ViewGroup.LayoutParams.MATCH_PARENT, 0);
		mContainer = (LinearLayout) LayoutInflater.from(context).inflate(
				R.layout.app_pull_listview_header, null);
		addView(mContainer, lp);
		setGravity(Gravity.BOTTOM);

		mLeftImageView = (ImageView) mContainer.findViewById(R.id.icon_left);
		mRightImageView = (ImageView) mContainer.findViewById(R.id.icon_right);
	}

	public void setState(int state) {
		if (state == mState) return ;

		if (state == STATE_REFRESHING) {
			startAnimation();
		} else {
			endAnimation();
		}
		mState = state;
	}

	private void startAnimation(){
		if (leftViewAnim==null && rightViewAnim== null){
			initAnim();
		}
		mLeftImageView.startAnimation(leftViewAnim);
		mRightImageView.startAnimation(rightViewAnim);
	}

	private void endAnimation(){
		mLeftImageView.clearAnimation();
		mRightImageView.clearAnimation();
	}

	private void initAnim(){
		leftViewAnim = new TranslateAnimation(0, 100, 0, 0);
		leftViewAnim.setDuration(500);
		leftViewAnim.setRepeatCount(Integer.MAX_VALUE);
		leftViewAnim.setRepeatMode(Animation.REVERSE);

		rightViewAnim = new TranslateAnimation(0, -100, 0, 0);
		rightViewAnim.setDuration(500);
		rightViewAnim.setRepeatCount(Integer.MAX_VALUE);
		rightViewAnim.setRepeatMode(Animation.REVERSE);
	}

	private void getAnim2(){

	}

	public void setVisiableHeight(int height) {
		if (height < 0)
			height = 0;
		LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) mContainer
				.getLayoutParams();
		lp.height = height;
		mContainer.setLayoutParams(lp);

		float rate = (float)height / (float) containerHeight - 0.5f;
		rate *= 2;
		if (rate < 0) {
			rate = 0f;
		} else if (rate > 1) {
			rate = 1.0f;
		}
		mLeftImageView.setAlpha(rate);
		mLeftImageView.setPadding(0, 0, (int)(rate*100), 0);

		mRightImageView.setAlpha(rate);
		mRightImageView.setPadding((int)(rate*100), 0, 0, 0);
	}

	public int getVisiableHeight() {
		return mContainer.getHeight();
	}

	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		super.onMeasure(widthMeasureSpec, heightMeasureSpec);
		if (containerHeight==0) {
			containerHeight = mContainer.findViewById(R.id.xlistview_header_content).getHeight();
		}
	} 
}
