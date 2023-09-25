package game.page.game;
import game.page.game.GamePage;
import game.root.RootView;
import viewTree.core.DrawContext;
import viewTree.core.View;

class GamePageView implements View
{
	var parent:RootView;
	var logic:GamePage;

	public function new(logic:GamePage, parent:RootView) 
	{
		this.logic = logic;
		this.parent = parent;
		
	}
	
	public function initialize():Void 
	{
		
	}
	
	public function dispose():Void 
	{
		
	}
	
	public function draw(context:DrawContext):Void 
	{
		
	}
	
}