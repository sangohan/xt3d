package xt3d.gl.view;

import xt3d.utils.geometry.Size;
import lime.graphics.GLRenderContext;

interface Xt3dGLView {

	var gl(get, null):GLRenderContext;
	var size(get, null):Size<Int>;
	var touchDelegate(get, set):TouchDelegate;
	var mouseDelegate(get, set):MouseDelegate;

	function addListener(listener:Xt3dGLViewListener):Void;
	function removeListener(listener:Xt3dGLViewListener):Void;

	function get_gl():GLRenderContext;
	function get_size():Size<Int>;
	function get_touchDelegate():TouchDelegate;
	function set_touchDelegate(value:TouchDelegate):TouchDelegate;
	function get_mouseDelegate():MouseDelegate;
	function set_mouseDelegate(value:MouseDelegate):MouseDelegate;



}
