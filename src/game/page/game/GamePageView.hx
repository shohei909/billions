package game.page.game;
import game.asset.tile.MainTileId;
import game.page.game.key.KeySuggestSprite;
import game.constants.GameConstants;
import game.constants.ViewConstants;
import game.page.game.GamePage;
import game.page.game.puzzle.PuzzleField;
import game.root.InputKind;
import game.root.RootView;
import h2d.Sprite;
import h2d.SpriteBatch;
import viewTree.core.DrawContext;
import viewTree.core.View;

class GamePageView implements View
{
	public var parent:RootView;
	public var logic:GamePage;
	public var fieldLayer(default, null):Sprite;
	public var uiLayer    (default, null):SpriteBatch;
	public var keySuggestBlue  :KeySuggestSprite;
	public var keySuggestYellow:KeySuggestSprite;
	
	public function new(logic:GamePage, parent:RootView) 
	{
		this.logic = logic;
		this.parent = parent;
	}
	
	public function initialize():Void 
	{
		parent.layer.addChild(fieldLayer = new Sprite());
		parent.layer.addChild(uiLayer    = new SpriteBatch(Main.assetsManager.rootTile));
		
		fieldLayer.x = (ViewConstants.WIDTH  - 12 * GameConstants.WIDTH ) / 2;
		fieldLayer.y = (ViewConstants.HEIGHT - 24 * GameConstants.HEIGHT) / 2 + 20;
		
		keySuggestBlue = new KeySuggestSprite(true);
		keySuggestBlue.addTo(uiLayer, uiLayer);
		
		keySuggestYellow = new KeySuggestSprite(true);
		keySuggestYellow.addTo(uiLayer, uiLayer);
		
		var yellow = uiLayer.alloc(Main.assetsManager.getMainTile(MainTileId.Yellow).tile);
		var blue   = uiLayer.alloc(Main.assetsManager.getMainTile(MainTileId.Blue  ).tile);
		
		yellow.x = 280;
		yellow.y = 20 - 12;
		blue  .x = 360;
		blue  .y = 20 - 12;
		
	}
	
	public function dispose():Void 
	{
		parent.layer.removeChild(fieldLayer);
		parent.layer.removeChild(uiLayer   );
	}
	
	public function draw(context:DrawContext):Void 
	{
		keySuggestYellow.draw(265, 20 + 8, InputKind.Yellow);
		keySuggestBlue  .draw(345, 20 + 8, InputKind.Blue  );
	}
}
