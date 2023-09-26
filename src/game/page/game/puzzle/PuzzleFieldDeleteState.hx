package game.page.game.puzzle;
import game.constants.GameConstants;
import game.constants.ViewConstants;
import game.page.game.puzzle.DeleteLine;
import game.page.game.puzzle.PuzzleField;
import game.page.game.puzzle.PuzzleFieldInputState;

class PuzzleFieldDeleteState 
{
	private var parent :PuzzleField;
	public var lines   :Array<DeleteLine>;
	public var linePool:Array<DeleteLine>;
	
	public function new(parent:PuzzleField) 
	{
		this.parent = parent;
		lines    = [];
		linePool = [];
	}

	public function tryStart():Void 
	{
		for (y in 0...GameConstants.HEIGHT)
		{
			for (x in 0...GameConstants.WIDTH)
			{
				var block = parent.blocks[x][y];
				if (block != null)
				{
					block.prevX = x;
					block.prevY = y;
				}
			}
		}
			
		var line;
		while ((line = lines.pop()) != null)
		{
			var block;
			while ((block = line.blocks.pop()) != null)
			{
				parent.blockPool.push(block);
			}
			linePool.push(line);
		}
		
		var chainCount = -1;
		for (x in 0...GameConstants.WIDTH)
		{
			for (y in 0...(GameConstants.HEIGHT - 1))
			{
				var block = parent.blocks[x][y];
				if (block != null)
				{
					var block2 = parent.blocks[x][y + 1];
					if (
						block2 != null &&
						block.color == block2.color
					)
					{
						var line = createLine();
						lines.push(line);
						line.blocks.push(block );
						line.blocks.push(block2);
						parent.blocks[x][y    ] = null;
						parent.blocks[x][y + 1] = null;
						chainCount += 2;
						
						var y2 = y + 2;
						while (y2 < GameConstants.HEIGHT)
						{
							var block3 = parent.blocks[x][y2];
							if (
								block3 != null &&
								block.color == block3.color
							)
							{
								line.blocks.push(block3);
								parent.blocks[x][y2] = null;
								chainCount += 1;
							}
							else
							{
								break;
							}
							y2 += 1;
						}
						line.centerX = x;
						line.centerY = (y + y2 - 1) / 2;
						line.x = x;
						line.y = y2 - 1;
						line.color = block.color;
					}
				}
			}
		}
		for (x in 0...GameConstants.WIDTH - 2)
		{
			for (y in 0...GameConstants.HEIGHT)
			{
				var block = parent.blocks[x][y];
				if (block != null)
				{
					var block2 = parent.blocks[x + 2][y];
					if (
						block2 != null &&
						block.color == block2.color
					)
					{
						var line = createLine();
						lines.push(line);
						line.blocks.push(block );
						line.blocks.push(block2);
						parent.blocks[x    ][y] = null;
						parent.blocks[x + 2][y] = null;
						chainCount += 2;
						
						var x2 = x + 4;
						while (x2 < GameConstants.WIDTH)
						{
							var block3 = parent.blocks[x2][y];
							if (
								block3 != null &&
								block.color == block3.color
							)
							{
								line.blocks.push(block3);
								parent.blocks[x2][y] = null;
								chainCount += 1;
							}
							else
							{
								break;
							}
							x2 += 2;
						}
						
						line.centerX = (x + x2 - 2) / 2;
						line.centerY = y;
						line.x = Math.round((x + x2 - 2) / 2);
						line.y = y;
						line.color = block.color;
					}
				}
			}
		}
		
		if (chainCount < 0)
		{
			parent.inputState.start();
		}
		else
		{
			parent.view.dirtyCells = true;
			parent.currentChain += chainCount;
			parent.state = PuzzleFieldState.Delete;
			parent.stateFrame = 0;
		}
	}
	
	public function finish():Void
	{
		for (line in lines)
		{
			parent.add(
				line.x,
				line.y,
				line.centerX,
				line.centerY,
				!line.color
			);
			parent.view.dirtyCells = true;
		}
		parent.drop();
	}
	
	public function createLine():DeleteLine
	{
		var line = linePool.pop();
		if (line == null) line = new DeleteLine();
		return line;
	}
}
