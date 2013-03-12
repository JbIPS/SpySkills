package fr.florajb.mariage;
import nme.events.Event;
import nme.Lib;
import nme.external.ExternalInterface;

/**
 * ...
 * @author jb
 */

class Main 
{

	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		ExternalInterface.addCallback("quit", quit);
		displayMenu(null);
	}
	
	private static function startGame(e: Event) : Void 
	{
		var game = new Barman();
		game.addEventListener(Event.COMPLETE, displayMenu);
		Lib.current.removeChildAt(0);
		Lib.current.addChild(game);
	}
	
	private static function displayMenu(e: Event) : Void 
	{
		var menu = new InterLevel("menu", startGame);
		Lib.current.addChild(menu);
	}
	
	public function new() : Void 
	{
		
	}
	
	public static function quit(){
		Lib.exit();
	}
	
}