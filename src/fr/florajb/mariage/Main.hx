package fr.florajb.mariage;
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
		
		Lib.current.addChild(new Barman());
	}
	
}