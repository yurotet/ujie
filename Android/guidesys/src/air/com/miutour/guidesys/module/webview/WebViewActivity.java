package air.com.miutour.guidesys.module.webview;

import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.Layout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;

import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaChromeClient;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CordovaWebViewClient;
import org.apache.cordova.LOG;

import air.com.miutour.R;

/**
 * Created by pcgroup on 15/6/13.
 */
public class WebViewActivity extends CordovaActivity{

    private EditText editText;
    private Button enterButton;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        root.setBackgroundColor(Color.WHITE);
        loadUrl("http://www.baidu.com");
    }

    public void init(CordovaWebView webView, CordovaWebViewClient webViewClient, CordovaChromeClient webChromeClient) {
        this.appView = webView;
        this.appView.setId(100);
        this.appView.setWebViewClient(webViewClient);
        this.appView.setWebChromeClient(webChromeClient);
        webViewClient.setWebView(this.appView);
        webChromeClient.setWebView(this.appView);
        this.appView.setLayoutParams(new LinearLayout.LayoutParams(-1, 0, 1.0F));
        if(this.getBooleanProperty("DisallowOverscroll", false) && Build.VERSION.SDK_INT >= 9) {
            this.appView.setOverScrollMode(2);
        }

        View view = LayoutInflater.from(this).inflate(R.layout.layout_edittext, null);

        editText = (EditText) view.findViewById(R.id.webview_edittext);
        enterButton = (Button) view.findViewById(R.id.webview_enter);
        root.addView(view);
        enterButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (editText.getText() != null) {
                    loadUrl(editText.getText().toString());
                }
            }
        });

        this.appView.setVisibility(View.INVISIBLE);
        this.root.addView(this.appView);
        this.setContentView(this.root);
        this.cancelLoadUrl = false;
    }
}
