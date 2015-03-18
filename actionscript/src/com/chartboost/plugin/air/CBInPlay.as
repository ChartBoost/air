package com.chartboost.plugin.air {
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class CBInPlay {
		
		// vars
		public var appName:String;
		public var appIcon:BitmapData;
		public var location:String;
		
		private var inPlayUniqueId:String;
		private var appIconData:String;
		private var loader:Loader;
		private var extContext:Object;
		private var iconLoadedCallback:Function;
		
		public function CBInPlay(extContext:Object, inPlay:Object, fn:Function = null) {
			this.inPlayUniqueId = inPlay.ID;
			this.appName = inPlay.name;
			this.appIconData = inPlay.icon;
			this.location = inPlay.location;
			this.extContext = extContext;
			this.iconLoadedCallback = fn;
			
			loadIcon();
		}
		
		public function show():void {
			if (Chartboost.isPluginSupported()) {
				this.extContext.call("inPlayShow", this.inPlayUniqueId);
			}
		}
		
		public function click():void {
			if (Chartboost.isPluginSupported()) {
				this.extContext.call("inPlayClick", this.inPlayUniqueId);
			}
		}
		
		private function loadComplete(e:Event):void {
			// Draw image
			this.appIcon = new BitmapData(this.loader.width, this.loader.height, true, 0x0);
			this.appIcon.draw(this.loader);
			
			// Cleanup
			this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			this.loader = null;
			
			if (this.iconLoadedCallback != null) {
				this.iconLoadedCallback(this);
			}
		}
		
		private function loadIcon():void {
			if (this.appIconData != null) {
				var newByteArr:ByteArray = Base64.decodeToByteArray(this.appIconData);
				
				this.loader = new Loader();
				this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
				this.loader.loadBytes(newByteArr);
			}
		}
	}
}