typedef ColorDef = {
	var red:UInt;
	var green:UInt;
	var blue:UInt;
}

@:forward
abstract Color(ColorDef) {
	public inline function new(cd)
		this = cd;

	@:to
	public inline function toString():String
		return "#" + StringTools.hex((this.red << 16) | (this.green << 8) | this.blue, 6);

	@:to
	public inline function toRGBString():String
		return 'R:${this.red}\nG:${this.green}\nB:${this.blue}';

	@:from
	static public function fromInt(s:Int) {
		if (s == null)
			return new Color({
				red: 0,
				green: 0,
				blue: 0
			});
		return new Color({
			red: (s & 0xff0000) >>> 16,
			green: (s & 0x00ff00) >>> 8,
			blue: s & 0x0000ff,
		});
	}

	@:from
	static public function fromString(s:String) {
		if (s == null)
			return new Color({
				red: 0,
				green: 0,
				blue: 0
			});
		if (s.indexOf("rgb(") == 0) {
			var ereg = ~/rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/;

			if (ereg.match(s)) {
				return new Color({
					red: Std.parseInt(ereg.matched(1)),
					green: Std.parseInt(ereg.matched(2)),
					blue: Std.parseInt(ereg.matched(3))
				});
			}
		} else if (s.indexOf("#") == 0) {
			return fromInt(Std.parseInt("0x" + s.substring(1, s.length)));
		} else if (s.indexOf("0x") == 0) {
			return fromInt(Std.parseInt(s));
		}

		return new Color({
			red: 0,
			green: 0,
			blue: 0
		});
	}
}
