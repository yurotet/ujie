package air.com.miutour.guidesys.module.order;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import air.com.miutour.guidesys.common.config.Urls;
import air.com.miutour.guidesys.model.Account;
import air.com.miutour.guidesys.model.CarInfo;
import air.com.miutour.guidesys.model.MyBidderItem;
import air.com.miutour.guidesys.model.OrderBaseInfor;
import air.com.miutour.guidesys.model.OrderCarPoolItem;
import air.com.miutour.guidesys.model.OrderItem;
import air.com.miutour.guidesys.util.AccountUtil;
import air.com.miutour.guidesys.util.MD5;
import android.content.Context;
import android.text.TextUtils;
import android.util.Log;
import cn.com.crazydemon.okhttp.HttpUtils;
import cn.com.crazydemon.okhttp.HttploadingListener;

public class OrderSever {

    public static List<OrderItem> getOrderList(JSONObject result) {
        List<OrderItem> datas = new ArrayList<OrderItem>();
        if (result != null) {
            JSONArray array = result.optJSONArray("data");
            if (array != null && array.length() > 0) {
                int len = array.length();
                OrderItem order;
                for (int i = 0; i < len; i++) {
                    order = new OrderItem();
                    JSONObject item = array.optJSONObject(i);
                    order.id = item.optString("id");
                    order.type = item.optString("type");
                    order.time = item.optString("time");
                    order.content = item.optString("title");
                    order.seatNum = item.optString("seatnum");
                    order.orderPrice = item.optString("price");
                    // order.bid = item.optString("myprice");
                    // order.extraPrice = item.optString("subsidy");
                    order.bid = item.optInt("myprice") + "";
                    order.extraPrice = item.optInt("subsidy") + "";
                    if (order.bid.equals("0") || order.bid.equals("")) {
                        order.isBid = false;
                    } else {
                        order.isBid = true;
                    }
                    // if (item.optString("urgent").equals("1")) {
                    // order.isEmergency = true;
                    // }else{
                    // order.isEmergency = false;
                    // }
                    if (item.optInt("urgent", -1) == 1) {
                        order.isEmergency = true;
                    } else {
                        order.isEmergency = false;
                    }
                    if (!order.type.equals("")) {
                        if (order.type.equals("拼车")) {
                            order.midText = item.optString("nums");
                        } else if (order.type.equals("包车")) {
                            order.midText = item.optString("mile");
                        } else if (order.type.equals("接送机")) {
                            order.midText = item.optString("mile");
                            order.oType = item.optString("otype");
                            order.hotelName = item.optString("hotel_name");
                            order.hotelAddr = item.optString("hotel_address");
                            order.airPort = item.optString("airport");
                            if (order.oType.equals("接机")) {
                                order.start = order.airPort;
                                order.arrive = order.hotelAddr;
                            }else if (order.oType.equals("送机")) {
                                order.start = order.hotelAddr;
                                order.arrive = order.airPort;
                            }
                        }
                    }
                    datas.add(order);

                }
            }
        }

        return datas;

    }
    public static void parseMixedOrder(JSONObject result, OrderBaseInfor baseInfor,List<OrderItem> childOrders) {
        JSONObject data = result.optJSONObject("data");
        if (data != null) {
            parseBaseInfo(data, baseInfor);
            
            JSONArray childOrderArray = data.optJSONArray("children");
            if (childOrderArray!=null && childOrders!=null) {
                OrderItem orderItem;
                JSONObject orderObject;
                for (int i = 0; i < childOrderArray.length(); i++) {
                    orderObject = childOrderArray.optJSONObject(i);
                    if (orderObject != null) {
                        orderItem = new OrderItem();
                        orderItem.id = orderObject.optString("id");
                        orderItem.type = orderObject.optString("type");
                        orderItem.orderPrice = orderObject.optString("price");
                        orderItem.time = orderObject.optString("time");
                        orderItem.midText = orderObject.optString("mile");
                        orderItem.extraPrice = orderObject.optString("subsidy");
                        if("包车".equals(orderItem.type)) {
                            orderItem.content = orderObject.optString("address");
                        } else if ("接送机".equals(orderItem.type)) {
                            orderItem.oType = orderObject.optString("otype");
                            orderItem.hotelAddr = orderObject.optString("hotel_address");
                            orderItem.hotelName = orderObject.optString("hotel_name");
                            orderItem.airPort = orderObject.optString("airport");
                            orderItem.flightNo = orderObject.optString("flight_no");
                            if (orderItem.oType.equals("接机")) {
                                orderItem.start = orderItem.airPort;
                                orderItem.arrive = orderItem.hotelAddr;
                            }else if (orderItem.oType.equals("送机")) {
                                orderItem.start = orderItem.hotelAddr;
                                orderItem.arrive = orderItem.airPort;
                            }
                        }
                        childOrders.add(orderItem);
                    }
                }
            }
        }
    }
    
