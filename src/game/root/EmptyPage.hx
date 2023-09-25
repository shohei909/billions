package game.root;
import viewTree.core.ViewableLogic;
import game.root.InputKind;
import game.root.RootLogic;
import viewTree.core.Page;
import viewTree.core.ViewReference;

class EmptyPage implements Page
{
	public var frame        (default, null):Int = 0;
	private var root:RootLogic;
	public var viewReference(default, null):ViewReference;
	
	public function new(parent:RootLogic) 
	{
		root = parent;
		viewReference = new ViewReference(
			parent.viewReference, 
			new EmptyView()
		);
	}
	
	
	public function update():Void 
	{
		frame += 1;
	}
	
	public function pauseUpdate():Void 
	{
		
	}
	
	public function keyDown(kind:InputKind):Void 
	{
		
	}
	
	public function keyUp(kind:InputKind):Void 
	{
		
	}
	
	public function walkChildren(callback:ViewableLogic->Void):Void 
	{
		
	}
}
