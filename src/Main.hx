package;

import game.asset.AssetManager;
import game.constants.ViewConstants;
import game.root.InputManager;
import game.root.RootLogic;
import game.save.SaveManager;
import game.sound.SoundPlayer;
import h3d.Engine;
import hxd.App;
import hxd.Event;
import hxd.Timer;
import hxd.Window;
import viewTree.core.DrawContext;
import viewTree.core.ViewTree;

class Main extends App {
	public static var app          :Main;
	public static var soundPlayer  :SoundPlayer;
	public static var assetsManager:AssetManager;
	public static var saveManager  :SaveManager;
	public static var inputManager :InputManager;

	public static function main() 
	{
		app = new Main();
	}

	public static function initStatic():Void {
		assetsManager = new AssetManager();
		soundPlayer   = new SoundPlayer();
		saveManager   = new SaveManager();
		inputManager  = new InputManager();
	}

	// ----------------------------
	// App
	// ----------------------------
	public var root(default, null):RootLogic;
	public var pausing(default, null):Bool;

	var viewTree:ViewTree;
	var rest:Float;

	public function new() {
		super();
		rest = 0;
		pausing = false;
	}

	override function init() {
		if (root != null) {
			return;
		}

		initStatic();
		
		this.root = new RootLogic();
		
		s2d.scaleMode = LetterBox(ViewConstants.WIDTH, ViewConstants.HEIGHT);

		viewTree = new ViewTree(root, new DrawContext());

		var window = Window.getInstance();
		window.addEventTarget(onEvent);
		
		saveManager.loadWindow();
		onResize();
	}

	override function update(delta:Float):Void 
	{
		if (root == null) {
			return;
		}
		inputManager.update();
		
		if (pausing) {
			root.pauseUpdate();
			return;
		}

		root.update();
		viewTree.update();
	}
		
	public override function render(e:h3d.Engine):Void 
	{
		if (root == null) {return; }
		
		// ピクセレートのため、ルートレイヤーを、小さいビットマップに書き込む
		engine.pushTarget(root.view.renderTaget);
		engine.clear(0x00000000, 1);
		var w = engine.width;
		var h = engine.height;
		engine.resize(ViewConstants.WIDTH, ViewConstants.HEIGHT);
		s2d.checkResize();
		root.view.rootLayer .visible = true ;
		root.view.rootBitmap.visible = false;
		s2d.render(e);
		engine.popTarget();
		
		// ピクセレート処理したビットマップを拡大表示する
		engine.resize(w, h);
		s2d.scaleMode = LetterBox(ViewConstants.WIDTH, ViewConstants.HEIGHT);
		s2d.checkResize();
		root.view.rootLayer .visible = false;
		root.view.rootBitmap.visible = true ;
		s2d.render(e);
	}

	override function dispose():Void {
		super.dispose();
		viewTree.dispose();
	}

	private function onEvent(e:Event):Void {
		if (e.kind == EFocus) {
			onActivate(e);
		} else if (e.kind == EFocusLost) {
			onDeactivate(e);
		}
	}

	function onActivate(e:Event):Void {
		Timer.skip();
		if (pausing) {
			pausing = false;
			Main.soundPlayer.pause();
		}
	}

	function onDeactivate(e:Event):Void {
		if (!pausing) {
			pausing = true;
			Main.soundPlayer.resume();
		}
	}
	@:access(h2d.Scene)
	var gl:Dynamic;
	override function onResize() {
		super.onResize();
		
		if (root == null) { return; }
		root.resize();
		saveManager.saveWindow();
	}
}
