#if js
package game.save;
import game.save.IDatabase;
import js.Browser;

class BrowserDatabase implements IDatabase
{
	public function new() {}

	public function saveString(key:String, value:String):Void
	{
		Browser.window.localStorage.setItem("billions/" + key, value);
	}

	public function readString(key:String):String
	{
		return Browser.window.localStorage.getItem("billions/" + key);
	}
}



#end
