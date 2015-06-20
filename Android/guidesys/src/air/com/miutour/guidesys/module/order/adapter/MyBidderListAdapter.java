package air.com.miutour.guidesys.module.order.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import org.w3c.dom.Text;

import java.util.List;

import air.com.miutour.R;
import air.com.miutour.guidesys.model.MyBidderItem;

/**
 * Created by user on 15/6/17.
 */
public class MyBidderListAdapter extends BaseAdapter{

    private Context context;
    private List<MyBidderItem> datas;
    private OnDelClickListener listener;

    public MyBidderListAdapter(Context context, List<MyBidderItem> datas) {
        this.context = context;
        this.datas = datas;
    }

    public void setOnDelClickListener(OnDelClickListener listener){
        this.listener = listener;
    }

    
    
    public void setDatas(List<MyBidderItem> datas) {
        this.datas = datas;
    }

    @Override
    public int getCount() {
        return datas==null ? 0 : datas.size();
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
            view = LayoutInflater.from(context).inflate(R.layout.list_item_my_order, null);
            holder = new ViewHolder();
            holder.topLineView = view.findViewById(R.id.my_order_line_top);
            holder.bottomLineView = view.findViewById(R.id.my_order_line_bottom);
            holder.dateTv = (TextView) view.findViewById(R.id.my_order_date);
            holder.roundIv = (ImageView) view.findViewById(R.id.my_order_round_tag);
            holder.priceTv = (TextView) view.findViewById(R.id.my_order_price);
            holder.delView = view.findViewById(R.id.my_order_del_tag);
            view.setTag(holder);
        } else {
            holder = (ViewHolder) view.getTag();
        }
        MyBidderItem item = datas.get(i);
        if (item != null) {
            if (i==0) {
                holder.topLineView.setVisibility(View.INVISIBLE);
                holder.bottomLineView.setVisibility(View.VISIBLE);
            } else if (i == datas.size()-1) {
                holder.topLineView.setVisibility(View.VISIBLE);
                holder.bottomLineView.setVisibility(View.INVISIBLE);
            } else {
                holder.topLineView.setVisibility(View.VISIBLE);
                holder.bottomLineView.setVisibility(View.VISIBLE);
            }

            if (i==0) {
                holder.roundIv.setImageResource(R.drawable.icon_my_order_cur);
                holder.dateTv.setTextColor(context.getResources().getColor(R.color.textcolor_red));
                holder.priceTv.setTextColor(context.getResources().getColor(R.color.textcolor_red));
            } else {
                holder.roundIv.setImageResource(R.drawable.icon_my_order_default);
                holder.dateTv.setTextColor(context.getResources().getColor(R.color.textcolor_black_3e));
                holder.priceTv.setTextColor(context.getResources().getColor(R.color.textcolor_black_3e));
            }
            holder.dateTv.setText(item.date);
            holder.priceTv.setText("出价"+item.price);
            holder.delView.setOnClickListener(clickListener);
            holder.delView.setTag(i);
        }
        return view;
    }

    private View.OnClickListener clickListener = new View.OnClickListener() {
        @Override
        public void onClick(View view) {
            if (listener!=null) listener.onDelClick((Integer) view.getTag());
        }
    };

    public interface OnDelClickListener{
        void onDelClick(int position);
    }

    private class ViewHolder{
        View topLineView;
        ImageView roundIv;
        View bottomLineView;
        TextView dateTv;
        TextView priceTv;
        View delView;
    }
}
