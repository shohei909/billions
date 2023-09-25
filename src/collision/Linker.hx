package collision;

@:allow(collision)
class Linker<T>
{
	public var nextLinker:Null<Linker<T>>;
	public var collider  :Collider<T>;
	
	public function new() {}
	public function initialize(collider:Collider<T>):Void
	{
		this.collider = collider;
	}
}
