package com.chartboost.plugin.air {
	
	import flash.utils.*;
	
	public class CBUtils {
		public static function InitEnumConstants(inType :*):void {
			var type:XML = flash.utils.describeType(inType);
			for each (var constant:XML in type.constant)
			inType[constant.@name].Text = constant.@name;		
		}
	}
	
}
