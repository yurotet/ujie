package air.com.miutour.guidesys.module.base;


import air.com.miutour.R;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;


public class BaseFragmentActivity extends FragmentActivity{



    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }


    @Override
    public void onBackPressed() {
        this.finish();
        this.overridePendingTransition(0, R.anim.right_fade_out);
    }

}
