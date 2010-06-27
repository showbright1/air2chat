package com.jxl.chatserver.events
{
	import flash.events.Event;
	import flash.net.Socket;

	public class ServiceEvent extends Event
	{
		
		public static const CHAT_SERVER_SERVICE_CONNECTED:String			= "chatServerServiceConnected";
		public static const CHAT_SERVER_SERVICE_ERROR:String				= "chatServerServiceError";
		
		public var lastError:String;
		
		public function ServiceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}