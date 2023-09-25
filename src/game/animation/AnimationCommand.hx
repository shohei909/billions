package game.animation;

enum AnimationCommand<Id>
{
	Move(fromX:Float, fromY:Float, toX:Float, toY:Float, easing:Float->Float, length:Int);
	MoveAlpha(from:Float, to:Float, easing:Float->Float, length:Int);
	MoveScale(from:Float, to:Float, easing:Float->Float, length:Int);
	Hide (frame:Int);
	Frame(tileIndex:Int, frame:Int);
	Stop (tileIndex:Int);
	Random(frame:Int);
	Goto (id:Id);
}
