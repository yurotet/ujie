package air.com.miutour.guidesys.model;

import java.util.List;

public class OrderInfor {

    public String type;     //订单类型
    public String price;    //订单价格
    public String content;  //订单简介
    public OrderBaseInfor baseInfor; //基本信息
    public List<String> destinations;   //行程
    public List<String> includeList;   //行程
    public List<String> unIncludeList;   //行程
    
}
