package air.com.miutour.guidesys.widget;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.support.v4.view.MotionEventCompat;
import android.support.v4.view.VelocityTrackerCompat;
import android.support.v4.view.ViewConfigurationCompat;
import android.util.AttributeSet;
import android.util.FloatMath;
import android.util.Log;
import android.view.Display;
import android.view.MotionEvent;
import android.view.VelocityTracker;
import android.view.View;
import android.view.ViewConfiguration;
import android.view.WindowManager;
import android.view.animation.Interpolator;
import android.widget.FrameLayout;
import android.widget.Scroller;

import java.lang.reflect.Method;

public class SlidingLayer extends FrameLayout {

    // TODO Document

    /**
     * Default value for the position of the layer. STICK_TO_AUTO shall inspect the container and choose a stick
     * mode depending on the position of the layour (ie.: layout is positioned on the right = STICK_TO_RIGHT).
     */
    public static final int STICK_TO_AUTO = 0;

    /**
     * Special value for the position of the layer. STICK_TO_RIGHT means that the view shall be attached to the
     * right side of the screen, and come from there into the viewable area.
     */
    public static final int STICK_TO_BOTTOM = -1;

    /**
     * Special value for the position of the layer. STICK_TO_LEFT means that the view shall be attached to the left
     * side of the screen, and come from there into the viewable area.
     */
    public static final int STICK_TO_TOP = -2;

    /**
     * Special value for the position of the layer. STICK_TO_MIDDLE means that the view will stay attached trying to
     * be in the middle of the screen and allowing dismissing both to right and left side.
     */
    public static final int STICK_TO_MIDDLE = -3;

    
    /*动画出入的最大推荐时间*/
    public static final int RECOMMEND_MAX_SCROLLING_DURATION = 600;//ms
    
    /*快速滑动其作用的最短推荐距离*/
    public static final int RECOMMEND_MIN_DISTANCE_FOR_FLING = 100;//dip
    
    
    private  int MAX_SCROLLING_DURATION = RECOMMEND_MAX_SCROLLING_DURATION; // in ms
    private int MIN_DISTANCE_FOR_FLING = RECOMMEND_MIN_DISTANCE_FOR_FLING; // in dip
    
    
    public void setMaxScrollDuration(int time){
    	MAX_SCROLLING_DURATION = time;
    }
    public void setMinDistanceFling(int dip){
    	MIN_DISTANCE_FOR_FLING = dip;
    }

    private static final Interpolator sMenuInterpolator = new Interpolator() {
        @Override
        public float getInterpolation(float t) {
            t -= 1.0f;
            return (float) Math.pow(t, 5) + 1.0f;
        }
    };

    private Scroller mScroller;

    private int mShadowWidth;
    private Drawable mShadowDrawable;

    private boolean mDrawingCacheEnabled;

    private int mScreenSide = STICK_TO_AUTO;
    private boolean closeOnTapEnabled = true;

    private boolean mEnabled = true;
    private boolean mSlidingFromShadowEnabled = true;
    private boolean mIsDragging;
    private boolean mIsUnableToDrag;
    private int mTouchSlop;

    private float mLastX = -1;
    private float mLastY = -1;
    private float mInitialY = -1;

    protected int mActivePointerId = INVALID_POINTER;

    /**
     * Sentinel value for no current active pointer. Used by {@link #mActivePointerId}.
     */
    private static final int INVALID_POINTER = -1;

    private boolean mIsOpen;
    private boolean mScrolling;

    private OnInteractListener mOnInteractListener;
    private OnScrollListener mOnScrollListener;

    protected VelocityTracker mVelocityTracker;
    private int mMinimumVelocity;
    protected int mMaximumVelocity;
    private int mFlingDistance;

    private boolean mLastTouchAllowed = false;

    public SlidingLayer(Context context) {
        this(context, null);
    }

