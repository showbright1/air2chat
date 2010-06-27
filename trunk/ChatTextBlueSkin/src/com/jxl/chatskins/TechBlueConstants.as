package com.jxl.chatskins
{
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	
	public class TechBlueConstants
	{
		
		
		[Embed(source="/assets/flash/tech-blue-skins.swf", fontName="uni 05_63_8pt_st", fontStyle="regular")]
		public static const UNIFont_05_63:Class;
		
		[Embed(source="/assets/flash/tech-blue-skins.swf", fontName="uni 05_53_8pt_st", fontStyle="regular")]
		public static const UNIFont_05_53:Class;
		
		
		public static const DROP_SHADOW:DropShadowFilter = new DropShadowFilter(1, 45, 0x333333, 1, 4, 4, 1, 3);
		
		public static const LINE_GLOW:GlowFilter = new GlowFilter(0x00FFFF, 1, 6, 6, 2, 2);

	}
}