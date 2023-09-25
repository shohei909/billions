package tool;

class GeometryTools 
{

	public static function isNear(radius:Float, ax:Float, ay:Float, bx:Float, by:Float):Bool
	{
		var dx = ax - bx;
		var dy = ay - by;
		return dx * dx + dy * dy < radius * radius;
	}
}
