package fr.florajb.mariage;
import nme.events.Event;
import nme.Lib;

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
		
		var menu = new InterLevel("menu", startGame);
		Lib.current.addChild(menu);
	}
	
	private static function startGame(e: Event) : Void 
	{
		Lib.current.removeChildAt(0);
		Lib.current.addChild(new Barman());
	}
	
	public function new() : Void 
	{
		
	}
	
}