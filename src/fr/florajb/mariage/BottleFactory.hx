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
			case "vermouth":bottle.x = 0;
							bottle.y = 300;
			case "vodka":	bottle.x = 130;
							bottle.y = 300;
			case "cola":	bottle.x = 415;
							bottle.y = 323;
			case "orange":	bottle.x = 75;
							bottle.y = 155;
			case "rhum":	bottle.x = 85;
							bottle.y = 300;
			case "ananas":	bottle.x = 10;
							bottle.y = 155;
			case "coco":	bottle.x = 130;
							bottle.y = 225;
		}
	}
	
	private function new() 
	{
		
	}
	
}