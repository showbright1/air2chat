package com.jxl.chatskins
{
	import mx.containers.FormItem;
	import mx.controls.Label;
	import mx.core.IUITextField;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class TechFormItem extends FormItem
	{
		
		private var fontEmbedDependency:TechBlueConstants;
		private var designLabelField:TechLabel;
		
		public override function set label(value:String):void
		{
			if(value && value is String && value.length > 0)
			{
				value = value.toUpperCase();
			}
			super.label = value;
		}
		
		public function TechFormItem()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			var label:Label = this.itemLabel;
			var textField:IUITextField = label.mx_internal::getTextField();
			
			
			label.setStyle("embedFonts", true);
			label.setStyle("fontFamily", "uni 05_53_8pt_st");
			label.setStyle("fontSize", 8);
			label.setStyle("fontAntiAliasType", "normal");
			
			if(UIComponentGlobals.designTime)
			{
				designLabelField = new TechLabel();
				rawChildren.addChild(designLabelField);
				designLabelField.fontFamily = "uni 05_53_8pt_st";
				designLabelField.textAlign = "right";
				label.visible = false;
			}
		}
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var labelField:Label = this.itemLabel
			
			if(designLabelField)
			{
				designLabelField.text		= label;
				designLabelField.x 			= labelField.x;
				designLabelField.y			= labelField.y;
				designLabelField.width 		= labelField.width + 4;
				designLabelField.height 	= labelField.height + 4;
			}
		}
		
	}
}