package game.animation;
import h2d.SpriteBatch.BatchElement;
import link.Next;

interface IAnimation extends Next<IAnimation>
{
	public var element         (default, null):BatchElement;
	public var x                              :Float;
	public var y                              :Float;
	public var loopCount       (default, null):Int;
	
	public function step(delta:Float):Void;
	public function dispose():Void;
	public function setBottomCenter(tileX:Float, tileY:Float):Void;
	public function setCenter      (tileX:Float, tileY:Float):Void;
}
