package;

import native.Libnut;
import haxe.ds.Option;

using api.IdeckiaApi;
using StringTools;

typedef Props = {
	@:editable("Is the color updated constantly?", false)
	var is_dynamic:Bool;
}

enum ViewMode {
	name;
	hex;
	rgb;
}

@:name("color-picker")
@:description("Pick the color from the point where the mouse is")
class ColorPicker extends IdeckiaAction {
	var currentViewMode:ViewMode = name;
	var currentColor:Color = null;

	var timer:haxe.Timer;
	var isRunning:Bool;
	var currentItemState:ItemState;

	static var COLOR_NAMES:Array<{name:String, hex:String}>;

	override public function init(initialState:ItemState):js.lib.Promise<ItemState> {
		if (COLOR_NAMES == null) {
			var content = try sys.io.File.getContent(haxe.io.Path.join([js.Node.__dirname, 'colornames.json'])) catch (e:Any) '[]';
			COLOR_NAMES = haxe.Json.parse(content);
		}

		currentViewMode = name;
		currentColor = null;
		isRunning = props.is_dynamic;

		currentItemState = initialState;
		if (props.is_dynamic) {
			initTimer();
		}

		return super.init(initialState);
	}

	function initTimer() {
		timer = new haxe.Timer(10);
		timer.run = () -> {
			if (!isRunning)
				return;

			calculateColor(currentItemState).then(updatedState -> {
				if (updatedState.hasChanged)
					server.updateClientState(updatedState.state);
			});
		};
	}

	public function execute(currentState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise<ItemState>((resolve, reject) -> {
			if (props.is_dynamic) {
				isRunning = !isRunning;
				if (isRunning) {
					initTimer();
				} else {
					timer.stop();
					timer = null;
				}
				resolve(currentState);
			} else {
				calculateColor(currentState).then(updatedState -> {
					resolve(updatedState.state);
				});
			}
		});
	}

	function calculateColor(currentState:ItemState) {
		return new js.lib.Promise<{hasChanged:Bool, state:ItemState}>((resolve, reject) -> {
			var capture = Libnut.screen.capture();
			var screenSize = Libnut.getScreenSize();
			var pixelDensity = {
				x: capture.width / screenSize.width,
				y: capture.height / screenSize.height,
			};

			var mousePos = Libnut.getMousePos();

			if (mousePos.x < 0 || mousePos.x > capture.width) {
				reject("Mouse is out of the bounds from the primary screen. Can't get the color from there.");
				return;
			}
			if (mousePos.y < 0 || mousePos.y > capture.height) {
				reject("Mouse is out of the bounds from the primary screen. Can't get the color from there.");
				return;
			}

			var scaledPointX = mousePos.x * pixelDensity.x;
			var scaledPointY = mousePos.y * pixelDensity.y;

			var firstByte = Std.int(capture.bytesPerPixel * (capture.width * scaledPointY + scaledPointX));

			var buff = [];
			for (i in 0...capture.bytesPerPixel) {
				buff.push(capture.image[firstByte + i]);
			}

			var color:Color = new Color({
				red: buff[2],
				green: buff[1],
				blue: buff[0]
			});

			var hasChanged = false;
			if (currentColor != color) {
				hasChanged = true;
				currentColor = color;
				currentState.text = switch findClosestColor(color) {
					case Some(v):
						switch currentViewMode {
							case name:
								v.name;
							case hex:
								color.toString();
							case rgb:
								color.toRGBString();
						}
					case None:
						switch currentViewMode {
							case name:
								'No name:\n' + color.toString();
							case hex:
								color.toString();
							case rgb:
								color.toRGBString();
						}
				}

				currentState.bgColor = 'ff' + color.toString().replace('#', '');
			}

			resolve({hasChanged: hasChanged, state: currentState});
		});
	}

	function calcEuclidDistance(color0:Color, color1:Color) {
		var r = color0.red - color1.red;
		var g = color0.green - color1.green;
		var b = color0.blue - color1.blue;
		return Math.sqrt(r * r + g * g + b * b);
	}

	function findClosestColor(color) {
		var smallestDistance = Math.POSITIVE_INFINITY;
		var distance;
		var curColor = null;
		for (c in COLOR_NAMES) {
			distance = calcEuclidDistance(c.hex, color);
			if (distance < smallestDistance) {
				smallestDistance = distance;
				curColor = c;
			}
		}

		return if (curColor != null) Some(curColor) else None;
	}

	override public function onLongPress(currentState:ItemState):js.lib.Promise<ItemState> {
		return new js.lib.Promise<ItemState>((resolve, reject) -> {
			currentViewMode = switch currentViewMode {
				case name: hex;
				case hex: rgb;
				case rgb: name;
			}

			calculateColor(currentState).then(updatedState -> {
				if (updatedState.hasChanged)
					resolve(updatedState.state);
			});
		});
	}
}
