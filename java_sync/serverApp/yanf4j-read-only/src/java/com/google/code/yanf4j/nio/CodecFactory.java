/**
 *Copyright [2008] [dennis zhuang]
 *Licensed under the Apache License, Version 2.0 (the "License");
 *you may not use this file except in compliance with the License. 
 *You may obtain a copy of the License at 
 *             http://www.apache.org/licenses/LICENSE-2.0 
 *Unless required by applicable law or agreed to in writing, 
 *software distributed under the License is distributed on an "AS IS" BASIS, 
 *WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 *either express or implied. See the License for the specific language governing permissions and limitations under the License
 */
package com.google.code.yanf4j.nio;
/**
 * 
 * @author dennis
 * 编码解码器工厂类
 * @param <T>
 */
public interface CodecFactory<T> {
	public interface Encoder<T> {
		public java.nio.ByteBuffer[] encode(T message);
	}

	public interface Decoder<T> {
		public T decode(java.nio.ByteBuffer buff);
	}

	public Encoder<T> getEncoder();

	public Decoder<T> getDecoder();
}
