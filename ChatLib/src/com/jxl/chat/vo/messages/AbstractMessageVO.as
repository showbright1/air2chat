package com.jxl.chat.vo.messages
{
	import com.adobe.serialization.json.JSON;
	
	public class AbstractMessageVO
	{
		public static var ID_COUNTER:uint = 0;
		
		protected var _id:uint;
		protected var _type:String = MessageTypes.ABSTRACT;
		
		public function get id():uint { return _id; }
		public function get type():String { return _type; }
		
		public function AbstractMessageVO()
		{
			_id = ++ID_COUNTER;
		}
		
		public function toJSON():String
		{
			var obj:Object = {id: id, t: _type};
			return JSON.encode(obj);
		}
		
		public function fromJSONObject(jsonObject:Object):void
		{
			_id					= jsonObject.id;
			_type 				= jsonObject.type;
		}
		
		public function toString():String
		{
			var str:String 			= "";
			str						+= "[class AbstractMessageVO ";
			str						+= "id=" + id;
			str						+= ", type=" + type;
			str						+= "]";
			return str;
		}

	}
}