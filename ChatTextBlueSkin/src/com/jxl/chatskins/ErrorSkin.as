package com.jxl.chatskins
{
	import flash.display.Bitmap;
	
	import mx.core.UIComponent;

	public class ErrorSkin extends UIComponent
	{
		
		[Embed(source="/assets/flash/error.png")]
		private var ErrorImage:Class;
		
		private var image:Bitmap;
		
		public function ErrorSkin()
		{
			super();
			
			width 		= 231;
			height		= 215;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			image = new ErrorImage() as Bitmap;
			addChild(image);
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			image.width 		= width;
			image.height 		= height;
		}
		
	}
}