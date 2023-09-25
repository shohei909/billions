package collision;
import collision.LinkerPosition;
import collision.Partition;
import tool.GeometryTools;

@:allow(collision)
class Collider<T>
{
	private var partition   :Partition<T>;
	
	private var nextCollider:Null<Collider<T>>;
	private var lastTest    :Int;
	public var x     :Float;
	public var y     :Float;
	public var width :Float;
	public var height:Float;
	public var target:T;
	
	public function new(partition:Partition<T>) 
	{
		this.partition = partition;
	}
	
	public function getCenterX():Float
	{
		return x + width / 2;
	}
	
	
	public function getCenterY():Float 
	{
		return y + height / 2;
	}
	private function initialize(
		x:Float, 
		y:Float, 
		width:Float, 
		height:Float,
		target:T
	)
	{
		this.x = x;
		this.y = y;
		this.width  = width;
		this.height = height;
		this.target = target;
		
		for (ix in Math.floor(x / partition.gridSize)...Math.floor((x + width) / partition.gridSize + 1))
		{
			for (iy in Math.floor(y / partition.gridSize)...Math.floor((y + height) / partition.gridSize + 1))
			{
				var position = new LinkerPosition(ix, iy);
				var linker = partition.linkerPool.pop();
				linker.initialize(this);
				
				linker.nextLinker = partition.linkers[position];
				partition.linkers[position] = linker;
			}
		}
	}
	
	public function isNear(ax:Float, ay:Float, ar:Float):Bool
	{
		var r = getRadius() + ar;
		return GeometryTools.isNear(r, ax, ay, getCenterX(), getCenterY());
	}
	
	public function getRadius():Float
	{
		return (width + height) / 2;
	}
}
