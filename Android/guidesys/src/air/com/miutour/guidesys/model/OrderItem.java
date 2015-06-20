package air.com.miutour.guidesys.model;

import java.util.List;

public class OrderItem {
    public String id;
    public String type;         //订单类型
    public String oType;        //接/送机
    public String time;         //订单时间
    public String start;        //出发地点
    public String arrive;       //送达地点
    public String hotelName;
    public String hotelAddr;
    public String airPort;
    public String flightNo;
    public String content;      //非接机内容
    public String seatNum;      //座位数
    public boolean isBid;       //是否出价
    public String midText;      //底部中间内容(组数、路程)
    public String orderPrice;   //指导价
    public String bid;          //出价
    public boolean isEmergency; //是否紧急
    public String extraPrice;   //补贴
    public List<ExtraItem> extras;

    public int agreedOrderState; // 已接订单状态：1.未开始，2.正在服务中，3.已结束
    @Override
    public String toString() {
        return "OrderItem [id=" + id + ", type=" + type + ", oType=" + oType + ", time=" + time + ", start=" + start + ", arrive=" + arrive + ", hotelName=" + hotelName + ", hotelAddr=" + hotelAddr + ", airPort=" + airPort + ", content=" + content
                + ", seatNum=" + seatNum + ", isBid=" + isBid + ", midText=" + midText + ", orderPrice=" + orderPrice + ", bid=" + bid + ", isEmergency=" + isEmergency + ", extraPrice=" + extraPrice + ", extras=" + extras + "]";
    }
    
    
    
}