    public SlidingLayer(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public SlidingLayer(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);

        // Style
        //TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.SlidingLayer);

        // Set the side of the screen
        setStickTo(STICK_TO_BOTTOM);

        // Sets the shadow drawable
        /*int shadowRes = ta.getResourceId(R.styleable.SlidingLayer_shadowDrawable, -1);
        if (shadowRes != -1) {
            setShadowDrawable(shadowRes);
        }*/

        // Sets the shadow width
       // setShadowWidth(10);

        // Sets the ability to close the layer by tapping in any empty space
        closeOnTapEnabled = false;

        //ta.recycle();

        init();
    }

    private void init() {
        setWillNotDraw(false);
        setDescendantFocusability(FOCUS_AFTER_DESCENDANTS);
        setFocusable(true);
        final Context context = getContext();
        mScroller = new Scroller(context, sMenuInterpolator);
        final ViewConfiguration configuration = ViewConfiguration.get(context);
        mTouchSlop = ViewConfigurationCompat.getScaledPagingTouchSlop(configuration)/2;
        mMinimumVelocity = configuration.getScaledMinimumFlingVelocity();
        mMaximumVelocity = configuration.getScaledMaximumFlingVelocity();

        final float density = context.getResources().getDisplayMetrics().density;
        mFlingDistance = (int) (MIN_DISTANCE_FOR_FLING * density);
    }

    public interface OnInteractListener {

        public void onOpen();

        public void onClose();

        public void onOpened();

        public void onClosed();
    }

    public interface OnScrollListener {
    	public void OnScroll(float percent);
    }
    
    public boolean isOpened() {
        return mIsOpen;
    }

    public void openLayer(boolean smoothAnim) {
        openLayer(smoothAnim, false);
    }

    private void openLayer(boolean smoothAnim, boolean forceOpen) {
        switchLayer(true, smoothAnim, forceOpen, 0);
    }

    public void closeLayer(boolean smoothAnim) {
        closeLayer(smoothAnim, false);
    }

    private void closeLayer(boolean smoothAnim, boolean forceClose) {
        switchLayer(false, smoothAnim, forceClose, 0);
    }

    private void switchLayer(boolean open, boolean smoothAnim, boolean forceSwitch) {
        switchLayer(open, smoothAnim, forceSwitch, 0);
    }

    private void switchLayer(boolean open, boolean smoothAnim, boolean forceSwitch, int velocity) {
        if (!forceSwitch && open == mIsOpen) {
            setDrawingCacheEnabled(false);
            return;
        }
        if (open) {
            if (mOnInteractListener != null) {
                mOnInteractListener.onOpen();
            }
        } else {
            if (mOnInteractListener != null) {
                mOnInteractListener.onClose();
            }
        }

        mIsOpen = open;

        final int destY = getDestScrollY(velocity);

        if (smoothAnim) {
            smoothScrollTo(0, destY, velocity);
        } else {
            completeScroll();
            scrollTo(0, destY);
        }
    }

    /**
     * Sets the listener to be invoked after a switch change {@link OnInteractListener}.
     * 
     * @param listener
     *            Listener to set
     */
    public void setOnInteractListener(OnInteractListener listener) {
        mOnInteractListener = listener;
    }
    
    public void setOnScrollListener(OnScrollListener listener) {
		mOnScrollListener = listener;
	}

    /**
     * Sets the shadow of the width which will be included within the view by using padding since it's on the left
     * of the view in this case
     * 
     * @param shadowWidth
     *            Desired width of the shadow
     * @see #getShadowWidth()
     * @see #setShadowDrawable(Drawable)
     * @see #setShadowDrawable(int)
     */
    public void setShadowWidth(int shadowWidth) {
        mShadowWidth = shadowWidth;
        invalidate(getLeft(), getTop(), getRight(), getBottom());
    }

    /**
     * Sets the shadow width by the value of a resource.
     * 
     * @param resId
     *            The dimension resource id to be set as the shadow width.
     */
    public void setShadowWidthRes(int resId) {
        setShadowWidth((int) getResources().getDimension(resId));
    }

    /**
     * Return the current with of the shadow.
     * 
     * @return The size of the shadow in pixels
     */
    public int getShadowWidth() {
        return mShadowWidth;
    }

