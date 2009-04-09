package winkCC.core.i18n;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.Hashtable;

import winkCC.core.WinksConstants;

/**
 * ���Զԡ�����������Ϣ,��δ���ʻ��ṩ֧��.
 * 
 * @author WangYinghua
 * 
 */
public class Properties {
	/** ���Զ� */
	private static Hashtable _propertyTable = null;

	// key��value�ķָ���
	private static final String KEY_VALUE_SEPARATORS = "=: \t\r\n\f";

	// key��value���ϸ�ָ���
	private static final String STRICT_KEY_VALUE_SEPARTORS = "=:";

	// ���ԵĿհ��ַ�
	private static final String WHITESPACE_CHARS = " \t\r\n\f";

	/**
	 * ��ʼ��property.<br>
	 * ���������ļ�ֻӦ�����������.
	 * 
	 * @param messageBundle
	 *            property�ļ�.
	 * @return ���ؽ��������ļ�ֵ��hashtable
	 */
	public static Hashtable initProperty(String messageBundle) {

		if (_propertyTable != null) {
			if (!_propertyTable.isEmpty())
				_propertyTable.clear();
			if (_propertyTable != null)
				_propertyTable = null;
		}
		_propertyTable = new Hashtable();

		loadPropertyBundle(WinksConstants.DEFAULT_PROPERTY_MESSAGES_BUNDLE);
		loadPropertyBundle(messageBundle);

		if (_propertyTable != null && !_propertyTable.isEmpty())
			return _propertyTable;
		else
			return null;
	}

