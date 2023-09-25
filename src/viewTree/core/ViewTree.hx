package viewTree.core;
import haxe.ds.Map;

class ViewTree 
{
	var logic:ViewableLogic;
	var children:Map<Int, ViewTree>;
	var indexes:Array<Int>;
	var updateCount:Int;
	var drawContext:DrawContext;
	var dirtyCount:Int;
	var nextDelta :Float;
	var initialized = false;
	var prevFrame :Int;
	public var parentCount:Int;
	
	public function new(logic:ViewableLogic, drawContext:DrawContext) 
	{
		this.drawContext = drawContext;
		this.logic = logic;
		this.parentCount = 0;
		this.updateCount = 0;
		this.dirtyCount = 0;
		this.children = new Map();
		this.indexes = [];
		
		logic.viewReference.view.initialize();
		prevFrame = logic.frame;
	}
	
	public function update():Void
	{
		updateCount += 1;
		
		if (Math.isNaN(prevFrame))
		{
			prevFrame = 0;
		}
		var delta = logic.frame - prevFrame;
		if (delta < 0 || Math.isNaN(delta))
		{
			delta = 0;
		}
		drawContext.reset(
			logic.viewReference.dirtyCount != dirtyCount,
			delta
		);
		prevFrame = logic.frame;
		dirtyCount = logic.viewReference.dirtyCount;
		logic.viewReference.view.draw(drawContext);
		
		if (!drawContext.blocked)
		{
			logic.walkChildren(draw);
			
			// remove
			var length = indexes.length;
			var removed = 0;
			for (i in 0...length)
			{
				var index = indexes[i - removed];
				var child = children[index];
				if (child.parentCount != updateCount)
				{
					children.remove(index);
					child.dispose();
					indexes.splice(i - removed, 1);
					removed += 1;
				}
			}
		}
	}
	
	function draw(child:ViewableLogic):Void
	{
		var id = child.viewReference.id;
		var childTree = if (children.exists(id))
		{
			children[id];
		}
		else
		{
			indexes.push(id);
			children[id] = new ViewTree(child, drawContext);
		}
		
		childTree.parentCount = updateCount;
		
		if (!logic.viewReference.pausing)
		{
			childTree.update();
		}
	}
	
	public function dispose():Void
	{
		var length = indexes.length;
		for (i in 0...length)
		{
			var index = indexes[i];
			var child = children[index];
			children.remove(index);
			child.dispose();
		}
		indexes.resize(0);
		logic.viewReference.dispose();
	}
}
