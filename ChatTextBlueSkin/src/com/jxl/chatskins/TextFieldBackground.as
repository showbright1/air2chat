package com.jxl.chatskins
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;

	public class TextFieldBackground extends UIComponent
	{
		
		[Embed(source="/assets/flash/text-field.png", scaleGridLeft="4", scaleGridTop="5", scaleGridRight="92", scaleGridBottom="12")]
		private var BackgroundImage:Class;
		
		private var image:DisplayObject;
		
		public function TextFieldBackground()
		{
			super();
			
			width 		= 160;
			height		= 22;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			image = new BackgroundImage() as DisplayObject;
			addChild(image);
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			image.width = width;
			image.height = height;
		}
		
	}
}