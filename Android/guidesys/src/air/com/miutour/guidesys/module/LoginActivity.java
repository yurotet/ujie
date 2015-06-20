package air.com.miutour.guidesys.module;

import air.com.miutour.R;
import air.com.miutour.guidesys.model.Account;
import air.com.miutour.guidesys.module.base.BaseFragmentActivity;
import air.com.miutour.guidesys.util.AccountUtil;
import air.com.miutour.guidesys.util.AccountUtil.LoginResult;
import air.com.miutour.guidesys.util.SoftInputUtils;
import air.com.miutour.guidesys.util.ToastUtils;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

public class LoginActivity extends BaseFragmentActivity {
    
    private EditText idEt;
    private EditText passwordEt;
    private TextView loginTv;
    private TextView forgotTv;
    private TextView registTv;
    private ProgressBar progressBar;
    
    private String username;
    private String password;
    
    

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        initView();
    }




    private void initView() {
        progressBar = (ProgressBar) findViewById(R.id.app_progressbar);
        idEt = (EditText) findViewById(R.id.username_et);
        passwordEt = (EditText) findViewById(R.id.password_et);
        loginTv = (TextView) findViewById(R.id.login_tv);
        forgotTv = (TextView) findViewById(R.id.forgot_password);
        registTv = (TextView) findViewById(R.id.register_tv);
        
        
        
        loginTv.setOnClickListener(clickListener);
        forgotTv.setOnClickListener(clickListener);
        registTv.setOnClickListener(clickListener);
        
        
        
    }
    
    
    /**
     * 点击监听事件
     */
    private OnClickListener clickListener = new OnClickListener() {

        @Override
        public void onClick(View v) {
            int id = v.getId();// 帐号登录
            if (id == R.id.login_tv) {
                login(); 
            } else if (id == R.id.forgot_password) {
                
            } else if (id == R.id.register_tv) {
                regist();
            }
        }

    };
    
    private void login() {
        username = idEt.getText().toString().trim();
        password = passwordEt.getText().toString().trim();
        if (("").equals(username) || ("").equals(password)) {
            SoftInputUtils.closedSoftInput(LoginActivity.this);
            ToastUtils.show(LoginActivity.this, "用户名或密码不能为空！", Toast.LENGTH_SHORT);
        } else {
            SoftInputUtils.closedSoftInput(LoginActivity.this);
            AccountUtil.login(LoginActivity.this, username, password, loginResult);
            progressBar.setVisibility(View.VISIBLE);
            loginTv.setClickable(false);
        }
        
    }

    private LoginResult loginResult = new LoginResult() {

        @Override
        public void onSuccess(Account accunt) {
            ToastUtils.show(LoginActivity.this, "登录成功！", Toast.LENGTH_SHORT);
            progressBar.setVisibility(View.GONE);
            SoftInputUtils.closedSoftInput(LoginActivity.this);
            loginTv.setClickable(true);
        }

        @Override
        public void onFailure(String errorMessage) {
            Log.i("czb", errorMessage);
            ToastUtils.show(LoginActivity.this, errorMessage, Toast.LENGTH_SHORT);
            progressBar.setVisibility(View.GONE);
            SoftInputUtils.closedSoftInput(LoginActivity.this);
            loginTv.setClickable(true);
        };
    };
    
    
    private void regist() {
        // TODO Auto-generated method stub
        
    }
    
    
}
