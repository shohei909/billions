package viewTree.core;

interface View
{
	public function initialize():Void;
	public function dispose():Void;
	public function draw(context:DrawContext):Void;
}
