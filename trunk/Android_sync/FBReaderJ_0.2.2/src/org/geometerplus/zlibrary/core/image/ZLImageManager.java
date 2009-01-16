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

package org.geometerplus.zlibrary.core.image;

public abstract class ZLImageManager {
	private static ZLImageManager ourInstance;

	public static ZLImageManager getInstance() {
		return ourInstance;
	}

	protected ZLImageManager() {
		ourInstance = this;
	}

	public abstract ZLImageData getImageData(ZLImage image);
	
/*	protected final static class Color {
		public final byte Red;
		public final byte Green;
		public final byte Blue;
		
		public Color(final byte red, final byte green, final byte blue) {
			Red = red;
			Green = green;
			Blue = blue;
		}
	}
*/	
	protected final static class PalmImageHeader {
		public final int Width;
		public final int Height;
		public final int BytesPerRow;
		public final int Flags;
		public final byte BitsPerPixel;
		public final byte CompressionType;
		
		public PalmImageHeader(byte [] byteData) {
			Width = uShort(byteData, 0);
			Height = uShort(byteData, 2);
			BytesPerRow = uShort(byteData, 4);
			Flags = uShort(byteData, 6);
			BitsPerPixel = byteData[8];
			CompressionType = (byte) (((Flags & 0x8000) != 0) ? byteData[13] : 0xFF);
		}
	}
	
