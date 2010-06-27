package com.jxl.chatskins
{
	import flash.display.MovieClip;

	public class MinimizeButton extends AbstractTechButton
	{
		[Embed(source="/assets/flash/tech-blue-skins.swf", symbol="MinimizeButtonSkin")]
		private var upSkinClass:Class;
		
		public function MinimizeButton()
		{
			super();
			
			width 		= 16;
			height		= 16;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			mc = new upSkinClass() as MovieClip;
			addChild(mc);
			mc.addFrameScript(9, stop);
			mc.addFrameScript(19, stop);
			mc.addFrameScript(28, stop);
		}
		
	}
}