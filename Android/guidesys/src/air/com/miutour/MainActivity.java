package air.com.miutour;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.MotionEvent;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.w3c.dom.Text;

import air.com.miutour.guidesys.model.Account;
import air.com.miutour.guidesys.module.LoginActivity;
import air.com.miutour.guidesys.module.order.OrderListFragment;
import air.com.miutour.guidesys.module.webview.WebViewActivity;
import air.com.miutour.guidesys.util.AccountUtil;
import air.com.miutour.guidesys.util.DisplayUtils;
import air.com.miutour.guidesys.util.IntentUtils;
import air.com.miutour.guidesys.widget.CircularImage;
import air.com.miutour.guidesys.widget.SlidingLayer;
import cn.com.crazydemon.imageloader.ImageLoader;
import cn.com.crazydemon.imageloader.ImageLoaderConfig;


public class MainActivity extends FragmentActivity {

    private View avaliableOrderTab; // 待接订单tab
    private View agreedOrderTab; // 已接订单tab
    private TextView agreedOrderCountIcon; // 已接订单消息提示
    private View customServiceBtn; // 客服按钮
    private SlidingLayer slidingLayer;
    private View userDetailLayout; // 用户详情标签
    private View userTagLayout; // 底部标签

    //******用户详情页****
    private CircularImage avatar; // 头像
    private TextView nameTextView;
    private TextView levelTextView;
    private TextView scoreTextView;
    private TextView moneyToDealTextView;
    private TextView moneyDealingTextView;
    private TextView totalMoneyTextView;
    private View newsLayout;
    private TextView news1TitleTv;
    private TextView news1ContentTv;
    private View news1LineView;
    private TextView news2TitleTv;
    private TextView news2ContentTv;
    private View news2LinView;

    private CircularImage tagAvatar;
    private TextView tagNameTv;
    private TextView tagLevelTv;


    private OrderListFragment avaliableOrderFragment;
    private OrderListFragment agreedOrderFragment;

    private int curTabPosition = -1;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        initFragment();
        initView();
        registerListener();

        setTabSelected(0);
    }

    private void initFragment(){
        avaliableOrderFragment = OrderListFragment.newInstance(OrderListFragment.ORDER_TYPE_AVALIABLE);
        agreedOrderFragment = OrderListFragment.newInstance(OrderListFragment.ORDER_TYPE_AGREED);
    }

    private void initView(){
        avaliableOrderTab = findViewById(R.id.tab_order_avaliable);
        agreedOrderTab = findViewById(R.id.tab_order_agreed);
        agreedOrderCountIcon = (TextView) findViewById(R.id.icon_order_agreed_count);
        customServiceBtn = findViewById(R.id.btn_custom_service);
        slidingLayer = (SlidingLayer) findViewById(R.id.sliding_layer);
        userDetailLayout = findViewById(R.id.user_detail_layout);
        userTagLayout = findViewById(R.id.user_tag_layout);
        slidingLayer.openLayer(false);
        userTagLayout.measure(0, 0);
        int bottomHeight = userTagLayout.getMeasuredHeight() - DisplayUtils.convertDIP2PX(this, 18);
        slidingLayer.setBottomMinHeight(bottomHeight);

        View fragmentView = findViewById(R.id.container_order_list_fragment);
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) fragmentView.getLayoutParams();
        params.bottomMargin = bottomHeight;
        fragmentView.setLayoutParams(params);

        userDetailLayout.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View view, MotionEvent motionEvent) {
                return true;
            }
        });
        slidingLayer.setOnScrollListener(new SlidingLayer.OnScrollListener() {
            @Override
            public void OnScroll(float percent) {
                userDetailLayout.setAlpha(percent);
                userTagLayout.setAlpha(1 - percent);
            }
        });
        initUserDetailView();
        initUserTagView();
        avatar.setImageResource(R.drawable.user_avatar_default);
        tagAvatar.setImageResource(R.drawable.user_avatar_default);
    }

    private void initUserDetailView() {
        avatar = (CircularImage) findViewById(R.id.user_detail_avatar);
        nameTextView = (TextView) findViewById(R.id.user_detail_name);
        levelTextView = (TextView) findViewById(R.id.user_detail_level);
        scoreTextView = (TextView) findViewById(R.id.user_detail_score);
        moneyToDealTextView = (TextView) findViewById(R.id.user_detail_money_to_deal);
        moneyDealingTextView = (TextView) findViewById(R.id.user_detail_money_dealing);
        totalMoneyTextView = (TextView) findViewById(R.id.user_detail_money_total);
        newsLayout = findViewById(R.id.user_detail_news_layout);
        news1TitleTv = (TextView) findViewById(R.id.message_time1);
        news1ContentTv = (TextView) findViewById(R.id.message_content1);
        news1LineView = findViewById(R.id.line_1);
        news2TitleTv = (TextView) findViewById(R.id.message_time2);
        news2ContentTv = (TextView) findViewById(R.id.message_content2);
        news2LinView = findViewById(R.id.line_2);
    }

    private void initUserTagView() {
        tagAvatar = (CircularImage) findViewById(R.id.user_tag_avatar);
        tagNameTv = (TextView) findViewById(R.id.user_tag_name);
        tagLevelTv = (TextView) findViewById(R.id.user_tag_level);
    }
    private void registerListener(){
        avaliableOrderTab.setOnClickListener(clickListener);
        agreedOrderTab.setOnClickListener(clickListener);
        customServiceBtn.setOnClickListener(clickListener);
    }

    private void loadAccountInfor() {
        Account account = AccountUtil.getLoginAccount(this);
        if (account != null) {
            ImageLoaderConfig config = new ImageLoaderConfig.Builder().setImageOnLoading(R.drawable.user_avatar_default).build();
            ImageLoader.loadImage(this, account.imgUrl, avatar, config);
            ImageLoader.loadImage(this, account.imgUrl, tagAvatar, config);
            nameTextView.setText(account.username);
            tagNameTv.setText(account.username);
        }
    }

    private View.OnClickListener clickListener = new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            if (view.getId() == R.id.tab_order_avaliable) {
                setTabSelected(0);
            } else if (view.getId() == R.id.tab_order_agreed) {
                setTabSelected(1);
            } else if (view.getId() == R.id.btn_custom_service) {
//                toCustomService();
                IntentUtils.startActivity(MainActivity.this, LoginActivity.class,null);
            }
        }
    };

    /**
     * 切换tab
     * @param position tab位置
     */
    private void setTabSelected(int position){
        if (position != curTabPosition){
            curTabPosition = position;
            FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
            if (position == 0){
                transaction.replace(R.id.container_order_list_fragment, avaliableOrderFragment);
                avaliableOrderTab.setSelected(true);
                agreedOrderTab.setSelected(false);
            } else {
                transaction.replace(R.id.container_order_list_fragment, agreedOrderFragment);
                avaliableOrderTab.setSelected(false);
                agreedOrderTab.setSelected(true);
            }
            transaction.commitAllowingStateLoss();
        }
    }

    /**
     * 跳转到客服页
     */
    private void toCustomService(){
        Intent intent = new Intent(this, WebViewActivity.class);
        intent.putExtra("BackgroundColor", Color.WHITE);
        intent.putExtra("ShowtTitle", true);
        startActivity(new Intent(this, WebViewActivity.class));
    }
}
