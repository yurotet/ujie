package air.com.miutour.guidesys.widget.pulltorefreshlistview;

/**
 * @file XListView.java
 * @package me.maxwin.view
 * @create Mar 18, 2012 6:28:41 PM
 * @author Maxwin
 * @description An ListView support (a) Pull down to refresh, (b) Pull up to load more.
 * 		Implement IXListViewListener, and see stopRefresh() / stopLoadMore().
 */

import air.com.miutour.R;
import android.content.Context;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver.OnGlobalLayoutListener;
import android.view.animation.DecelerateInterpolator;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.Scroller;
import android.widget.TextView;


public class PullToRefreshListView extends ListView implements OnScrollListener {

    private static final String TAG = "PullToRefreshListView";

    private float mLastY = -1; // save event y
    private Scroller mScroller; // used for scroll back
    private OnScrollListener mScrollListener; // user's scroll listener

    // the interface to trigger refresh and load more.
    private PullAndRefreshListViewListener pullAndRefreshListViewListener;

    // -- header view
    private PullToRefreshListViewHeader mHeaderView;
    // header view content, use it to calculate the Header's height. And hide it
    // when disable pull refresh.
    private RelativeLayout mHeaderViewContent;
    private int mHeaderViewHeight; // header view's height
    private boolean mEnablePullRefresh = true;
    private boolean mPullRefreshing = false; // is refreashing.

    // -- footer view
    private PullToRefreshListViewFooter mFooterView;
    private boolean mEnablePullLoad;
    private boolean mPullLoading;
    private boolean mIsFooterReady = false;

    // total list items, used to detect is at the bottom of listview.
    private int mTotalItemCount;
    // for mScroller, scroll back from header or footer.
    private int mScrollBack;
    private final static int SCROLLBACK_HEADER = 0;
    private final static int SCROLLBACK_FOOTER = 1;

    private final static int SCROLL_DURATION = 400; // scroll back duration
    // private final static int PULL_LOAD_MORE_DELTA = 50; // when pull up >=
    // 50px
    // at bottom, trigger
    // load more.
    private final static float OFFSET_RADIO = 1.8f; // support iOS like pull
                                                    // feature.

    private long refreshTime = 0;
    private Context context = null;
    private int totalItemCount = 1000;
    private static final int LAST_REFRESH_TIME = 1000;
    
    private static final float ALMOST_READY_RATE = 0.2f; // "只差一点"状态所占的高度比例（4.5新增）
    

    /**
     * @param context
     */
    public PullToRefreshListView(Context context) {
        super(context);
        initWithContext(context);
    }

