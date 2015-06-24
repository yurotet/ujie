package air.com.miutour.guidesys.module.order.adapter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import air.com.miutour.R;
import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridView;
import android.widget.TextView;

public class CarSelectAdapter extends PagerAdapter {

    private List<String> datas;
    private Context mContext;
    private Map<Integer, View> views;
    
    public CarSelectAdapter(Context context,List<String> types) {
        mContext = context;
        this.datas = types;
        views = new HashMap<Integer, View>();
    }
    
    
    public List<String> getDatas() {
        return datas;
    }


    public void setDatas(List<String> datas) {
        this.datas = datas;
    }


    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView(views.get(position));
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        if (!views.containsKey(position)) {
            View view = LayoutInflater.from(mContext).inflate(R.layout.pager_item_car_select, null);
            TextView seatNum = (TextView) view.findViewById(R.id.car_seat_num);
            if (datas.get(position) != null) {
                seatNum.setText(datas.get(position));
            }
            views.put(position, view);
        }
        container.addView(views.get(position));
        return views.get(position);
    }

    @Override
    public int getCount() {
        return datas == null ? 0 : datas.size();
    }

    @Override
    public boolean isViewFromObject(View arg0, Object arg1) {
        return arg0==arg1;
    }

}
