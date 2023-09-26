package game.page.game.key;
import game.asset.tile.TileSheet;
import game.asset.tile.TileSource;
import game.root.InputKind;
import h2d.SpriteBatch;
import h2d.Tile;
import hxd.Key;

class KeySuggestSprite 
{
	private var bitmap      :BatchElement;
	private var text        :BatchElement;
	private var plusText    :BatchElement;
	private var secondBitmap:BatchElement;
	private var secondText  :BatchElement;
	private var shouldCheck :Bool; // ボタンの押下状態を反映する
	
	public function new(shouldCheck:Bool) 
	{
		this.shouldCheck = shouldCheck;
		var sheet        = Main.assetsManager.keyTiles;
		this.bitmap       = new BatchElement(sheet.tiles[0]);
		this.text         = new BatchElement(Main.assetsManager.font.getChar(0).t);
		this.plusText     = new BatchElement(Main.assetsManager.font.getChar(0).t);
		this.secondBitmap = new BatchElement(sheet.tiles[0]);
		this.secondText   = new BatchElement(Main.assetsManager.font.getChar(0).t);
		
		text.alpha = 0.6;
		secondText.alpha = 0.6;
	}
	
	public function addTo(layer:SpriteBatch, textLayer:SpriteBatch):Void
	{
		layer.add(bitmap      );
		layer.add(secondBitmap);
		
		// text
		layer.add(text        );
		layer.add(plusText    );
		layer.add(secondText  );
	}
	
	public function dispose():Void 
	{
		bitmap      .remove();
		secondBitmap.remove();
		
		// text
		text        .remove();
		plusText    .remove();
		secondText  .remove();
	}
	
	public function draw(
		x:Float,
		y:Float,
		inputKind:InputKind,
		secondInputKind:Null<InputKind> = null
	):Void 
	{
		var sheet = getTiles(inputKind);
		text.visible = bitmap.visible = true;
		bitmap.t = sheet.tiles[if (shouldCheck && Main.inputManager.check(inputKind)) 1 else 0];
		text  .t = Main.assetsManager.font.getChar(getCharCode(inputKind)).t;
		
		if (secondInputKind == null)
		{
			bitmap.x = Math.round(x - sheet.width / 2 - 0.5);
			bitmap.y = Math.round(y - sheet.height);
			text.x   = bitmap.x + sheet.width / 2 - text.t.width / 2 + 1.0;
			text.y   = bitmap.y + if (shouldCheck && Main.inputManager.check(inputKind)) 4 else 2;
			plusText.visible = secondText.visible = secondBitmap.visible = false;
		}
		else
		{
			var sheet = getTiles(secondInputKind);
			secondBitmap.t = sheet.tiles[if (shouldCheck && Main.inputManager.check(secondInputKind)) 1 else 0];
			secondText  .t = Main.assetsManager.font.getChar(getCharCode(secondInputKind)).t;
			
			bitmap.x = -14 + Math.round(x - sheet.width / 2 - 0.5);
			bitmap.y = Math.round(y - sheet.height - 0.5);
			text.x   = bitmap.x + sheet.width / 2 - text.t.width / 2 + 1.0;
			text.y   = bitmap.y + if (Main.inputManager.check(inputKind)) 4 else 2;
			
			
			secondBitmap.x = 14 + Math.round(x - sheet.width / 2 - 0.5);
			secondBitmap.y = Math.round(y - sheet.height - 0.5);
			secondText.x   = secondBitmap.x + sheet.width / 2 - text.t.width / 2 + 1.0;
			secondText.y   = secondBitmap.y + if (shouldCheck && Main.inputManager.check(secondInputKind)) 4 else 2;
			
			plusText.t    = Main.assetsManager.font.getChar(43).t;
			plusText.x    = Math.round(x - plusText.t.width / 2 + 0.5);
			plusText.y    = bitmap.y + 3;
			
			plusText.visible = secondText.visible = secondBitmap.visible = true;
		}
	}
	
