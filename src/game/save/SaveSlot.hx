package game.save;

class SaveSlot 
{
	public var index       :Null<Int    >;
	
	public function new() {}
	
	public function reset(index:Int):Void
	{
		this.index        = index;
	}
	
	public function migrate(slotIndex:Int):Void
	{
		this.index        = slotIndex;
	}
}
