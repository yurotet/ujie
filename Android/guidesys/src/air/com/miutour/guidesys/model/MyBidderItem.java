package air.com.miutour.guidesys.model;

/**
 * Created by user on 15/6/17.
 */
public class MyBidderItem {

    public String id;
    public String date; //出价时间
    public String carModel; //车辆品牌
    public String carType; //车型
    public String seatNum; //座位数
    public String price; //价格

    public MyBidderItem(){
        
    }
    public MyBidderItem(String price, String date) {
        this.price = price;
        this.date = date;
    }
}
