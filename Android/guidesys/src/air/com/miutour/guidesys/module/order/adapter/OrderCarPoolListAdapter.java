package air.com.miutour.guidesys.module.order.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import java.util.List;

import air.com.miutour.R;
import air.com.miutour.guidesys.model.OrderCarPoolItem;

/**
 * Created by user on 15/6/17.
 */
public class OrderCarPoolListAdapter extends BaseAdapter{

    private Context context;
    private List<OrderCarPoolItem> datas;
    public OrderCarPoolListAdapter(Context context, List<OrderCarPoolItem> datas){
        this.context = context;
        this.datas = datas;
    }

    @Override
    public int getCount() {
        return datas==null?0:datas.size();
    }

    @Override
    public Object getItem(int i) {
        return null;
    }

    @Override
    public long getItemId(int i) {
        return 0;
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        ViewHolder holder;
        if (view == null) {
            view = LayoutInflater.from(context).inflate(R.layout.list_item_passenger, null);
            holder = new ViewHolder();
            holder.groupNumTv = (TextView) view.findViewById(R.id.group_num);
            holder.adultTv = (TextView) view.findViewById(R.id.adult_num);
            holder.childTv = (TextView) view.findViewById(R.id.child_num);
            holder.babyTv = (TextView) view.findViewById(R.id.baby_num);
            holder.locationTv = (TextView) view.findViewById(R.id.location_tv);
            view.setTag(holder);
        } else {
            holder = (ViewHolder) view.getTag();
        }
        OrderCarPoolItem item = datas.get(i);
        if (item != null) {
            holder.groupNumTv.setText("客人" + (i+1) + "组");
            holder.adultTv.setText(item.adultCount + "");
            holder.childTv.setText(item.childCount + "");
            holder.babyTv.setText(item.babyCount + "");
            holder.locationTv.setText(item.location);
        }
        return view;
    }

    private class ViewHolder{
        TextView groupNumTv;
        TextView adultTv;
        TextView childTv;
        TextView babyTv;
        TextView locationTv;
    }
}