	/**
	 * ���������ļ�, �ṩ�����ļ���������.
	 * 
	 * @param propertyBundle �����ļ�
	 * @return �Ƿ�ɹ�
	 */
	public static boolean loadPropertyBundle(String propertyBundle) {
		// ���·��
		if (propertyBundle != null && !propertyBundle.startsWith("/")) {
			propertyBundle = new StringBuffer(
					WinksConstants.DEFAULT_PROPERTY_RES_FOLDER).append(
					propertyBundle).toString();
		}

		InputStream inputStream = null;

		Class clazz = WHITESPACE_CHARS.getClass();
		inputStream = clazz.getResourceAsStream(propertyBundle);
		if (inputStream != null) {
			try {
				Properties.loadProperty(inputStream);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return _propertyTable != null;
	}

	/**
	 * ����key��value.
	 * 
	 * @param inStream �����ļ�������
	 * @throws IOException 
	 */
	public static synchronized Hashtable /* void */loadProperty(
			InputStream inStream) throws IOException  {
		InputStreamReader inputStream = new InputStreamReader(inStream, "UTF-8");
		while (true) {
			// ȥ��һ��
			String line = readLine(inputStream);
			if (line == null)
				return _propertyTable;

			if (line.length() > 0) {

				// key����ʼλ��
				int len = line.length();
				int keyStart;
				for (keyStart = 0; keyStart < len; keyStart++) {
					if (WHITESPACE_CHARS.indexOf(line.charAt(keyStart)) == -1) {
						break;
					}
				}

				// ���Կ���
				if (keyStart == len) {
					continue;
				}

				// �ҵ�һ����������
				char firstChar = line.charAt(keyStart);
				if ((firstChar != '#') && (firstChar != '!')) {
					while (continueLine(line)) {
						String nextLine = readLine(inputStream);
						if (nextLine == null) {
							nextLine = "";
						}
						String loppedLine = line.substring(0, len - 1);
						int startIndex;
						for (startIndex = 0; startIndex < nextLine.length(); startIndex++) {
							if (WHITESPACE_CHARS.indexOf(nextLine
									.charAt(startIndex)) == -1) {
								break;
							}
						}
						nextLine = nextLine.substring(startIndex, nextLine
								.length());
						line = new String(loppedLine + nextLine);
						len = line.length();
					}

					// �ҵ�key��value֮��ķָ���λ��
					int separatorIndex;
					for (separatorIndex = keyStart; separatorIndex < len; separatorIndex++) {
						char currentChar = line.charAt(separatorIndex);
						if (currentChar == '\\') {
							separatorIndex++;
						} else if (KEY_VALUE_SEPARATORS.indexOf(currentChar) != -1) {
							break;
						}
					}

					// ����key���white space
					int valueIndex;
					for (valueIndex = separatorIndex; valueIndex < len; valueIndex++) {
						if (WHITESPACE_CHARS.indexOf(line.charAt(valueIndex)) == -1) {
							break;
						}
					}

					// ������white space�ָ���
					if (valueIndex < len) {
						if (STRICT_KEY_VALUE_SEPARTORS.indexOf(line
								.charAt(valueIndex)) != -1) {
							valueIndex++;
						}
					}

					// �����ָ������white space
					while (valueIndex < len) {
						if (WHITESPACE_CHARS.indexOf(line.charAt(valueIndex)) == -1) {
							break;
						}
						valueIndex++;
					}
					String key = line.substring(keyStart, separatorIndex);
					String value = (separatorIndex < len) ? line.substring(
							valueIndex, len) : "";

					key = convertString(key);
					value = convertString(value);
					if (_propertyTable == null)
						_propertyTable = new Hashtable();
					_propertyTable.put(key, value);
				}
			}
		}
	}

	/**
	 * ��ȡһ��. �����ݷ���null
	 * 
	 * @param in
	 *            ������
	 * @return һ���ַ�
	 * @throws IOException
	 */
	private static String readLine(InputStreamReader in) throws IOException {
		StringBuffer strBuf = new StringBuffer("");
		int i;
		while ((i = in.read()) != -1) {
			if ((char) i == '\r' || (char) i == '\n') {
				return strBuf.toString();
			}
			strBuf.append((char) i);
		}
		return strBuf.length() > 0 ? strBuf.toString() : null;
	}

	/**
	 * ����(��һ�д���)
	 * 
	 * @param line
	 *            һ��String
	 * @return true ���String��������һ��
	 */
	private static boolean continueLine(String line) {
		int slashCount = 0;
		int index = line.length() - 1;
		while ((index >= 0) && (line.charAt(index--) == '\\'))
			slashCount++;
		return (slashCount % 2 == 1);
	}

	/**
	 * ����\\uxxxx ��ʽ��unicode�ַ�
	 * 
	 * @param theString
	 *            unicode�ַ�
	 * @return ������String
	 */
	private static String convertString(String theString) {
		char aChar;
		int len = theString.length();
		StringBuffer outBuffer = new StringBuffer(len);

		for (int x = 0; x < len;) {
			aChar = theString.charAt(x++);
			if (aChar == '\\') {
				aChar = theString.charAt(x++);
				if (aChar == 'u') {
					// xxxx
					int value = 0;
					for (int i = 0; i < 4; i++) {
						aChar = theString.charAt(x++);
						switch (aChar) {
						case '0':
						case '1':
						case '2':
						case '3':
						case '4':
						case '5':
						case '6':
						case '7':
						case '8':
						case '9':
							value = (value << 4) + aChar - '0';
							break;
						case 'a':
						case 'b':
						case 'c':
						case 'd':
						case 'e':
						case 'f':
							value = (value << 4) + 10 + aChar - 'a';
							break;
						case 'A':
						case 'B':
						case 'C':
						case 'D':
						case 'E':
						case 'F':
							value = (value << 4) + 10 + aChar - 'A';
							break;
						default:
							// δ֪
							return "???";
						}
					}
					outBuffer.append((char) value);
				} else {
					if (aChar == 't') {
						aChar = '\t';
					} else if (aChar == 'r') {
						aChar = '\r';
					} else if (aChar == 'n') {
						aChar = '\n';
					} else if (aChar == 'f') {
						aChar = '\f';
					}
					outBuffer.append(aChar);
				}
			} else {
				outBuffer.append(aChar);
			}
		}
		return outBuffer.toString();
	}
}