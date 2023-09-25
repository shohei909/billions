package game.asset.tile;
import h2d.Tile;

class TileSource 
{
	public var width (default, null):Float;
	public var height(default, null):Float;
	public var tile  (default, null):Tile;
	
	public function new(width:Float, height:Float, tile:Tile) 
	{
		this.height = height;
		this.width = width;
		this.tile = tile;
	}
	
	public function sub(
		x     :Float,
		y     :Float,
		width :Float,
		height:Float,
	):TileSource
	{
		var dx = 0.0;
		var dy = 0.0;
		var x = tile.x + x - tile.dx;
		var y = tile.y + y - tile.dy;
		var w = width ;
		var h = height;
		if (x < tile.x)
		{
			dx = tile.x - x;
			x  = tile.x;
			w  -= dx;
		}
		if (y < tile.y)
		{
			dy = tile.y - y;
			y  = tile.y;
			h  -= dy;
		}
		if (tile.x + tile.width < x + w)
		{
			w -= (x + w) - (tile.x + tile.width);
		}
		if (tile.y + tile.height < y + h)
		{
			h -= (y + h) - (tile.y + tile.height);
		}
		if (w < 0) w = 0;
		if (h < 0) h = 0;

		return new TileSource(
			width,
			height,
			tile.sub( 
				x - tile.x, 
				y - tile.y, 
				w, 
				h, 
				dx, 
				dy
			)
		);
	}
}
