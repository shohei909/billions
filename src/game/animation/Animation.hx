package game.animation;
import game.animation.AnimationResolver;
import game.asset.tile.TileSource;
import game.constants.ViewConstants;
import h2d.SpriteBatch.BatchElement;
import h2d.Tile;
using tweenxcore.Tools;

class Animation<Id:Int> implements IAnimation
{
	public var element         (default, null):BatchElement;
	public var x                              :Float =  0;
	public var y                              :Float =  0;
	public var tileIndex       (default, null):Int       ;
	public var prevCommandIndex(default, null):Int   = -1;
	public var waitFrame       (default, null):Float =  0;
	public var moveFromX       (default, null):Float =  0;
	public var moveFromY       (default, null):Float =  0;
	public var moveToX         (default, null):Float =  0;
	public var moveToY         (default, null):Float =  0;
	public var moveFrame       (default, null):Float =  0;
	public var moveLength      (default, null):Float =  0;
	public var moveEasing      (default, null):Float->Float;
	public var moveAlphaFrame  (default, null):Float =  0;
	public var moveAlphaFrom   (default, null):Float =  0;
	public var moveAlphaTo     (default, null):Float =  0;
	public var moveAlphaEasing (default, null):Float->Float;
	public var moveAlphaLength (default, null):Int   =  0;
	public var moveScaleFrame  (default, null):Float =  0;
	public var moveScaleFrom   (default, null):Float =  0;
	public var moveScaleTo     (default, null):Float =  0;
	public var moveScaleEasing (default, null):Float->Float;
	public var moveScaleLength (default, null):Int   =  0;
	public var resolver                       :AnimationResolver<Id>;
	public var commands        (default, null):Array<AnimationCommand<Id>>;
	public var currentId       (default, null):Id;
	public var loopCount       (default, null):Int = 0;
	public var nextObject                     :Null<IAnimation>;
	private var offsetX                       :Float = 0;
	private var offsetY                       :Float = 0;
	private var tileSource                    :TileSource;
	
	public var width(get, never):Float;
	private function get_width():Float { return tileSource.width; }
	public var height(get, never):Float;
	private function get_height():Float { return tileSource.height; }
	
	public function new(resolver:AnimationResolver<Id>) 
	{
		this.resolver = resolver;
		element = new BatchElement(resolver.tiles[tileIndex = 0].tile);
		reset();
	}
	
	public function reset():Void
	{
		x                = 0;
		y                = 0;
		tileIndex        = 0;
		prevCommandIndex = 0;
		waitFrame        = 0;
		moveFromX        = 0;
		moveFromY        = 0;
		moveToX          = 0;
		moveToY          = 0;
		moveFrame        = 0;
		moveLength       = 0;
		moveEasing       = null;
		moveAlphaFrame   = 0;
		moveAlphaFrom    = 0;
		moveAlphaTo      = 0;
		moveAlphaEasing  = null;
		moveAlphaLength  = 0;
		moveScaleFrame   = 0;
		moveScaleFrom    = 0;
		moveScaleTo      = 0;
		moveScaleEasing  = null;
		moveScaleLength  = 0;
		commands         = null;
		loopCount        = 0;
		nextObject       = null;
		offsetX          = 0;
		offsetY          = 0;
		
		tileSource = resolver.tiles[tileIndex = 0];
		element.t = tileSource.tile;
		element.alpha = 1.0;
		element.x = 0;
		element.y = 0;
		goto(resolver.initial);
	}
	
	public function dispose():Void
	{
		element.remove();
		resolver.pool(this);
	}
	
	public function step(delta:Float):Void
	{
		while (delta > 0)
		{
			var prevWaitFrame = waitFrame;
			waitFrame -= delta;
			if (waitFrame <= 0)
			{
				delta = -waitFrame;
				readCommand();
				move(prevWaitFrame);
			}
			else
			{
				move(delta);
				delta = 0;
			}
		}
		element.x = x + offsetX + (tileSource.width  * (1 - element.scaleX)) / 2;
		element.y = y + offsetY + (tileSource.height * (1 - element.scaleY)) / 2;
	}
	
