package game.root;

import game.page.game.GamePage;
import game.root.InputKind;
import game.save.InitialLoadedData;
import viewTree.core.Page;
import viewTree.core.ViewReference;
import viewTree.core.ViewableLogic;

class RootLogic implements ViewableLogic 
{
	
	public var frame(default, null):Int = 0;
	public var page  (default, null):Page;
	public var viewReference(default, null):ViewReference;
	public var view(default, null):RootView;
	
	public function new() {
		viewReference = new ViewReference(null, view = new RootView());
		page = new EmptyPage(this);
		Main.saveManager.loadInitial(1, onInitialize);
	}
	
	public function onInitialize(data:InitialLoadedData):Void
	{
		page = new GamePage(this, data);
	}
	
	public function walkChildren(callback:ViewableLogic->Void):Void {
		callback(page);
	}
	public function update() {
		frame += 1;
		page.update();
	}
	public function pauseUpdate() {
		page.pauseUpdate();
	}
	public function resize() {
		view.resize();
	}
	
	public function keyDown(kind:InputKind):Void 
	{
		page.keyDown(kind);
	}
	
	public function keyUp(kind:InputKind):Void 
	{
		page.keyUp(kind);
	}
}
