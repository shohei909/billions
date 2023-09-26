package game.page.game.puzzle;
import game.asset.tile.MainTileId;
import game.page.game.puzzle.BlockKind;
import h2d.SpriteBatch.BatchElement;
import h2d.Tile;

class PuzzleBlock
{
	public var x:Int;
	public var y:Int;
	public var prevX:Float;
	public var prevY:Float;
	public var movedFrame:Int;
	public var color:BlockColor;
	
	public function new(
		x:Int,
		y:Int,
		prevX:Float,
		prevY:Float,
		movedFrame:Int,
		color:BlockColor
	)
	{
		refresh(
			x,
			y,
			prevX, 
			prevY, 
			movedFrame, 
			color
		);
	}
	
	public function refresh(
		x:Int,
		y:Int,
		prevX:Float,
		prevY:Float,
		movedFrame:Int,
		color:BlockColor
	):Void
	{
		this.x = x;
		this.y = y;
		this.color = color;
		this.movedFrame = movedFrame;
		this.prevY = prevY;
		this.prevX = prevX;
	}
	
	public function getTile():Tile
	{
		return switch (color)
		{
			case BlockColor.Blue  : Main.assetsManager.getMainTile(MainTileId.Blue  ).tile;
			case BlockColor.Yellow: Main.assetsManager.getMainTile(MainTileId.Yellow).tile;
		}
	}
}
