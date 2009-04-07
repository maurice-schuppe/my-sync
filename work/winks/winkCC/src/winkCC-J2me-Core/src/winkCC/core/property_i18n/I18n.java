package winkCC.core.property_i18n;

import java.io.InputStream;
import java.io.UTFDataFormatException;
import java.util.Hashtable;

import winkCC.core.WinksConstants;

public class I18n {

	/** 手机当前locale */
	public static String _locale = "zh-CN";
	/** 手机当前编码 */
	public static String _encoding = "ISO-8859-1";
	/** 属性对 */
	public static Hashtable _messageTable = null;

	/**
	 * 获得locale 或默认locale zh-CN.
	 * 
	 * @return
	 */
	public static String getLocale() {
		try {
			_locale = System.getProperty("microedition.locale");
		} catch (Exception e) {
		}
		return _locale;
	}

	/**
	 * 初始化国际化property.
	 * 
	 * @param messageBundle
	 *            property文件.
	 * @param locale
	 * @return
	 */
	public static boolean initI18nProperty(String messageBundle, String locale) {

		_messageTable = new Hashtable();

		// 保存locale
		_locale = locale;

		loadI18nBundle(WinksConstants.DEFAULT_I18N_MESSAGES_BUNDLE);
		loadI18nBundle(messageBundle);

		return _messageTable != null;
	}

	/**
	 * 载入国际化property.
	 * 
	 * @param messageBundle
	 *            property文件的路径(支持绝对路径或只给出文件名).
	 * @return 读取property文件是否成功.
	 */
	public static boolean loadI18nBundle(String messageBundle) {
		// 相对路径
		if (messageBundle != null && !messageBundle.startsWith("/")) {
			messageBundle = new StringBuffer(
					WinksConstants.DEFAULT_PROPERTY_RES_FOLDER).append(
					messageBundle).toString();
		}

		InputStream inputStream = null;
		Class clazz = _locale.getClass();
		try {

			// Construct messageBundle
			if ((_locale != null) && (_locale.length() > 1)) {
				int lastIndex = messageBundle.lastIndexOf('.');
				String prefix = messageBundle.substring(0, lastIndex);
				String suffix = messageBundle.substring(lastIndex);
				// replace '-' with '_', some phones returns locales with
				// '-' instead of '_'. For example Nokia or Motorola
				_locale = _locale.replace('-', '_');
				inputStream = clazz
						.getResourceAsStream(new StringBuffer(prefix).append(
								'.').append(_locale).append(suffix).toString());
				if (inputStream == null) {
					// 没找到资源则 取代zh_CN尝试zh
					_locale = _locale.substring(0, 2);
					inputStream = clazz.getResourceAsStream(new StringBuffer(
							prefix).append('.').append(_locale).append(suffix)
							.toString());
				}
			}
			if (inputStream == null) {
				// 如果未找到或locale没有设置则尝试默认locale
				inputStream = clazz.getResourceAsStream(messageBundle);
			}
			if (inputStream != null) {
				// load messages to messageTable hashtable
				_messageTable = Properties.loadProperty(inputStream);
			}
		} catch (UTFDataFormatException e) {
			System.err
					.println("Property Error : *.properties files need to be UTF-8 encoded");
		} catch (Exception e) {
			e.printStackTrace();
		}

		return _messageTable != null;
	}
}
