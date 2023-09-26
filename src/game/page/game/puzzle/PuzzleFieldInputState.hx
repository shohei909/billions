package game.page.game.puzzle;
import game.constants.GameConstants;
import game.page.game.puzzle.PuzzlePosition;
import game.page.game.puzzle.PuzzleField;
import game.page.game.puzzle.PuzzleSuggest;
import tool.XorShift;

class PuzzleFieldInputState 
{
	public var parent:PuzzleField;
	public var nexts :Array<PuzzleSuggest>;
	public var previewEmitter:XorShift;
	
	public function new(parent:PuzzleField) 
	{
		this.parent = parent;
		previewEmitter = new XorShift();
		nexts = [
			new PuzzleSuggest(),
			new PuzzleSuggest(),
		];
	}
	
	public function start():Void 
	{
		applyPreview(nexts, parent.emitter.gen());
		
		parent.emitter.copyTo(previewEmitter);
		for (preview in parent.previews)
		{
			applyPreview(preview, previewEmitter.gen());
		}
		for (next in nexts)
		{
			var y = 0;
			while (y < GameConstants.HEIGHT - 1)
			{
				if (
					(next.x <= 0 || parent.blocks[next.x - 1][y + 1] == null) &&
					parent.blocks[next.x][y + 1] == null &&
					(next.x >= GameConstants.WIDTH - 1 || parent.blocks[next.x + 1][y + 1] == null)
				)
				{
					y += 1;
				}
				else
				{
					break;
				}
			}
			next.y = y;
		}
		
		parent.currentChain = 0;
		parent.stateFrame = 0;
		parent.state = PuzzleFieldState.Input;
		parent.view.dirtyCells = true;
	}
	
	private function applyPreview(preview:Array<PuzzleSuggest>, gen:Int):Void 
	{
		var pos = 0;
		var len = Math.ceil(GameConstants.WIDTH / 4);
		pos = gen % len;
		preview[0].x = pos * 2;
		preview[0].color = Math.random() > 0.5;
		gen = Math.floor(gen / len);
		pos = len + (gen % len);
		preview[1].x = pos * 2;
		preview[1].color = Math.random() > 0.5;
		if (preview[0].x > preview[1].x)
		{
			preview.reverse();
		}
	}
}
