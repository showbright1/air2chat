package com.jxl.chat.vo.messages
{
	import com.adobe.serialization.json.JSON;
	
	public class ChatMessageVO extends AbstractMessageVO
	{
		
		public var message:*;
		public var instructions:String;
		public var username:String;
		
		public function ChatMessageVO()
		{
			super();
			
			_type = MessageTypes.CHAT;
		}
		
		public override function toJSON():String
		{
			var obj:Object = {id: id, m: message, u: username, i: instructions, t: _type};
			return JSON.encode(obj);
		}
		
		public override function fromJSONObject(jsonObject:Object):void
		{
			_id					= jsonObject.id;
			message 			= jsonObject.m;
			username 			= jsonObject.u;
			instructions		= jsonObject.i;
			_type				= jsonObject.t;
		}
		
		public override function toString():String
		{
			var str:String 			= "";
			str						+= "[class ChatMessageVO ";
			str						+= "id=" + id;
			str						+= ", type=" + _type;
			str						+= ", instructions=" + instructions;
			str						+= ", username=" + username;
			str 					+= ", message=" + message;
			str						+= "]";
			return str;
		}

	}
}