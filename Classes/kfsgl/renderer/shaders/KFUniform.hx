package kfsgl.renderer.shaders;

import haxe.Json;
import openfl.geom.Matrix3D;

import kfsgl.renderer.shaders.KFUniformLib;
import kfsgl.utils.KF;
import kfsgl.errors.KFException;

class KFUniform  {

	private var _name:String;
	private var _uniformInfo:KFUniformInfo;
	private var _location:Int;
	private var _size:Int;

	private var _floatValue:Float = 0.0;
	private var _floatArrayValue:Array<Float> = new Array<Float>();
	private var _matrixValue:Matrix3D = new Matrix3D();

	private var _defaultFloatValue:Float;
	private var _defaultFloatArrayValue:Array<Float> = new Array<Float>();
	private var _defaultMatrixValue:Matrix3D = new Matrix3D();

	private var _hasBeenSet:Bool = false;
	private var _isDirty:Bool = true;

	public function new(name:String, uniformInfo:KFUniformInfo, location:Int) {
		_name = name;
		_uniformInfo = uniformInfo;
		_location = location;

		handleDefaultValue();

		KF.Log(toString());
	}


	public function clone():KFUniform {
		return new KFUniform(_name, _uniformInfo, _location);
	}


	public function prepareForUse() {
		_hasBeenSet = false;
	}

	public function use() {
		// If hasn't been set then use the default value
		if (!_hasBeenSet) {
			if (_size == 1) {
				setValue(_defaultFloatValue);
			} else if (_size < 16) {
				setArrayValue(_defaultFloatArrayValue);
			} else {
				setMatrixValue(_defaultMatrixValue);
			}
		}

		// Send value to the GPU if it is dirty
		if (_isDirty) {
			// TODO set value in the GPU
		}
	}

	public function setValue(value:Float) {
		if (_size != 1) {
			throw new KFException("IncoherentUniformValue", "A float value is being set for the uniform array " + _uniformInfo.name);
		} else {
			_hasBeenSet = true;

			if (_floatValue != value) {
				_floatValue = value;
				_isDirty = true;
			}
		}
	}

	public function setArrayValue(value:Array<Float>) {
		if (_size == 1 || _size == 16) {
			throw new KFException("IncoherentUniformValue", "A float or matrix value is being set for the array uniform " + _uniformInfo.name);
		
		} else if (_size != value.length) {
			throw new KFException("IncoherentUniformValue", "An array of size " + value.length + " is being set for the uniform array " + _uniformInfo.name + " with size " + _size);
		
		} else {
			_hasBeenSet = true;

			// Comparison of both arrays
			if (value.toString() != _floatArrayValue.toString()) {
				// Copy array values
				_floatArrayValue = value.copy();
				_isDirty = true;
			}

		}
	}

	public function setMatrixValue(value:Matrix3D) {
		_hasBeenSet = true;

		// Comparison of both matrices
		if (value.rawData.toString() != _matrixValue.rawData.toString()) {

			// Copy array values
			_matrixValue.copyFrom(value);
			_isDirty = true;
		}
	}

	public function handleDefaultValue() {
		var defaultValue = _uniformInfo.defaultValue;
		if (defaultValue != null) {
			var type = _uniformInfo.type;

			if (type == "float") {
				_size = 1;
				var floatValue:Float = Std.parseFloat(defaultValue);
				if (floatValue == Math.NaN) {
					throw new KFException("UnableToParseUniformValue", "Could not parse default value " + defaultValue + " for uniform " + _uniformInfo.name);

				} else {
					_defaultFloatValue = floatValue;
					setValue(_defaultFloatValue);
				}

			} else if (type == "vec2") {
				_defaultFloatArrayValue = haxe.Json.parse(defaultValue);
				_size = 2;
				setArrayValue(_defaultFloatArrayValue);

			} else if (type == "vec3") {
				_defaultFloatArrayValue = haxe.Json.parse(defaultValue);
				_size = 3;
				setArrayValue(_defaultFloatArrayValue);

			} else if (type == "ve4") {
				setArrayValue(_defaultFloatArrayValue);
				_defaultFloatArrayValue = haxe.Json.parse(defaultValue);
				_size = 4;
				setArrayValue(_defaultFloatArrayValue);

			} else if (type == "mat3") {
				if (defaultValue == "identity") {
					defaultValue = "[1, 0, 0, 0, 1, 0, 0, 0, 1]";
				}
				_defaultFloatArrayValue = haxe.Json.parse(defaultValue);
				_size = 9;
				setArrayValue(_defaultFloatArrayValue);

			} else if (type == "mat4") {
				if (defaultValue == "identity") {
					defaultValue = "[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]";
				}
				var floatArray:Array<Float> = haxe.Json.parse(defaultValue);
				_defaultMatrixValue.copyRawDataFrom(floatArray);
				_size = 16;
				setMatrixValue(_defaultMatrixValue);

			}
		}
	}

	public function toString() {
		var type = _uniformInfo.type;
		var text:String = "unifom " + _name + " (";

		if (type == "float") {
			text += _floatValue;

		} else if (type == "vec2") {
			text += _floatArrayValue.toString();

		} else if (type == "vec3") {
			text += _floatArrayValue.toString();

		} else if (type == "ve4") {
			text += _floatArrayValue.toString();

		} else if (type == "mat3") {
			text += _floatArrayValue.toString();

		} else if (type == "mat4") {
			text += _matrixValue.rawData.toString();

		}

		text += ")" + " : " + _uniformInfo.name + " = " + _location;

		return text;
	}

}