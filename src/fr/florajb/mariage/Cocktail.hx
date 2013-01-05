package fr.florajb.mariage;
import nme.display.BitmapData;

/**
 * ...
 * @author jb
 */

class Cocktail
{

	public var icon: BitmapData;
	public var name: String;
	public var recipe: Array<String>;
	public var points: Int;
	
	public function new(name: String, icon: BitmapData, recipe: Array<String>, points: Int) 
	{
		this.name = name;
		this.icon = icon;
		this.recipe = recipe;
		this.points = points;
	}
	
	public function equalsRecipe(recipe: Array<String>) : Bool
	{
		var equals = true;
		if (this.recipe.length != recipe.length)
			return false;
		this.recipe.sort(sort);
		recipe.sort(sort);
		var i = 0;
		for (string in this.recipe) {
			if (string != recipe[i])
				equals = false;
			i++;
		}
		return equals;
	}
	
	private function sort(x: String, y: String) : Int 
	{
		var scoreX = x.charCodeAt(0) + x.charCodeAt(1) + x.charCodeAt(2) + x.charCodeAt(3);
		var scoreY = y.charCodeAt(0) + y.charCodeAt(1) + y.charCodeAt(2) + y.charCodeAt(3);
		return scoreX - scoreY;
	}
	
	public function contains(elem: String) : Bool
	{
		for (string in recipe) {
			if (string == elem)
				return true;
		}
		return false;
	}
}