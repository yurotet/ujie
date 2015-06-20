package air.com.miutour.guidesys.module.order.adapter;

import java.util.ArrayList;
import java.util.List;

import air.com.miutour.R;
import air.com.miutour.guidesys.model.OrderItem;
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

public class OrderListAdapter extends BaseAdapter {

    public List<OrderItem> orders;
    private Context context;
    
    public OrderListAdapter(Context context, List<OrderItem> orders){
        this.context = context;
        this.orders = orders;
    }
    
    @Override
    public int getCount() {
        return orders == null ? 0 : orders.size();
    }

    @Override
    public Object getItem(int position) {
        return orders.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (null == convertView) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(context).inflate(R.layout.list_item_order, null);
            holder.backgroundLayout = (LinearLayout) convertView.findViewById(R.id.background_layout);
            holder.seatLayout = (RelativeLayout) convertView.findViewById(R.id.seat_layout);
            holder.midLayout = (RelativeLayout) convertView.findViewById(R.id.mid_layout);
            holder.priceLayout = (RelativeLayout) convertView.findViewById(R.id.price_layout);
            holder.typeTv = (TextView) convertView.findViewById(R.id.item_type_tv);
            holder.timeTv = (TextView) convertView.findViewById(R.id.item_time_tv);
            holder.startTag = (TextView) convertView.findViewById(R.id.start_tag);
            holder.arriveTag = (TextView) convertView.findViewById(R.id.arrive_tag);
            holder.startContent = (TextView) convertView.findViewById(R.id.start_content);
            holder.arriveContent = (TextView) convertView.findViewById(R.id.arrive_content);
            holder.stateTv = (TextView) convertView.findViewById(R.id.order_state_tv);
            holder.seatNum = (TextView) convertView.findViewById(R.id.seat_num_tv);
            holder.midNum = (TextView) convertView.findViewById(R.id.mid_num_tv);
            holder.midTag = (TextView) convertView.findViewById(R.id.mid_tag_tv);
            holder.priceTv = (TextView) convertView.findViewById(R.id.price_tv);
            holder.extraTv = (TextView) convertView.findViewById(R.id.extra_tv);
            holder.emergencyIm = (ImageView) convertView.findViewById(R.id.emergency);
            holder.stateTv = (TextView) convertView.findViewById(R.id.agreed_order_tag);
            convertView.setTag(holder);
        }else{
            holder = (ViewHolder) convertView.getTag();
        }
        OrderItem order = orders.get(position);
        if (null != order) {
            if (order.type.equals("接送机")) {
                holder.typeTv.setText(order.oType);
            }else{
                holder.typeTv.setText(order.type);
            }
            holder.timeTv.setText(order.time);
            if (order.isBid) {
                holder.stateTv.setText("已出价\n¥" + order.bid);
            }else{
                holder.stateTv.setText("去接单");
            }
            holder.seatNum.setText(order.seatNum);
            holder.priceTv.setText(order.orderPrice);
            if (!TextUtils.isEmpty(order.extraPrice) && !order.extraPrice.equals("0")) {
                holder.extraTv.setText("奖励\n¥" + order.extraPrice);
                holder.extraTv.setVisibility(View.VISIBLE);
            }else{
                holder.extraTv.setVisibility(View.GONE);
            }
            
            if (order.isEmergency) {
                holder.emergencyIm.setVisibility(View.VISIBLE);
                holder.backgroundLayout.setBackgroundResource(R.drawable.background_shadow_orange);
            }else{
                holder.emergencyIm.setVisibility(View.GONE);
                holder.backgroundLayout.setBackgroundResource(R.drawable.background_shadow);
            }
            //根据不同的订单类型隐藏/显示相关项
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
            }else if (order.type.equals("包车")) {
                holder.arriveTag.setVisibility(View.GONE);
                holder.arriveContent.setVisibility(View.GONE);
                holder.midLayout.setVisibility(View.VISIBLE);
                holder.startTag.setText("线路");
                holder.startContent.setText(order.content);
                holder.midNum.setText(order.midText);
                holder.midTag.setText("预估路程");
            }else if (order.type.equals("拼车")) {
                holder.arriveTag.setVisibility(View.GONE);
                holder.arriveContent.setVisibility(View.GONE);
                holder.midLayout.setVisibility(View.VISIBLE);
                holder.startTag.setText("线路");
                holder.startContent.setText(order.content);
                holder.midNum.setText(order.midText);
                holder.midTag.setText("客人组数");
            }else if (order.type.equals("组合")) {
                holder.arriveTag.setVisibility(View.GONE);
                holder.arriveContent.setVisibility(View.GONE);
                holder.midLayout.setVisibility(View.GONE);
                holder.startTag.setText("服务内容");
                holder.startContent.setText(order.content);
            }

            if (order.agreedOrderState==0) {
                holder.stateTv.setVisibility(View.GONE);
            } else {
                holder.stateTv.setVisibility(View.VISIBLE);
                if (order.agreedOrderState==1) {
                    holder.stateTv.setText("距离服务还有2天");
                    holder.stateTv.setBackgroundResource(R.drawable.tag_order_servered);
                } else if (order.agreedOrderState==2) {
                    holder.stateTv.setText("正在服务中");
                    holder.stateTv.setBackgroundResource(R.drawable.tag_order_servering);
                } else if (order.agreedOrderState==3) {
                    holder.stateTv.setText("服务已结束");
                    holder.stateTv.setBackgroundResource(R.drawable.tag_order_servered);
                }
            }
        }
        return convertView;
    }

    class ViewHolder{
        LinearLayout backgroundLayout;//背景
        RelativeLayout seatLayout;  //座位数布局
        RelativeLayout midLayout;   //底部中间布局
        RelativeLayout priceLayout; //参考价布局
        TextView typeTv;            //订单类型
        TextView timeTv;            //订单时间
        TextView startTag;          //开始地点标签
        TextView arriveTag;         //到达地点标签
        TextView startContent;      //开始地点
        TextView arriveContent;     //到达地点
        TextView stateTv;           //订单状态
        TextView seatNum;           //座位数
        TextView midNum;            //中间文字
        TextView midTag;            //中间标签
        TextView priceTv;           //参考价
        ImageView emergencyIm;      //紧急图片
        TextView extraTv;           //加价图
    }
}
