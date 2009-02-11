package com.google.code.yanf4j.nio.impl;
/**
 *Copyright [2008-2009] [dennis zhuang]
 *Licensed under the Apache License, Version 2.0 (the "License");
 *you may not use this file except in compliance with the License. 
 *You may obtain a copy of the License at 
 *             http://www.apache.org/licenses/LICENSE-2.0 
 *Unless required by applicable law or agreed to in writing, 
 *software distributed under the License is distributed on an "AS IS" BASIS, 
 *WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 *either express or implied. See the License for the specific language governing permissions and limitations under the License
 */
import com.google.code.yanf4j.nio.Session;
import com.google.code.yanf4j.nio.util.EventType;

/**
 * 管理session注册、派发事件
 * 
 * @see com.google.code.yanf4j.nio.impl.Reactor
 * 
 * @author dennis
 * 
 */
public interface SessionEventManager {
	public void register(Session session, EventType event);

	public void dispatchEvent(Session session, EventType event);

	public void wakeup();

	public void wakeup(Session session, EventType eventType);
}
