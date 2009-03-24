package luke.java.practice.net.socket.TCP.NIO.sample;

import java.io.*;
import java.net.*;
import java.nio.*;
import java.nio.channels.*;
import java.util.*;

public class Server {
	private static int port = 9999;

	public static void main(String args[]) throws Exception {
		Selector selector = Selector.open();

		ServerSocketChannel channel = ServerSocketChannel.open();
		channel.configureBlocking(false);
		InetSocketAddress isa = new InetSocketAddress(port);
		channel.socket().bind(isa);

		// Register interest in when connection ������serverSocketChannelֻ��OP_ACCEPT����
		channel.register(selector, SelectionKey.OP_ACCEPT);

		// Wait for something of interest to happen
		while (selector.select() > 0) {
			// Get set of ready objects
			Set readyKeys = selector.selectedKeys();
			Iterator readyItor = readyKeys.iterator();

			// Walk through set
			while (readyItor.hasNext()) {
				// Get key from set
				SelectionKey key = (SelectionKey) readyItor.next();
				// Remove current entry ɾ����ǰ��Ҫ������ѡ���
				readyItor.remove();

				// ������пͻ�����������
				if (key.isAcceptable()) {
					// Get channel
					ServerSocketChannel nextReady = (ServerSocketChannel) key
							.channel();

					// Get server socket
					ServerSocket serverSocket = nextReady.socket();
					// Accept request ��ȡ�ͻ����׽���
					Socket socket = serverSocket.accept();
					
					// Return canned message
					PrintWriter out = new PrintWriter(socket.getOutputStream(),
							true);
					out.println("Hello, NIO");
					out.close();
				} else {
					System.err.println("Ooops");
				}
			}
		}
		// Never ends
	}
}