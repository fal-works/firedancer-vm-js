@:expose("FiredancerVM.RectangleBounds")
@:structInit
class RectangleBounds {
	public static function fromCorners(x1:Float, y1:Float, x2:Float, y2:Float):RectangleBounds {
		return {
			leftX: x1,
			topY: y1,
			rightX: x2,
			bottomY: y2
		};
	}

	public static function fromSize(width:Float, height:Float, margin:Float, centerX = false, centerY = false):RectangleBounds {
		return {
			leftX: (if (centerX) -width / 2 else 0.0) - margin,
			topY: (if (centerY) -height / 2 else 0.0) - margin,
			rightX: (if (centerX) width / 2 else width) + margin,
			bottomY: (if (centerY) height / 2 else height) + margin
		};
	}

	final leftX:Float;
	final topY:Float;
	final rightX:Float;
	final bottomY:Float;

	/**
		@return `true` if the point `(x, y)` is in the habitable zone.
	**/
	public inline function containsPoint(x:Float, y:Float):Bool
		return y < bottomY && topY <= y && leftX <= x && x < rightX;
}
