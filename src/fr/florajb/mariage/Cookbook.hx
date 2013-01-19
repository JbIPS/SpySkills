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
			case 1:	recipes.add(new Cocktail("Jus d'orange", Assets.getBitmapData("img/jusorange.png"), [ "orange"], 50));
					recipes.add(new Cocktail("Jus d'ananas", Assets.getBitmapData("img/jusananas.png"), [ "ananas"], 50));
					recipes.add(new Cocktail("Cola", Assets.getBitmapData("img/cola_verre.png"), [ "cola"], 50));
					recipes.add(new Cocktail("Vodka Martini", Assets.getBitmapData("img/vodkamartini.png"), [ "vodka", "vermouth"], 100));
					recipes.add(new Cocktail("Screwdriver", Assets.getBitmapData("img/screwdriver.png"), [ "vodka", "orange"], 100));
			case 2:	recipes.add(new Cocktail("Daiquiri", null, [ "rhum", "sucre", "citron"], 150));
					recipes.add(new Cocktail("Cuba Libre", Assets.getBitmapData("img/cubalibre.png"), [ "rhum", "cola", "citron"], 100));
			case 3: recipes.add(new Cocktail("Piña Colada", null, [ "rhum", "ananas", "coco"], 150));
					recipes.add(new Cocktail("Tequila \nSunrise", null, [ "tequila", "orange", "grenadine"], 150));
			case 4: recipes.add(new Cocktail("Margarita", null, [ "tequila", "triplesec", "citron"], 150));
					recipes.add(new Cocktail("Bronx", null, [ "gin", "vermouth", "orange"], 150));
			case 6: recipes.add(new Cocktail("Gin Fizz", null, [ "gin", "sucre", "citron", "eau"], 200));
			case 7: recipes.add(new Cocktail("Mojito", null, [ "rhum", "sucre", "menthe", "citron", "eau"], 250));
			case 8: recipes.add(new Cocktail("Sex on the \nBeach", null, [ "vodka", "triplesec", "citron", "ananas", "grenadine"], 250));
			case 9: recipes.add(new Cocktail("Coco Loco", null, [ "tequila", "gin", "rhum", "ananas", "citron", "sucre", "coco"], 500));
			case 10: recipes.add(new Cocktail("Long Island \nIced Tea", null, [ "tequila", "gin", "rhum", "vodka", "triplesec", "citron", "sucre", "cola"], 600));
		}
	}
	
	private function new () {
		recipes = new FastList<Cocktail>();		
	}	
}