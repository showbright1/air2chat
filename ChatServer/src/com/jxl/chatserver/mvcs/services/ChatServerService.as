package com.jxl.chatserver.mvcs.services
{
	import com.jxl.chat.events.MessageSocketEvent;
	import com.jxl.chat.net.MessageManager;
	import com.jxl.chat.net.MessageSocket;
	import com.jxl.chat.vo.InstructionConstants;
	import com.jxl.chat.vo.messages.AbstractMessageVO;
	import com.jxl.chat.vo.messages.ChatMessageVO;
	import com.jxl.chatserver.events.ServiceEvent;
	import com.jxl.chatserver.mvcs.models.ClientsModel;
	import com.jxl.chatserver.vo.ClientVO;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;

	[Event(name="chatServerServiceConnected", type="com.jxl.chatserver.events.ServiceEvent")]
	[Event(name="chatServerServiceError", type="com.jxl.chatserver.events.ServiceEvent")]
	public class ChatServerService extends EventDispatcher
	{
		
		private static const WHATS_MY_NAME_BEEEEOOOTCH:String = "Server";
		
		private var socket:ServerSocket;
		private var _clientsModel:ClientsModel = new ClientsModel();
		private var messageManager:MessageManager = MessageManager.instance;
		
		public function get clientsModel():ClientsModel { return _clientsModel; }
		
		public function ChatServerService()
		{
			super();
		}
		
		public function startServer(host:String, port:int):void
		{
			//DebugMax.log("ChatServerService::startServer, host: " + host + ", port: " + port);
			destroy();
			
			createSocket();
			
			try
			{
				socket.bind(port, host);
				socket.listen();
			}
			catch(err:Error)
			{
				DebugMax.error("ChatServerService::connect, err: " + err);
				dispatchError(err.message);
				return;
			}
			dispatchEvent(new ServiceEvent(ServiceEvent.CHAT_SERVER_SERVICE_CONNECTED));
		}
		
		private function destroySocket():void
		{
			if(socket)
			{
				socket.removeEventListener(Event.CONNECT, 							onClientSocketConnected);
				socket.removeEventListener(Event.CLOSE,								onClose);
				socket = null;
			}
		}
		
		private function createSocket():void
		{
			destroy();
			socket = new ServerSocket();
			socket.addEventListener(Event.CONNECT, 								onClientSocketConnected);
			socket.addEventListener(Event.CLOSE,								onClose);
		}
		
		private function onClose(event:Event):void
		{
			//DebugMax.log("ChatServerService::onClose");
		}
		
		private function onClientSocketConnected(event:ServerSocketConnectEvent):void
		{
            var clientSocket:Socket 		= event.socket as Socket;
         	var messageSocket:MessageSocket = new MessageSocket(clientSocket);
         	
         	clientsModel.addClient(messageSocket);
         	
         	messageSocket.addEventListener(MessageSocketEvent.NEW_MESSAGE,		onClientNewMessage);
            messageSocket.addEventListener(Event.CLOSE, 						onClientSocketClose); 
            messageSocket.addEventListener(IOErrorEvent.IO_ERROR, 				onClientError);
            messageSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, 	onClientError);
             
            //Send a client connect message 
            sendMessageToClient(messageSocket, InstructionConstants.SERVER_CLIENT_CONNECTED, "Connected to server.", WHATS_MY_NAME_BEEEEOOOTCH);
		}
		
		private function dispatchError(message:String):void
		{
			var errorEvent:ServiceEvent = new ServiceEvent(ServiceEvent.CHAT_SERVER_SERVICE_ERROR);
			errorEvent.lastError = message;
			dispatchEvent(errorEvent);
		}
				
		private function sendMessageToClient(messageSocket:MessageSocket, instructions:String, message:*, username:String):void
		{
			//DebugMax.log("ChatServerService::sendMessageToClient, " + username + "> " + instructions + ", " + message);
			var chatMessage:ChatMessageVO			= new ChatMessageVO();
			chatMessage.instructions				= instructions;
			chatMessage.message						= message;
			chatMessage.username					= username;
			
			messageManager.addMessage(messageSocket, chatMessage);
			/*
			try
			{
				clientSocket.writeUTFBytes(chatMessage.toJSON()); 
            	clientSocket.flush();
   			}
   			catch(err:Error)
   			{
   				DebugMax.error("ChatServerService::sendMessageToClient, err: " + err);
   			}
   			*/
		}
		
		private function sendGlobalChatMessage(instructions:String, message:String, username:String):void
		{
			//DebugMax.log("ChatServerService::sendGlobalChatMessage, " + username + "> " + instructions + ", " + message);
			var len:int = clientsModel.length;
			while(len--)
			{
				var clientSocketVO:ClientVO = clientsModel.getClientAt(len);
				sendMessageToClient(clientSocketVO.messageSocket, instructions, message, username);
			}
		}
		
		private function destroyClients():void
		{
			var len:int = clientsModel.length;
            while(len--)
            {
            	var clientSocketVO:ClientVO = clientsModel.getClientAt(len);
            	destroyClient(clientSocketVO.messageSocket);
            }
		}
		
		private function destroyClient(messageSocket:MessageSocket):void
		{
			clientsModel.removeClientByMessageSocket(messageSocket);
			removeClientListeners(messageSocket);
            try
            {
            	messageSocket.close();
            }
            catch(err:Error){}
		}
		
		private function removeClientListeners(messageSocket:MessageSocket):void
		{
			messageSocket.removeEventListener(MessageSocketEvent.NEW_MESSAGE,		onClientNewMessage); 
            messageSocket.removeEventListener(Event.CLOSE, 							onClientSocketClose); 
            messageSocket.removeEventListener(IOErrorEvent.IO_ERROR, 				onClientError);
            messageSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, 	onClientError);
		}
		
		private function destroy():void
		{
			destroyClients();
			destroySocket();
			messageManager.destroy();
		}
		
		// -- Client Handlers --
		private function onClientNewMessage(event:MessageSocketEvent):void
		{
			//DebugMax.log("ChatServerService::onClientNewMessage");
			
			var messageSocket:MessageSocket 		= event.target as MessageSocket;
			var clientVO:ClientVO					= clientsModel.getClientBySocket(messageSocket.socket);
			var len:int 							= messageSocket.messages.length;
			for(var index:uint = 0; index < len; index++)
			{
				var message:AbstractMessageVO = messageSocket.messages.getItemAt(index) as AbstractMessageVO;
				if(message is ChatMessageVO)
	            {
	            	var chatMessage:ChatMessageVO = message as ChatMessageVO;
	            	if(chatMessage == null)
	            	{
	            		DebugMax.warn("ChatServerService::onClientNewMessage, couldn't parse chat message.");
	            		return;
	            	}
	            }
	            else
	            {
	            	// we only care about chat messages, we ignore everything else including ACK's
	            	continue;
	            }
	 			
	 			messageSocket.removeMessageAt(index);
	 			index--;
	 			len--;
	 			messageManager.sendACK(messageSocket, chatMessage);
	 			
	 			switch(chatMessage.instructions)
	 			{
	 				case InstructionConstants.CLIENT_SET_USERNAME:
	 					clientVO.username = chatMessage.username;
	 					clientsModel.clients.setItemAt(clientVO, clientsModel.clients.getItemIndex(clientVO));
	 					sendGlobalChatMessage(InstructionConstants.SERVER_CLIENT_CONNECTED_TO_CHAT, chatMessage.username + " connected to the chat.", chatMessage.username);
	 					var usernameList:Array = clientsModel.getClientUsernameList();
	 					sendMessageToClient(clientVO.messageSocket, InstructionConstants.SERVER_UPDATED_USER_LIST, usernameList, WHATS_MY_NAME_BEEEEOOOTCH);
	 					break;
	 				
	 				case InstructionConstants.CLIENT_CHAT_MESSAGE:
	 					// echo chat messages to all in group
	 					sendGlobalChatMessage(InstructionConstants.SERVER_CLIENT_CHAT_MESSAGE, chatMessage.message, chatMessage.username);
	 					break;
	 				
	 				default:
	 					// ignore rogue messages
	 					//sendGlobalChatMessage(InstructionConstants.SERVER_UKNOWN_CLIENT_MESSAGE, "lol, wut? DoEs n0T cOmPUt3, OT OT OT", WHATS_MY_NAME_BEEEEOOOTCH);
	 			}
			}
		}
		
		private function onClientSocketClose(event:Event):void
		{
			var clientSocket:MessageSocket			= event.target as MessageSocket;
			var clientVO:ClientVO 					= clientsModel.getClientBySocket(clientSocket.socket);
			if(clientVO)
			{
				sendGlobalChatMessage(InstructionConstants.SERVER_CLIENT_DISCONNECTED, clientVO.username, WHATS_MY_NAME_BEEEEOOOTCH);
			}
			
			destroyClient(clientSocket);
		}
		
		private function onClientError(event:ErrorEvent):void
		{
			DebugMax.error("ChatServerService::onClientError: " + event.text);
		}
		
		public function bootUser(user:ClientVO):void
		{
			destroyClient(user.messageSocket);
			sendGlobalChatMessage(InstructionConstants.SERVER_USER_BOOTED, user.username + " was booted from the chat.", WHATS_MY_NAME_BEEEEOOOTCH);
		}
		
		public function close():void
		{
			destroy();
		}
	}
}