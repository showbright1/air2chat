package com.jxl.chatskins
{
	import mx.controls.TextArea;
	import mx.core.ClassFactory;

	public class TechTextArea extends TextArea
	{
		
		[Embed(source="/assets/flash/tech-blue-skins.swf", symbol="ArrowUpButton")]
		private var ArrowUpButton:Class;
		
		public function TechTextArea()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			/*
			borderColor: #B7BABC;
			cornerRadius: 4;
			downArrowDisabledSkin: ClassReference("mx.skins.halo.ScrollArrowSkin");
			downArrowDownSkin: ClassReference("mx.skins.halo.ScrollArrowSkin");
			downArrowOverSkin: ClassReference("mx.skins.halo.ScrollArrowSkin");
			downArrowUpSkin: ClassReference("mx.skins.halo.ScrollArrowSkin");
			thumbOffset: 0;
			thumbDownSkin: ClassReference("mx.skins.halo.ScrollThumbSkin");
			thumbOverSkin: ClassReference("mx.skins.halo.ScrollThumbSkin");
			thumbUpSkin: ClassReference("mx.skins.halo.ScrollThumbSkin");
			trackColors: #94999b, #e7e7e7;
			trackSkin: ClassReference("mx.skins.halo.ScrollTrackSkin");
			upArrowDisabledSkin: ClassReference("mx.skins.halo.ScrollArrowSkin");
			upArrowDownSkin: ClassReference("mx.skins.halo.ScrollArrowSkin");
			upArrowOverSkin: ClassReference("mx.skins.halo.ScrollArrowSkin");
			upArrowUpSkin: ClassReference("mx.skins.halo.ScrollArrowSkin");
			*/
			setStyle("upArrowUpSkin", ArrowUpButton);
		}
		
	}
}