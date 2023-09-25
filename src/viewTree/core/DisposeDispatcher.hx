package viewTree.core;

interface DisposeDispatcher 
{
	public function listenDispose(handler:Void->Void):Void;
	public function unlistenDispose(handler:Void->Void):Bool;
	public function dispose():Void;
}
