package winkCC.log;

/**
 * ILog�ӿ�
 * 
 * @author WangYinghua
 */
public interface ILog {
	static final String INFO = "[INFO ]";
	static final String WARN = "[WARN ]";
	static final String DEBUG = "[DEBUG]";
	static final String ERROR = "[ERROR]";
	static final String FATAL = "[FATAL]";

	void debug(String message);

	void debug(String message, Throwable e);

	void debug(Throwable e);

	void info(String message);

	void warn(final String message);

	void warn(String message, Throwable e);

	void warn(Throwable e);

	void error(final String message);

	void error(String message, Throwable e);

	void error(Throwable e);

	void fatal(final String message);

	void fatal(String message, Throwable e);

	void fatal(Throwable e);

	public String getContent();

	public void clear();
}
