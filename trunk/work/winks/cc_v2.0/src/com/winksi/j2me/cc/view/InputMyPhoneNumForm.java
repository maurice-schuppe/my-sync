package com.winksi.j2me.cc.view;

import com.winksi.j2me.cc.common.CPProperty;
import javax.microedition.lcdui.*;
import com.winksi.j2me.cc.control.GUIController;

/** 第一次使用软件时的激活界面(输入手机号),无返回按键 */
public class InputMyPhoneNumForm extends Form implements CommandListener {

	private GUIController controller;
	private Command ok;
	private Command exit;
	private TextField phonenumber;
	//        private TextField password;
	private Alert alert;

	public InputMyPhoneNumForm(GUIController controller, String title, String info) {
		super(title);
		this.controller = controller;
		ok = new Command(CPProperty.COMMAND_OK[this.controller.getLanguage()], Command.OK, 1);
		exit = new Command(CPProperty.COMMAND_EXIT[this.controller.getLanguage()], Command.EXIT, 1);
		append(info);
		phonenumber = new TextField(CPProperty.PHONE_NUMBER[controller.getLanguage()], "", 20,
				TextField.PHONENUMBER);
		//                password=new TextField(CPProperty.PASSWORD[controller.getLanguage()],"",10,TextField.PASSWORD);
		alert = new Alert("");
		append(phonenumber);
		//                append(password);
		addCommand(ok);
		addCommand(exit);
		setCommandListener(this);
	}

	public void commandAction(Command c, Displayable d) {
		if (c == ok) {
			String number = phonenumber.getString();
			//                    System.out.println("number : "+number);
			if (number.equals("")) {
				alert.setString(CPProperty.ERROR_INPUT[controller.getLanguage()]);
				controller.setAlertDis(alert);
			} else {
				Object[] obj = { number };
				controller.handleEvent(GUIController.EventID.EVENT_CONFIGSERVER, obj);
				//                        phonenumber.setString("");
			}
		} else if (c == exit) {
			controller.handleEvent(GUIController.EventID.EVENT_SURE_EXIT, null);
		}
	}

}