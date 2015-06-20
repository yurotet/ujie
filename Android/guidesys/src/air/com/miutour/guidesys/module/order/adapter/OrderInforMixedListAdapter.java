package air.com.miutour.guidesys.module.order.adapter;

import java.util.List;

import air.com.miutour.R;
import air.com.miutour.guidesys.model.ExtraItem;
import air.com.miutour.guidesys.model.OrderItem;
import air.com.miutour.guidesys.module.order.adapter.OrderListAdapter.ViewHolder;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class OrderInforMixedListAdapter extends BaseAdapter {

    private List<OrderItem> datas;
    private Context context;

    public OrderInforMixedListAdapter(Context context, List<OrderItem> datas) {
        this.context = context;
        this.datas = datas;
    }

    @Override
    public int getCount() {
        return datas == null ? 0 : datas.size();
    }

    @Override
    public Object getItem(int position) {
        return datas.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = new ViewHolder();
        convertView = LayoutInflater.from(context).inflate(R.layout.list_item_mixed, null);
        holder.backgroundLayout = (LinearLayout) convertView.findViewById(R.id.background_layout);
        holder.midLayout = (RelativeLayout) convertView.findViewById(R.id.mid_layout);
        holder.priceLayout = (RelativeLayout) convertView.findViewById(R.id.price_layout);
        holder.typeTv = (TextView) convertView.findViewById(R.id.item_type_tv);
        holder.timeTv = (TextView) convertView.findViewById(R.id.item_time_tv);
        holder.startTag = (TextView) convertView.findViewById(R.id.start_tag);
        holder.arriveTag = (TextView) convertView.findViewById(R.id.arrive_tag);
        holder.startContent = (TextView) convertView.findViewById(R.id.start_content);
        holder.arriveContent = (TextView) convertView.findViewById(R.id.arrive_content);
        holder.midNum = (TextView) convertView.findViewById(R.id.mid_num_tv);
        holder.midTag = (TextView) convertView.findViewById(R.id.mid_tag_tv);
        holder.priceTv = (TextView) convertView.findViewById(R.id.price_tv);
        convertView.setTag(holder);
        OrderItem order = datas.get(position);
        if (null != order) {
            holder.typeTv.setText(order.type);
            holder.timeTv.setText(order.time);
            holder.priceTv.setText(order.orderPrice);
            // 根据不同的订单类型隐藏/显示相关项
            if (order.type.equals("接机")) {
                holder.arriveTag.setVisibility(View.VISIBLE);
                holder.arriveContent.setVisibility(View.VISIBLE);
                holder.midLayout.setVisibility(View.VISIBLE);
                holder.startTag.setText("出发地点");
                holder.arriveTag.setText("到达地点");
                holder.startContent.setText(order.start);
                holder.arriveContent.setText(order.arrive);
                holder.midNum.setText(order.midText);
                holder.midTag.setText("预估路程");
            } else if (order.type.equals("包车")) {
                holder.arriveTag.setVisibility(View.GONE);
                holder.arriveContent.setVisibility(View.GONE);
                holder.midLayout.setVisibility(View.VISIBLE);
                holder.startTag.setText("线路");
                holder.startContent.setText(order.content);
                holder.midNum.setText(order.midText);
                holder.midTag.setText("预估路程/时长");
            }
            if (order.extras != null && order.extras.size() > 0) {
                addExtraView(order.extras, holder.backgroundLayout);
            }
        }
        return convertView;
    }

    private void addExtraView(List<ExtraItem> extras, LinearLayout backgroundLayout) {
        int len = extras.size();
        RelativeLayout addView;
        ExtraItem item;
        for (int i = 0; i < len; i++) {
            item = extras.get(i);
            addView = (RelativeLayout) LayoutInflater.from(context).inflate(R.layout.addview_gap_price, null);
            TextView titleTag = (TextView) addView.findViewById(R.id.gap_price_title_tag);
            TextView title = (TextView) addView.findViewById(R.id.gap_price_title);
            TextView extraPrice = (TextView) addView.findViewById(R.id.gap_price);
            if (len != 1) {
                titleTag.setText("补差价" + (i + 1));
            } else {
                titleTag.setText("补差价");
            }
            title.setText(item.title);
            extraPrice.setText(item.price);
            backgroundLayout.addView(addView);
        }

    }

    class ViewHolder {
        LinearLayout backgroundLayout;
        RelativeLayout midLayout; // 底部中间布局
        RelativeLayout priceLayout; // 参考价布局
        TextView typeTv; // 订单类型
        TextView timeTv; // 订单时间
        TextView startTag; // 开始地点标签
        TextView arriveTag; // 到达地点标签
        TextView startContent; // 开始地点
        TextView arriveContent; // 到达地点
        TextView midNum; // 中间文字
        TextView midTag; // 中间标签
        TextView priceTv; // 参考价
    }
}
