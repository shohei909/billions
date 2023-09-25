package collision;
import collision.Partition;

@:allow(collision)
class ColliderPool<T>
{
	private var partition:Partition<T>;
	private function new(partition:Partition<T>)
	{
		this.partition = partition;
	}
	
	private var nextCollider:Null<Collider<T>>;
	private function pop():Collider<T>
	{
		return if (nextCollider == null)
		{
			new Collider(partition);
		}
		else
		{
			var collider = nextCollider;
			nextCollider = collider.nextCollider;
			collider.nextCollider = null;
			collider;
		}
	}

	private function push(collider:Collider<T>):Void
	{
		collider.nextCollider = nextCollider;
		nextCollider = collider;
	}
}
