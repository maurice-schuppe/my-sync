package com.example.android.apis.view;

import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import android.widget.ImageView;
import android.graphics.BitmapFactory;
import android.graphics.Bitmap;
import com.example.android.apis.R;

/**
 * Demonstrates how to write an efficient list adapter. The adapter used in this
 * example binds to an ImageView and to a TextView for each row in the list.
 * 
 * To work efficiently the adapter implemented here uses two techniques: - It
 * reuses the convertView passed to getView() to avoid inflating View when it is
 * not necessary - It uses the ViewHolder pattern to avoid calling
 * findViewById() when it is not necessary
 * 
 * The ViewHolder pattern consists in storing a data structure in the tag of the
 * view returned by getView(). This data structures contains references to the
 * views we want to bind data to, thus avoiding calls to findViewById() every
 * time getView() is invoked.
 */
public class List14 extends ListActivity {

	private static class EfficientAdapter extends BaseAdapter {
		private LayoutInflater mInflater;
		private Bitmap mIcon1;
		private Bitmap mIcon2;

		public EfficientAdapter(Context context) {
			// Cache the LayoutInflate to avoid asking for a new one each time.
			mInflater = LayoutInflater.from(context);

			// Icons bound to the rows.
			mIcon1 = BitmapFactory.decodeResource(context.getResources(),
					R.drawable.icon48x48_1);
			mIcon2 = BitmapFactory.decodeResource(context.getResources(),
					R.drawable.icon48x48_2);
		}

		/**
		 * The number of items in the list is determined by the number of
		 * speeches in our array.
		 * 
		 * @see android.widget.ListAdapter#getCount()
		 */
		public int getCount() {
			return DATA.length;
		}

		/**
		 * Since the data comes from an array, just returning the index is
		 * sufficent to get at the data. If we were using a more complex data
		 * structure, we would return whatever object represents one row in the
		 * list.
		 * 
		 * @see android.widget.ListAdapter#getItem(int)
		 */
		public Object getItem(int position) {
			return position;
		}

		/**
		 * Use the array index as a unique id.
		 * 
		 * @see android.widget.ListAdapter#getItemId(int)
		 */
		public long getItemId(int position) {
			return position;
		}

		/**
		 * Make a view to hold each row.
		 * 
		 * @see android.widget.ListAdapter#getView(int, android.view.View,
		 *      android.view.ViewGroup)
		 */
		public View getView(int position, View convertView, ViewGroup parent) {
			// A ViewHolder keeps references to children views to avoid
			// unneccessary calls to findViewById() on each row.
			ViewHolder holder;

			// When convertView is not null, we can reuse it directly, there is
			// no need to reinflate it. We only inflate a new View when the
			// convertView supplied by ListView is null.
			if (convertView == null) {
				convertView = mInflater.inflate(R.layout.list_item_icon_text,
						null);

				// Creates a ViewHolder and store references to the two children
				// views we want to bind data to.
				holder = new ViewHolder();
				holder.text = (TextView) convertView.findViewById(R.id.text);
				holder.icon = (ImageView) convertView.findViewById(R.id.icon);

				convertView.setTag(holder);
			} else {
				// Get the ViewHolder back to get fast access to the TextView
				// and the ImageView.
				holder = (ViewHolder) convertView.getTag();
			}

			// Bind the data efficiently with the holder.
			holder.text.setText(DATA[position]);
			holder.icon.setImageBitmap((position & 1) == 1 ? mIcon1 : mIcon2);

			return convertView;
		}

		static class ViewHolder {
			TextView text;
			ImageView icon;
		}
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setListAdapter(new EfficientAdapter(this));
	}

	private static final String[] DATA = { "Abbaye de Belloc",
			"Abbaye du Mont des Cats", "Abertam", "Abondance", "Ackawi",
			"Acorn", "Adelost", "Affidelice au Chablis", "Afuega'l Pitu",
			"Airag", };
}
