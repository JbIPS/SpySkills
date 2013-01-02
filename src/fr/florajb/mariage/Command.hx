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

	public function new() 
	{
		super();
		var board = new Bitmap(Assets.getBitmapData("img/planche.png"));
		board.scaleX = board.scaleY = 0.2;
		addChild(board);
		
		var nextRecipe: String = "";
		var bestScore: Float = 0;
		for (recipe in Main.cookbook.keys()) {
			var score = Math.random();
			if (score > bestScore) {
				bestScore = score;
				nextRecipe = recipe;
			}
		}
		
		Lib.trace("next recipe: " + nextRecipe);
		
		////////
		var recipe: Bitmap = new Bitmap(Assets.getBitmapData("img/bloodymary.png"));
		recipe.scaleX = recipe.scaleY = 0.3;
		recipe.x = recipe.y = 10;
		addChild(recipe);
		var recipeName = new TextField();
		recipeName.defaultTextFormat = new TextFormat("_sans", 10);
		recipeName.text = "Bloody Mary";
		recipeName.x = board.width / 2;
		recipeName.y = board.height / 2 - 8;
		addChild(recipeName);
		///////
	}
	
}