	private function move(delta:Float):Void 
	{
		if (moveEasing != null) 
		{
			moveFrame += delta;
			var rate = moveEasing(moveFrame.inverseLerp(0, moveLength).clamp());
			offsetX = rate.lerp(moveFromX, moveToX);
			offsetY = rate.lerp(moveFromY, moveToY);
			if (moveLength <= moveFrame) {
				moveEasing = null;
			}
		}
		element.alpha = 1.0;
		if (moveAlphaEasing != null) 
		{
			moveAlphaFrame += delta;
			var rate = moveAlphaEasing(moveAlphaFrame.inverseLerp(0, moveAlphaLength).clamp());
			element.alpha = rate.lerp(moveAlphaFrom, moveAlphaTo);
			if (moveAlphaLength <= moveAlphaFrame) {
				moveAlphaEasing = null;
			}
		}
		if (moveScaleEasing != null) 
		{
			moveScaleFrame += delta;
			var rate = moveScaleEasing(moveScaleFrame.inverseLerp(0, moveScaleLength).clamp());
			element.scale = rate.lerp(moveScaleFrom, moveScaleTo);
			if (moveScaleLength <= moveScaleFrame) {
				moveScaleEasing = null;
			}
		}
		if (tileIndex == -1)
		{
			element.alpha = 0.0;
		}
	}
	
	private function readCommand():Void
	{
		loopCount += Math.floor((prevCommandIndex + 1) / commands.length);
		prevCommandIndex = (prevCommandIndex + 1) % commands.length;
		var command = commands[prevCommandIndex];
		
		switch (command)
		{
			case AnimationCommand.Hide(frame):
				this.tileIndex = -1;
				waitFrame = frame;
				
			case AnimationCommand.Frame(tileIndex, frame):
				tileSource = resolver.tiles[this.tileIndex = tileIndex];
				element.t = tileSource.tile;
				waitFrame = frame;
				
			case AnimationCommand.Stop(tileIndex): 
				tileSource = resolver.tiles[this.tileIndex = tileIndex];
				element.t = tileSource.tile;
				waitFrame = 0x7FFFFFFF;
				
			case AnimationCommand.Random(frame): 
				waitFrame = Std.random(frame);
				
			case AnimationCommand.Move(fromX, fromY, toX, toY, easing, length): 
				moveFrame = 0;
				moveFromX = fromX;
				moveFromY = fromY;
				moveToX = toX;
				moveToY = toY;
				moveEasing = easing;
				moveLength = length;
				
			case AnimationCommand.MoveAlpha(from, to, easing, length): 
				moveAlphaFrame  = 0;
				moveAlphaFrom   = from;
				moveAlphaTo     = to;
				moveAlphaEasing = easing;
				moveAlphaLength = length;
				
			case AnimationCommand.MoveScale(from, to, easing, length): 
				moveScaleFrame  = 0;
				moveScaleFrom   = from;
				moveScaleTo     = to;
				moveScaleEasing = easing;
				moveScaleLength = length;
				
			case AnimationCommand.Goto(id):
				goto(id);
		}
	}
	
	public function change(id:Id):Void
	{
		if (id == currentId) { return; }
		goto(id);
	}
	
	public function goto(id:Id):Void
	{
		currentId = id;
		commands = resolver.resolve(id);
		prevCommandIndex = -1;
		waitFrame = 0;
		readCommand();
	}
	
	public function setBottomCenter(tileX:Float, tileY:Float):Void 
	{
		x = tileX * ViewConstants.TILE_SIZE - tileSource.width / 2;
		y = tileY * ViewConstants.TILE_SIZE - tileSource.height;
	}
	
	public function setCenter(tileX:Float, tileY:Float):Void 
	{
		x = tileX * ViewConstants.TILE_SIZE - tileSource.width  / 2;
		y = tileY * ViewConstants.TILE_SIZE - tileSource.height / 2;
	}
}
