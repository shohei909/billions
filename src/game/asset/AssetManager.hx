package game.asset;

import game.animation.IAnimation;
import game.asset.tile.MainTileId;
import game.asset.tile.TileSheet;
import game.asset.tile.TileSource;
import game.gen.CoreTileId;
import h2d.Font;
import h2d.Tile;
import hxd.Res;
import hxd.res.BitmapFont;
import typepacker.json.Json;

class AssetManager {
	public var rootTile       :Tile;
	public var mainTileStart  :Int;
	public var tiles          :Array<TileSource>;
	public var font           :Font;
	public var mainTiles      :TileSheet;
	
	public function new() {
		
		#if js
		hxd.Res.initEmbed({compressSounds:true});
		#else
		hxd.res.Resource.LIVE_UPDATE = true;
		hxd.Res.initLocal();
		#end
	
		var fontText = Res.load("font/milimoji.fnt");
		var fontBmp  = Res.load("font/milimoji_0.png");
		var font:BitmapFont = new BitmapFont(fontText.entry);
		@:privateAccess font.loader = fontBmp.loader;
		this.font = font.toFont();
		
		rootTile = Res.load("tiles/main.png").toTile();
		var text = Res.load("tiles/main.json").toText();
		var json = Json.parse("Array<game.asset.TileInfo>", text);
		tiles = [];
		for (data in json) {
			tiles.push(
				new TileSource(
					data.sw,
					data.sh,
					rootTile.sub(data.x, data.y, data.w, data.h, data.sx, data.sy)
				)
			);
		}

		mainTiles = initTiles(CoreTileId.TILES, 24, 24);
	}
	public function initTiles(id:CoreTileId, tileWidth:Int, tileHeight:Int):TileSheet
	{
		return new TileSheet(getCoreTile(id), tileWidth, tileHeight);	
	}
	public function initSlice9(id:CoreTileId, left:Int, right:Int, top:Int, bottom:Int):Array<TileSource>
	{
		var baseTile = getCoreTile(id);
		var x0 = 0;
		var y0 = 0;
		var x1 = left;
		var y1 = top ;
		var x2 = baseTile.width  - right ;
		var y2 = baseTile.height - bottom;
		var w0 = x1;
		var h0 = y1;
		var w1 = x2 - x1;
		var h1 = y2 - y1;
		var w2 = right;
		var h2 = bottom;
		
		return [
			baseTile.sub(x0,y0,w0,h0), baseTile.sub(x1,y0,w1,h0), baseTile.sub(x2,y0,w2,h0), 
			baseTile.sub(x0,y1,w0,h1), baseTile.sub(x1,y1,w1,h1), baseTile.sub(x2,y1,w2,h1), 
			baseTile.sub(x0,y2,w0,h2), baseTile.sub(x1,y2,w1,h2), baseTile.sub(x2,y2,w2,h2), 
		];
	}
	public function getCoreTileId(id:CoreTileId):Int {
		return cast id;
	}

	public function getCoreTile(id:CoreTileId):TileSource {
		return tiles[getCoreTileId(id)];
	}

	public function getMainTileId(id:MainTileId):Int {
		return cast id;
	}

	public function getMainTile(id:MainTileId):TileSource {
		return mainTiles.source[getMainTileId(id)];
	}
	
}
