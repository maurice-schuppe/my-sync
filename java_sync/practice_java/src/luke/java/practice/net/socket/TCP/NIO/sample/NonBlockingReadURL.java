package luke.java.practice.net.socket.TCP.NIO.sample;

import java.io.*;
import java.net.*;
import java.nio.*;
import java.nio.channels.*;
import java.nio.charset.*;
import java.util.*;

/**
 * 使用非阻塞IO
 * 客户端非阻塞IO?? 有点纳闷
 * 
 * @author WangYinghua
 * 
 */
public class NonBlockingReadURL {
	static Selector selector;

	public static void main(String args[]) {
		String host = /* args[0] */"www.google.com";
		SocketChannel channel = null;

		try {
			// Setup
			InetSocketAddress socketAddress = new InetSocketAddress(host, 80);
			Charset charset = Charset.forName("GBK");
			CharsetDecoder decoder = charset.newDecoder();
			CharsetEncoder encoder = charset.newEncoder();

			// Allocate buffers
			ByteBuffer buffer = ByteBuffer.allocateDirect(1024);
			CharBuffer charBuffer = CharBuffer.allocate(1024);

			// Connect
			channel = SocketChannel.open();
			channel.configureBlocking(false);
			channel.connect(socketAddress);

			// Open Selector
			selector = Selector.open();

			// Register interest in when connection
			channel.register(selector, SelectionKey.OP_CONNECT
					| SelectionKey.OP_READ);

			// Wait for something of interest to happen
			while (selector.select(500) > 0) {
				// Get set of ready objects
				Set readyKeys = selector.selectedKeys();
				Iterator readyItor = readyKeys.iterator();

				// Walk through set
				while (readyItor.hasNext()) {

					// Get key from set
					SelectionKey key = (SelectionKey) readyItor.next();
					// Remove current entry
					// The ready set of channels can change while you are
					// processing them. So, you should remove the one you are
					// processing when you process it.
					readyItor.remove();
					// Get channel
					SocketChannel keyChannel = (SocketChannel) key.channel();

					if (key.isConnectable()) {
						// Finish connection
						if (keyChannel.isConnectionPending()) {
							keyChannel.finishConnect();
						}

						// Send request
						String request = "GET / \r\n\r\n";
						keyChannel.write(encoder.encode(CharBuffer
								.wrap(request)));
					} else if (key.isReadable()) {
						// Read what's ready in response
						keyChannel.read(buffer);
						buffer.flip();

						// Decode buffer
						decoder.decode(buffer, charBuffer, false);

						// Display
						charBuffer.flip();
						System.out.print(charBuffer);

						// Clear for next pass
						buffer.clear();
						charBuffer.clear();
					} else {
						System.err.println("Ooops");
					}
				}
			}
		} catch (UnknownHostException e) {
			System.err.println(e);
		} catch (IOException e) {
			System.err.println(e);
		} finally {
			if (channel != null) {
				try {
					channel.close();
				} catch (IOException ignored) {
				}
			}
		}
		System.out.println();
	}
}
