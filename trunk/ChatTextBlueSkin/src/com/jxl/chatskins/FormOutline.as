package com.jxl.chatskins
{
	import flash.display.Sprite;
	
	import mx.core.UIComponent;

	public class FormOutline extends UIComponent
	{
		
		[Embed(source="/assets/flash/tech-blue-skins.swf", symbol="FormOutline")]
		private var symbol:Class;
		
		private var mc:Sprite;
		
		public function FormOutline()
		{
			super();
			width		= 100;
			height		= 100;
			
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