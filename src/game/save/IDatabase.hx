package game.save;

interface IDatabase 
{
	function saveString(key:String, value:String):Void;
	function readString(key:String):String;
}
