package game.animation;

class AnimationProcessor 
{
	public var resolver                :AnimationResolver<Id>;
	public var commands (default, null):Array<AnimationCommand<Id>>;
	public var currentId(default, null):Id;
	
	public function new() 
	{
		
	}
	
}