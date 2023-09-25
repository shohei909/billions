package game.page.game;
import game.page.game.GamePageView;
import viewTree.core.ViewableLogic;
import viewTree.core.ViewReference;
import game.root.InputKind;
import game.save.InitialLoadedData;
import game.root.RootLogic;
import viewTree.core.Page;

class GamePage implements Page
{
	public var frame(default, null):Int = 0;
	public var viewReference(default, null):ViewReference;
	
	private var root:RootLogic;
	private var data:InitialLoadedData;
	private var view:GamePageView;

	public function new(root:RootLogic, data:InitialLoadedData) 
	{
		viewReference = new ViewReference(
			root.viewReference, 
			view = new GamePageView(
				this,
				root.view
			)
		);
		
		this.data = data;
		this.root = root;
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