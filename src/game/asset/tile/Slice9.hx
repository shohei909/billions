package game.asset.tile;
import game.asset.tile.TileSource;
import h2d.SpriteBatch;
import h2d.SpriteBatch.BatchElement;

class Slice9 
{
	public var tiles:Array<TileSource>;
	public var element00:BatchElement;
	public var element01:BatchElement;
	public var element02:BatchElement;
	public var element10:BatchElement;
	public var element11:BatchElement;
	public var element12:BatchElement;
	public var element20:BatchElement;
	public var element21:BatchElement;
	public var element22:BatchElement;
	
	
	public function new(tiles:Array<TileSource>, x:Float, y:Float, width:Float, height:Float, scaleX:Float, scaleY:Float) 
	{
		this.tiles = tiles;
		element00 = new BatchElement(tiles[0].tile);
		element01 = new BatchElement(tiles[1].tile);
		element02 = new BatchElement(tiles[2].tile);
		element10 = new BatchElement(tiles[3].tile);
		element11 = new BatchElement(tiles[4].tile);
		element12 = new BatchElement(tiles[5].tile);
		element20 = new BatchElement(tiles[6].tile);
		element21 = new BatchElement(tiles[7].tile);
		element22 = new BatchElement(tiles[8].tile);
		
		move(x, y, width, height, scaleX, scaleY);
	}
	
	public function move(x:Float, y:Float, width:Float, height:Float, scaleX:Float, scaleY:Float):Void
	{
		var w0 = tiles[0].width ;
		var h0 = tiles[0].height;
		var w2 = tiles[8].width ;
		var h2 = tiles[8].height;
		var w1 = width  - w0 - w2;
		var h1 = height - h0 - h2;
		
		w0 *= scaleX;
		h0 *= scaleY;
		w2 *= scaleX;
		h2 *= scaleY;
		w1 *= scaleX;
		h1 *= scaleY;
		
		var x0 = x;
		var y0 = y;
		var x1 = x0 + w0;
		var y1 = y0 + h0;
		var x2 = x1 + w1;
		var y2 = y1 + h1;
		
		inline function set(element:BatchElement, x:Float, y:Float, width:Float, height:Float):Void
		{
			element.x = x;
			element.y = y;
			element.scaleX = width  / element.t.width ;
			element.scaleY = height / element.t.height;
		}
		
		set(element00, x0,y0,w0,h0); set(element01, x1,y0,w1,h0); set(element02, x2,y0,w2,h0);
		set(element10, x0,y1,w0,h1); set(element11, x1,y1,w1,h1); set(element12, x2,y1,w2,h1);
		set(element20, x0,y2,w0,h2); set(element21, x1,y2,w1,h2); set(element22, x2,y2,w2,h2);
	}
	
	public function addTo(layer:SpriteBatch):Void 
	{
		layer.add(element00);
		layer.add(element01);
		layer.add(element02);
		layer.add(element10);
		layer.add(element11);
		layer.add(element12);
		layer.add(element20);
		layer.add(element21);
		layer.add(element22);
	}
	
	public function remove():Void
	{
		element00.remove();
		element01.remove();
		element02.remove();
		element10.remove();
		element11.remove();
		element12.remove();
		element20.remove();
		element21.remove();
		element22.remove();
	}
	
	public function show():Void 
	{
		element00.visible = true;
		element01.visible = true;
		element02.visible = true;
		element10.visible = true;
		element11.visible = true;
		element12.visible = true;
		element20.visible = true;
		element21.visible = true;
		element22.visible = true;
	}
	public function hide():Void 
	{
		element00.visible = false;
		element01.visible = false;
		element02.visible = false;
		element10.visible = false;
		element11.visible = false;
		element12.visible = false;
		element20.visible = false;
		element21.visible = false;
		element22.visible = false;
	}
}