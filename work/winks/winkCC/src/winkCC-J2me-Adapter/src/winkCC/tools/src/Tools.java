package winkCC.tools.src;

/**
 * 
 */

import java.util.Enumeration;

import javax.microedition.lcdui.Command;
import javax.microedition.lcdui.CommandListener;
import javax.microedition.lcdui.Display;
import javax.microedition.lcdui.Displayable;
import javax.microedition.lcdui.Form;
import javax.microedition.lcdui.TextField;
import javax.microedition.midlet.MIDlet;
import javax.microedition.midlet.MIDletStateChangeException;

import winkCC.fs.FileUtils;

public class Tools extends MIDlet implements CommandListener {
	Display display = null;
	Form form = null;
	final Command mkdirs = new Command("mkdirs", Command.OK, 1);
	final Command makeDir = new Command("makeDir", Command.OK, 1);
	final Command write = new Command("write", Command.OK, 1);
	final Command read = new Command("read", Command.OK, 1);
	final Command list = new Command("list", Command.OK, 1);
	final Command mkFile = new Command("mkFile", Command.OK, 1);
	final Command delete = new Command("delete", Command.OK, 1);
	final Command rename = new Command("rename", Command.OK, 1);
	final Command exit = new Command("Exit", Command.EXIT, 3);

	TextField dataField = new TextField("����", "ABC", 100, TextField.ANY);

	FileUtils fileUtils = new FileUtils();

	public Tools() {
		display = Display.getDisplay(this);
		form = new Form("File test");
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.microedition.midlet.MIDlet#destroyApp(boolean)
	 */
	protected void destroyApp(boolean arg0) throws MIDletStateChangeException {

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.microedition.midlet.MIDlet#pauseApp()
	 */
	protected void pauseApp() {

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.microedition.midlet.MIDlet#startApp()
	 */
	protected void startApp() throws MIDletStateChangeException {
		form.addCommand(mkdirs);
		form.addCommand(makeDir);
		form.addCommand(write);
		form.addCommand(read);
		form.addCommand(list);
		form.addCommand(mkFile);
		form.addCommand(delete);
		form.addCommand(rename);
		form.addCommand(exit);
		//		form.append(dataField);
		form.setCommandListener(this);
		display.setCurrent(form);

		test();
	}

	public void test() {

		form.append(System.getProperty("microedition.profiles"));
		form.append(System.getProperty("microedition.configuration"));
		form.append("locale: "
				+ System.getProperty("microedition.locale"));
		form.append("encoding: "
				+ System.getProperty("microedition.encoding"));
		form.append(System.getProperty("microedition.platform"));
		form.append("imsi: "
				+ System.getProperty("com.sonyericsson.sim.subscribernumber"));
	}

	public void commandAction(Command cmd, Displayable disp) {
		if (cmd == mkdirs) {
			fileUtils.executeCreateFile("e:/d1d/d2d/dii/sss/");

		} else if (cmd == makeDir) {
			fileUtils.executeCreateFile("e:/ii/");
			fileUtils.executeCreateFile("e:/ii2/");
		} else if (cmd == write) {
			fileUtils.executeWriteFile("e:/dada/xx.txt", new byte[] { 1, 2, 3,
					4, 5, 6, 7, 8, 9 });
		} else if (cmd == read) {
			byte[] buffer = new byte[9];
			fileUtils.executeReadFile("e:/dada/xx.txt", buffer);
		} else if (cmd == list) {
			new Thread() {
				public void run() {
					Enumeration files = fileUtils.listFiles("e:/dada/",
							"*.txt", true);
					while (files.hasMoreElements()) {
						System.out.println(files.nextElement());
					}
				}
			}.start();
		} else if (cmd == delete) {
			fileUtils.executeDelete("e:/www/wer/ttt.txt");
		} else if (cmd == mkFile) {
			fileUtils.executeCreateFile("e:/www/wer/ttt.txt");
		} else if (cmd == rename) {
			new Thread() {
				public void run() {
					fileUtils.rename("e:/dada/xx.txt", "sss.yy");
				}
			}.start();
		} else if (cmd == exit) {
			//			rms.close();
			try {
				destroyApp(true);
			} catch (MIDletStateChangeException e) {
				e.printStackTrace();
			}
			notifyDestroyed();
		}
	}
}
