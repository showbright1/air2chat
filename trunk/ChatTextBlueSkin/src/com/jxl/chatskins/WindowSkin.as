package com.jxl.chatskins
{
	import flash.display.Sprite;
	
	import mx.core.UIComponent;

	public class WindowSkin extends UIComponent
	{
		
		[Embed(source="/assets/flash/window.png", scaleGridLeft="355", scaleGridTop="175", scaleGridRight="502", scaleGridBottom="340")]
		private var symbol:Class;
		
		private var mc:Sprite;
		
		public function WindowSkin()
		{
			super();
			
			width		= 512.55;
			height		= 408.5;
			
			
			filters 	= [TechBlueConstants.DROP_SHADOW]; 
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			mc = new symbol() as Sprite;
			addChild(mc);
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			mc.width		= width;
			mc.height		= height;
		}
		
	}
}