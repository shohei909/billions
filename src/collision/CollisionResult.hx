package collision;
import collision.Collider;

@:allow(collision)
class CollisionResult<T> implements ICollisionResult
{
	public var collider       (default, null):Collider<T>;
	public var target         (default, null):T;
	public var distanceSquared(default, null):Float;
	public var sourceX        (default, null):Float;
	public var sourceY        (default, null):Float;
	public var sourceWidth    (default, null):Float;
	public var sourceHeight   (default, null):Float;
	public var shouldAbort                   :Bool;
	
	public function new() {}
	public function copyFrom(result:CollisionResult<T>):Void
	{
		this.collider        = result.collider       ;
		this.target          = result.target         ;
		this.distanceSquared = result.distanceSquared;
		this.sourceX         = result.sourceX     ;
		this.sourceY         = result.sourceY     ;
		this.sourceWidth     = result.sourceWidth ;
		this.sourceHeight    = result.sourceHeight;
		this.shouldAbort     = false;
	}
	
	public function getMiddleX():Float
	{
		return if (sourceX + sourceWidth / 2 < collider.x + collider.width / 2)
		{
			(sourceX + sourceWidth + collider.x) / 2;
		}
		else
		{
			(sourceX + collider.x + collider.width) / 2;
		}
	}
	
	public function getMiddleY():Float
	{
		return if (sourceY + sourceHeight < collider.y + collider.height / 2)
		{
			(sourceY + sourceHeight + collider.y) / 2;
		}
		else
		{
			(sourceY + collider.y + collider.height) / 2;
		}
	}
	
	public function getForeX():Float
	{
		return if (sourceX + sourceWidth / 2 < collider.x + collider.width / 2)
		{
			sourceX + sourceWidth;
		}
		else
		{
			sourceX;
		}
	}
	
	public function getForeY():Float
	{
		return if (sourceY + sourceHeight < collider.y + collider.height / 2)
		{
			sourceY + sourceHeight;
		}
		else
		{
			sourceY;
		}
	}
}
