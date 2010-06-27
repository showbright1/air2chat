package com.jxl.chatclient.mvcs.services
{
	import com.jxl.chat.events.MessageSocketEvent;
	import com.jxl.chat.net.MessageManager;
	import com.jxl.chat.net.MessageSocket;
	import com.jxl.chat.vo.InstructionConstants;
	import com.jxl.chat.vo.messages.AbstractMessageVO;
	import com.jxl.chat.vo.messages.ChatMessageVO;
	import com.jxl.chatclient.events.ServiceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	[Event(name="connected", type="com.jxl.chatclient.events.ServiceEvent")]
	[Event(name="error", type="com.jxl.chatclient.events.ServiceEvent")]
	[Event(name="chatMessage", type="com.jxl.chatclient.events.ServiceEvent")]
	[Event(name="joinedChat", type="com.jxl.chatclient.events.ServiceEvent")]
	[Event(name="disconnected", type="com.jxl.chatclient.events.ServiceEvent")]
	[Event(name="userListUpdated", type="com.jxl.chatclient.events.ServiceEvent")]
	[Event(name="userJoinedChat", type="com.jxl.chatclient.events.ServiceEvent")]
	[Event(name="userLeftChat", type="com.jxl.chatclient.events.ServiceEvent")]
	[Event(name="usernameTaken", type="com.jxl.chatclient.events.ServiceEvent")]
	public class ChatService extends EventDispatcher
	{
		
		private var messageSocket:MessageSocket;
		private var username:String;
		private var messageManager:MessageManager;
		
		public function ChatService()
		{
			super();
		}
		
		public function connect(host:String, port:int, username:String):void
		{
			//DebugMax.log("ChatService::connect, host: " + host + ", port: " + port + ", username: " + username);
			createSocket();
			
			this.username = username;
			
			try
			{
				messageSocket.connect(host, port);
			}
			catch(err:Error)
			{
				DebugMax.error("ChatService::connect, err: " + err);
				dispatchError(err.message);
			}
		}
		
		private function dispatchError(message:String):void
		{
			var evt:ServiceEvent = new ServiceEvent(ServiceEvent.ERROR);
			evt.lastError = message;
			dispatchEvent(evt);
		}
		
		public function destroySocket():void
		{
			if(messageManager) messageManager.destroy();
			messageManager = null;
			
			if(messageSocket)
			{
				messageSocket.removeEventListener(Event.CONNECT, 							onConnected);
				messageSocket.removeEventListener(Event.CLOSE,								onClose);
				messageSocket.removeEventListener(IOErrorEvent.IO_ERROR, 					onIOError);
				messageSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 		onSecurityError);
				messageSocket.removeEventListener(MessageSocketEvent.NEW_MESSAGE,			onNewMessage);
				try { messageSocket.close(); } catch(err:Error) { }
				messageSocket = null;
			}
		}
		
		private function createSocket():void
		{
			destroySocket();
			
			messageManager = MessageManager.instance;
			
			messageSocket = new MessageSocket(new Socket());
			messageSocket.addEventListener(Event.CONNECT, 								onConnected);
			messageSocket.addEventListener(Event.CLOSE,									onClose);
			messageSocket.addEventListener(IOErrorEvent.IO_ERROR, 						onIOError);
			messageSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,			onSecurityError);
			messageSocket.addEventListener(MessageSocketEvent.NEW_MESSAGE,				onNewMessage);
		}
		
		private function onConnected(event:Event):void
		{
			//DebugMax.log("ChatService::onConnected");
			dispatchEvent(new ServiceEvent(ServiceEvent.CONNECTED));
		}
		
		private function onClose(event:Event):void
		{
			//DebugMax.log("ChatService::onClose");
			destroySocket();
			dispatchEvent(new ServiceEvent(ServiceEvent.DISCONNECTED));
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			DebugMax.error(this + "::onIOError, error: " + event.text);
			destroySocket();
			dispatchError(event.text);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			DebugMax.error(this + "::onSecurityError, error: " + event.text);
			destroySocket();
			dispatchError(event.text);
		}
		
		private function onNewMessage(event:MessageSocketEvent):void
		{
			//DebugMax.log("ChatService::onNewMessage");
			
			var len:int = messageSocket.messages.length;
			for(var index:uint = 0; index < len; index++)
			{
				var message:AbstractMessageVO = messageSocket.messages.getItemAt(index) as AbstractMessageVO;
				if(message is ChatMessageVO)
				{
					var chatMessage:ChatMessageVO = message as ChatMessageVO;
					messageSocket.removeMessageAt(index);
					index--;
					len--;
		            messageManager.sendACK(messageSocket, chatMessage);
		            
		            var evt:ServiceEvent;
		            
		            switch(chatMessage.instructions)
		            {
		            	case InstructionConstants.SERVER_CLIENT_CONNECTED:
		            		// join the chat
		            		sendChatMessage(InstructionConstants.CLIENT_SET_USERNAME, "Set username.");
		            		break;
		            		
		            	case InstructionConstants.SERVER_USER_BOOTED:
		            	case InstructionConstants.SERVER_CLIENT_CHAT_MESSAGE:
		            	case InstructionConstants.SERVER_CLIENT_ALREADY_IN_CHAT:
		            	case InstructionConstants.SERVER_UKNOWN_CLIENT_MESSAGE:
		            		evt	= new ServiceEvent(ServiceEvent.CHAT_MESSAGE);
		            		evt.chatMessage 	= chatMessage;
		            		break;
		            	
		            	case InstructionConstants.SERVER_CLIENT_CONNECTED_TO_CHAT:
		            		if(chatMessage.username != username)
		            		{
		            			evt = new ServiceEvent(ServiceEvent.USER_JOINED_CHAT);
		            			evt.chatMessage = chatMessage;
		            		}
		            		else
		            		{
		            			evt = new ServiceEvent(ServiceEvent.JOINED_CHAT);
		            		}
		            		break;
		            	
		            	case InstructionConstants.SERVER_CLIENT_DISCONNECTED:
		            		if(chatMessage.username != username)
		            		{
		            			evt = new ServiceEvent(ServiceEvent.USER_LEFT_CHAT);
		            			evt.chatMessage = chatMessage;
		            		}
		            		else
		            		{
		            			evt = new ServiceEvent(ServiceEvent.JOINED_CHAT);
		            		}
		            		break;
		            	
		            	case InstructionConstants.SERVER_UPDATED_USER_LIST:
		            		evt = new ServiceEvent(ServiceEvent.USER_LIST_UPDATED);
		            		evt.userList = chatMessage.message;
		            		break;
		            	
		            	case InstructionConstants.SERVER_USERNAME_TAKEN:
		            		evt = new ServiceEvent(ServiceEvent.USERNAME_TAKEN);
		            		destroySocket();
		            		break;
		            }
		            
		            if(evt)
		            	dispatchEvent(evt);
				}
			}
			
		}
		
		public function sendChatMessage(instructions:String, message:String):void
		{
			//DebugMax.log("ChatService::sendChatMessage, instructions: " + instructions + ", message: " + message);
			
			var chatMessage:ChatMessageVO 	= new ChatMessageVO();
			chatMessage.username			= username;
			chatMessage.message				= message;
			chatMessage.instructions		= instructions;
			
			messageManager.addMessage(messageSocket, chatMessage);
			
			/*
			try
			{
				socket.writeUTFBytes(chatMessage.toJSON());
				socket.flush();
			}
			catch(err:Error)
			{
				DebugMax.error("ChatService::sendChatMessage, err: " + err);
			}
			*/
		}
		
		
	}
}