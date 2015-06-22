package air.com.miutour.guidesys.module.order;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;

import air.com.miutour.R;
import air.com.miutour.guidesys.model.MyBidderItem;
import air.com.miutour.guidesys.model.OrderBaseInfor;
import air.com.miutour.guidesys.model.OrderItem;
import air.com.miutour.guidesys.module.base.BaseFragmentActivity;
import air.com.miutour.guidesys.module.order.OrderSever.HttpListener;
import air.com.miutour.guidesys.module.order.adapter.CarSelectAdapter;
import air.com.miutour.guidesys.module.order.adapter.MyBidderListAdapter;
import air.com.miutour.guidesys.module.order.adapter.OrderInforMixedListAdapter;
import air.com.miutour.guidesys.util.IntentUtils;
import air.com.miutour.guidesys.util.ToastUtils;
import air.com.miutour.guidesys.widget.CustomException;
import air.com.miutour.guidesys.widget.CustomException.LoadViewReloadListener;
import air.com.miutour.guidesys.widget.FixedListView;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.text.TextUtils;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class MixedOrderInforActivity extends BaseFragmentActivity {
    private static final String TAG = "MixedOrderInforActivity";
    
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
    private TextView carTypeTv;
    private FixedListView mixedListView;
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
    
    private OrderInforMixedListAdapter mixedListAdapter;
    private CarSelectAdapter mCarSelectAdapter;

    private View myOrderLayout;
    private FixedListView myOrderListView;
    private List<MyBidderItem> myOrders;
    private MyBidderListAdapter myOrderListAdapter;
    
    private OrderBaseInfor baseInfor = new OrderBaseInfor();//基本信息
    private List<OrderItem> childOrders;
    private List<String> carTypes;
    private int currentPage = 0;
    private String orderId;
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_order_infor_mixed);
        childOrders = new ArrayList<OrderItem>();
        carTypes = new ArrayList<String>();
        myOrders = new ArrayList<MyBidderItem>();
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
        carTypeTv = (TextView) findViewById(R.id.car_type);
        mixedListView = (FixedListView) findViewById(R.id.mix_order_lv);
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
        
        mixedListAdapter = new OrderInforMixedListAdapter(getApplicationContext(), childOrders);
        mixedListView.setAdapter(mixedListAdapter);
        mixedListView.setOnItemClickListener(itemClickListener);
        mCarSelectAdapter = new CarSelectAdapter(getApplicationContext(), carTypes);
        carSelectViewPager.setAdapter(mCarSelectAdapter);
        carSelectViewPager.setOnPageChangeListener(pageChangeListener);

        myOrderLayout = findViewById(R.id.my_order_layout);
        myOrderListView = (FixedListView) findViewById(R.id.my_order_lv);
        myOrderListAdapter = new MyBidderListAdapter(this, myOrders);
        myOrderListView.setAdapter(myOrderListAdapter);
        myOrderListAdapter.setOnDelClickListener(new MyBidderListAdapter.OnDelClickListener() {
            @Override
            public void onDelClick(int position) {

            }
        });

    }
    
    private void loadData() {
        loadView.setVisible(true, false);
        OrderSever.loadInforData(MixedOrderInforActivity.this, orderId, TAG, new HttpListener() {

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
        OrderSever.parseMixedOrder(jsonObject, baseInfor, childOrders);
        typeTv.setText(baseInfor.orderType);
        if (baseInfor.isEmergency) {
            emergencyTv.setVisibility(View.VISIBLE);
        }else{
            emergencyTv.setVisibility(View.INVISIBLE);
        }
        if (!TextUtils.isEmpty(baseInfor.extraPrice) && !baseInfor.extraPrice.equals("0")) {
            extraTv.setText("奖励\n¥" + baseInfor.extraPrice);
            extraTv.setVisibility(View.VISIBLE);
        }else{
            extraTv.setVisibility(View.GONE);
        }
        orderContentTv.setText(baseInfor.orderConent);
        adultNumTv.setText(baseInfor.adultNum);
        childNumTv.setText(baseInfor.childNum);
        babyNumTv.setText(baseInfor.babNum);
        orderNoTv.setText(baseInfor.orderNo);
        carTypeTv.setText(baseInfor.seatNum);
        orderPriceTv.setText(baseInfor.orderPrice);
        myPriceTv.setText(baseInfor.myPrice);
        highPriceTv.setText(baseInfor.highPrice);
        priceEdit.setText(baseInfor.myPrice);
        myOrderListAdapter.setDatas(baseInfor.myBidders);
        if (baseInfor.myBidders.isEmpty()) {
            myOrderLayout.setVisibility(View.GONE);
        } else {
            myOrderLayout.setVisibility(View.VISIBLE);
        }
        notifyAdapter();
    }


    private void notifyAdapter(){
        mixedListAdapter.notifyDataSetChanged();
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
                if (priceEdit.getText() != null && !priceEdit.getText().toString().equals("0")) {
                    myPriceTv.setText(priceEdit.getText());
                    baseInfor.myPrice = priceEdit.getText().toString();
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
        if (priceEdit.getText() != null && !priceEdit.getText().toString().equals("0")) {
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
            if (position >= 0 && childOrders.get(position) != null) {
                Bundle bundle = new Bundle();
                bundle.putString("id", childOrders.get(position).id);
                if (childOrders.get(position).type.equals("包车")) {
                    IntentUtils.startActivity(MixedOrderInforActivity.this, CharteredOrderInforActivity.class, bundle);
                }else if (childOrders.get(position).type.equals("接送机")) {
                    IntentUtils.startActivity(MixedOrderInforActivity.this, PickUpOrderInforActivity.class, bundle);
                }
            }
            
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
