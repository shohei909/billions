#if sys
package game.save;
import typepacker.json.Json;
import bomb.page.game.field.map.MapDatabaseKey;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;
import bomb.page.game.field.map.MapKind;
import bomb.save.SaveChunk;

// 非同期にしたい
// https://github.com/HaxeFoundation/haxe/pull/10342
// 待ち
class FileDatabase implements IDatabase
{
	public var directory:String;
	
    public function new(org:String, app:String) 
    {
		directory = getDirectory() + "/" + org + "/" + app + "/";
		if (!FileSystem.exists(directory))
		{
			FileSystem.createDirectory(directory);
		}
    }
	
	public function getDirectory():String
	{
		var system = Sys.systemName().toLowerCase();
		if (system == "windows")
		{
			var appData = Sys.getEnv("APPDATA");
			if (appData != null) 
			{
				return StringTools.replace(appData, "\\", "/");
			}
		}
		else
		{
			var xdgDataHome = Sys.getEnv("XDG_DATA_HOME");
			if (xdgDataHome != null && Path.isAbsolute(xdgDataHome))
			{
				return xdgDataHome;
			}
			var home = Sys.getEnv("HOME");
			if (home != null && Path.isAbsolute(home))
			{
				return if (system == "mac")
				{
					home + "/Library/Application Support";
				}
				else
				{
					home + "/.local/share";
				}
			}
		}
		return ".";
	}
    
	public function saveString(key:String, value:String):Void 
	{
		var path = directory + key + ".sav";
		var dir = Path.directory(path);
		if (!FileSystem.exists(dir))
		{
			FileSystem.createDirectory(dir);
		}
		File.saveContent(path, value);
	}
	
	public function readString(key:String):String 
	{
		var path = directory + key + ".sav";
		if (!FileSystem.exists(path)) { return null; }
		return 
		File.getContent(path);
	}
}
#end
