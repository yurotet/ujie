package air.com.miutour.guidesys.model;

/**
 * Created by user on 15/6/17.
 */
public class OrderCarPoolItem {

    public String id;
    public String orderType;//订单类型
    public int adultCount;
    public int childCount;
    public int babyCount;
    public String location;

    public OrderCarPoolItem(){

    }
    public OrderCarPoolItem(int adultCount, int childCount, int babyCount, String location) {
        this.adultCount = adultCount;
        this.childCount = childCount;
        this.babyCount = babyCount;
        this.location = location;
    }
}
