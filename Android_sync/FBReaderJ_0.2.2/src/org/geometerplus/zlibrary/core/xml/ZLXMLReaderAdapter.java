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

package org.geometerplus.zlibrary.core.xml;

import java.util.*;
import java.io.InputStream;

public class ZLXMLReaderAdapter implements ZLXMLReader {
	public boolean read(String fileName) {
		return ZLXMLProcessorFactory.getInstance().createXMLProcessor().read(this, fileName);
	}
	
	public boolean read(InputStream stream) {
		return ZLXMLProcessorFactory.getInstance().createXMLProcessor().read(this, stream);
	}
	
	public boolean dontCacheAttributeValues() {
		return false;
	}

	public boolean startElementHandler(String tag, ZLStringMap attributes) {
		return false;
	}
	
	public boolean endElementHandler(String tag) {
		return false;
	}
	
	public void characterDataHandler(char[] ch, int start, int length) {
	}

	public void characterDataHandlerFinal(char[] ch, int start, int length) {
		characterDataHandler(ch, start, length);	
	}

	public void startDocumentHandler() {
	}
	
	public void endDocumentHandler() {
	}

	public boolean processNamespaces() {
		return false;
	}

	public void namespaceListChangedHandler(HashMap namespaces) {
	}

	public ArrayList externalDTDs() {
		return new ArrayList();
	}
}
