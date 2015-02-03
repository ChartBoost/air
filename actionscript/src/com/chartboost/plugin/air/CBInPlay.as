package com.chartboost.plugin.air {
	
	import com.adobe.serialization.json.Json;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.display.*;
	
	public class CBInPlay {
		
		// NOTE: this class is not fully functional yet and is not included in release
		
		// vars
		public var appName:String;
		public var appIcon:String;
		private var inPlayUniqueId:String;
		private var _loader:Loader;
		private var _callback:Function;
		private var extContext:Object;
		
		public function CBInPlay(extContext:Object, inPlay:Object) {
			this.inPlayUniqueId = inPlay.ID;
			this.appName = inPlay.name;
			this.appIcon = inPlay.icon;
			this.extContext = extContext;
		}
		
		private function loadComplete(e:Event):void {
			var bmp:BitmapData = new BitmapData(this._loader.width, this._loader.height, true, 0x0);
			bmp.draw(this._loader);
			this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			if (this._callback != null) {
				this._callback.call(bmp);
				this._callback = null;
			}
			this._loader = null;
		}
		
		public function loadIcon(loadComplete:Function):void {
			var newByteArr:ByteArray = Base64.decodeToByteArray(this.appIcon);
			
			this._callback = loadComplete;
			this._loader = new Loader();
			this._loader.loadBytes(newByteArr);
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}
		
		public function show():void {
			if (Chartboost.isPluginSupported())
				this.extContext.call("inPlayShow", this.inPlayUniqueId);
		}
		
		public function click():void {
			if (Chartboost.isPluginSupported())
				this.extContext.call("inPlayClick", this.inPlayUniqueId);
		}
	}
}