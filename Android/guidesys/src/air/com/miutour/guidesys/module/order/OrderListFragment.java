package air.com.miutour.guidesys.module.order;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import air.com.miutour.R;
import air.com.miutour.guidesys.common.config.Env;
import air.com.miutour.guidesys.common.config.Urls;
import air.com.miutour.guidesys.model.Account;
import air.com.miutour.guidesys.model.OrderItem;
import air.com.miutour.guidesys.module.order.adapter.OrderListAdapter;
import air.com.miutour.guidesys.util.AccountUtil;
import air.com.miutour.guidesys.util.IntentUtils;
import air.com.miutour.guidesys.util.MD5;
import air.com.miutour.guidesys.util.ToastUtils;
import air.com.miutour.guidesys.widget.CustomException;
import air.com.miutour.guidesys.widget.CustomException.LoadViewReloadListener;
import air.com.miutour.guidesys.widget.pulltorefreshlistview.PullToRefreshListView;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Toast;
import cn.com.crazydemon.okhttp.HttpUtils;
import cn.com.crazydemon.okhttp.HttploadingListener;

/**
 * Created by lvyang on 15/6/9.
 */
public class OrderListFragment extends Fragment {

    private static final String TAG = "OrderListFragment";
    
    private static final String ORDER_TYPE_KEY = "type";
    /** 待接订单 */
    public static final int ORDER_TYPE_AVALIABLE = 1;
    /** 已接订单 */
    public static final int ORDER_TYPE_AGREED = 2;

    private int orderType;
    
    private boolean isLoadMore;

    private PullToRefreshListView listView;
    
    private CustomException loadView;

    private List<OrderItem> orders = new ArrayList<OrderItem>();
    
    private OrderListAdapter orderAdapter;
    
    private boolean cancelTag;
    
    private Account account;
    /**
     * 获取该类实例
     * @param orderType 列表数据类型，参照OrderListFragment#ORDER_TYPE_AVALIABLE, OrderListFragment#ORDER_TYPE_AGREED
     * @return
     */
    public static OrderListFragment newInstance(int orderType){
        Bundle bundle = new Bundle();
        bundle.putInt(ORDER_TYPE_KEY, orderType);
        OrderListFragment fragment = new OrderListFragment();
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            orderType = getArguments().getInt(ORDER_TYPE_KEY, 1);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_order_list, null);
        account = AccountUtil.getLoginAccount(getActivity());
        initView(view);
        return view;
    }
    
    private void initView(View view) {
        if (view != null) {
            loadView = (CustomException) view.findViewById(R.id.loadView);
            loadView.setLoadFaileException();
            if (null != loadView) {
                loadView.setClickReLoadListener(new LoadViewReloadListener() {

                    @Override
                    public void reLoad() {
                        loadData(false);
                    }
                });
            }
            listView = (PullToRefreshListView) view.findViewById(R.id.order_listview);
            listView.setPullAndRefreshListViewListener(new PullToRefreshListView.PullAndRefreshListViewListener() {
                @Override
                public void onRefresh() {
                    loadData(false);
                }

                @Override
                public void onLoadMore() {
                    loadData(true);
                }

                @Override
                public void onLoadCancel() {
                    cancelTag = true;
                    cancelCurLoading();
                }
            });
            listView.setPullLoadEnable(true);
            listView.setPullRefreshEnable(true);
            orderAdapter = new OrderListAdapter(getActivity(), orders);
            listView.setAdapter(orderAdapter);
            listView.setOnItemClickListener(itemClickListener);
            loadData(false);
        }
    }

    
    private OnItemClickListener itemClickListener = new OnItemClickListener() {

        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            position--;
            if (position >= 0 && orders.get(position) != null) {
                Bundle bundle = new Bundle();
                bundle.putString("id", orders.get(position).id);
                if (orders.get(position).type.equals("包车")) {
                    IntentUtils.startActivity(getActivity(), CharteredOrderInforActivity.class, bundle);
                }else if (orders.get(position).type.equals("接送机")) {
                    IntentUtils.startActivity(getActivity(), PickUpOrderInforActivity.class, bundle);
                }else if (orders.get(position).type.equals("拼车")) {
                    IntentUtils.startActivity(getActivity(), CarPoolOrderInforActivity.class, bundle);
                }else if (orders.get(position).type.equals("组合")) {
                    IntentUtils.startActivity(getActivity(), MixedOrderInforActivity.class, bundle);
                }
            }
        }
    };
    
    
    /**
     * 加载数据
     * TODO
     * @param isLoadMore
     */
    private void loadData(final boolean isLoadMore) {
        this.isLoadMore = isLoadMore;
        if (!isLoadMore) {
            if (orders==null || orders.isEmpty()) {
                loadView.setVisible(true, false);
            }
        }else{
            loadView.setVisible(false, false);
        }
        Account account = AccountUtil.getLoginAccount(getActivity());
        Map<String, String> header = new HashMap<String, String>();
        header.put("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
        Map<String, String> param = new HashMap<String, String>();
        param.put("username", account.username);
        param.put("token", account.token);
        param.put("nonce", account.nonce);
        try {
            param.put("signature", MD5.getSignatureByValue(param, ""));
        } catch (IOException e1) {
            e1.printStackTrace();
        }
        param.remove("nonce");
        Log.i("czb", account.toString());
        Log.i("czb", param.toString());
        HttpUtils.getInstance().postJson(Urls.ORDER_LIST, TAG, header, param, new HttploadingListener() {

            @Override
            public void onFail(Exception e) {
                super.onFail(e);
                if (orders==null || orders.isEmpty()) {
                    loadView.setVisible(false, true);
                } else if (!cancelTag){
                    ToastUtils.show(getActivity(), "数据加载失败", Toast.LENGTH_SHORT);
                }
                cancelTag = false;
                listView.stopLoadMore();
                listView.stopRefresh(false);
            }

            @Override
            public void onSuccess2JsonObject(int statusCode, JSONObject jsonObject) {
                super.onSuccess2JsonObject(statusCode, jsonObject);
                Log.i("czb", jsonObject.toString());
                String code = jsonObject.optString("err_code");
                String message = jsonObject.optString("err_msg");
                if (code.equals("0") && message.equals("success")) {
                    loadView.setVisible(false, false);
                    setData(jsonObject);
                }else{
                    loadView.setVisible(false, true);
                }
                
                
            }

        });
        
        
    }
    private void setData(JSONObject result) {
        if (!isLoadMore) {
            orders.clear();
            listView.stopRefresh(true);
        }else{
            listView.stopLoadMore();
        }
        orders.addAll(OrderSever.getOrderList(result));
        orderAdapter.notifyDataSetChanged();
        
    }
    /**
     * 取消当前下载
     * TODO
     */
    private void cancelCurLoading() {
        HttpUtils.getInstance().cancelByTag(TAG);
        
    }


}
