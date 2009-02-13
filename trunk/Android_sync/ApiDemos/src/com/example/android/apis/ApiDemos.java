package com.example.android.apis;

import android.app.ListActivity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ApiDemos extends ListActivity {
	private static final String TAG = "ApiDemos";

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		// Return the intent that started this activity.
		Intent intent = getIntent();
		String path = intent.getStringExtra("com.example.android.apis.Path");

		if (path == null) {
			path = "";
		}

		// ΪListActivity�е�ListView������
		setListAdapter(new SimpleAdapter(this, getData(path),
				android.R.layout.simple_list_item_1, new String[] { "title" },
				new int[] { android.R.id.text1 }));
		// �õ��ڴ�ListActivity�е�ListView
		ListView listView = getListView();
		// ���ù�����
		listView.setTextFilterEnabled(true);
	}

	protected List getData(String prefix) {
		List<Map> myData = new ArrayList<Map>();

		Intent mainIntent = new Intent(Intent.ACTION_MAIN, null);
		mainIntent.addCategory(Intent.CATEGORY_SAMPLE_CODE);

		PackageManager pm = getPackageManager();
		List<ResolveInfo> list = pm.queryIntentActivities(mainIntent, 0);

		if (null == list)
			return myData;

		String[] prefixPath;

		if (prefix.equals("")) {
			prefixPath = null;
			// debug
			// Log.d(TAG, "prefixPath: Null");
		} else {
			prefixPath = prefix.split("/");

			// debug
			// for (int i = 0; i < prefixPath.length; i++) {
			// Log.d(TAG, "prefixPath: " + prefixPath[i]);
			// }
		}

		int len = list.size();

		Map<String, Boolean> entries = new HashMap<String, Boolean>();

		// ��������ʾ���Intent(ָ�������activity)
		for (int i = 0; i < len; i++) {
			ResolveInfo info = list.get(i);
			CharSequence labelSeq = info.loadLabel(pm);
			String label = labelSeq != null ? labelSeq.toString()
					: info.activityInfo.name;
			// debug
			Log.d(TAG, "label: " + label);

			if (prefix.length() == 0 || label.startsWith(prefix)) {

				String[] labelPath = label.split("/");

				// ����������activity����ʾ������, ������������activity����ʾ��Ŀ¼��
				String nextLabel = ((prefixPath == null) ? labelPath[0]
						: labelPath[prefixPath.length]);
				// debug
				// Log.d(TAG, "nextLabel: " + nextLabel);

				if ((prefixPath != null ? prefixPath.length : 0) == labelPath.length - 1) {
					addItem(myData, nextLabel, activityIntent(
							info.activityInfo.applicationInfo.packageName,
							info.activityInfo.name));
					Log.e(TAG, "packageName: "
							+ info.activityInfo.applicationInfo.packageName);
					Log.e(TAG, "componentName: " + info.activityInfo.name);
				} else {
					if (entries.get(nextLabel) == null) {
						addItem(myData, nextLabel, browseIntent(prefix
								.equals("") ? nextLabel : prefix + "/"
								+ nextLabel));
						entries.put(nextLabel, true);
					}
				}
			}
		}

		Collections.sort(myData, sDisplayNameComparator);

		return myData;
	}

	private final static Comparator<Map> sDisplayNameComparator = new Comparator<Map>() {
		private final Collator collator = Collator.getInstance();

		public int compare(Map map1, Map map2) {
			return collator.compare(map1.get("title"), map2.get("title"));
		}
	};

	/** �ѵ���Ŀ¼��ĩ��, */
	protected Intent activityIntent(String packageName, String componentName) {
		Intent result = new Intent();
		result.setClassName(packageName, componentName);
		return result;
	}

	/** û�е�Ŀ¼��ĩ��(ĩ����activity), �����ڴ�listActivity����ʾ */
	protected Intent browseIntent(String path) {
		Intent result = new Intent();
		result.setClass(this, ApiDemos.class);
		result.putExtra("com.example.android.apis.Path", path);
		return result;
	}

	/** ��ListView��������ʾitem */
	protected void addItem(List<Map> data, String name, Intent intent) {
		Map<String, Object> temp = new HashMap<String, Object>();
		temp.put("title", name);
		temp.put("intent", intent);
		data.add(temp);
	}

	/** �����Ŀ¼�������һ��Ŀ¼,����Ѿ���Ŀ¼��ĩ����ִ�и�activity */
	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		Map map = (Map) l.getItemAtPosition(position);

		Intent intent = (Intent) map.get("intent");
		startActivity(intent);
	}

}