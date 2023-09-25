package game.save;
import game.constants.ViewConstants;
import game.save.IDatabase;
import game.save.InitialLoadedData;
import game.save.SaveSlot;
import hxd.Key;
import hxd.Window;
import typepacker.json.Json;
class SaveManager 
{	
    public var inputSetting(default, null):InputSetting;
	public var database    (default, null):IDatabase;
	public var slotIndex   (default, null):Int;
	
	public function new()
	{
		Json.defaultPacker.setting.forceNullable = true;
		database = 
		#if js
			new BrowserDatabase();
		#else
			new FileDatabase("corge.net", "Billions");
		#end
		
		inputSetting = Json.parse("game.save.InputSetting", database.readString("input"));
		if (inputSetting == null)
		{
			inputSetting = {
				isPad: false,
				pad: {
					yellow   :"A",
					blue     :"B",
					yes      :"A",
					no       :"B",
					sub      :"Y",
					l        : "LB",
					r        : "RB",
					up       : "DUp",
					down     : "DDown",
					left     : "DLeft",
					right    : "DRight",
					pause    : "Start",
					fullScreen:null,
					abReverse: true, // FIXME: false
					xyReverse: true, // FIXME: false
				},
				key: 
				{
					yellow   : Key.Z,
					blue     : Key.X,
					yes      : Key.Z,
					no       : Key.X,
					sub      : Key.C,
					l        : Key.A,
					r        : Key.D,
					up       : Key.UP,
					down     : Key.DOWN,
					left     : Key.LEFT,
					right    : Key.RIGHT,
					pause    : Key.ESCAPE,
					fullScreen: Key.F11,
				}
			}
		}
		saveInputSetting();
	}

    @:access(hxd.Window)
	public function loadWindow():Void
	{
        #if hl
		var state = Json.parse("bomb.save.WindowSetting", database.readString("window")) ?? {
			x:100, 
			y:100, 
			width:1280, 
			height:720, 
			fullscreen:false 
		};
		var window = Window.getInstance();
        window.window.setPosition(state.x, state.y);
		window.resize(state.width, state.height);
		window.displayMode = if (state.fullscreen) DisplayMode.Fullscreen else DisplayMode.Windowed;
        #end
	}
    @:access(hxd.Window)
    public function saveWindow():Void
    {
        #if hl
		var window = Window.getInstance();
		database.saveString(
			"window",
			Json.print(
				"game.save.WindowSetting",
				{
					x         :window.window.x, 
					y         :window.window.y, 
					width     :window.width, 
					height    :window.height, 
					fullscreen:window.displayMode == DisplayMode.Fullscreen
				}
			)
		);
        #end
    }
	public function saveInputSetting():Void
	{
		database.saveString(
			"input",
			Json.print(
				"game.save.InputSetting",
				inputSetting
			)
		);
	}
	
	public function save(slotIndex:Int):Void 
	{
		var saveSlot = new SaveSlot();
		saveSlot.reset(
			slotIndex
		);		
		database.saveString("slot" + slotIndex, Json.print("game.save.SaveSlot", saveSlot));
	}
	
	public function loadInitial(slotIndex:Int, onLoaded:InitialLoadedData->Void):Void
	{
		var saveSlot = Json.parse("game.save.SaveSlot", database.readString("slot" + slotIndex));
		saveSlot = saveSlot ?? new SaveSlot();
		saveSlot.migrate(slotIndex);
		
		onLoaded(
			new InitialLoadedData(saveSlot)
		);
	}
}