	protected static int PalmImage8bitColormap[][] = {
		{255, 255, 255 }, { 255, 204, 255 }, { 255, 153, 255 }, { 255, 102, 255 }, 
		{ 255,  51, 255 }, { 255,   0, 255 }, { 255, 255, 204 }, { 255, 204, 204 }, 
		{ 255, 153, 204 }, { 255, 102, 204 }, { 255,  51, 204 }, { 255,   0, 204 }, 
		{ 255, 255, 153 }, { 255, 204, 153 }, { 255, 153, 153 }, { 255, 102, 153 }, 
		{ 255,  51, 153 }, { 255,   0, 153 }, { 204, 255, 255 }, { 204, 204, 255 },
		{ 204, 153, 255 }, { 204, 102, 255 }, { 204,  51, 255 }, { 204,   0, 255 },
		{ 204, 255, 204 }, { 204, 204, 204 }, { 204, 153, 204 }, { 204, 102, 204 },
		{ 204,  51, 204 }, { 204,   0, 204 }, { 204, 255, 153 }, { 204, 204, 153 },
		{ 204, 153, 153 }, { 204, 102, 153 }, { 204,  51, 153 }, { 204,   0, 153 },
		{ 153, 255, 255 }, { 153, 204, 255 }, { 153, 153, 255 }, { 153, 102, 255 },
		{ 153,  51, 255 }, { 153,   0, 255 }, { 153, 255, 204 }, { 153, 204, 204 },
		{ 153, 153, 204 }, { 153, 102, 204 }, { 153,  51, 204 }, { 153,   0, 204 },
		{ 153, 255, 153 }, { 153, 204, 153 }, { 153, 153, 153 }, { 153, 102, 153 },
		{ 153,  51, 153 }, { 153,   0, 153 }, { 102, 255, 255 }, { 102, 204, 255 },
		{ 102, 153, 255 }, { 102, 102, 255 }, { 102,  51, 255 }, { 102,   0, 255 },
		{ 102, 255, 204 }, { 102, 204, 204 }, { 102, 153, 204 }, { 102, 102, 204 },
		{ 102,  51, 204 }, { 102,   0, 204 }, { 102, 255, 153 }, { 102, 204, 153 },
		{ 102, 153, 153 }, { 102, 102, 153 }, { 102,  51, 153 }, { 102,   0, 153 },
		{  51, 255, 255 }, {  51, 204, 255 }, {  51, 153, 255 }, {  51, 102, 255 },
		{  51,  51, 255 }, {  51,   0, 255 }, {  51, 255, 204 }, {  51, 204, 204 },
		{  51, 153, 204 }, {  51, 102, 204 }, {  51,  51, 204 }, {  51,   0, 204 },
		{  51, 255, 153 }, {  51, 204, 153 }, {  51, 153, 153 }, {  51, 102, 153 },
		{  51,  51, 153 }, {  51,   0, 153 }, {   0, 255, 255 }, {   0, 204, 255 },
		{   0, 153, 255 }, {   0, 102, 255 }, {   0,  51, 255 }, {   0,   0, 255 },
		{   0, 255, 204 }, {   0, 204, 204 }, {   0, 153, 204 }, {   0, 102, 204 },
		{   0,  51, 204 }, {   0,   0, 204 }, {   0, 255, 153 }, {   0, 204, 153 },
		{   0, 153, 153 }, {   0, 102, 153 }, {   0,  51, 153 }, {   0,   0, 153 },
		{ 255, 255, 102 }, { 255, 204, 102 }, { 255, 153, 102 }, { 255, 102, 102 },
		{ 255,  51, 102 }, { 255,   0, 102 }, { 255, 255,  51 }, { 255, 204,  51 },
		{ 255, 153,  51 }, { 255, 102,  51 }, { 255,  51,  51 }, { 255,   0,  51 },
		{ 255, 255,   0 }, { 255, 204,   0 }, { 255, 153,   0 }, { 255, 102,   0 },
		{ 255,  51,   0 }, { 255,   0,   0 }, { 204, 255, 102 }, { 204, 204, 102 },
		{ 204, 153, 102 }, { 204, 102, 102 }, { 204,  51, 102 }, { 204,   0, 102 },
		{ 204, 255,  51 }, { 204, 204,  51 }, { 204, 153,  51 }, { 204, 102,  51 },
		{ 204,  51,  51 }, { 204,   0,  51 }, { 204, 255,   0 }, { 204, 204,   0 },
		{ 204, 153,   0 }, { 204, 102,   0 }, { 204,  51,   0 }, { 204,   0,   0 },
		{ 153, 255, 102 }, { 153, 204, 102 }, { 153, 153, 102 }, { 153, 102, 102 },
		{ 153,  51, 102 }, { 153,   0, 102 }, { 153, 255,  51 }, { 153, 204,  51 },
		{ 153, 153,  51 }, { 153, 102,  51 }, { 153,  51,  51 }, { 153,   0,  51 },
		{ 153, 255,   0 }, { 153, 204,   0 }, { 153, 153,   0 }, { 153, 102,   0 },
		{ 153,  51,   0 }, { 153,   0,   0 }, { 102, 255, 102 }, { 102, 204, 102 },
		{ 102, 153, 102 }, { 102, 102, 102 }, { 102,  51, 102 }, { 102,   0, 102 },
		{ 102, 255,  51 }, { 102, 204,  51 }, { 102, 153,  51 }, { 102, 102,  51 },
		{ 102,  51,  51 }, { 102,   0,  51 }, { 102, 255,   0 }, { 102, 204,   0 },
		{ 102, 153,   0 }, { 102, 102,   0 }, { 102,  51,   0 }, { 102,   0,   0 },
		{  51, 255, 102 }, {  51, 204, 102 }, {  51, 153, 102 }, {  51, 102, 102 },
		{  51,  51, 102 }, {  51,   0, 102 }, {  51, 255,  51 }, {  51, 204,  51 },
		{  51, 153,  51 }, {  51, 102,  51 }, {  51,  51,  51 }, {  51,   0,  51 },
		{  51, 255,   0 }, {  51, 204,   0 }, {  51, 153,   0 }, {  51, 102,   0 },
		{  51,  51,   0 }, {  51,   0,   0 }, {   0, 255, 102 }, {   0, 204, 102 },
		{   0, 153, 102 }, {   0, 102, 102 }, {   0,  51, 102 }, {   0,   0, 102 },
		{   0, 255,  51 }, {   0, 204,  51 }, {   0, 153,  51 }, {   0, 102,  51 },
		{   0,  51,  51 }, {   0,   0,  51 }, {   0, 255,   0 }, {   0, 204,   0 },
		{   0, 153,   0 }, {   0, 102,   0 }, {   0,  51,   0 }, {  17,  17,  17 },
		{  34,  34,  34 }, {  68,  68,  68 }, {  85,  85,  85 }, { 119, 119, 119 },
		{ 136, 136, 136 }, { 170, 170, 170 }, { 187, 187, 187 }, { 221, 221, 221 },
		{ 238, 238, 238 }, { 192, 192, 192 }, { 128,   0,   0 }, { 128,   0, 128 },
		{   0, 128,   0 }, {   0, 128, 128 }, {   0,   0,   0 }, {   0,   0,   0 },
		{   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 },
		{   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 },
		{   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 },
		{   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 },
		{   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 },
		{   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 }, {   0,   0,   0 }
	};
	
	private static int uShort(byte [] byteData, int offset) {
		return ((byteData[offset] & 0xFF) << 8) + (byteData[offset + 1] & 0xFF);
	}	
}
