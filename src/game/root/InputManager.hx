package game.root;

import game.root.InputKind;
import hxd.Key;
import hxd.Pad;

class InputManager {

    public var buttonYellow:Bool = false;
    public var buttonBlue  :Bool = false;
    public var buttonL     :Bool = false;
    public var buttonR     :Bool = false;
    public var buttonUp    :Bool = false;
    public var buttonDown  :Bool = false;
    public var buttonLeft  :Bool = false;
    public var buttonRight :Bool = false;
    public var buttonPause :Bool = false;
    public var buttonYes   :Bool = false;
    public var buttonNo    :Bool = false;
    public var pad:Pad;

	public function new() {
		Key.initialize();
		
		pad = Pad.createDummy();
		Pad.wait(p -> pad = p);
	}

    public function update():Void
    {
        updateButton(InputKind.Yellow);
        updateButton(InputKind.Blue  );
        updateButton(InputKind.L     );
        updateButton(InputKind.R     );
        updateButton(InputKind.Up    );
        updateButton(InputKind.Down  );
        updateButton(InputKind.Left  );
        updateButton(InputKind.Right );
        updateButton(InputKind.Pause );
        updateButton(InputKind.Yes   );
        updateButton(InputKind.No    );
    }
	
	private function updateButton(kind:InputKind):Void 
	{
		var prev = switch (kind)
		{
			case InputKind.Yellow: buttonYellow;
			case InputKind.Blue  : buttonBlue  ;
			case InputKind.L     : buttonL     ;
			case InputKind.R     : buttonR     ;
			case InputKind.Up    : buttonUp    ;
			case InputKind.Down  : buttonDown  ;
			case InputKind.Left  : buttonLeft  ;
			case InputKind.Right : buttonRight ;
			case InputKind.Pause : buttonPause ;
			case InputKind.Yes   : buttonYes   ;
			case InputKind.No    : buttonNo    ;
		}
		var current = switch (kind)
		{
			case InputKind.Yellow : buttonYellow = check(InputKind.Yellow);
			case InputKind.Blue   : buttonBlue   = check(InputKind.Blue  );
			case InputKind.L      : buttonL      = check(InputKind.L     );
			case InputKind.R      : buttonR      = check(InputKind.R     );
			case InputKind.Up     : buttonUp     = check(InputKind.Up    );
			case InputKind.Down   : buttonDown   = check(InputKind.Down  );
			case InputKind.Left   : buttonLeft   = check(InputKind.Left  );
			case InputKind.Right  : buttonRight  = check(InputKind.Right );
			case InputKind.Pause  : buttonPause  = check(InputKind.Pause );
			case InputKind.Yes    : buttonYes    = check(InputKind.Yes   );
			case InputKind.No     : buttonNo     = check(InputKind.No    );
		}
		
		if (prev && !current)
		{
			Main.app.root.keyUp(kind);
		}
		else if (!prev && current)
		{
			Main.app.root.keyDown(kind);
		}
	}
	
	public function check(kind:InputKind):Bool
	{
		return keyCheck(kind) || padCheck(kind);
	}
	
	private function keyCheck(kind:InputKind):Bool
	{
		var id = getKeySetting(kind);
		var result = Key.isDown(id);
		if (result) { changeSetting(false); } 
		return result;
	}
	private function padCheck(kind:InputKind):Bool
	{
		var name = getPadSetting(kind);
		
		var setting = Main.saveManager.inputSetting.pad;
		if (setting.abReverse && name == "B") { name = "A"; }
		else if (setting.abReverse && name == "A") { name = "B"; }
		else if (setting.xyReverse && name == "X") { name = "Y"; }
		else if (setting.xyReverse && name == "Y") { name = "X"; }
		
		var id = pad.config.names.indexOf(name);
		var result = pad.isDown(id);
		if (result) { changeSetting(true); } 
		return result;
	}
	
	function changeSetting(flag:Bool):Void 
	{
		if (Main.saveManager.inputSetting.isPad != flag)
		{
			Main.saveManager.inputSetting.isPad = flag;
			Main.saveManager.saveInputSetting();
		}
	}
	public function getPadSetting(kind:InputKind):String
	{
		var setting = Main.saveManager.inputSetting.pad;
		var name = switch (kind)
		{
			case InputKind.Yellow: setting.yellow;
			case InputKind.Blue  : setting.blue  ;
			case InputKind.L     : setting.l     ;
			case InputKind.R     : setting.r     ;
			case InputKind.Up    : setting.up    ;
			case InputKind.Down  : setting.down  ;
			case InputKind.Left  : setting.left  ;
			case InputKind.Right : setting.right ;
			case InputKind.Pause : setting.pause ;
			case InputKind.Yes   : setting.yes   ;
			case InputKind.No    : setting.no    ;
		}
		
		return name;
	}
	
	public function getKeySetting(kind:InputKind):Int 
	{
		var setting = Main.saveManager.inputSetting.key;
		return switch (kind)
		{
			case InputKind.Yellow: setting.yellow;
			case InputKind.Blue  : setting.blue  ;
			case InputKind.L     : setting.l     ;
			case InputKind.R     : setting.r     ;
			case InputKind.Up    : setting.up    ;
			case InputKind.Down  : setting.down  ;
			case InputKind.Left  : setting.left  ;
			case InputKind.Right : setting.right ;
			case InputKind.Pause : setting.pause ;
			case InputKind.Yes   : setting.yes   ;
			case InputKind.No    : setting.no    ;
		}
	}
}
