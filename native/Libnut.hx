package native;

@:jsRequire('@nut-tree/libnut')
extern class Libnut {
	static var screen:Screen;
	static public function getMousePos():Point;
	static public function getScreenSize():Size;
}

extern class Screen {
	public function capture(?x:UInt, ?y:UInt, ?width:UInt, ?height:UInt):Bitmap;
}

typedef Point = {
	var x:UInt;
	var y:UInt;
}

typedef Size = {
	var width:UInt;
	var height:UInt;
}

typedef Bitmap = {
	var width:UInt;
	var height:UInt;
	var image:js.node.Buffer;
	var byteWidth:UInt;
	var bitsPerPixel:UInt;
	var bytesPerPixel:UInt;
}
