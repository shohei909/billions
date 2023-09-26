package game.page.game.puzzle;
import game.constants.GameConstants;
import game.page.game.puzzle.PuzzleCell;
import game.page.game.puzzle.PuzzleField;
import tool.XorShift;

class PuzzleFieldInputState 
{
	public var parent:PuzzleField;
	public var nextX:Array<Int>;
	public var next :Array<PuzzleCell>;
	public var previewEmitter:XorShift;
	
	public function new(parent:PuzzleField) 
	{
		this.parent = parent;
		previewEmitter = new XorShift();
		next = [];
		nextX = [];
	}
	
	public function start():Void 
	{
		applyPreview(nextX, parent.emitter.gen());
		
		parent.emitter.copyTo(previewEmitter);
		for (preview in parent.previews)
		{
			applyPreview(preview, previewEmitter.gen());
		}
		next.resize(0);
		for (x in nextX)
		{
			var y = 0;
			while (y < GameConstants.HEIGHT - 1)
			{
				if (
					(x <= 0 || parent.blocks[x - 1][y + 1] == null) &&
					parent.blocks[x    ][y + 1] == null &&
					(x >= GameConstants.WIDTH - 1 || parent.blocks[x + 1][y + 1] == null)
				)
				{
					y += 1;
				}
				else
				{
					break;
				}
			}
			next.push(new PuzzleCell(x, y));
		}
		
		parent.currentChain = 0;
		parent.stateFrame = 0;
		parent.state = PuzzleFieldState.Input;
		parent.view.dirtyCells = true;
	}
	
	public function isPreview(position:PuzzleCell):Bool 
	{
		return next.indexOf(position) >= 0;
	}
	
	private function applyPreview(preview:Array<Int>, gen:Int):Void 
	{
		preview.resize(0);
		
		var pos = 0;
		var len = Math.floor(GameConstants.WIDTH / 2);
		var rest = len;
		pos = gen % rest;
		preview.push((pos % len) * 2);
		gen = Math.floor(gen / rest);
		rest -= 1;
		pos += (gen % rest) + 1;
		preview.push((pos % len) * 2);
	}
}
