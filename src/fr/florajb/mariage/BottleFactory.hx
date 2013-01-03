package fr.florajb.mariage;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;

/**
 * ...
 * @author jb
 */

class BottleFactory 
{
	public static function createBottle(name: String) : Bottle
	{
		var bottle: Bottle = new Bottle(name, new Bitmap(Assets.getBitmapData("img/" + name + ".png")));
		setPosition(bottle);
		
		return bottle;
	}
	
	private static function setPosition(bottle: Bottle) 
	{
		switch(bottle.name){
			case "vodka":	bottle.x = 100;
							bottle.y = 300;
			case "tomato":	bottle.x = 315;
							bottle.y = 315;
			case "rhum":	bottle.x = 200;
							bottle.y = 300;
			case "ananas":	bottle.x = 50;
							bottle.y = 155;
			case "coco":	bottle.x = 200;
							bottle.y = 225;
		}
	}
	
	private function new() 
	{
		
	}
	
}