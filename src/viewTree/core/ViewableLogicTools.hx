package viewTree.core;

class ViewableLogicTools 
{
	public static function dirtyChildren(logic:ViewableLogic):Void
	{
		logic.viewReference.dirty();
		logic.walkChildren(dirtyChildren);
	}
}