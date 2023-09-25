package viewTree.core;

class DrawContext 
{
	public var delta  (default, null):Float;
	public var isDirty(default, null):Bool;
	public var blocked(default, null):Bool;
	
	public function new() 
	{
		reset(true, 1);
	}
	
	public function reset(isDirty:Bool, delta:Float):Void
	{
		this.isDirty = isDirty;
		this.delta = delta;
		blocked = false;
	}
	public function block():Void
	{
		blocked = true;
	}
}
