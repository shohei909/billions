package game.page.game.puzzle;
import game.asset.tile.MainTileId;
import game.constants.GameConstants;
import game.page.game.GamePage;
import game.page.game.puzzle.BlockColor;
import game.page.game.puzzle.PuzzlePosition;
import game.page.game.puzzle.PuzzleFieldDeleteState;
import game.page.game.puzzle.PuzzleSuggest;
import game.root.InputKind;
import h2d.Tile;
import tool.XorShift;
import viewTree.core.ViewReference;
import viewTree.core.ViewableLogic;

class PuzzleField implements ViewableLogic
{
	public var frame(default, null):Int = 0;
	public var stateFrame   :Int = 0;
	public var viewReference:ViewReference;
	public var parent:GamePage;
	public var view:PuzzleFieldView;
	
	public var emitter:XorShift;
	
	public var blocks   :Array<Array<PuzzleBlock>>;
	public var blockPool:Array<PuzzleBlock>;
	public var state    :PuzzleFieldState;
	
	public var inputState :PuzzleFieldInputState;
	public var deleteState:PuzzleFieldDeleteState;
	public var previews:Array<Array<PuzzleSuggest>>;
	public var currentChain:Int;
	
	public function new(parent:GamePage) 
	{
		this.parent = parent;
		viewReference = new ViewReference(
			parent.viewReference,
			view = new PuzzleFieldView(
				this,
				parent.view
			)
		);
		
		blocks    = [for (x in 0...GameConstants.WIDTH) [for (y in 0...GameConstants.HEIGHT) null]];
		blockPool = [];
		
		previews = [for (_ in 0...2) [new PuzzleSuggest(), new PuzzleSuggest()]];
		
		emitter = new XorShift(Math.floor(Math.random() * 0x7FFFFFFF));
		inputState = new PuzzleFieldInputState(this);
		deleteState = new PuzzleFieldDeleteState(this);
		
		inputState.start();
	}
	
	public function walkChildren(callback:ViewableLogic->Void):Void 
	{
	}
	
	public function update():Void
	{
		frame += 1;
		stateFrame += 1;
		
		switch (state)
		{
			case PuzzleFieldState.Input :
			case PuzzleFieldState.Delete: if (stateFrame >  5) { deleteState.finish(); }
			case PuzzleFieldState.Drop  : if (stateFrame > 15) { deleteState.tryStart(); }
		}
	}
	
	
	public function keyDown(kind:InputKind):Void
	{
		switch (kind)
		{
			case InputKind.L | InputKind.Left : emit(0);
			case InputKind.R | InputKind.Right: emit(1);
			case _:
		}
	}
	
	public function emit(index:Int):Void 
	{
		if (state != PuzzleFieldState.Input) { return; }
		
		var state = inputState.nexts[index];
		add(state.x, state.y, state.x, 0, state.color);
		
		drop();
	}
	
	public function drop():Void 
	{
		for (ry in 0...GameConstants.HEIGHT - 1)
		{
			for (x in 0...GameConstants.WIDTH)
			{
				var y = GameConstants.HEIGHT - 2 - ry;
				var block = blocks[x][y];
				if (block != null) 
				{
					y += 1;
					while (y < GameConstants.HEIGHT)
					{
						if (
							(x <= 0 || blocks[x - 1][y] == null) &&
							blocks[x][y] == null &&
							(x >= GameConstants.WIDTH - 1 || blocks[x + 1][y] == null)
						)
						{
							y += 1;
						}
						else
						{
							break;
						}
					} 
					if (block.y != y - 1)
					{
						blocks[block.x][block.y] = null;
						block.y = y - 1;
						block.movedFrame = frame;
						blocks[block.x][block.y] = block;
					}
				}
			}
		}
		
		state = PuzzleFieldState.Drop;
		stateFrame = 0;
		view.dirtyCells = true;
	}
	
	public function add(x:Int, y:Int, prevX:Float, prevY:Float, color:BlockColor):Void
	{
		var block = blockPool.pop();
		if (block == null)
		{
			block = new PuzzleBlock(x, y, prevX, prevY, frame, color);
		}
		else
		{
			block.refresh(x, y, prevX, prevY, frame, color);
		}
		blocks[block.x][block.y] = block;
	}
}
