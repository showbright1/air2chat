package com.jxl.chatskins
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.UIComponent;

	public class AbstractTechButton extends UIComponent
	{
		
		protected var mc:MovieClip;
		
		public function AbstractTechButton()
		{
			super();
			
			buttonMode = mouseEnabled = useHandCursor = true;
			mouseChildren = false;
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function stop():void
		{
			mc.stop();
		}
		
		private function playLabel(label:String):void
		{
			mc.gotoAndPlay(label);
			mc.play();
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			playLabel("over");
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			playLabel("up");
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			playLabel("down");
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			if(hitTestPoint(event.localX, event.localY))
			{
				playLabel("down");
			}
			else
			{
				playLabel("up");
			}
		}
		
		private function onAddedToStage(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
	}
}