package collision;

abstract LinkerPosition(Int)
{
	public function new(x:UInt, y:UInt) 
	{
		this = (x % 0x10000) + (y % 0x10000) * 0x10000;
	}
}
