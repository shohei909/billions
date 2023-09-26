package game.page.game.puzzle;
import game.asset.tile.MainTileId;
import game.asset.tile.Slice9;
import game.constants.GameConstants;
import game.page.game.GamePageView;
import game.page.game.puzzle.PuzzleBlock;
import game.page.game.puzzle.PuzzlePosition;
import game.page.game.puzzle.PuzzleField;
import game.root.InputKind;
import h2d.SpriteBatch;
import h2d.SpriteBatch.BatchElement;
import h2d.Tile;
import tweenxcore.Tools.Easing;
import viewTree.core.DrawContext;
import viewTree.core.View;

class PuzzleFieldView implements View
{
	public var dirtyCells:Bool;
	private var parent:GamePageView;
	private var logic:PuzzleField;
	
	private var layer   :SpriteBatch;
	private var cells   :Array<PuzzleBlockView>;
	private var pools   :Array<PuzzleBlockView>;
	private var previews:Array<PuzzlePreview>;
	
	public function new(
		logic:PuzzleField, 
		parent:GamePageView) 
	{
		this.logic = logic;
		this.parent = parent;
		this.cells = [];
		this.pools = [];
		this.dirtyCells = false;
	}
	
	public function initialize():Void 
	{
		parent.fieldLayer.addChild(layer = new SpriteBatch(Main.assetsManager.rootTile));
		
		previews = [for (i in 0...2) new PuzzlePreview(layer)];
		
		var background = new Slice9(
			Main.assetsManager.frame,
			-1,
			-1,
			12 * (GameConstants.WIDTH + 1) + 2,
			24 * GameConstants.HEIGHT + 2,
			1,
			1
		);
		background.addTo(layer);
		layer.hasRotationScale = true;
	}
	
	public function dispose():Void 
	{
		layer.remove();
	}
	
	public function draw(context:DrawContext):Void 
	{
		if (dirtyCells)
		{
			var cell:PuzzleBlockView;
			while((cell = cells.pop()) != null)
			{
				pools.push(cell);
				cell.element.remove();
			}
			
			for (x in 0...GameConstants.WIDTH)
			{
				for (y in 0...GameConstants.HEIGHT)
				{
					var cell = logic.blocks[x][y];
					if (cell == null)
					{
						continue;
					}
					add(cell);
				}
			}
			
			for (i in 0...previews.length)
			{
				var preview = previews[i];
				if (logic.state == PuzzleFieldState.Input && i< logic.inputState.nexts.length)
				{
					var next = logic.inputState.nexts[i];
					preview.show(next.x, next.y, if (i == 0) InputKind.L else InputKind.R, next.color);
				}
				else
				{
					preview.hide();
				}
			}
			this.dirtyCells = false;
		}
		
		for (cell in cells)
		{
			cell.draw(logic.frame);
		}
		for (preview in previews)
		{
			preview.draw();
		}
	}
	
	private function add(logic:PuzzleBlock):Void
	{
		var cell = pools.pop();
		if (cell == null)
		{
			cell = new PuzzleBlockView();
		}
		cell.refresh(logic);
		
		layer.add(cell.element);
		cells.push(cell);
		
	}
}

private class PuzzleBlockView
{
	public var element:BatchElement;
	private var logic:PuzzleBlock;
	
	public function new ()
	{
		this.element = new BatchElement(Main.assetsManager.getMainTile(MainTileId.Preview).tile);
	}
	
	public function refresh(logic:PuzzleBlock):Void
	{
		this.logic = logic;
		
		
		element.t = logic.getTile();
		element.x = 12 * logic.prevX;
		element.y = 24 * logic.prevY;
	}
	
	public function draw(frame:Int):Void 
	{
		var rate = (frame - logic.movedFrame).inverseLerp(0, 15).clamp().mixEasing(
			Easing.quintIn,
			Easing.linear,
			0.8
		);
		
		
		element.x = 12 * rate.lerp(logic.prevX, logic.x);
		element.y = 24 * rate.lerp(logic.prevY, logic.y);
	}
}