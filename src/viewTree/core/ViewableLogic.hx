package viewTree.core;
import viewTree.core.ViewReference;

interface ViewableLogic 
{
	public var frame        (default, null):Int;
	public var viewReference(default, null):ViewReference;
	public function walkChildren(callback:ViewableLogic->Void):Void;
}
