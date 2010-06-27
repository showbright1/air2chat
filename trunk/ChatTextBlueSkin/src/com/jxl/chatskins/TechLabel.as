package com.jxl.chatskins
{
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.UIComponent;

	public class TechLabel extends UIComponent
	{
		
		
		private var labelField:TextField;
		private var labelFieldFormat:TextFormat;
		
		private var _text:String = "Label";
		private var textDirty:Boolean = false;
		private var _align:String = "left";
		private var alignDirty:Boolean = false;
		private var _fontFamily:String = "uni 05_63_8pt_st";
		private var fontFamilyDirty:Boolean = false;
		private var _debug:Boolean = false;
		private var debugDirty:Boolean = false;
		private var _color:uint = 0x000000;
		private var colorDirty:Boolean = false;
		
		public function get textField():TextField { return labelField; }
		
		public function get text():String { return _text; }
		public function set text(value:String):void
		{
			_text = value;
			textDirty = true;
			invalidateProperties();
		}
		
		public function get textAlign():String { return _align; }
		public function set textAlign(value:String):void
		{
			_align = value;
			alignDirty = true;
			invalidateProperties();
		}
		
		public function get fontFamily():String { return _fontFamily; }
		public function set fontFamily(value:String):void
		{
			_fontFamily = value;
			fontFamilyDirty = true;
			invalidateProperties();
		}
		
		public function get debug():Boolean { return _debug; }
		public function set debug(value:Boolean):void
		{
			_debug = value;
			debugDirty = value;
			invalidateProperties();
		}
		
		public function get color():uint { return _color; }
		public function set color(value:uint):void
		{
			_color = value;
			colorDirty = true;
			invalidateProperties();
		}
		
		public function TechLabel()
		{
			super();
			
			width  		= 100;
			height		= 14;
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			labelField 				= new TextField();
			addChild(labelField);
			labelField.multiline 	= labelField.wordWrap = false;
			labelField.selectable 	= false;
			labelField.embedFonts 	= true;
			
			labelFieldFormat 		= new TextFormat();
			labelFieldFormat.font 	= _fontFamily;
			labelFieldFormat.size 	= 8;
			labelFieldFormat.align 	= _align;
			
			labelField.text 		= _text;
			
			labelField.setTextFormat(labelFieldFormat);
		}
		
		protected override function commitProperties():void
		{
			super.commitProperties();
			
			if(textDirty)
			{
				textDirty 				= false;
				labelField.text 		= _text;
				alignDirty 				= true;
				fontFamilyDirty			= true;
			}
			
			
			if(alignDirty || fontFamilyDirty || colorDirty)
			{
				alignDirty 				= false;
				fontFamilyDirty			= false;
				labelFieldFormat.align 	= _align;
				labelFieldFormat.font 	= _fontFamily;
				labelFieldFormat.color	= _color;
				labelField.setTextFormat(labelFieldFormat);
			}
			
			if(debugDirty)
			{
				debugDirty = false;
				invalidateDisplayList();
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			labelField.width 	= width;
			labelField.height 	= height;
			
			var g:Graphics = graphics;
			if(_debug)
			{	
				g.clear();
				if(_debug)
				{
					g.lineStyle(0, 0xFF0000);
					g.drawRect(0, 0, width, height);
					g.endFill();
				}
			}
		}
		
		public function sizeToText():void
		{
			labelField.width 	= labelField.textWidth + 4;
			labelField.height 	= labelField.textHeight + 4;
		}
		
	}
}