package se.rupy.http;

import java.io.IOException;

/**
 * The failure, if thrown, does not display the error to the user but
 * disconnects the client. Useful if you receive hack attempts or similar
 * unwanted requests. Also used internally to jump the 500 Internal Server Error
 * bridge.
 * 
 * @author marc
 */
public class Failure extends IOException {
	Failure(String message) {
		super(message);
	}

	Failure(Helper helper) {
		super(helper.getRoot().getMessage());
	}

	static void chain(Throwable t) throws Failure {
		throw (Failure) new Failure(new Failure.Helper(t)).initCause(t);
	}

	static void chain(String message, Throwable t) throws Failure {
		throw (Failure) new Failure(message).initCause(t);
	}

	static class Helper {
		Throwable root;

		public Helper(Throwable t) {
			while (t.getCause() != null) {
				t = t.getCause();
			}

			root = t;
		}

		public Throwable getRoot() {
			return root;
		}
	}
}
