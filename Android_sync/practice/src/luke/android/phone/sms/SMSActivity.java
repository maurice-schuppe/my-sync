package luke.android.phone.sms;

import luke.android.R;
import android.app.Activity;
import android.os.Bundle;

public class SMSActivity extends Activity {
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.phone_sms);
	}
}