    /**
     * Sets a drawable that will be used to create the shadow for the layer.
     * 
     * @param d
     *            Drawable append as a shadow
     */
    public void setShadowDrawable(Drawable d) {
        mShadowDrawable = d;
        refreshDrawableState();
        setWillNotDraw(false);
        invalidate(getLeft(), getTop(), getRight(), getBottom());
    }

    /**
     * Sets a drawable resource that will be used to create the shadow for the layer.
     * 
     * @param resId
     *            Resource ID of a drawable
     */
    public void setShadowDrawable(int resId) {
        setShadowDrawable(getContext().getResources().getDrawable(resId));
    }

    @Override
    protected boolean verifyDrawable(Drawable who) {
        return super.verifyDrawable(who) || who == mShadowDrawable;
    }

    @Override
    protected void drawableStateChanged() {
        super.drawableStateChanged();
        final Drawable d = mShadowDrawable;
        if (d != null && d.isStateful()) {
            d.setState(getDrawableState());
        }
    }

    public boolean isSlidingEnabled() {
        return mEnabled;
    }

    public void setSlidingEnabled(boolean _enabled) {
        mEnabled = _enabled;
    }

    public boolean isSlidingFromShadowEnabled() {
        return mSlidingFromShadowEnabled;
    }

    public void setSlidingFromShadowEnabled(boolean _slidingShadow) {
        mSlidingFromShadowEnabled = _slidingShadow;
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent ev) {

        try {
			if (!mEnabled) {
				return false;
			}
			final int action = ev.getAction();// & MotionEventCompat.ACTION_MASK;
			if (action == MotionEvent.ACTION_CANCEL
					|| action == MotionEvent.ACTION_UP) {
				mIsDragging = false;
				mIsUnableToDrag = false;
				mActivePointerId = INVALID_POINTER;
				if (mVelocityTracker != null) {
					mVelocityTracker.recycle();
					mVelocityTracker = null;
				}
				return false;
			}
			switch (action) {
			case MotionEvent.ACTION_MOVE:
				/* final int activePointerId = mActivePointerId;
				 if (activePointerId == INVALID_POINTER) {
				     break;
				 }

				 final int pointerIndex = MotionEventCompat.findPointerIndex(ev, activePointerId);
				 if (pointerIndex == -1) {
				     mActivePointerId = INVALID_POINTER;
				     break;
				 }*/

				final float x = ev.getRawX();//MotionEventCompat.getX(ev, pointerIndex);
				final float dx = x - mLastX;
				final float xDiff = Math.abs(dx);
				final float y = ev.getRawY();//MotionEventCompat.getY(ev, pointerIndex);
				final float yDiff = Math.abs(y - mLastY);
				if (yDiff - xDiff > 15) {
					mIsDragging = true;
					mLastX = x;
					mLastY = y;
					setDrawingCacheEnabled(true);
				} else {
					mIsDragging = false;
					mLastX = x;
					mLastY = y;
				}
				break;

			case MotionEvent.ACTION_DOWN:
				mActivePointerId = ev.getAction();
				mLastX = ev.getRawX();//MotionEventCompat.getX(ev, mActivePointerId);
				mLastY = mInitialY = ev.getRawY();//MotionEventCompat.getY(ev, mActivePointerId);
				if (allowSlidingFromHere(ev)) {
					mIsDragging = false;
					mIsUnableToDrag = false;
					// If nobody else got the focus we use it to close the layer
					return super.onInterceptTouchEvent(ev);
				} else {
					mIsUnableToDrag = true;
				}
				break;
			case MotionEventCompat.ACTION_POINTER_UP:
				onSecondaryPointerUp(ev);
				break;
			}
			if (!mIsDragging) {
				if (mVelocityTracker == null) {
					mVelocityTracker = VelocityTracker.obtain();
				}
				mVelocityTracker.addMovement(ev);
			}
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
			return false;
		}
		return mIsDragging;
    }

