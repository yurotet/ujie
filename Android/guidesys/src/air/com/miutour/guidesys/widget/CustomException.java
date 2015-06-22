package air.com.miutour.guidesys.widget;

import air.com.miutour.R;
import air.com.miutour.guidesys.util.NetworkUtils;
import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * 自定义异常view
 * 
 * @author mac
 * 
 */
public class CustomException extends RelativeLayout {
    private Context context;
    private LinearLayout mExceptionLayout;// 异常页面
    private ImageView exceptionImageView; // 异常图片
    private TextView hintTextView; // 异常文案提示
    private ProgressBar mProgressBar;
    private LoadViewReloadListener reLoadListener; // 点击异常页面监听器

    public CustomException(Context context) {
        super(context);

        this.context = context;
        inflateResource(context);
        initView();
    }

    public CustomException(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
        inflateResource(context);
        initView();
    }

    public CustomException(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        this.context = context;
        inflateResource(context);
        initView();
    }

    public void setEnableVisibile(boolean isShow) {
        if (isShow) {
            this.setVisibility(View.VISIBLE);
        } else {
            this.setVisibility(View.GONE);
        }
    }

    private void inflateResource(Context context) {
        LayoutInflater.from(context).inflate(R.layout.app_exception, this);
    }

    private void initView() {
        mProgressBar = (ProgressBar) this.findViewById(R.id.app_progressbar);
        mExceptionLayout = (LinearLayout) this.findViewById(R.id.exceptionLayout);
        exceptionImageView = (ImageView) this.findViewById(R.id.exception_img);
        hintTextView = (TextView) this.findViewById(R.id.excetion_hint);
        mExceptionLayout.setOnClickListener(clickListener);
        mExceptionLayout.setBackgroundResource(R.color.white);
    }

    /**
     * 加载数据仅菊花显示 true
     */
    public void loading(boolean hideback) {
        if (hideback) {
            this.setBackgroundColor(context.getResources().getColor(R.color.transparent));
        }
        this.setVisibility(View.VISIBLE);
        mExceptionLayout.setVisibility(View.GONE);
        mProgressBar.setVisibility(View.VISIBLE);
    }

    /**
     * 加载数据菊花显示,背景为白
     */
    public void loading() {
        loading(false);
    }

    /**
     * 数据加载完,一般在onSuccess和onFailure调用
     */
    public void loaded() {
        mProgressBar.setVisibility(View.INVISIBLE);
        this.setVisibility(View.GONE);
    }

    /**
     * 获得加载框组件
     * 
     * @return
     */
    public ProgressBar getProgressBar() {
        return mProgressBar;
    }

    /**
     * 获得加载框组件
     * 
     * @return
     */
    public LinearLayout getExceptionView() {
        return mExceptionLayout;
    }

    /**
     * 返回异常图片组件
     * 
     * @return
     */
    public ImageView getExceptionIV() {
        return exceptionImageView;
    }

    public static String replaceBr(String str) {
        if (str == null || "".equals(str)) {
            return "";
        }
        return str.replaceAll("(?i)<br>", "\n").replace("，", ",");
    }

    /**
     * 异常时点击重新做加载所要用到的监听器，必须手动set进来
     * 
     * @param reLoadListener
     */
    public void setClickReLoadListener(LoadViewReloadListener reLoadListener) {
        this.reLoadListener = reLoadListener;
    }

    /**
     * 取消异常页面点击监听，因为有成功正确加载数据但无数据特殊异常页面。
     */
    public void offClickReLoadListener() {
        mExceptionLayout.setEnabled(false);
    }

    /**
     * 显示没有访问到相关数据的异常页
     */
    public void showNoDataExceptionView() {
        setNoDataDefaultHit();
        offClickReLoadListener();
        mExceptionLayout.setVisibility(View.VISIBLE);
    }

    public void hideHit() {
            if (hintTextView != null) {
            hintTextView.setVisibility(View.GONE);
        }
    }

    /**
     * 自定义异常提示
     * 
     * @param content
     */
    public void setCustomHit(String content) {
        if (hintTextView != null) {
            hintTextView.setText(content);
            hintTextView.setVisibility(View.VISIBLE);
            if (exceptionImageView != null)
                exceptionImageView.setVisibility(View.VISIBLE);
            this.setVisibility(View.VISIBLE);
        }
    }

    /**
     * 正常加载，下载不到数据时调用此方法
     */
    public void setNoDataDefaultHit() {
        if (hintTextView != null) {
            hintTextView.setText(context.getString(R.string.hit_no_data));
            hintTextView.setVisibility(View.VISIBLE);
            if (exceptionImageView != null)
                exceptionImageView.setVisibility(View.VISIBLE);
            this.setVisibility(View.VISIBLE);
        }
    }

    public void loadFaile() {
        try {
            if (!NetworkUtils.isNetworkAvailable(context)) {// 魔方上该处有报空异常
                setNetworkException();
            } else {
                setLoadFaileException();
            }
        } catch (Exception e) {
            setNetworkException();
            e.printStackTrace();
        }
        setVisible(false, true);
    }

    /**
     * 设置加载失败时 如：json解析失败
     */
    public void setLoadFaileException() {
        if (hintTextView != null) {
            hintTextView.setText(context.getString(R.string.hit_load_data_failure));
            hintTextView.setVisibility(View.VISIBLE);
            if (exceptionImageView != null)
                exceptionImageView.setVisibility(View.VISIBLE);
            this.setVisibility(View.VISIBLE);
        }
    }

    /**
     * 设置网络异常时 如网络未连接
     */
    public void setNetworkException() {
        mExceptionLayout.setEnabled(true);
        if (hintTextView != null) {
            hintTextView.setText(context.getString(R.string.hit_network_failure));
            hintTextView.setVisibility(View.VISIBLE);
            if (exceptionImageView != null)
                exceptionImageView.setVisibility(View.VISIBLE);
            this.setVisibility(View.VISIBLE);
        }
    }

    private void setViewVisible(final View v, final boolean visible) {
        if (null != v) {
            if (visible) {
                v.setVisibility(View.VISIBLE);
            } else {
                v.setVisibility(View.GONE);
            }
        }
    }

    /**
     * 需要显示组件与否
     * 
     * @param progressVisible
     * @param exceptionVisible
     */
    public void setVisible(final boolean progressVisible, final boolean exceptionVisible) {
        setViewVisible(mProgressBar, progressVisible);
        setViewVisible(mExceptionLayout, exceptionVisible);
        if (null != context) {
            if (!progressVisible && !exceptionVisible) {
                this.setVisibility(View.GONE);
            } else {
                this.setVisibility(View.VISIBLE);
                if (progressVisible) {
                    this.setBackgroundColor(context.getResources().getColor(R.color.transparent));
                } else {
                        this.setBackgroundColor(context.getResources().getColor(R.color.white));
                }
            }
        }
    }

    /**
     * 返回异常文本组件
     * 
     * @return
     */
    public TextView getExcepitonHitTV() {
        return hintTextView;
    }

    /**
     * 对异常图片进行设置
     * 
     * @param resId
     */
    public void setExcepitonIV(int resId) {
        if (exceptionImageView != null) {
            exceptionImageView.setImageResource(resId);
        }
    }



    /**
     * 重新加载监听器
     */
    public interface LoadViewReloadListener {
        public void reLoad();
    }

    private OnClickListener clickListener = new OnClickListener() {

        @Override
        public void onClick(View v) {
            int id = v.getId();
            if (id == R.id.exceptionLayout) {
                if (reLoadListener != null) {
                    loading();
                    reLoadListener.reLoad();
                }
            }
        }
    };
}
