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
			case 2:	recipes.add(new Cocktail("Pina Colada", null, [ "rhum", "ananas", "coco"], 150));
		}
	}
	
	private function new () {
		recipes = new FastList<Cocktail>();		
	}	
}

/*3. Cola = Cola
4. Vodka Martini = Vodka + Vermouth
5. Screwdriver = Vodka + Orange
6. Daiquiri = Rhum + Sucre + Citron
7. Cuba Libre = Rhum + Cola
8. Piña Colada = Rhum + Ananas + Coco
9. Tequila Sunrise = Tequila + Orange + Grenadine
10. Margarita = Tequila+ Triple sec + Citron
11. Bronx = Gin + Vermouth + Orange
12. Gin Fizz = Gin + Sucre + Citron + Eau gazeuse
13. Mojito = Rhum + Sucre + Menthe + Citron + Eau gazeuse
14. Sex on the Beach = Vodka + Triple sec + Citron + Ananas + Grenadine
15. Coco Loco = Tequila + Gin + Rhum + Ananas + Citron + Sucre + Coco
16. Long Island Iced Tea = Tequila + Gin + Rhum + Vodka + Triple sec + Cola + Sucre + Citron

Niveaux
Niveau 1
• 1 Planche
• Ingrédients :
o Ananas
o Orange
Jus d’orange
Jus d’ananas
Cola
Vodka Martini
Screwdriver

o
o
o
o
o

Niveau 2
• 2 Planches
• Ingrédients supplémentaires :
o Rhum
o Citron
o Sucre
• Cocktails appris :
o Daiquiri
o Cuba Libre

Niveau 3
• 2 Planches
• Ingrédients supplémentaires :
o Coco
o Tequila
o Grenadine
• Cocktails appris :
o Piña Colada
o Tequila Sunrise*/
