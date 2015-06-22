package air.com.miutour.guidesys.module.order.adapter;

import java.util.List;

import air.com.miutour.R;
import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class OrderLocationListAdapter extends BaseAdapter {

    private List<String> datas;
    private Context context;
    
    public OrderLocationListAdapter(Context context, List<String> datas){
        this.context = context;
        this.datas = datas;
    }
    
    
    
    public List<String> getDatas() {
        return datas;
    }



    public void setDatas(List<String> datas) {
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
        ViewHolder holder;
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = LayoutInflater.from(context).inflate(R.layout.list_item_trip, null);
            holder.infor = (TextView) convertView.findViewById(R.id.location_tv);
            holder.locationTag = (ImageView) convertView.findViewById(R.id.location_tag);
            convertView.setTag(holder);
        }else{
            holder = (ViewHolder) convertView.getTag();
        }
        
        String infor = datas.get(position);
        if (null != infor) {
            holder.infor.setText(infor);
        }
        if (position != datas.size() - 1) {
            holder.locationTag.setImageResource(R.drawable.tag_location);
        }else{
            holder.locationTag.setImageResource(R.drawable.tag_location_end);
        }
        return convertView;
    }

    class ViewHolder{
        TextView infor;
        ImageView locationTag;
    }
}
