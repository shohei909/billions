package game.page.game.puzzle;

abstract PuzzlePosition(Int) 
{
	public function new(x:Int, y:Int)
	{
		this = x + (y << 16);
	}
	
	public var x(get, never):Int;
	private function get_x():Int
	{
		return this & 0xFFFF;
	}
	public var y(get, never):Int;
	private function get_y():Int
	{
		return (this >> 16) & 0xFFFF;
	}
}