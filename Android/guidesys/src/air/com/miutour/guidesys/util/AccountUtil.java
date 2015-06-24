package air.com.miutour.guidesys.util;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import cn.com.crazydemon.okhttp.HttpUtils;
import cn.com.crazydemon.okhttp.HttploadingListener;
import cn.com.crazydemon.utils.PreferencesUtils;
import air.com.miutour.guidesys.common.config.Env;
import air.com.miutour.guidesys.common.config.Urls;
import air.com.miutour.guidesys.model.Account;
import android.app.Activity;
import android.content.Context;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;

public class AccountUtil {

    private static final String ACCOUNT_PRE = "account_pre";
    private static final String ACCOUNT_KEY = "account_key";
    
    public static Account getLoginAccount(Context context){
        if (context == null)
            return null;
        String account_message = PreferencesUtils.getPreference(context, ACCOUNT_PRE, ACCOUNT_KEY, "");
        Account account = null;
        try {
            if (!account_message.equals("")) {
                JSONObject accountJson = new JSONObject(account_message);
                account = new Account();
                account.userId = accountJson.optString("userId");
                account.password = accountJson.optString("password");
                account.token = accountJson.optString("token");
                account.username = accountJson.optString("username");
                account.imgUrl = accountJson.optString("imgUrl");
                account.nonce = accountJson.optString("nonce");
                account.expired = accountJson.optLong("expired");
                account.loginTime = accountJson.optLong("loginTime");
            }
        } catch (JSONException e) {
            account = null;
            e.printStackTrace();
        }

        
        return account;
    }
    
    
    public static void saveAccount(Context context, Account account){
        JSONObject accountJson = new JSONObject();
        try {
            accountJson.put("username", account.username);
            accountJson.put("password", account.password);
            accountJson.put("token", account.token);
            accountJson.put("userId", account.userId);
            accountJson.put("imgUrl", account.imgUrl);
            accountJson.put("nonce", account.nonce);
            accountJson.put("expired", account.expired);
            accountJson.put("loginTime", System.currentTimeMillis());
            PreferencesUtils.setPreferences(context, ACCOUNT_PRE, ACCOUNT_KEY, accountJson.toString());
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }
    
    public static void login(final Activity context1, final String username, final String password, final LoginResult loginResul){

        HashMap<String, String> params = new HashMap<String, String>();
        params.put("username", username);
        params.put("passwd", password);
        params.put("devicetoken", ((TelephonyManager) context1.getSystemService(Context.TELEPHONY_SERVICE)).getDeviceId());
        params.put("type", "android");
        params.put("nonce", "miutour.xyz~");
        try {
            params.put("signature", MD5.getSignatureByValue(params, ""));
        } catch (IOException e1) {
            e1.printStackTrace();
        }
        params.remove("nonce");
        Map<String, String> header = new HashMap<String, String>();
        header.put("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");

        HttpUtils.getInstance().postJson(Urls.LOGIN_URL, null, header, params, new HttploadingListener() {
            @Override
            public void onSuccess2JsonObject(int statusCode, JSONObject jsonObject) {
                if (loginResul==null) return;
                if (jsonObject!=null) {
                    if (!TextUtils.isEmpty(jsonObject.optString("err_code"))) {
                        if (jsonObject.optString("err_code").equals("0")) {
                            JSONObject data = jsonObject.optJSONObject("data");
                            if (data != null) {
                                Account account = new Account();
                                account.password = password;
                                account.token = data.optString("token");
                                account.username = username;
                                account.nonce = data.optString("nonce");
                                account.expired = data.optLong("expired ");
                                saveAccount(context1, account);
                                loginResul.onSuccess(account);
                            }
                        }else{
                            loginResul.onFailure(jsonObject.optString("err_msg"));
                        }
                        
                        
                        
                    } else {
                        String content = null;
                        for (int i = 1; i < 12; i++) {
                            content = jsonObject.optString("" + i);
                            if (!TextUtils.isEmpty(content)) {
                                loginResul.onFailure(content);
                                return;
                            }
                        }
                    }
                } else {
                    loginResul.onFailure("服务器错误");
                }
            }

            @Override
            public void onFail(Exception e) {
                if (loginResul!=null) {
                    loginResul.onFailure("网络不可用");
                }
            }
        });
        
        
        
        
        
        
        
    }
    
 // 登录结果
    public interface LoginResult {
        public void onSuccess(Account accunt);

        public void onFailure(String errorMessage);
    }
    
}
