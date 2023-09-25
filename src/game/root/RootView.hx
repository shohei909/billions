package game.root;

import game.constants.ViewConstants;
import h2d.Bitmap;
import h2d.Graphics;
import h2d.Sprite;
import h2d.Text;
import h2d.Tile;
import h3d.mat.Data.TextureFlags;
import h3d.mat.Texture;
import hxd.Timer;
import viewTree.core.DrawContext;
import viewTree.core.View;

class RootView implements View {
	#if fps
	public var text:Text;
	#end
	public var rootLayer  (default, null):Sprite;
	public var layer      (default, null):Sprite;
	public var casing     (default, null):Graphics;
	public var renderTaget(default, null):Texture;
	public var rootBitmap (default, null):Bitmap;
	
	public function new()
	{
		renderTaget = new Texture(ViewConstants.WIDTH, ViewConstants.HEIGHT, [TextureFlags.Target]);
		
		rootBitmap = new Bitmap(Tile.fromTexture(renderTaget));
		rootLayer = new Sprite();
		layer = new Sprite();
		rootLayer.addChild(layer);
		
		#if fps
		text = new Text(hxd.res.DefaultFont.get());
		rootLayer.addChild(text);
		text.y = 40;
		text.scale(1);
		#end
	}

	public function initialize():Void 
	{
		Main.app.s2d.addChild(rootLayer );
		Main.app.s2d.addChild(rootBitmap);
	}

	public function dispose():Void {
		Main.app.s2d.removeChild(rootLayer);
		Main.app.s2d.removeChild(rootBitmap);
	}

	public function draw(context:DrawContext):Void 
	{
		#if fps
		text.text = "FPS:" + Math.round(Timer.fps()) + "/" + Timer.wantedFPS + "\nDRAW:" + Main.app.engine.drawCalls;
		#end
	}

	public function resize():Void
	{
	}
}
