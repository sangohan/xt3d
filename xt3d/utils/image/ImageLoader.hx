package xt3d.utils.image;

import haxe.io.Error;
import lime.net.HTTPRequest;
import lime.graphics.Image;
class ImageLoader {

	// properties

	// members
	private var _url:String;
	private var _successCbk:Image -> Void;
	private var _errorCbk:String -> Void;
	private var _progress:Float = 0.0;

	public static function create(url:String, successCbk:Image -> Void, errorCbk:String -> Void = null):ImageLoader {
		var object = new ImageLoader();

		if (object != null && !(object.init(url, successCbk, errorCbk))) {
			object = null;
		}

		return object;
	}

	public function init(url:String, successCbk:Image -> Void, errorCbk:String -> Void = null):Bool {
		this._url = url;
		this._successCbk = successCbk;
		this._errorCbk = errorCbk;

		var loader:HTTPRequest = new HTTPRequest();
		var future = loader.load(url);

		future.onComplete(this.onComplete);
		future.onError(this.onError);
		future.onProgress(this.onProgress);

		return true;
	}


	public function new() {

	}


	/* ----------- Properties ----------- */

	/* --------- Implementation --------- */


	private function onComplete(data):Void {
		XT.Log("Got image");

		try {
			Image.fromBytes(data, function (image) {
				// Call callback with bitmap data
				this._successCbk(image);
			});

		} catch (error:Dynamic) {
			handleError("invalid response data: " + error);
		}
	}

	private inline function onProgress(progress:Float):Void {
		// Progress between 0 and 1 ?
		this._progress = progress;

		XT.Log("loading " + Math.round(this._progress * 100) + "%");
	}

	private inline function onError(error:String):Void {
		handleError("ioErrorHandler: " + error);
	}

	private inline function handleError(error:String) {
		var errorString:String = "Error loading \"" + this._url + "\" : " + error;
		if (this._errorCbk == null) {
			XT.Error(errorString);

		} else {
			this._errorCbk(errorString);
		}
	}
}
