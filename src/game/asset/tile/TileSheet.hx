package game.asset.tile;
import game.asset.tile.TileSource;
import game.gen.CoreTileId;
import h2d.Tile;

class TileSheet 
{
	public var width :Int;
	public var height:Int;
	public var tiles :Array<Tile>;
	public var source:Array<TileSource>;
	
	public function new(baseTile:TileSource, tileWidth:Int, tileHeight:Int) 
	{
		width = tileWidth;
		height = tileHeight;
		source = [];
		tiles = [];
		
		for (i in 0...Math.floor(baseTile.height / tileHeight))
		{
			for (j in 0...Math.floor(baseTile.width / tileWidth))
			{
				var sub = baseTile.sub(
					tileWidth * j,
					tileHeight * i,
					tileWidth,
					tileHeight
				);
				source.push(sub);
				tiles.push(sub.tile);
			}
		}
	}
}