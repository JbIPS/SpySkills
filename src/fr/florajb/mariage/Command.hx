package fr.florajb.mariage;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * ...
 * @author jbrichardet
 */

class Command extends Sprite
{
	public var cocktail: Cocktail;
	public var points: Int;
	
	public function new() 
	{
		super();
		var board = new Bitmap(Assets.getBitmapData("img/planche.png"));
		board.scaleX = board.scaleY = 0.2;
		addChild(board);
		
		var nextRecipe: Cocktail = null;
		var bestScore: Float = 0;
		var list = Cookbook.instance.recipes;
		for (recipe in list) {
			var score = Math.random();
			if (score > bestScore) {
				bestScore = score;
				nextRecipe = recipe;
			}
		}
		
		cocktail = nextRecipe;
		points = cocktail.points;
		
		var icon: Bitmap = new Bitmap(cocktail.icon);
		icon.scaleX = icon.scaleY = 0.6;
		icon.x = icon.y = 10;
		addChild(icon);
		
		var recipeName = new TextField();
		recipeName.selectable = recipeName.mouseEnabled = false;
		recipeName.defaultTextFormat = new TextFormat("_sans", 11, true);
		recipeName.text = nextRecipe.name;
		recipeName.x = board.width / 2;
		recipeName.y = board.height / 2 - 8;
		addChild(recipeName);
	}
	
}