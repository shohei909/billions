package collision;

interface ICollisionResult 
{
	public var distanceSquared(default, null):Float;
	public var sourceX        (default, null):Float;
	public var sourceY        (default, null):Float;
	public var sourceWidth    (default, null):Float;
	public var sourceHeight   (default, null):Float;
	public var shouldAbort    (default, null):Bool ;
}