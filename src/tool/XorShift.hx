package tool;
import tool.XorShift;

class XorShift 
{
	public var x:Int = 0xf588c7a6;
	public var y:Int = 0xd58c1882;
	public var z:Int = 0x76cedae1;
	public var w:Int;
	
	public function new(seed:Int = 0xedb0948c) 
	{
		w = seed;
	}
	
	public function gen():Int
	{
		var t = x ^ (x << 11);
		x = y; 
		y = z; 
		z = w;
		return w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
	}
	
	
	public function copyTo(previewEmitter:XorShift):Void 
	{
		previewEmitter.x = x;
		previewEmitter.y = y;
		previewEmitter.z = z;
		previewEmitter.w = w;
	}
}
