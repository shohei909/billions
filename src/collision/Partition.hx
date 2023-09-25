package collision;
import collision.CollisionResult;
import collision.LinkerPool;

@:allow(collision)
class Partition<T>
{
	private var hitTestIndex:Int;
	
	private var linkerPool:LinkerPool<T>;
	private var colliderPool:ColliderPool<T>;
	
	private var linkers:Map<LinkerPosition, Null<Linker<T>>>;
	private var nextCollider:Null<Collider<T>>;
	private var result:CollisionResult<T>;
	private var nearResult:CollisionResult<T>;
	private var gridSize:Int = 3;
	
	public function new() 
	{
		hitTestIndex = 0;
		
		linkers      = new Map();
		linkerPool   = new LinkerPool();
		colliderPool = new ColliderPool(this);
		result       = new CollisionResult();
		nearResult   = new CollisionResult();
	}
	
	public function clear():Void
	{
		var collider = nextCollider;
		while (collider != null)
		{
			var next = collider.nextCollider;
			colliderPool.push(collider);
			collider = next;
		}
		nextCollider = null;
		for (i => linker in linkers)
		{
			while (linker != null)
			{
				var nextLinker = linker.nextLinker;
				linkerPool.push(linker);
				linker = nextLinker;
			}
			linkers.remove(i);
		}
	}
	
	public function add(x:Float, y:Float, width:Float, height:Float, target:T):Void
	{
		var collider = colliderPool.pop();
		collider.initialize(x, y, width, height, target);
	}
	
	public inline function hitTest(
		x:Float, 
		y:Float, 
		width:Float, 
		height:Float, 
		func:CollisionResult<T>->Void
	):Void
	{
		var ax = x + width  / 2;
		var ay = y + height / 2;
		
		hitTestIndex += 1;
		result.shouldAbort = false;
		for (ix in Math.floor(x / gridSize)...Math.floor((x + width) / gridSize + 1))
		{
			for (iy in Math.floor(y / gridSize)...Math.floor((y + height) / gridSize + 1))
			{
				var position = new LinkerPosition(ix, iy);
				var linker = linkers[position];
				while (linker != null)
				{
					var collider = linker.collider;
					if (collider.lastTest != hitTestIndex)
					{
						collider.lastTest = hitTestIndex;
						var bx = collider.getCenterX();
						var by = collider.getCenterY();
						var dx = ax - bx;
						var dy = ay - by;
						
						if (
							Math.abs(dx) * 2 < width  + collider.width &&
							Math.abs(dy) * 2 < height + collider.height
						)
						{
							result.collider        = collider;
							result.target          = collider.target;
							result.distanceSquared = dx * dx + dy * dy;
							result.sourceX      = x;
							result.sourceY      = y;
							result.sourceWidth  = width;
							result.sourceHeight = height;
							func(result);
							if (result.shouldAbort) { break; }
						}
					}
					linker = linker.nextLinker;
				}
				if (result.shouldAbort) { break; }
			}
			if (result.shouldAbort) { break; }
		}
	}
	
	public inline function hitTestNearest(
		x:Float, 
		y:Float, 
		width:Float, 
		height:Float, 
		hitCheck:T->Bool,
		defaultNearest:Null<CollisionResult<T>> = null
	):Null<CollisionResult<T>>
	{
		var currentResult = defaultNearest;
		hitTest(
			x, 
			y, 
			width, 
			height, 
			result -> if (
				currentResult == null || 
				result.distanceSquared < currentResult.distanceSquared || 
				hitCheck(result.target)
			)
			{
				nearResult.copyFrom(result);
				currentResult = cast nearResult;
			}
		);
		return currentResult;
	}
	
	public static function compare<A, B>(
		resultA:CollisionResult<A>, 
		resultB:CollisionResult<B>,
		onA:CollisionResult<A>->Void,
		onB:CollisionResult<B>->Void,
		onNull:Void->Void = null
	):Void
	{
		if (resultA == null && resultB == null) 
		{
			if (onNull != null) { onNull(); }
			return;
		}
		if (resultA == null) { onB(resultB); return; }
		if (resultB == null) { onA(resultA); return; }
		
		if (resultA.distanceSquared <= resultB.distanceSquared)
		{
			onA(resultA);
		}
		else
		{
			onB(resultB);
		}
	}
}
