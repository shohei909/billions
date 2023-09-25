package game.animation;
import game.animation.Animation;
import game.animation.AnimationCommand;
import game.asset.tile.TileSheet;
import game.asset.tile.TileSource;
import h2d.Tile;

class AnimationResolver<Id:Int>
{
	private var pooledObject(default, null):Null<Animation<Id>>;
	public var tiles  (default, null):Array<TileSource>;
	public var initial(default, null):Id;
	public var data   (default, null):Map<Id, Array<AnimationCommand<Id>>>;
	
	public function new(
		tiles:Array<TileSource>,
		data:Map<Id, Array<AnimationCommand<Id>>>
	)
	{
		this.tiles = tiles;
		this.data = data;
		this.initial = cast 0;
	}
	
	public function resolve(id:Id):Array<AnimationCommand<Id>>
	{
		return data[id];
	}
	
	public function create():Animation<Id>
	{
		return if (pooledObject == null)
		{
			new Animation(this);
		}
		else
		{
			var result = pooledObject;
			pooledObject = cast pooledObject.nextObject;
			result.reset();
			result;
		}
	}
	
	public function pool(animation:Animation<Id>):Void
	{
		animation.nextObject = pooledObject;
		pooledObject = animation;
	}
}