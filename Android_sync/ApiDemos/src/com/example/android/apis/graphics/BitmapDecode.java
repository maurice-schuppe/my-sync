package com.example.android.apis.graphics;

import com.example.android.apis.R;

import android.app.Activity;
import android.content.Context;
import android.graphics.*;
import android.graphics.drawable.*;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.*;

import java.io.IOException;
import java.io.InputStream;

public class BitmapDecode extends GraphicsActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(new SampleView(this));
	}

	private static class SampleView extends View {
		private Bitmap mBitmap;
		private Bitmap mBitmap2;
		private Bitmap mBitmap3;
		private Bitmap mBitmap4;
		private Drawable mDrawable;

		private Movie mMovie;
		private long mMovieStart;

		public SampleView(Context context) {
			super(context);
			setFocusable(true);

			java.io.InputStream is;
			is = context.getResources().openRawResource(R.drawable.beach);

			BitmapFactory.Options opts = new BitmapFactory.Options();
			Bitmap bm;

			opts.inJustDecodeBounds = true;
			bm = BitmapFactory.decodeStream(is, null, opts);

			// now opts.outWidth and opts.outHeight are the dimension of the
			// bitmap, even though bm is null

			opts.inJustDecodeBounds = false; // this will request the bm
			opts.inSampleSize = 4; // scaled down by 4
			bm = BitmapFactory.decodeStream(is, null, opts);

			mBitmap = bm;

			// decode an image with transparency
			is = context.getResources().openRawResource(R.drawable.frog);
			mBitmap2 = BitmapFactory.decodeStream(is);

			// create a deep copy of it using getPixels() into different configs
			int w = mBitmap2.getWidth();
			int h = mBitmap2.getHeight();
			int[] pixels = new int[w * h];
			mBitmap2.getPixels(pixels, 0, w, 0, 0, w, h);
			mBitmap3 = Bitmap.createBitmap(pixels, 0, w, w, h,
					Bitmap.Config.ARGB_8888);
			mBitmap4 = Bitmap.createBitmap(pixels, 0, w, w, h,
					Bitmap.Config.ARGB_4444);

			mDrawable = context.getResources().getDrawable(R.drawable.button);
			mDrawable.setBounds(150, 20, 300, 100);

			is = context.getResources()
					.openRawResource(R.drawable.animated_gif);
			mMovie = Movie.decodeStream(is);
		}

		@Override
		protected void onDraw(Canvas canvas) {
			canvas.drawColor(0xFFCCCCCC);

			Paint p = new Paint();
			p.setAntiAlias(true);

			canvas.drawBitmap(mBitmap, 10, 10, null);
			canvas.drawBitmap(mBitmap2, 10, 170, null);
			canvas.drawBitmap(mBitmap3, 110, 170, null);
			canvas.drawBitmap(mBitmap4, 210, 170, null);

			mDrawable.draw(canvas);

			long now = android.os.SystemClock.uptimeMillis();
			if (mMovieStart == 0) { // first time
				mMovieStart = now;
			}
			int relTime = (int) ((now - mMovieStart) % mMovie.duration());
			mMovie.setTime(relTime);
			mMovie.draw(canvas, getWidth() - mMovie.width(), getHeight()
					- mMovie.height());
			invalidate();
		}
	}
}
