package com.jxl.chat.factories
{
	import com.adobe.serialization.json.JSON;
	import com.jxl.chat.vo.messages.ACKMessageVO;
	import com.jxl.chat.vo.messages.AbstractMessageVO;
	import com.jxl.chat.vo.messages.ChatMessageVO;
	import com.jxl.chat.vo.messages.MessageTypes;
	import com.jxl.chat.vo.messages.UnknownMessageVO;
	
	import flash.net.Socket;
	
	public class MessageFactory
	{
		
		public static function getMessagesFromSocket(socket:Socket):Array
		{
			var json:String						= socket.readUTFBytes(socket.bytesAvailable);
			//DebugMax.log("MessageFactory::getMessagesFromSocket");
			//DebugMax.log("-- json --");
			//DebugMax.log(json);
			var messageStrings:Array			= json.split("}");
			messageStrings.length--;
			var len:int = messageStrings.length;
			var parsedMessages:Array = [];
			var message:AbstractMessageVO;
			for(var index:uint = 0; index < len; index++)
			{
				var messageStr:String = messageStrings[index] + "}";
				var obj:Object = JSON.decode(messageStr);
				if(obj.t == undefined || (obj.t is String) == false)
				{
					continue;
				}
				
				switch(obj.t)
				{
					case MessageTypes.ABSTRACT:
						message = new AbstractMessageVO();
						break;
					
					case MessageTypes.ACK:
						message = new ACKMessageVO();
						break;
					
					case MessageTypes.CHAT:
						message = new ChatMessageVO();
						break;
					
					case MessageTypes.UNKNOWN:
						message = new UnknownMessageVO();
						break;
				}
				
				if(message)
				{
					message.fromJSONObject(obj);
				}
				else
				{
					continue;
				}
				
				parsedMessages[index] = message;
			}
			
			return parsedMessages;
		}
		

	}
}