    public static void parsePickUpOrder(JSONObject result, OrderBaseInfor baseInfor,List<String> locationDatas, List<String> includeDatas,  List<String> unIncludeDatas) {
        JSONObject data = result.optJSONObject("data");
        if (data != null) {
            Log.i("czb", data.toString());
            parseBaseInfo(data, baseInfor);
            
            baseInfor.flightNo = data.optString("flight_no");
            baseInfor.hotelAddress = data.optString("hotel_address");
            baseInfor.hotelName = data.optString("hotel_name");
            baseInfor.otype = data.optString("otype");
            baseInfor.airport = data.optString("airport");
            if ("接机".equals(baseInfor.otype)) {
                baseInfor.destination = baseInfor.hotelName;
                locationDatas.add(baseInfor.airport);
                locationDatas.add(baseInfor.hotelAddress);
            } else {
                baseInfor.destination = baseInfor.airport;
                locationDatas.add(baseInfor.hotelAddress);
                locationDatas.add(baseInfor.airport);
            }
            JSONArray includeArray = data.optJSONArray("cost_include");
            if (includeArray!=null && includeDatas!=null) {
                for (int i = 0; i < includeArray.length(); i++) {
                    includeDatas.add(includeArray.optString(i));
                }
            }
            JSONArray unincludeArray = data.optJSONArray("cost_uninclude");
            if (unincludeArray!=null && unIncludeDatas!=null) {
                for (int i = 0; i < unincludeArray.length(); i++) {
                    unIncludeDatas.add(unincludeArray.optString(i));
                }
            }
        }
    }
    
    public static void parseCharteredOrder(JSONObject result, OrderBaseInfor baseInfor,List<String> locationDatas, List<String> includeDatas,  List<String> unIncludeDatas) {
        JSONObject data = result.optJSONObject("data");
        if (data != null) {
            parseBaseInfo(data, baseInfor);
            
            JSONArray locationArray = data.optJSONArray("travel_route");
            if (locationArray!=null && locationDatas!=null) {
                for (int i = 0; i < locationArray.length(); i++) {
                    locationDatas.add(locationArray.optString(i));
                }
            }
            JSONArray includeArray = data.optJSONArray("cost_include");
            if (includeArray!=null && includeDatas!=null) {
                for (int i = 0; i < includeArray.length(); i++) {
                    includeDatas.add(includeArray.optString(i));
                }
            }
            JSONArray unincludeArray = data.optJSONArray("cost_uninclude");
            if (unincludeArray!=null && unIncludeDatas!=null) {
                for (int i = 0; i < unincludeArray.length(); i++) {
                    unIncludeDatas.add(unincludeArray.optString(i));
                }
            }
        }
    }
    
    public static void parseCarpoolOrder(JSONObject result, OrderBaseInfor baseInfor, List<OrderCarPoolItem> carPoolItems) {
        JSONObject data = result.optJSONObject("data");
        if (data != null) {
            parseBaseInfo(data, baseInfor);
            
            JSONArray carPoolArray = data.optJSONArray("children");
            if (carPoolArray!=null && carPoolItems!=null) {
                OrderCarPoolItem carPoolItem;
                JSONObject carPoolObject;
                JSONArray persons;
                for (int i = 0; i < carPoolArray.length(); i++) {
                    carPoolObject = carPoolArray.optJSONObject(i);
                    if (carPoolObject != null) {
                        carPoolItem = new OrderCarPoolItem();
                        carPoolItem.id = carPoolObject.optString("id");
                        carPoolItem.location = carPoolObject.optString("address");
                        carPoolItem.orderType = carPoolObject.optString("type");
                        persons = data.optJSONArray("person");
                        if (persons!=null) {
                            for (int j = 0; j < persons.length(); j++) {
                                if (i==0) {
                                    carPoolItem.adultCount = persons.optInt(0);
                                } else if (i==1) {
                                    carPoolItem.childCount = persons.optInt(1);
                                } else if (i==2) {
                                    carPoolItem.babyCount = persons.optInt(2);
                                    break;
                                }
                            }
                        }
                        carPoolItems.add(carPoolItem);
                    }
                }
            }
        }
    }
    
