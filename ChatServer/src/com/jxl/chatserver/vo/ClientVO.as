package com.jxl.chatserver.vo
{
	import com.jxl.chat.net.MessageSocket;
	
	public class ClientVO
	{
		public var messageSocket:MessageSocket;
		public var username:String;
	
		public function ClientVO(messageSocket:MessageSocket, username:String):void
		{
			this.messageSocket 		= messageSocket;
			this.username			= username;
		}
		
		public function clone():ClientVO
		{
			return new ClientVO(messageSocket, username);
		}

	}
}