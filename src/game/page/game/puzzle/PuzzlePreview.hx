package game.page.game.puzzle;
import game.asset.tile.MainTileId;
import game.page.game.key.KeySuggestSprite;
import game.page.game.puzzle.BlockColor;
import game.root.InputKind;
import h2d.SpriteBatch;
import haxe.io.Input;

class PuzzlePreview 
{
	public var inputKind:InputKind;
	public var layer:SpriteBatch;
	public var frame  :BatchElement;
	public var color  :BatchElement;
	public var suggest:KeySuggestSprite;
	
	public function new(layer:SpriteBatch) 
	{
		this.layer = layer;
		color = layer.alloc(Main.assetsManager.getMainTile(MainTileId.Blue   ).tile);
		frame = layer.alloc(Main.assetsManager.getMainTile(MainTileId.Preview).tile);
		
		color.a = 0.7;
		
		suggest =  new KeySuggestSprite(true);
		suggest.addTo(layer, layer);
		hide();
	}
	
	public function draw():Void
	{
		if (color.visible)
		{
			suggest.draw(
				color.x + 12, 
				color.y - 2,
				inputKind
			);
		}
	}
	
	public function show(x:Int, y:Int, inputKind:InputKind, c:BlockColor):Void 
	{
		this.inputKind = inputKind;
		color.x = frame.x = 12 * x;
		color.y = frame.y = 24 * y;
		color.t = c.getTile();
		
		color.visible = true;
		frame.visible = true;
	}
	
	public function hide():Void 
	{
		suggest.hide();
		color.visible = false;
		frame.visible = false;
	}
}