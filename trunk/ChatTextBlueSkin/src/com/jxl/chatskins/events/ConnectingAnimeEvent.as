package com.jxl.chatskins.events
{
	import flash.events.Event;

	public class ConnectingAnimeEvent extends Event
	{
		public static const READY:String			= "ready";
		public static const COMPLETE:String			= "complete";
		
		public function ConnectingAnimeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return new ConnectingAnimeEvent(type, bubbles, cancelable);
		}
		
	}
}