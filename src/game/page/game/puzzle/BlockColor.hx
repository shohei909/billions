package game.page.game.puzzle;
import game.asset.tile.MainTileId;
import h2d.Tile;

enum abstract BlockColor(Bool) from Bool
{
	var Yellow = false;
	var Blue   = true;
	
	@:op(!a) public function invert():BlockColor;
	
	public function getTile():Tile
	{
		return switch abstract 
		{
			case BlockColor.Blue  : Main.assetsManager.getMainTile(MainTileId.Blue   ).tile;
			case BlockColor.Yellow: Main.assetsManager.getMainTile(MainTileId.Yellow ).tile;
		}
	}
}