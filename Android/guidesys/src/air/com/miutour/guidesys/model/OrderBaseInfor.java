package air.com.miutour.guidesys.model;

import java.util.ArrayList;
import java.util.List;

public class OrderBaseInfor {
    public String id;
    public String orderType;    //订单类型
    public String orderConent;  //订单简介
    public String orderNo;      //订单号
    public String orderPrice;   //订单报价
    public String adultNum;     //成人数
    public String childNum;     //学生数
    public String babNum;       //婴儿数
    public String time;         //时间
    public String flightInfor;  //航班信息
    public String destination;  //目的地
    public String myPrice;      //我的出价
    public String highPrice;    //最高出价
    public String extraPrice;    //补贴
    public String seatNum;       //座位数
    public boolean isEmergency;    //是否紧急
    public String requiredCarType; //需求车型
    public String groupCount;       //客人组数
    public List<MyBidderItem> myBidders = new ArrayList<MyBidderItem>(); //我的出价
    public List<CarInfo> carInfos = new ArrayList<CarInfo>(); //车辆信息
    public List<String> carTypes = new ArrayList<String>(); //车辆类型
    
    public String hotelName; // 酒店信息
    public String hotelAddress; //酒店地址
    public String flightNo; // 航班号
    public String airport; // 机场名称
    public String otype; // 接送机类型
}
