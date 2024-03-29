///*
// * CreditsCanvas.java
// *
// * Created on 14 de julio de 2004, 15:34
// */
//
//package winkCC.deviceTest.midpsysinfo;
//
//import java.io.IOException;
//
//import javax.microedition.lcdui.Canvas;
//import javax.microedition.lcdui.Font;
//import javax.microedition.lcdui.Graphics;
//import javax.microedition.lcdui.Image;
//
//import de.enough.polish.util.Locale;
//import de.enough.polish.util.TextUtil;
//
///**
// * Shows the credits of the MIDP SysInfo.
// * 
// * @author Waldemar Baraldi <waldemar.baraldi@grimo-software.com>
// * @author Robert Virkus <j2mepolish@enough.de> (additional elements)
// */
//public class CreditsCanvas extends Canvas {
//	private final static int MARGIN = 1;
//	private final static int BACKGROUND_COLOR = 0;
//	private final static int TITLE_COLOR = 0xFFFFFF;
//	private final static int TEXT_COLOR = 0xff9933;
//
//	private final Image backgroundImage;
//	private int yOffset;
//	private final int availableHeight;
//	private final int contentHeight;
//	private final Font titleFont;
//	private final Font textFont;
//	private final String[] credits;
//	private final int titleHeight;
//
//	/**
//	 * Creates a new instance of CreditsCanvas
//	 */
//	public CreditsCanvas() {
//		Image image = null;
//		try {
//			image = Image.createImage("/bg.png");
//		} catch (IOException e) {
//			// #debug error
//			System.out.println("Unable to load image [/bg.png]" + e);
//		}
//		this.backgroundImage = image;
//		this.titleFont = Font.getFont(Font.FACE_PROPORTIONAL, Font.STYLE_BOLD,
//				Font.SIZE_LARGE);
//		this.textFont = Font.getFont(Font.FACE_PROPORTIONAL, Font.STYLE_BOLD,
//				Font.SIZE_SMALL);
//		this.titleHeight = (2 * MARGIN) + this.titleFont.getHeight();
//		this.availableHeight = getHeight() - this.titleHeight;
//		int availableWidth = getWidth() - (2 * MARGIN);
//		this.credits = TextUtil.split(Locale.get("text.credits"),
//				this.titleFont, availableWidth, availableWidth);
//		this.contentHeight = this.credits.length
//				* (this.textFont.getHeight() + MARGIN);
//	}
//
//	public void paint(Graphics g) {
//		// paint background:
//		g.setColor(BACKGROUND_COLOR);
//		g.fillRect(0, 0, getWidth(), getHeight());
//		if (this.backgroundImage != null) {
//			g.drawImage(this.backgroundImage, getWidth() / 2, getHeight() / 2,
//					Graphics.HCENTER | Graphics.VCENTER);
//		}
//		// write title:
//		g.setColor(TITLE_COLOR);
//		g.setFont(this.titleFont);
//		g.drawString(Locale.get("title.credits"), getWidth() / 2, MARGIN,
//				Graphics.TOP | Graphics.HCENTER);
//
//		// protect title:
//		g.setClip(0, this.titleHeight, getWidth(), this.availableHeight);
//
//		int y = this.titleHeight + this.yOffset;
//		g.setColor(TEXT_COLOR);
//		g.setFont(this.textFont);
//		int lineHeight = this.textFont.getHeight() + MARGIN;
//		for (int i = 0; i < this.credits.length; i++) {
//			String text = this.credits[i];
//			g.drawString(text, MARGIN, y, Graphics.TOP | Graphics.LEFT);
//			y += lineHeight;
//		}
//	}
//
//	protected void keyPressed(int keyCode) {
//		try {
//			int gameAction = getGameAction(keyCode);
//			if (gameAction == Canvas.UP && this.yOffset < 0) {
//				this.yOffset += 10;
//				if (this.yOffset > 0) {
//					this.yOffset = 0;
//				}
//				repaint();
//			} else if (gameAction == Canvas.DOWN
//					&& (this.yOffset + this.contentHeight > this.availableHeight)) {
//				this.yOffset -= 10;
//				repaint();
//			}
//		} catch (Exception e) {
//			// #debug error
//			System.out.println("Unable to scroll credits screen" + e);
//		}
//	}
//}
