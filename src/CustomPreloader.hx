package;
import openfl.display.Preloader;
import openfl.text.TextField;

class CustomPreloader extends Preloader
{
	private var text:TextField;
	public function new() 
	{
		#if hl
		hl.UI.closeConsole();
		#end
		super(new DefaultPreloader());
	}
	
	override function update(loaded:Int, total:Int):Void 
	{
		super.update(loaded, total);
	}	
}
