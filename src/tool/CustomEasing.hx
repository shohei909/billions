package tool;

class CustomEasing 
{

	public static function quintQuintIn(v:Float):Float
	{
		return v.quintIn().quintIn();
	}
	public static function quintQuintOut(v:Float):Float
	{
		return v.quintOut().quintOut();
	}
}