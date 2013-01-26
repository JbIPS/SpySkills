package fr.florajb.mariage;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.filters.DropShadowFilter;
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
		icon.x = icon.y = 10;
		addChild(icon);
		
		var recipeName = new TextField();
		recipeName.selectable = recipeName.mouseEnabled = false;
		recipeName.defaultTextFormat = new TextFormat("_sans", 11, true);
		recipeName.text = nextRecipe.name;
		recipeName.height = recipeName.textHeight + 5;
		recipeName.x = board.width / 2;
		recipeName.y = this.height / 2 - 8;
		addChild(recipeName);
		
		filters = [new DropShadowFilter(5, 135, 0, 0.5, 10)];
	}
	
}