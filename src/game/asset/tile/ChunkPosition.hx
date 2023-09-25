package game.asset.tile;

abstract ChunkPosition(Int)
{
	public function new(x:UInt, y:UInt) 
	{
		this = (x % 0x10000) + (y % 0x10000) * 0x10000;
	}
}