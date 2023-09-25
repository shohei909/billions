package collision;
import collision.Linker;

@:allow(collision)
class LinkerPool<T>
{
	private function new() {}
	
	private var nextLinker:Null<Linker<T>>;
	private function pop():Linker<T>
	{
		return if (nextLinker == null)
		{
			new Linker();
		}
		else
		{
			var linker = nextLinker;
			nextLinker = linker.nextLinker;
			linker.nextLinker = null;
			linker;
		}
	}
	
	private function push(linker:Linker<T>):Void
	{
		linker.nextLinker = nextLinker;
		nextLinker = linker;
	}
}
