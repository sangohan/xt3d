package xt3d.utils.errors;

import haxe.CallStack;

class XTError {


	private static inline var DEFAULT_TO_STRING = "Error";

	public var errorID:Int;
	public var message:String;
	public var name:String;


	public function new (message:String = "", id:Int = 0) {

		this.message = message;
		this.errorID = id;
		name = "Error";

	}


	public function getStackTrace ():String {

		return CallStack.toString (CallStack.exceptionStack ());

	}


	public function toString ():String {

		if (message != null) {

			return message;

		} else {

			return DEFAULT_TO_STRING;

		}

	}


}
