package com.jxl.chat.vo.messages
{
	import com.adobe.serialization.json.JSON;
	
	public class ACKMessageVO extends AbstractMessageVO
	{
		public var ackMessageID:uint = 0;
		
		public function ACKMessageVO()
		{
			super();
			
			_type = MessageTypes.ACK;
		}
		
		public override function toJSON():String
		{
			var obj:Object = {id: id, t: _type, aid: ackMessageID};
			return JSON.encode(obj);
		}
		
		public override function fromJSONObject(jsonObject:Object):void
		{
			_id					= jsonObject.id;
			_type				= jsonObject.t;
			ackMessageID		= jsonObject.aid;
		}
		
		public override function toString():String
		{
			var str:String 			= "";
			str						+= "[class ACKMessageVO ";
			str						+= "id=" + id;
			str						+= ", type=" + _type;
			str						+= ", ackMessageID=" + ackMessageID;
			str						+= "]";
			return str;
		}

	}
}