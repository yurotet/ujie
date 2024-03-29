package air.com.miutour.guidesys.module.order;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.test.MoreAsserts;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;

import air.com.miutour.R;
import air.com.miutour.guidesys.model.Account;
import air.com.miutour.guidesys.model.CarInfo;
import air.com.miutour.guidesys.model.MyBidderItem;
import air.com.miutour.guidesys.model.OrderBaseInfor;
import air.com.miutour.guidesys.model.OrderCarPoolItem;
import air.com.miutour.guidesys.module.base.BaseFragmentActivity;
import air.com.miutour.guidesys.module.order.OrderSever.HttpListener;
import air.com.miutour.guidesys.module.order.adapter.CarSelectAdapter;
import air.com.miutour.guidesys.module.order.adapter.MyBidderListAdapter;
import air.com.miutour.guidesys.module.order.adapter.OrderCarPoolListAdapter;
import air.com.miutour.guidesys.module.order.adapter.OrderInforListAdapter;
import air.com.miutour.guidesys.module.order.adapter.OrderLocationListAdapter;
import air.com.miutour.guidesys.util.AccountUtil;
import air.com.miutour.guidesys.util.ToastUtils;
import air.com.miutour.guidesys.widget.CustomException;
import air.com.miutour.guidesys.widget.FixedListView;
import air.com.miutour.guidesys.widget.CustomException.LoadViewReloadListener;

public class CarPoolOrderInforActivity extends BaseFragmentActivity {
    private static final String TAG = "CarPoolOrderInforActivity";
    private FrameLayout backLayou;
    private TextView typeTv;
    private TextView emergencyTv;       //紧急标签
    private TextView extraTv;       //补贴标签
    private TextView orderNoTv;       //订单编号
    private TextView rightTv;     //联系客服
    private TextView orderPriceTv;    //订单价格
    private TextView orderContentTv;  //订单介绍
    private TextView adultNumTv;
    private TextView childNumTv;
    private TextView babyNumTv;
    private TextView timeTv;
    private TextView requredCarTv; // 需要车型
    private TextView groupCountTv; // 客人组数
    private FixedListView groupListview;  //客人列表
    private TextView myPriceTv;           //我的报价
    private TextView highPriceTv;           //我的报价
    private ViewPager carSelectViewPager;
    private ImageView carSelectLeftImg;
    private ImageView carSelectRightImg;
    private EditText priceEdit;
    private TextView bidTv;     //出价
    private ImageView downImg;
    private ImageView upImg;
    
    private CustomException loadView;
    
    private View myOrderLayout;
    private FixedListView myOrderListView;
    private MyBidderListAdapter myOrderListAdapter;

    private OrderCarPoolListAdapter mGroupListAdapter;
    private CarSelectAdapter mCarSelectAdapter;
    
