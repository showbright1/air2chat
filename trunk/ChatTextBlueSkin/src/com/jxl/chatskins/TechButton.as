package com.jxl.chatskins
{
	import flash.display.MovieClip;

	public class TechButton extends AbstractTechButton
	{
		
		// force compiler to embed font
		private var fontEmbedDepdency:TechBlueConstants;
		
		[Embed(source="/assets/flash/tech-blue-skins.swf", symbol="Button")]
		private var upSkinClass:Class;
		private var labelField:TechLabel;
		
		private var _label:String = "";
		private var labelDirty:Boolean = false;
		
		public function get label():String { return _label; }
		public function set label(value:String):void
		{
			_label = value;
			labelDirty = true;
			invalidateProperties();
		}
		
		public function TechButton()
		{
			super();
			
			width 		= 100;
			height		= 40;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			mc = new upSkinClass() as MovieClip;
			addChild(mc);
			mc.addFrameScript(9, stop);
			mc.addFrameScript(19, stop);
			mc.addFrameScript(29, stop);
			mc.gotoAndPlay("up");
			
			labelField = new TechLabel();
			addChild(labelField);
			labelField.textAlign = "center";
			labelField.text = _label;
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(labelDirty)
			{
				labelDirty = false;
				labelField.text = _label;
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			labelField.height = 12;
			labelField.y = (height / 2) - (labelField.height / 2);
			labelField.width = width;
		}
		
		
	}
}