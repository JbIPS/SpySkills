package fr.florajb.mariage;

import nme.Assets;
import haxe.FastList;

class Cookbook
{
	public static var instance (getInstance, null): Cookbook;
	
	public var recipes: FastList<Cocktail>;
	
	public static function getInstance(){
		if(instance == null)
			instance = new Cookbook();
		return instance;
	}
	
	public function setLevel(level: Int){
		for(recipe in LevelManager.getNewRecipes(level)){
			recipes.add(recipe);
		}
	}
	
	private function new () {
		recipes = new FastList<Cocktail>();		
	}	
}