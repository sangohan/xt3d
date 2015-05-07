package kfsgl.textures;

import kfsgl.utils.gl.GLTextureManager;
import kfsgl.utils.KF;
class TextureCache {

	// properties

	// members
	private var _textureManager:GLTextureManager;
	private var _textures:Map<String, Texture2D>;


	private function new() {
	}


	public static function create(textureManager:GLTextureManager):TextureCache {
		var object = new TextureCache();

		if (object != null && !(object.init(textureManager))) {
			object = null;
		}

		return object;
	}

	private function init(textureManager:GLTextureManager):Bool {
		this._textures = new Map<String, Texture2D>();
		this._textureManager = textureManager;

		return true;
	}


	/* ----------- Properties ----------- */

	/* --------- Implementation --------- */

	public function addTextureWithURL(url:String, callback:Void -> Texture2D):Void {

	}

	public function addTextureFromAssetImage(imagePath:String, textureOptions:TextureOptions = null):Texture2D {
		if (this._textures.exists(imagePath)) {
			return this._textures.get(imagePath);
		}

		var texture = Texture2D.createFromAssetImage(imagePath, textureOptions, this._textureManager);
		this._textures.set(imagePath, texture);

		return texture;
	}

	public function asyncAddTextureFromAssetImage(imagePath:String, callback:Texture2D -> Void):Void {

	}


	public function textureForKey(textureKey:String):Texture2D {
		if (this._textures.exists(textureKey)) {
			return this._textures.get(textureKey);
		} else {
			KF.Warn("Texture for key \"" + textureKey + "\" does not exist");
			return null;
		}
	}


	public function removeTextureForKey(textureKey:String):Void {
		if (this._textures.exists(textureKey)) {
			var texture = this._textures.get(textureKey);

			// Dispose of the gl object
			texture.dispose(this._textureManager);

			this._textures.remove(textureKey);
		}
	}


	public function removeAllTextures():Void {
		var textureKeys = this._textures.keys();
		// Dispose all textures
		for (key in textureKeys) {
			this.removeTextureForKey(key);
		}
	}


	public function removeUnusedTextures():Void {
		// Get textures that are not used
		var unusedTextureKeys:Array<String> = new Array<String>();
		var textureKeys = this._textures.keys();
		while (textureKeys.hasNext()) {
			var textureKey = textureKeys.next();
			var texture = this._textures.get(textureKey);

			if (texture.retainCount == 0) {
				unusedTextureKeys.push(textureKey);
			}
		}

		// Remove unused textures
		for (unusedTextureKey in unusedTextureKeys) {
			this.removeTextureForKey(unusedTextureKey);
		}
	}


}