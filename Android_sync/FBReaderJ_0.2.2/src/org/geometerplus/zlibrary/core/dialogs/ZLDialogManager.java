/*
 * Copyright (C) 2007-2008 Geometer Plus <contact@geometerplus.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

package org.geometerplus.zlibrary.core.dialogs;

import org.geometerplus.zlibrary.core.application.ZLApplication;
import org.geometerplus.zlibrary.core.application.ZLApplicationWindow;
import org.geometerplus.zlibrary.core.resources.ZLResource;

public abstract class ZLDialogManager {
	protected static ZLDialogManager ourInstance;
	
	public static final String OK_BUTTON = "ok";
	public static final String CANCEL_BUTTON = "cancel";
	public static final String YES_BUTTON = "yes";
	public static final String NO_BUTTON = "no";
	public static final String APPLY_BUTTON = "apply";
	
	public static final String COLOR_KEY = "color";
	public static final String DIALOG_TITLE = "title";
	
	protected ZLDialogManager() {
		ourInstance = this;
	}
	
	public static ZLDialogManager getInstance() {
		return ourInstance;
	} 
	
	public abstract void runSelectionDialog(String key, ZLTreeHandler handler, Runnable actionOnAccept);

	public abstract void showInformationBox(String key, String message);

	public final void showInformationBox(String key) {
		showInformationBox(key, getDialogMessage(key));
	}
	
	public abstract void showErrorBox(String key, String message, Runnable action);
	
	public final void showErrorBox(String key, Runnable action) {
		showErrorBox(key, getDialogMessage(key), action);
	}
	
	public abstract void showQuestionBox(String key, String message, String button0, Runnable action0, String button1, Runnable action1, String button2, Runnable action2);

	public final void showQuestionBox(String key, String button0, Runnable action0, String button1, Runnable action1, String button2, Runnable action2) {
		showQuestionBox(key, getDialogMessage(key), button0, action0, button1, action1, button2, action2);
	}
	
	public abstract ZLApplicationWindow createApplicationWindow(ZLApplication application);
	
	public abstract ZLDialog createDialog(String key);
	
	public abstract ZLOptionsDialog createOptionsDialog(String key, Runnable exitAction, Runnable applyAction, boolean showApplyButton);
	
	public abstract void wait(String key, Runnable runnable);
	
	public static String getButtonText(String key) {
		return getResource().getResource("button").getResource(key).getValue();
	}

	public static String getWaitMessageText(String key) {
		return getResource().getResource("waitMessage").getResource(key).getValue();
	}
	
	public static String getDialogMessage(String key) {
		return getResource().getResource(key).getResource("message").getValue();
	}
	
	public static String getDialogTitle(String key) {
		return getResource().getResource(key).getResource("title").getValue();
	}
	
	protected static ZLResource getResource() {
		return ZLResource.resource("dialog");
	}
}


/*
 * 
 * 

public:
	

	virtual shared_ptr<ZLDialog> createDialog(const ZLResourceKey &key) const = 0;
	
	virtual void wait(const ZLResourceKey &key, Runnable &runnable) const = 0;

	interface ClipboardType {
		CLIPBOARD_MAIN,
		CLIPBOARD_SELECTION
	};
	virtual bool isClipboardSupported(ClipboardType type) const = 0;
	virtual void setClipboardText(const std::string &text, ClipboardType type) const = 0;
 * 
 */