    public PullToRefreshListView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initWithContext(context);
    }

    public PullToRefreshListView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initWithContext(context);
    }

    private void initWithContext(Context context) {
        mScroller = new Scroller(context, new DecelerateInterpolator());
        // XListView need the scroll event, and it will dispatch the event to
        // user's listener (as a proxy).
        super.setOnScrollListener(this);
        this.context = context;
        // init header view
        mHeaderView = new PullToRefreshListViewHeader(context);
        mHeaderViewContent = (RelativeLayout) mHeaderView.findViewById(R.id.xlistview_header_content);
        addHeaderView(mHeaderView);

        // init footer view
        mFooterView = new PullToRefreshListViewFooter(context);
        mFooterView.hide();

        // init header height
        mHeaderView.getViewTreeObserver().addOnGlobalLayoutListener(new OnGlobalLayoutListener() {
            @Override
            public void onGlobalLayout() {
                mHeaderViewHeight = mHeaderViewContent.getHeight();
                getViewTreeObserver().removeGlobalOnLayoutListener(this);
            }
        });
    }

    @Override
    public void setAdapter(ListAdapter adapter) {
        // make sure XListViewFooter is the last footer view, and only add once.
        if (mIsFooterReady == false) {
            mIsFooterReady = true;
            addFooterView(mFooterView);
        }
        super.setAdapter(adapter);
    }

    /**
     * enable or disable pull down refresh feature.
     * 
     * @param enable
     */
    public void setPullRefreshEnable(boolean enable) {
        mEnablePullRefresh = enable;
        if (!mEnablePullRefresh) { // disable, hide the content
            mHeaderViewContent.setVisibility(View.GONE);
        } else {
            mHeaderViewContent.setVisibility(View.VISIBLE);
        }
    }

    /**
     * enable or disable pull up load more feature.
     * 
     * @param enable
     */
    public void setPullLoadEnable(boolean enable) {
        mEnablePullLoad = enable;
        if (!mEnablePullLoad) {
            mFooterView.hide();
        } else {
            mPullLoading = false;
            mFooterView.show();
            mFooterView.setState(PullToRefreshListViewFooter.STATE_NORMAL);
        }
    }

    public void stopRefresh(final boolean success) {
        // Logs.d(TAG, "==============================================");
        if (mPullRefreshing == true) {
            mResetHeaderHandler.removeCallbacks(mResetHeaderRunable);

            mPullRefreshing = false;
            long times = System.currentTimeMillis() - refreshTime;
            if (!success) {
            	resetHeaderHeight();
			} else if (times >= LAST_REFRESH_TIME) {
                mHeaderView.setState(PullToRefreshListViewHeader.STATE_COMPLETE);
                mResetHeaderHandler.postDelayed((mResetHeaderRunable = new Runnable() {
                    @Override
                    public void run() {
                        resetHeaderHeight();

                    }
                }), LAST_REFRESH_TIME);

            } else {
                mHeaderView.setState(PullToRefreshListViewHeader.STATE_COMPLETE);
                mResetHeaderHandler.postDelayed((mResetHeaderRunable = new Runnable() {
                    @Override
                    public void run() {
                        resetHeaderHeight();

                    }
                }), LAST_REFRESH_TIME - times);
            }
        }
    }

    private Handler mResetHeaderHandler = new Handler();
    private Runnable mResetHeaderRunable;

    /**
     * stop load more, reset footer view.
     */
    public void stopLoadMore() {
        if (mPullLoading == true) {
            mPullLoading = false;
            mFooterView.hide();
            mFooterView.setState(PullToRefreshListViewFooter.STATE_NORMAL);
        }
    }

    private void invokeOnScrolling() {
        if (mScrollListener instanceof OnXScrollListener) {
            OnXScrollListener l = (OnXScrollListener) mScrollListener;
            l.onXScrolling(this);
        }
    }

    private void updateHeaderHeight(float delta) {
        mHeaderView.setVisiableHeight((int) delta + mHeaderView.getVisiableHeight());
        if (mEnablePullRefresh) { // 未处于刷新状态，更新箭头
        	int visibleHeight = mHeaderView.getVisiableHeight();
            if (visibleHeight > mHeaderViewHeight*(1+ALMOST_READY_RATE)) {
                mHeaderView.setState(PullToRefreshListViewHeader.STATE_READY);
            } else if (visibleHeight <= mHeaderViewHeight*(1+ALMOST_READY_RATE) && visibleHeight > mHeaderViewHeight*(1-ALMOST_READY_RATE)) {
            	mHeaderView.setState(PullToRefreshListViewHeader.STATE_ALMOST_READY);
			} else {
                mHeaderView.setState(PullToRefreshListViewHeader.STATE_NORMAL);
            }
            if (mPullRefreshing && pullAndRefreshListViewListener!=null){
                pullAndRefreshListViewListener.onLoadCancel();
            }
            mPullRefreshing = false;
        }
        setSelection(0); // scroll to top each time
    }

    /**
     * reset header view's height.
     */
    private void resetHeaderHeight() {
        int height = mHeaderView.getVisiableHeight();
        if (height <= 0) // not visible.
            return;
        // refreshing and header isn't shown fully. do nothing.
        if (mPullRefreshing && height <= mHeaderViewHeight*(1+ALMOST_READY_RATE)) {
            return;
        }
        int finalHeight = 0; // default: scroll back to dismiss header.
        // is refreshing, just scroll back to show all the header.
        if (mPullRefreshing && height > mHeaderViewHeight*(1+ALMOST_READY_RATE)) {
            finalHeight = (int) (mHeaderViewHeight*(1+ALMOST_READY_RATE));
        }
        mScrollBack = SCROLLBACK_HEADER;
        mScroller.startScroll(0, height, 0, finalHeight - height, SCROLL_DURATION);
        // trigger computeScroll
        invalidate();
    }

    public void showHeaderAndRefresh() {
        // 1 改变当前显示的时间，以便下一次显示
        mPullRefreshing = true;
        mHeaderView.setState(PullToRefreshListViewHeader.STATE_REFRESHING);
        if (pullAndRefreshListViewListener != null) {
            refreshTime = System.currentTimeMillis();
            pullAndRefreshListViewListener.onRefresh();
        }
        mScroller.startScroll(0, 0, 0, (int) (mHeaderViewHeight*(1+ALMOST_READY_RATE)), SCROLL_DURATION);
        invalidate();
    }

    public void refresh() {
    	mPullRefreshing = true;
        if (pullAndRefreshListViewListener != null) {
            refreshTime = System.currentTimeMillis();
            pullAndRefreshListViewListener.onRefresh();
        }
    }

    private void startLoadMore() {
        mPullLoading = true;
        mFooterView.setState(PullToRefreshListViewFooter.STATE_LOADING);
        if (pullAndRefreshListViewListener != null) {
            mFooterView.show();
            pullAndRefreshListViewListener.onLoadMore();
        }
    }

    /** 滑动方向 */
    private int mDirection = DIRECTION_NONE;
    /** 方向向上 */
    private static final int DIRECTION_UP = 0X1;
    /** 方向向下 */
    private static final int DIRECTION_DOWN = 0X2;
    /** 点击之后不动 */
    private static final int DIRECTION_NONE = 0x3;

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        if (mLastY == -1) {
            mLastY = ev.getRawY();
        }
        switch (ev.getAction()) {
        case MotionEvent.ACTION_DOWN:
            mDirection = DIRECTION_NONE;
            mLastY = ev.getRawY();
            break;
        case MotionEvent.ACTION_MOVE:
            final float deltaY = ev.getRawY() - mLastY;
            if (deltaY > 0) {
                mDirection = DIRECTION_UP;
            } else if (deltaY < 0) {
                mDirection = DIRECTION_DOWN;
            }
            mLastY = ev.getRawY();
            if (getFirstVisiblePosition() == 0 && (mHeaderView.getVisiableHeight() > 0 || deltaY > 0)) {
                // the first item is showing, header has shown or pull down.
                updateHeaderHeight(deltaY / OFFSET_RADIO);
                invokeOnScrolling();
            } else if (getLastVisiblePosition() == mTotalItemCount - getHeaderViewsCount()) {
                // last item, already pulled up or want to pull up.
                // updateFooterHeight(-deltaY / OFFSET_RADIO);
            }
            break;
        default:
            mLastY = -1; // reset
            if (getFirstVisiblePosition() == 0) {
                // invoke refresh
                if (mEnablePullRefresh && mHeaderView.getVisiableHeight() > mHeaderViewHeight*(1+ALMOST_READY_RATE)) {
                    mPullRefreshing = true;
                    mHeaderView.setState(PullToRefreshListViewHeader.STATE_REFRESHING);
                    if (pullAndRefreshListViewListener != null) {
                        refreshTime = System.currentTimeMillis();
                        pullAndRefreshListViewListener.onRefresh();
                    }
                }
                resetHeaderHeight();
            } else if (getLastVisiblePosition() == mTotalItemCount - 2) {
            }
            break;
        }
        return super.onTouchEvent(ev);
    }

    @Override
    public void computeScroll() {
        if (mScroller.computeScrollOffset()) {
            if (mScrollBack == SCROLLBACK_HEADER) {
                mHeaderView.setVisiableHeight(mScroller.getCurrY());
            } else {
                mFooterView.setBottomMargin(mScroller.getCurrY());
            }
            postInvalidate();
            invokeOnScrolling();
        }
        super.computeScroll();
    }

    @Override
    public void setOnScrollListener(OnScrollListener l) {
        mScrollListener = l;
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (mScrollListener != null) {
            mScrollListener.onScrollStateChanged(view, scrollState);
        }
        int lastVisiPos = this.getLastVisiblePosition();
        int visiblePosition = view.getLastVisiblePosition() - view.getFirstVisiblePosition();
        if (lastVisiPos == this.totalItemCount - 1 && !mPullLoading && !mPullRefreshing && mEnablePullLoad && visiblePosition < this.totalItemCount - 1
//                && mDirection == DIRECTION_UP
                ) {
            startLoadMore();
        }
    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        // send to user's listener
        mTotalItemCount = totalItemCount;
        if (mScrollListener != null) {
            mScrollListener.onScroll(view, firstVisibleItem, visibleItemCount, totalItemCount);
        }
        this.totalItemCount = totalItemCount;
    }

    public void setPullAndRefreshListViewListener(PullAndRefreshListViewListener l) {
        pullAndRefreshListViewListener = l;
    }

    /**
     * you can listen ListView.OnScrollListener or this one. it will invoke
     * onXScrolling when header/footer scroll back.
     */
    public interface OnXScrollListener extends OnScrollListener {
        public void onXScrolling(View view);
    }

    /**
     * implements this interface to get refresh/load more event.
     */
    public interface PullAndRefreshListViewListener {
        public void onRefresh();

        public void onLoadMore();

        public void onLoadCancel();
    }

    public void hideFooterView() {
        if (null != mFooterView) {
            mFooterView.hide();
        }
    }

}