    @Override
    public boolean onTouchEvent(MotionEvent ev) {
        try {
			if (!mEnabled || !mIsDragging && !mLastTouchAllowed && !allowSlidingFromHere(ev)) {
			    return false;
			}

			final int action = ev.getAction();

			if (action == MotionEvent.ACTION_UP || action == MotionEvent.ACTION_CANCEL
			        || action == MotionEvent.ACTION_OUTSIDE) {
			    mLastTouchAllowed = false;
			} else {
			    mLastTouchAllowed = true;
			}

			if (mVelocityTracker == null) {
			    mVelocityTracker = VelocityTracker.obtain();
			}
			mVelocityTracker.addMovement(ev);

			switch (action & MotionEventCompat.ACTION_MASK) {
			case MotionEvent.ACTION_DOWN:
			    completeScroll();

			    // Remember where the motion event started
			    mLastY = mInitialY = ev.getY();
			    mActivePointerId = MotionEventCompat.getPointerId(ev, 0);
			    break;
			case MotionEvent.ACTION_MOVE:
			    if (!mIsDragging) {
			        final int pointerIndex = MotionEventCompat.findPointerIndex(ev, mActivePointerId);
			        if (pointerIndex == -1) {
			            mActivePointerId = INVALID_POINTER;
			            break;
			        }
			        final float x = MotionEventCompat.getX(ev, pointerIndex);
			        final float xDiff = Math.abs(x - mLastX);
			        final float y = MotionEventCompat.getY(ev, pointerIndex);
			        final float yDiff = Math.abs(y - mLastY);
			        if (yDiff > mTouchSlop && yDiff > xDiff) {
			            mIsDragging = true;
			            mLastY = y;
			            setDrawingCacheEnabled(true);
			        }
			    }
			    if (mIsDragging) {
			        // Scroll to follow the motion event
			        final int activePointerIndex = MotionEventCompat.findPointerIndex(ev, mActivePointerId);
			        if (activePointerIndex == -1) {
			            mActivePointerId = INVALID_POINTER;
			            break;
			        }
			        final float y = MotionEventCompat.getY(ev, activePointerIndex);
			        final float deltaY = mLastY - y;
			        mLastY = y;
			        float oldScrollY = getScrollY();
			        float scrollY = oldScrollY + deltaY;
			        final float topBound = mScreenSide < STICK_TO_BOTTOM ? getHeight() : 0;
			        final float bottomBound = mScreenSide == STICK_TO_TOP ? 0 : -getHeight();
			        if (scrollY > topBound) {
			            scrollY = topBound;
			        } else if (scrollY < bottomBound) {
			            scrollY = bottomBound;
			        }
			        // Keep the precision
			        mLastY += scrollY - (int) scrollY;
			        scrollTo(getScrollX(), (int) scrollY);
			    }
			    break;
			case MotionEvent.ACTION_UP:
			    if (mIsDragging) {
			        final VelocityTracker velocityTracker = mVelocityTracker;
			        velocityTracker.computeCurrentVelocity(1000, mMaximumVelocity);
			        int initialVelocity = (int) VelocityTrackerCompat.getYVelocity(velocityTracker, mActivePointerId);
			        final int scrollY = getScrollY();
			        final int activePointerIndex = MotionEventCompat.findPointerIndex(ev, mActivePointerId);
			        final float y = MotionEventCompat.getY(ev, activePointerIndex);
			        final int totalDelta = (int) (y - mInitialY);
			        boolean nextStateOpened = determineNextStateOpened(mIsOpen, scrollY, initialVelocity, totalDelta);
			        switchLayer(nextStateOpened, true, true, initialVelocity);

			        mActivePointerId = INVALID_POINTER;
			        endDrag();
			    } else if (mIsOpen && closeOnTapEnabled) {
			        closeLayer(true);
			    }
			    break;
			case MotionEvent.ACTION_CANCEL:
			    if (mIsDragging) {
			        switchLayer(mIsOpen, true, true);
			        mActivePointerId = INVALID_POINTER;
			        endDrag();
			    }
			    break;
			case MotionEventCompat.ACTION_POINTER_DOWN: {
			    final int index = MotionEventCompat.getActionIndex(ev);
			    final float y = MotionEventCompat.getY(ev, index);
			    mLastY = y;
			    mActivePointerId = MotionEventCompat.getPointerId(ev, index);
			    break;
			}
			case MotionEventCompat.ACTION_POINTER_UP:
			    onSecondaryPointerUp(ev);
			    mLastY = MotionEventCompat.getY(ev, MotionEventCompat.findPointerIndex(ev, mActivePointerId));
			    break;
			}
			if (mActivePointerId == INVALID_POINTER) {
			    mLastTouchAllowed = false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
        return true;
    }

    private boolean allowSlidingFromHere(MotionEvent ev) {
        return mIsOpen /* && allowSlidingFromShadow || ev.getX() > mShadowWidth */;
    }

    private boolean allowDraging(float dx) {
        return mIsOpen && dx > 0;
    }

    private boolean determineNextStateOpened(boolean currentState, float swipeOffset, int velocity, int deltaY) {
        boolean targetState;

        if (Math.abs(deltaY) > mFlingDistance && Math.abs(velocity) > mMinimumVelocity) {

            targetState = mScreenSide == STICK_TO_BOTTOM && velocity <= 0 || mScreenSide == STICK_TO_TOP
                    && velocity > 0;

        } else {
            int h = getHeight();

            if (mScreenSide == STICK_TO_BOTTOM) {
                targetState = swipeOffset > -h / 2;
            } else if (mScreenSide == STICK_TO_TOP) {
                targetState = swipeOffset < h / 2;
            } else if (mScreenSide == STICK_TO_MIDDLE) {
                targetState = Math.abs(swipeOffset) < h / 2;
            } else {
                targetState = true;
            }
        }

        return targetState;
    }

    /**
     * Like {@link View#scrollBy}, but scroll smoothly instead of immediately.
     * 
     * @param x
     *            the number of pixels to scroll by on the X axis
     * @param y
     *            the number of pixels to scroll by on the Y axis
     */
    void smoothScrollTo(int x, int y) {
        smoothScrollTo(x, y, 0);
    }

    /**
     * Like {@link View#scrollBy}, but scroll smoothly instead of immediately.
     * 
     * @param x
     *            the number of pixels to scroll by on the X axis
     * @param y
     *            the number of pixels to scroll by on the Y axis
     * @param velocity
     *            the velocity associated with a fling, if applicable. (0 otherwise)
     */
    void smoothScrollTo(int x, int y, int velocity) {
        if (getChildCount() == 0) {
            setDrawingCacheEnabled(false);
            return;
        }
        int sx = getScrollX();
        int sy = getScrollY();
        int dx = x - sx;
        int dy = y - sy;
        if (dx == 0 && dy == 0) {
            completeScroll();
            if (mIsOpen) {
                if (mOnInteractListener != null) {
                    mOnInteractListener.onOpened();
                }
            } else {
                if (mOnInteractListener != null) {
                    mOnInteractListener.onClosed();
                }
            }
            return;
        }

        setDrawingCacheEnabled(true);
        mScrolling = true;

        final int height = getHeight();
        final int halfHeight = height / 2;
        final float distanceRatio = Math.min(1f, 1.0f * Math.abs(dy) / height);
        final float distance = halfHeight + halfHeight * distanceInfluenceForSnapDuration(distanceRatio);

        int duration = 0;
        velocity = Math.abs(velocity);
        if (velocity > 0) {
            duration = 4 * Math.round(1000 * Math.abs(distance / velocity));
        } else {
            duration = MAX_SCROLLING_DURATION;
        }
        duration = Math.min(duration, MAX_SCROLLING_DURATION);

        mScroller.startScroll(sx, sy, dx, dy, duration);
        invalidate();
    }

    // We want the duration of the page snap animation to be influenced by the distance that
    // the screen has to travel, however, we don't want this duration to be effected in a
    // purely linear fashion. Instead, we use this method to moderate the effect that the distance
    // of travel has on the overall snap duration.
    float distanceInfluenceForSnapDuration(float f) {
        f -= 0.5f; // center the values about 0.
        f *= 0.3f * Math.PI / 2.0f;
        return FloatMath.sin(f);
    }

    private void endDrag() {
        mIsDragging = false;
        mIsUnableToDrag = false;
        mLastTouchAllowed = false;

        if (mVelocityTracker != null) {
            mVelocityTracker.recycle();
            mVelocityTracker = null;
        }
    }

    @Override
    public void setDrawingCacheEnabled(boolean enabled) {

        if (mDrawingCacheEnabled != enabled) {
            super.setDrawingCacheEnabled(enabled);
            mDrawingCacheEnabled = enabled;

            final int l = getChildCount();
            for (int i = 0; i < l; i++) {
                final View child = getChildAt(i);
                if (child.getVisibility() != GONE) {
                    child.setDrawingCacheEnabled(enabled);
                }
            }
        }
    }

    private void onSecondaryPointerUp(MotionEvent ev) {
        final int pointerIndex = MotionEventCompat.getActionIndex(ev);
        final int pointerId = MotionEventCompat.getPointerId(ev, pointerIndex);
        if (pointerId == mActivePointerId) {
            // This was our active pointer going up. Choose a new
            // active pointer and adjust accordingly.
            final int newPointerIndex = pointerIndex == 0 ? 1 : 0;
            mLastX = MotionEventCompat.getX(ev, newPointerIndex);
            mActivePointerId = MotionEventCompat.getPointerId(ev, newPointerIndex);
            if (mVelocityTracker != null) {
                mVelocityTracker.clear();
            }
        }
    }

    private void completeScroll() {
        boolean needPopulate = mScrolling;
        if (needPopulate) {
            // Done with scroll, no longer want to cache view drawing.
            setDrawingCacheEnabled(false);
            mScroller.abortAnimation();
            int oldX = getScrollX();
            int oldY = getScrollY();
            int x = mScroller.getCurrX();
            int y = mScroller.getCurrY();
            if (oldX != x || oldY != y) {
                scrollTo(x, y);
            }
            if (mIsOpen) {
                if (mOnInteractListener != null) {
                    mOnInteractListener.onOpened();
                }
            } else {
                if (mOnInteractListener != null) {
                    mOnInteractListener.onClosed();
                }
            }
        }
        mScrolling = false;
    }

    public void setStickTo(int screenSide) {

        mScreenSide = screenSide;
        closeLayer(false, true);
    }

    public void setCloseOnTapEnabled(boolean _closeOnTapEnabled) {
        closeOnTapEnabled = _closeOnTapEnabled;
    }

    @SuppressWarnings("deprecation")
    private int getScreenSideAuto(int newTop, int newBottom) {

        int newScreenSide;

        if (mScreenSide == STICK_TO_AUTO) {
            int screenHeight;
            Display display = ((WindowManager) getContext().getSystemService(Context.WINDOW_SERVICE))
                    .getDefaultDisplay();
            try {
                Class<?> cls = Display.class;
                Class<?>[] parameterTypes = { Point.class };
                Point parameter = new Point();
                Method method = cls.getMethod("getSize", parameterTypes);
                method.invoke(display, parameter);
                screenHeight = parameter.y;
            } catch (Exception e) {
                screenHeight = display.getHeight();
            }

            boolean boundToTopBorder = newTop == 0;
            boolean boundToBottomBorder = newBottom == screenHeight;

            if (boundToTopBorder == boundToBottomBorder && getLayoutParams().height == android.view.ViewGroup.LayoutParams.MATCH_PARENT) {
                newScreenSide = STICK_TO_MIDDLE;
            } else if (boundToTopBorder) {
                newScreenSide = STICK_TO_TOP;
            } else {
                newScreenSide = STICK_TO_BOTTOM;
            }
        } else {
            newScreenSide = mScreenSide;
        }

        return newScreenSide;
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {

        int width = getDefaultSize(0, widthMeasureSpec);
        int height = getDefaultSize(0, heightMeasureSpec);
        setMeasuredDimension(width, height);

        super.onMeasure(getChildMeasureSpec(widthMeasureSpec, 0, width),
                getChildMeasureSpec(heightMeasureSpec, 0, height));
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        // Make sure scroll position is set correctly.
        if (w != oldw) {
            completeScroll();
            scrollTo(getScrollX(), getDestScrollY());
        }
    }

    // FIXME Draw with lefts and rights instead of paddings
    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {

        int screenSide = mScreenSide;

        if (mScreenSide == STICK_TO_AUTO) {
            screenSide = getScreenSideAuto(top, bottom);
        }

        if (screenSide != mScreenSide) {
            setStickTo(screenSide);

            if (mScreenSide == STICK_TO_BOTTOM) {
                setPadding(getPaddingLeft(), getPaddingTop() + mShadowWidth, getPaddingRight(), getPaddingBottom());
            } else if (mScreenSide == STICK_TO_TOP) {
                setPadding(getPaddingLeft(), getPaddingTop(), getPaddingRight(), getPaddingBottom() + mShadowWidth);
            } else if (mScreenSide == STICK_TO_MIDDLE) {
                setPadding(getPaddingLeft(), getPaddingTop() + mShadowWidth, getPaddingRight(),
                        getPaddingBottom() + mShadowWidth);
            }
        }

        super.onLayout(changed, left, top, right, bottom);
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
    }

    private int getDestScrollY() {
        return getDestScrollY(0);
    }

    private int getDestScrollY(int velocity) {
        if (mIsOpen) {
            return 0;
        } else {
            if (mScreenSide == STICK_TO_BOTTOM) {
                return -getHeight() + bottomMinHeight;
            } else if (mScreenSide == STICK_TO_TOP) {
                return getHeight();
            } else {
                if (velocity == 0) {
                    return getHeight();
                } else {
                    return velocity > 0 ? -getHeight() : getHeight();
                }
            }
        }
    }

    public int getContentLeft() {
        return getLeft() + getPaddingLeft();
    }

    @Override
    protected void dispatchDraw(Canvas canvas) {
        super.dispatchDraw(canvas);
        // Draw the margin drawable if needed.
        if (mShadowWidth > 0 && mShadowDrawable != null) {
            if (mScreenSide != STICK_TO_TOP) {
                mShadowDrawable.setBounds(0, 0, getWidth(), mShadowWidth);
            }
            if (mScreenSide < STICK_TO_BOTTOM) {
                mShadowDrawable.setBounds(0, getHeight() - mShadowWidth, getWidth(), getHeight());
            }
            mShadowDrawable.draw(canvas);
        }
    }

    @Override
    public void computeScroll() {
        if (!mScroller.isFinished()) {
            if (mScroller.computeScrollOffset()) {
                int oldX = getScrollX();
                int oldY = getScrollY();
                int x = mScroller.getCurrX();
                int y = mScroller.getCurrY();

                if (oldX != x || oldY != y) {
                    scrollTo(x, y);
                }

                // Keep on drawing until the animation has finished. Just re-draw the necessary part
                invalidate(getLeft(), getTop() + oldY, getRight(), getBottom());
                return;
            }
        }

        // Done with scroll, clean up state.
        completeScroll();
    }

    private int bottomMinHeight;

    public void setBottomMinHeight(int height) {
        bottomMinHeight = height;
    }

    @Override
    protected void onScrollChanged(int l, int t, int oldl, int oldt) {
    	if (mOnScrollListener != null) {
            int maxHeight = getHeight() - bottomMinHeight;
    		int current = t + maxHeight;
    		if (Math.abs(current - maxHeight) <= 2) {
				current = maxHeight;
			} else if (current <= 2) {
				current = 0;
			}
			mOnScrollListener.OnScroll((float)current / (float) maxHeight);
		}
    }
}
