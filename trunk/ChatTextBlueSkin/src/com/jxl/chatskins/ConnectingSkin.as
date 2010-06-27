package com.jxl.chatskins
{
	import com.jxl.chatskins.events.ConnectingAnimeEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import mx.core.MovieClipAsset;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;

	[Event(name="complete", type="com.jxl.chatskins.events.ConnectingAnimeEvent")]
	[Event(name="ready", type="com.jxl.chatskins.events.ConnectingAnimeEvent")]
	public class ConnectingSkin extends UIComponent
	{
		[Embed(source="/assets/flash/tech-blue-skins.swf", symbol="Connecting")]
		private var symbol:Class;
		
		private var anime:MovieClip;
		
		public function ConnectingSkin()
		{
			super();
			
			width 	= 163;
			height 	= 32;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			
			
			anime = new symbol() as MovieClipAsset;
			addChild(anime);
			anime.addFrameScript(29, onReady);
			anime.addFrameScript(49, onDone);
			
			if(UIComponentGlobals.designMode)
				anime.gotoAndStop(19);
					
		}
		
		public function stop():void
		{
			anime.stop();
		}
		
		private function onReady():void
		{
			anime.stop();
			dispatchEvent(new ConnectingAnimeEvent(ConnectingAnimeEvent.READY));
		}
		
		private function onDone():void
		{
			anime.stop();
			dispatchEvent(new ConnectingAnimeEvent(ConnectingAnimeEvent.COMPLETE));
		}
		
		public function playCreate():void
		{
			anime.gotoAndPlay("create");
			anime.play();
		}
		
		public function playDestroy():void
		{
			anime.gotoAndPlay("destroy");
			anime.play();
		}
		
	}
}