	public function hide():Void 
	{
		text.visible = bitmap.visible = false;
		plusText.visible = secondText.visible = secondBitmap.visible = false;	
	}
	
	private static function getTiles(inputKind:InputKind):TileSheet
	{
		return if (Main.saveManager.inputSetting.isPad)
		{
			switch (Main.inputManager.getPadSetting(inputKind))
			{
				case 
					"LX",
					"LY",
					"RX",
					"RY",
					"LT", 
					"RT", 
					"Back",
					"Start",
					"LB",
					"RB": 
					Main.assetsManager.padWideTiles;
				
				case value   : 
					Main.assetsManager.padTiles;
			}
			
		}
		else
		{
			Main.assetsManager.keyTiles;
		}
	}
	
	private static function getCharCode(inputKind:InputKind):Int
	{
		return getText(inputKind).charCodeAt(0);
	}
	private static function getText(inputKind:InputKind):String
	{
		return if (Main.saveManager.inputSetting.isPad)
		{
			switch (Main.inputManager.getPadSetting(inputKind))
			{
				case "DUp"   : "▲";
				case "DDown" : "▼";
				case "DLeft" : "◀";
				case "DRight": "▶";
				case "Start" : "⏵";
				case value   : value.substr(0, 1);
			}
		}
		else 
		{
			switch (Main.inputManager.getKeySetting(inputKind))
			{
				case Key.LEFT : "←"	;
				case Key.UP   : "↑"	;
				case Key.RIGHT: "→" ;
				case Key.DOWN : "↓"	;
				case Key.NUMBER_0: "0";
				case Key.NUMBER_1: "1";
				case Key.NUMBER_2: "2";
				case Key.NUMBER_3: "3";
				case Key.NUMBER_4: "4";
				case Key.NUMBER_5: "5";
				case Key.NUMBER_6: "6";
				case Key.NUMBER_7: "7";
				case Key.NUMBER_8: "8";
				case Key.NUMBER_9: "9";
				case Key.NUMPAD_0: "0";
				case Key.NUMPAD_1: "1";
				case Key.NUMPAD_2: "2";
				case Key.NUMPAD_3: "3";
				case Key.NUMPAD_4: "4";
				case Key.NUMPAD_5: "5";
				case Key.NUMPAD_6: "6";
				case Key.NUMPAD_7: "7";
				case Key.NUMPAD_8: "8";
				case Key.NUMPAD_9: "9";
				case Key.F1	     : " ";
				case Key.F2	     : " ";
				case Key.F3	     : " ";
				case Key.F4	     : " ";
				case Key.F5	     : " ";
				case Key.F6	     : " ";
				case Key.F7	     : " ";
				case Key.F8	     : " ";
				case Key.F9	     : " ";
				case Key.F10     : " ";
				case Key.F11     : " ";
				case Key.F12     : " ";
				case Key.QWERTY_EQUALS       : "=";
				case Key.QWERTY_MINUS        : "-";
				case Key.QWERTY_TILDE        : "~";
				case Key.QWERTY_BRACKET_LEFT : "(";
				case Key.QWERTY_BRACKET_RIGHT: ")";
				case Key.QWERTY_SEMICOLON    : ";";
				case Key.QWERTY_QUOTE        : "'";
				case Key.QWERTY_BACKSLASH    : "\\";
				case Key.QWERTY_COMMA        : ",";
				case Key.QWERTY_PERIOD       : ".";
				case Key.QWERTY_SLASH        : "/";
				case Key.BACKSPACE	  : "⌫";
				case Key.TAB		  : "␉";
				case Key.SHIFT		  : "⌂";
				case Key.CTRL		  : "⌃";
				case Key.ALT		  : "⌥";
				case Key.ESCAPE		  : "␛";
				case Key.SPACE		  : "␣";
				case Key.ENTER		  : "⏎";
				case id: Key.getKeyName(id);
			}
		}
	}
}