    public static void parseBaseInfo(JSONObject data, OrderBaseInfor baseInfor) {
        if (data != null) {
            baseInfor.id = data.optString("id");
            baseInfor.orderNo = data.optString("ordid");
            baseInfor.orderType = data.optString("type");
            baseInfor.orderPrice = data.optString("price");
            baseInfor.orderConent = data.optString("title");
            JSONArray personArray = data.optJSONArray("person");
            if (personArray!=null) {
                for (int i = 0; i < personArray.length(); i++) {
                    if (i==0) {
                        baseInfor.adultNum = personArray.optInt(0) + "";
                    } else if (i==1) {
                        baseInfor.childNum = personArray.optInt(1) + "";
                    } else if (i==2) {
                        baseInfor.babNum = personArray.optInt(2) + "";
                        break;
                    }
                }
            }
            baseInfor.time = data.optString("time");
            baseInfor.seatNum = data.optInt("seatnum") + "";
            baseInfor.groupCount = data.optInt("nums") + "";
            baseInfor.isEmergency = data.optInt("urgent", -1)==1;
            baseInfor.extraPrice = data.optInt("subsidy") + "";
            
            JSONArray bidderArray = data.optJSONArray("bidder");
            if (bidderArray != null) {
                baseInfor.myBidders = new ArrayList<MyBidderItem>();
                MyBidderItem bidderItem;
                JSONObject bidderObject;
                for (int i = 0; i < bidderArray.length(); i++) {
                    bidderObject = bidderArray.optJSONObject(i);
                    if (bidderObject != null) {
                        bidderItem = new MyBidderItem();
                        bidderItem.id = bidderObject.optString("id");
                        bidderItem.price = bidderObject.optString("price");
                        bidderItem.carModel = bidderObject.optString("car_models");
                        bidderItem.carType = bidderObject.optString("car_type");
                        bidderItem.seatNum = bidderObject.optString("car_seatnum");
                        bidderItem.date = bidderObject.optString("atime");
                        baseInfor.myBidders.add(bidderItem);
                    }
                }
            }
            JSONArray carArray = data.optJSONArray("car");
            if (carArray != null) {
                baseInfor.carInfos = new ArrayList<CarInfo>();
                baseInfor.carTypes = new ArrayList<String>();
                CarInfo carInfoItem;
                JSONObject carInfoObject;
                for (int i = 0; i < carArray.length(); i++) {
                    carInfoObject = carArray.optJSONObject(i);
                    if (carInfoObject != null) {
                        carInfoItem = new CarInfo();
                        carInfoItem.id = carInfoObject.optString("id");
                        carInfoItem.uid = carInfoObject.optString("uid");
                        carInfoItem.model = carInfoObject.optString("models");
                        carInfoItem.type = carInfoObject.optString("type");
                        carInfoItem.seatNum = carInfoObject.optString("number");
                        carInfoItem.year = carInfoObject.optString("year");
                        carInfoItem.age = carInfoObject.optString("age");
                        carInfoItem.seatNum = carInfoObject.optString("seatnum");
                        baseInfor.carTypes.add(carInfoObject.optString("seatnum"));
                        baseInfor.carInfos.add(carInfoItem);
                        
                    }
                }
            }
        }
    }
    
