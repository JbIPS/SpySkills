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
			case "gin":		bottle.x = 5;
							bottle.y = 300;
			case "rhum":	bottle.x = 65;
							bottle.y = 300;
			case "vodka":	bottle.x = 120;
							bottle.y = 310;
			case "tequila":	bottle.x = 185;
							bottle.y = 300;
			case "vermouth":bottle.x = 265;
							bottle.y = 300;
			case "triplesec":bottle.x = 325;
							bottle.y = 310;
			case "eau":		bottle.x = 385;
							bottle.y = 296;
			case "cola":	bottle.x = 455;
							bottle.y = 325;
			case "grenadine":bottle.x = 515;
							bottle.y = 293;
			case "sucre":	bottle.x = 570;
							bottle.y = 290;
			case "orange":	bottle.x = 85;
							bottle.y = 155;
			case "ananas":	bottle.x = 10;
							bottle.y = 155;
			case "coco":	bottle.x = 160;
							bottle.y = 210;
			case "menthe":	bottle.x = 300;
							bottle.y = 230;
			case "citron":	bottle.x = 380;
							bottle.y = 235;
		}
	}
	
	private function new() 
	{
		
	}
	
}