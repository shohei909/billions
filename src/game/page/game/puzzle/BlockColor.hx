package game.page.game.puzzle;

enum abstract BlockColor(Bool)
{
	var Yellow = false;
	var Blue   = true;
	
	@:op(!a) public function invert():BlockColor;
}