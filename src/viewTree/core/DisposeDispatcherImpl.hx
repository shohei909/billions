package viewTree.core;

class DisposeDispatcherImpl implements DisposeDispatcher
{
	private var disposeDispatchers(default, null):Array<Void->Void>;
	private var disposed          (default, null):Bool;
	
	public function new()
	{
		disposed = false;
	}
	
	public function listenDispose(handler:Void->Void):Void
	{
		if (disposeDispatchers == null) 
		{
			disposeDispatchers = [];
		}
		disposeDispatchers.push(handler);
	}
	
	public function unlistenDispose(handler:Void->Void):Bool
	{
		if (disposeDispatchers == null) { return false; }
		return disposeDispatchers.remove(handler);
	}
	
	public function dispose():Void
	{
		if (disposeDispatchers != null) 
		{
			for (func in disposeDispatchers)
			{
				func();
			}
			disposeDispatchers = null;
		}
		disposed = true;
	}
}