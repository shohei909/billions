package viewTree.core;

import game.root.InputKind;

interface Page extends ViewableLogic 
{
	public function update():Void;
	public function pauseUpdate():Void;
	public function keyDown(kind:InputKind):Void;
	public function keyUp(kind:InputKind):Void;
}
