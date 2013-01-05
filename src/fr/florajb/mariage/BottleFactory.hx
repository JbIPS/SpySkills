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
			case "vermouth":bottle.x = 330;
							bottle.y = 300;
			case "vodka":	bottle.x = 130;
							bottle.y = 310;
			case "cola":	bottle.x = 440;
							bottle.y = 323;
			case "orange":	bottle.x = 85;
							bottle.y = 155;
			case "rhum":	bottle.x = 80;
							bottle.y = 300;
			case "ananas":	bottle.x = 10;
							bottle.y = 155;
			case "coco":	bottle.x = 160;
							bottle.y = 225;
			case "sucre":	bottle.x = 580;
							bottle.y = 290;
			case "citron":	bottle.x = 380;
							bottle.y = 235;
			case "grenadine":bottle.x = 510;
							bottle.y = 293;
			case "tequila":	bottle.x = 188;
							bottle.y = 300;
		}
	}
	
	private function new() 
	{
		
	}
	
}