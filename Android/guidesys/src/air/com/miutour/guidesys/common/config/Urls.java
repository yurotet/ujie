package air.com.miutour.guidesys.common.config;

public class Urls {

    
    public static final String BASE_URL = "http://testgapi.miutour.com";//测试接口
//    public static final String BASE_URL = "http://gapi.miutour.com";//正式接口
    
    //登录
    public static final String LOGIN_URL = BASE_URL + "/user/login";
    
    //订单列表
    public static final String ORDER_LIST = BASE_URL + "/bidding/blist";
    
    //订单详情
    public static final String ORDER_INFOR = BASE_URL + "/bidding/detail";
    
    //出价
    public static final String BID_PRICE = BASE_URL + "/bidding/price";
    
    //删除
    public static final String DELETE_BID = BASE_URL + "/bidding/price";
    
}
