package tool;

class IntTools 
{
	public static function mod(a:Int, b:Int):Int
	{
		return ((a % b) + b) % b;
	}
}