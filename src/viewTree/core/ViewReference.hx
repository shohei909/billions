package viewTree.core;

class ViewReference extends DisposeDispatcherImpl
{
	static var idCounter:Int = 0;
	
	public var id             (default, null):Int;
	public var view           (default, null):View;
	public var dirtyCount     (default, null):Int;
	public var pausing        (default, null):Bool = false;
	private var parent:Null<ViewReference>;
	
	public function new(parent:Null<ViewReference>, view:View):Void
	{
		super();
		this.parent = parent;
		this.id = idCounter++;
		this.view = view;
		this.dirtyCount = 1;
	}
	
	public function dirty():Void
	{
		dirtyCount += 1;
	}
	
	public override function dispose():Void 
	{
		view.dispose();
		super.dispose();
	}
}
