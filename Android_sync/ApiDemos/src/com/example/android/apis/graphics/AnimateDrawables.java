/* 
 * Copyright (C) 2008 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.example.android.apis.graphics;

import com.example.android.apis.R;

import android.app.Activity;
import android.content.Context;
import android.graphics.*;
import android.graphics.drawable.*;
import android.view.animation.*;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;

public class AnimateDrawables extends GraphicsActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(new SampleView(this));
    }
    
    private static class SampleView extends View {
        private AnimateDrawable mDrawable;

        public SampleView(Context context) {
            super(context);
            setFocusable(true);
            setFocusableInTouchMode(true);

            Drawable dr = context.getResources().getDrawable(R.drawable.beach);
            dr.setBounds(0, 0, dr.getIntrinsicWidth(), dr.getIntrinsicHeight());
            
            Animation an = new TranslateAnimation(0, 100, 0, 200);
            an.setDuration(2000);
            an.setRepeatCount(-1);
            an.initialize(10, 10, 10, 10);
            
            mDrawable = new AnimateDrawable(dr, an);
            an.startNow();
        }
        
        @Override protected void onDraw(Canvas canvas) {
            canvas.drawColor(Color.WHITE);

            mDrawable.draw(canvas);
            invalidate();
        }
    }
}

