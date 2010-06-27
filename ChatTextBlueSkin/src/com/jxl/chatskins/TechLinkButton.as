package com.jxl.chatskins
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.core.UIComponent;

	public class TechLinkButton extends UIComponent
	{
		
		private var labelField:TechLabel;
		private var underline:Shape;
		
		private var _label:String = "Link Button";
		private var labelDirty:Boolean = false;
		
		private var underlineColor:uint = 0x00FFFF;
		
		public function get label():String { return _label; }
		public function set label(value:String):void
		{
			_label = value;
			labelDirty = true;
			invalidateProperties();
		}
		
		public function TechLinkButton()
		{
			super();
			
			
			width		= 100;
			height		= 16;
			
			buttonMode = useHandCursor = true;
			mouseChildren = false;
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			labelField = new TechLabel();
			addChild(labelField);
			labelField.color = 0x00FFFF;
			
			underline = new Shape();
			addChild(underline);
			
			filters = [new DropShadowFilter(1, 45, 0x333333, 1, 1, 1, 1, 3), TechBlueConstants.DROP_SHADOW];
			
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(labelDirty)
			{
				labelDirty = false;
				labelField.text = _label;
				invalidateDisplayList();
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			labelField.height = height;
			
			underline.y = height - 2;
			underline.graphics.clear();
			underline.graphics.lineStyle(1, underlineColor);
			underline.graphics.lineTo(labelField.textField.textWidth + 4, 0);
			underline.graphics.endFill();
		}
		
		private function onRollOver(event:MouseEvent):void
		{
			labelField.color = underlineColor = 0xEEEEEE;
			invalidateDisplayList();
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			labelField.color = underlineColor = 0x00FFFF;
			invalidateDisplayList();
		}
		
	}
}