    private Account account;
    private OrderBaseInfor baseInfor = new OrderBaseInfor();//基本信息
    private List<OrderCarPoolItem> groupList;
    private int currentPage = 0;
    private String orderId;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_order_infor_car_pool);
        groupList = new ArrayList<OrderCarPoolItem>();
        account = AccountUtil.getLoginAccount(getApplicationContext());
        getInstant();
        initView();
        loadData();
    }
    
    private void getInstant() {
        Intent intent = getIntent();
        if (intent != null) {
            Bundle bundle = intent.getExtras();
            if (bundle != null) {
                orderId = bundle.getString("id");
            }
        }
    }
    
    private void initView() {
        loadView = (CustomException) findViewById(R.id.loadView);
        typeTv = (TextView) findViewById(R.id.type_tv);
        backLayou = (FrameLayout) findViewById(R.id.app_top_banner_left_layout);
        emergencyTv = (TextView) findViewById(R.id.emergency);
        extraTv = (TextView) findViewById(R.id.extra_tv);
        orderNoTv = (TextView) findViewById(R.id.app_top_banner_centre_bottom);
        rightTv = (TextView) findViewById(R.id.app_top_banner_right_text);
        orderPriceTv = (TextView) findViewById(R.id.price_tv);
        orderContentTv = (TextView) findViewById(R.id.order_title);
        adultNumTv = (TextView) findViewById(R.id.adult_num);
        childNumTv = (TextView) findViewById(R.id.child_num);
        babyNumTv = (TextView) findViewById(R.id.baby_num);
        timeTv = (TextView) findViewById(R.id.using_car_time);
        requredCarTv = (TextView) findViewById(R.id.car_tv);
        groupCountTv = (TextView) findViewById(R.id.passenger_tv);
        groupListview = (FixedListView) findViewById(R.id.passenger_lv);
        myPriceTv = (TextView) findViewById(R.id.bottom_price_tv);
        highPriceTv = (TextView) findViewById(R.id.top_price);
        carSelectViewPager = (ViewPager) findViewById(R.id.car_select_viewpager);
        carSelectLeftImg = (ImageView) findViewById(R.id.car_choose_left);
        carSelectRightImg = (ImageView) findViewById(R.id.car_choose_right);
        priceEdit = (EditText) findViewById(R.id.price_edit);
        bidTv = (TextView) findViewById(R.id.price_bid);
        downImg = (ImageView) findViewById(R.id.price_down_btn);
        upImg = (ImageView) findViewById(R.id.price_up_btn);
        
        if (null != loadView) {
            loadView.setLoadFaileException();
            loadView.setClickReLoadListener(new LoadViewReloadListener() {

                @Override
                public void reLoad() {
                    loadData();
                }
            });
        }
        
        backLayou.setOnClickListener(clickListener);
        rightTv.setOnClickListener(clickListener);
        bidTv.setOnClickListener(clickListener);
        downImg.setOnClickListener(clickListener);
        upImg.setOnClickListener(clickListener);
        carSelectLeftImg.setOnClickListener(clickListener);
        carSelectRightImg.setOnClickListener(clickListener);

        mGroupListAdapter = new OrderCarPoolListAdapter(this, groupList);
        groupListview.setAdapter(mGroupListAdapter);
        mCarSelectAdapter = new CarSelectAdapter(getApplicationContext(), baseInfor.carTypes);
        carSelectViewPager.setAdapter(mCarSelectAdapter);
        carSelectViewPager.setOnPageChangeListener(pageChangeListener);

        myOrderLayout = findViewById(R.id.my_order_layout);
        myOrderListView = (FixedListView) findViewById(R.id.my_order_lv);
        myOrderListAdapter = new MyBidderListAdapter(this, baseInfor.myBidders);
        myOrderListView.setAdapter(myOrderListAdapter);
        myOrderListAdapter.setOnDelClickListener(new MyBidderListAdapter.OnDelClickListener() {
            @Override
            public void onDelClick(final int position) {
                if (account == null) {
                    ToastUtils.show(getApplicationContext(), "请先登录", Toast.LENGTH_SHORT);
                    return;
                }
                OrderSever.deleteMyBidder(account.username, account.token, account.nonce, baseInfor.myBidders.get(position).id, new HttpListener() {
                    
                    @Override
                    public void onSuccess(JSONObject result) {
                        int code = result.optInt("err_code");
                        if (code == 0) {
                            ToastUtils.show(getApplicationContext(), "删除成功", Toast.LENGTH_LONG);
                        }else{
                            ToastUtils.show(getApplicationContext(), "删除失败", Toast.LENGTH_LONG);
                        }
                        baseInfor.myBidders.remove(position);
                        myOrderListAdapter.notifyDataSetChanged();
                    }
                    
                    @Override
                    public void onSuccess(String content) {
                        
                    }
                    
                    @Override
                    public void onFailure(String content) {
                        
                    }
                });
            }
        });
    }
    
    private void loadData() {
        loadView.setVisible(true, false);
        OrderSever.loadInforData(CarPoolOrderInforActivity.this, orderId, TAG, new HttpListener() {

            @Override
            public void onSuccess(JSONObject result) {
                setData(result);
                loadView.setVisible(false, false);

            }

            @Override
            public void onSuccess(String content) {

            }

            @Override
            public void onFailure(String content) {
                loadView.setVisible(false, true);
            }
        });
    }
    
    private void setData(JSONObject jsonObject) {
        OrderSever.parseCarpoolOrder(jsonObject, baseInfor, groupList);
        typeTv.setText(baseInfor.orderType);
        if (baseInfor.isEmergency) {
            emergencyTv.setVisibility(View.VISIBLE);
        }else{
            emergencyTv.setVisibility(View.GONE);
        }
        if (!TextUtils.isEmpty(baseInfor.extraPrice) && !baseInfor.extraPrice.equals("0")) {
            extraTv.setText("奖励\n¥" + baseInfor.extraPrice);
            extraTv.setVisibility(View.VISIBLE);
        }else{
            extraTv.setVisibility(View.INVISIBLE);
        }
        orderContentTv.setText(baseInfor.orderConent);
        requredCarTv.setText(baseInfor.requiredCarType);
        groupCountTv.setText(baseInfor.groupCount);
        adultNumTv.setText(baseInfor.adultNum);
        childNumTv.setText(baseInfor.childNum);
        babyNumTv.setText(baseInfor.babNum);
        orderNoTv.setText(baseInfor.orderNo);
        timeTv.setText(baseInfor.time);
        orderPriceTv.setText(baseInfor.orderPrice);
        myPriceTv.setText(baseInfor.myPrice);
        highPriceTv.setText(baseInfor.highPrice);
        priceEdit.setText(baseInfor.myPrice);
        if (baseInfor.myBidders.isEmpty()) {
            myOrderLayout.setVisibility(View.GONE);
        } else {
            myOrderLayout.setVisibility(View.VISIBLE);
        }
        mCarSelectAdapter.setDatas(baseInfor.carTypes);
        notifyAdapter();
    }

    private void notifyAdapter(){
        mGroupListAdapter.notifyDataSetChanged();
        mCarSelectAdapter.notifyDataSetChanged();
        myOrderListAdapter.notifyDataSetChanged();
    }
    
    private OnClickListener clickListener = new OnClickListener() {
        
        @Override
        public void onClick(View v) {
            int id = v.getId();
            if (id == R.id.app_top_banner_left_layout) {
                onBackPressed();
            }else if (id == R.id.app_top_banner_right_text) {
                
            }else if (id == R.id.price_bid) {
                if (account == null) {
                    ToastUtils.show(getApplicationContext(), "请先登录", Toast.LENGTH_SHORT);
                    return;
                }
                if (priceEdit.getText() != null && !priceEdit.getText().toString().equals("0")) {
                    myPriceTv.setText(priceEdit.getText());
                    baseInfor.myPrice = priceEdit.getText().toString();
                    final CarInfo car = baseInfor.carInfos.get(currentPage);
                    final String price = priceEdit.getText().toString();
                    OrderSever.addBidder(account.username, account.token, account.nonce, orderId,priceEdit.getText().toString() ,car.model , car.type, car.seatNum, new HttpListener() {
                        
                        @Override
                        public void onSuccess(JSONObject result) {
                            int code = result.optInt("err_code");
                            if (code == 0) {
                                ToastUtils.show(getApplicationContext(), "出价成功", Toast.LENGTH_LONG);
                                MyBidderItem bidder = new MyBidderItem();
                                bidder.id = result.optJSONObject("data").optString("id");
                                bidder.carModel = car.model;
                                bidder.carType = car.type;
                                bidder.price = price;
                                bidder.seatNum = car.seatNum;
                                bidder.date = result.optString("time");
                                baseInfor.myBidders.add(0,bidder);
                                myOrderListAdapter.notifyDataSetChanged();
                            }else{
                                ToastUtils.show(getApplicationContext(), result.optString("err_msg"), Toast.LENGTH_LONG);
                            }
                            
                        }
                        
                        @Override
                        public void onSuccess(String content) {
                            
                        }
                        
                        @Override
                        public void onFailure(String content) {
                            ToastUtils.show(getApplicationContext(), content, Toast.LENGTH_LONG);
                        }
                    });
                }else {
                    ToastUtils.show(getApplicationContext(), "请输入有效价格", Toast.LENGTH_SHORT);
                }
            }else if (id == R.id.price_down_btn) {
                changePrice(-100);
            }else if (id == R.id.price_up_btn) {
                changePrice(100);
            }else if (id == R.id.car_choose_left) {
                if (currentPage > 0) {
                    currentPage = currentPage - 1;
                    carSelectViewPager.setCurrentItem(currentPage);
                }
            }else if (id == R.id.car_choose_right) {
                if (currentPage < mCarSelectAdapter.getCount()) {
                    currentPage = currentPage + 1;
                    carSelectViewPager.setCurrentItem(currentPage);
                }
            }
        }
    };
    
    private void changePrice(int price){
        if (priceEdit.getText() != null) {
            int editPrice;
            if (priceEdit.getText().toString().equals("")) {
                editPrice = 0;
            }else{
                editPrice = Integer.valueOf(priceEdit.getText().toString());
            }
            
            if ((editPrice + price) > 0) {
                priceEdit.setText(editPrice + price + "");
            }else {
                priceEdit.setText("0");
            }
        }
    }
    
    private OnItemClickListener itemClickListener = new OnItemClickListener() {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            
        }
    };
    
    private OnPageChangeListener pageChangeListener = new OnPageChangeListener() {
        
        @Override
        public void onPageSelected(int arg0) {
            
        }
        
        @Override
        public void onPageScrolled(int arg0, float arg1, int arg2) {
            
        }
        
        @Override
        public void onPageScrollStateChanged(int arg0) {
            
        }
    };
    
    
    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
    }
}
