package fr.florajb.mariage;

import nme.Assets;
import haxe.FastList;
/**
 * ...
 * @author jb
 */
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
		switch(level){
			case 1:	recipes.add(new Cocktail("Jus d'orange", Assets.getBitmapData("img/orange.png"), [ "orange"], 50));
					recipes.add(new Cocktail("Jus d'ananas", Assets.getBitmapData("img/ananas.png"), [ "ananas"], 50));
					recipes.add(new Cocktail("Cola", Assets.getBitmapData("img/cola.png"), [ "cola"], 50));
					recipes.add(new Cocktail("Vodka Martini", null, [ "vodka", "vermouth"], 100));
					recipes.add(new Cocktail("Screwdriver", null, [ "vodka", "orange"], 100));
			case 2:	recipes.add(new Cocktail("Daiquiri", null, [ "rhum", "sucre", "citron"], 150));
					recipes.add(new Cocktail("Cuba Libre", null, [ "rhum", "cola"], 100));
			case 3: recipes.add(new Cocktail("Piña Colada", null, [ "rhum", "ananas", "coco"], 150));
					recipes.add(new Cocktail("Tequila Sunrise", null, [ "tequila", "orange", "grenadine"], 150));
			case 4: recipes.add(new Cocktail("Margarita", null, [ "tequila", "triplesec", "citron"], 150));
					recipes.add(new Cocktail("Bronx", null, [ "gin", "vermouth", "orange"], 150));
			case 6: recipes.add(new Cocktail("Gin Fizz", null, [ "gin", "sucre", "citron", "eau"], 200));
			case 7: recipes.add(new Cocktail("Mojito", null, [ "rhum", "sucre", "menthe", "citron", "eau"], 250));
			case 8: recipes.add(new Cocktail("Sex on the Beach", null, [ "vodka", "triplesec", "citron", "ananas", "grenadine"], 250));
			case 9: recipes.add(new Cocktail("Coco Loco", null, [ "tequila", "gin", "rhum", "ananas", "citron", "sucre", "coco"], 500));
			case 10: recipes.add(new Cocktail("Long Island Iced Tea", null, [ "tequila", "gin", "rhum", "vodka", "triplesec", "citron", "sucre", "cola"], 600));
		}
	}
	
	private function new () {
		recipes = new FastList<Cocktail>();		
	}	
}