    public static void addBidder(String userName, String token, String signature, String orderId, String price, String carModel, String carType, String carSeatNum, final HttpListener listener) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("username", userName);
        params.put("token", token);
        params.put("id", orderId);
        params.put("price", price);
        params.put("car_models", carModel);
        params.put("car_type", carType);
        params.put("car_seatnum", carSeatNum);
        params.put("nonce", signature);
        try {
            params.put("signature", MD5.getSignatureByValue(params, ""));
        } catch (IOException e1) {
            e1.printStackTrace();
        }
        params.remove("nonce");
        Map<String, String> header = new HashMap<String, String>();
        header.put("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");

        String url = "http://testgapi.miutour.com/bidding/price";
        HttpUtils.getInstance().postJson(url, null, header, params, new HttploadingListener() {
            @Override
            public void onSuccess2JsonObject(int statusCode, JSONObject jsonObject) {
                if (listener==null) return;
                if (jsonObject!=null) {
                    if (!TextUtils.isEmpty(jsonObject.optString("err_code"))) {
                        if (jsonObject.optString("err_code").equals("0")) {
                            listener.onSuccess(jsonObject);
                        }else{
                            listener.onFailure(jsonObject.optString("err_msg"));
                        }
                        
                    }
                } else {
                    listener.onFailure("服务器错误");
                }
            }

            @Override
            public void onFail(Exception e) {
                if (listener!=null) {
                    listener.onFailure("网络不可用");
                }
            }
        });
    }
    
    public static void deleteMyBidder(String userName, String token, String signature, String id, final HttpListener listener) {
        Map<String, String> params = new HashMap<String, String>();
        params.put("username", userName);
        params.put("token", token);
        params.put("nonce", signature);
        params.put("id", id);
        try {
            params.put("signature", MD5.getSignatureByValue(params, ""));
        } catch (IOException e1) {
            e1.printStackTrace();
        }
        params.remove("nonce");
        Map<String, String> header = new HashMap<String, String>();
        header.put("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");

        String url = "http://testgapi.miutour.com/bidding/delprice";
        HttpUtils.getInstance().postJson(url, null, header, params, new HttploadingListener() {
            @Override
            public void onSuccess2JsonObject(int statusCode, JSONObject jsonObject) {
                if (listener==null) return;
                if (jsonObject!=null) {
                    Log.i("czb", jsonObject.toString());
                    if (!TextUtils.isEmpty(jsonObject.optString("err_code"))) {
                        if (jsonObject.optString("err_code").equals("0")) {
                            listener.onSuccess(jsonObject);
                        }else{
                            listener.onFailure(jsonObject.optString("err_msg"));
                        }
                        
                    }
                } else {
                    listener.onFailure("服务器错误");
                }
            }

            @Override
            public void onFail(Exception e) {
                if (listener!=null) {
                    listener.onFailure("网络不可用");
                }
            }
        });
    }

    public interface HttpListener {
        void onSuccess(String content);
        void onSuccess(JSONObject result);
        void onFailure(String content);
    }
    
    
    public static void loadInforData(Context context,String orderId,String TAG,final HttpListener listener) {
        Map<String, String> header = new HashMap<String, String>();
        header.put("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
        Map<String, String> param = new HashMap<String, String>();
        Account account = AccountUtil.getLoginAccount(context);
        param.put("username", account.username);
        param.put("token", account.token);
        param.put("id", orderId);
        param.put("nonce", account.nonce);
        try {
            param.put("signature", MD5.getSignatureByValue(param, ""));
        } catch (IOException e1) {
            e1.printStackTrace();
        }
        param.remove("nonce");
        HttpUtils.getInstance().postJson(Urls.ORDER_INFOR, TAG, header, param, new HttploadingListener() {

            @Override
            public void onFail(Exception e) {
                super.onFail(e);
                if (listener!=null) {
                    listener.onFailure("网络不可用");
                }
            }

            @Override
            public void onSuccess2JsonObject(int statusCode, JSONObject jsonObject) {
                super.onSuccess2JsonObject(statusCode, jsonObject);
                if (jsonObject != null) {
                    String code = jsonObject.optString("err_code");
                    if (code.equals("0")) {
                        if (listener!=null) {
                            listener.onSuccess(jsonObject);
                        }
                    }else{
                        if (listener!=null) {
                            listener.onFailure("请求错误");
                        }
                    }
                    
                }
                

            }

        });
    }
    
    
    
    
    
    
    
}
