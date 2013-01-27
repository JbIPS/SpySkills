package fr.florajb.mariage;
import com.eclecticdesignstudio.motion.Actuate;
import haxe.Timer;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.media.SoundChannel;
import nme.media.SoundTransform;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author jb
 */

class InterLevel extends Sprite
{
	
	public var score (default, setScore): Int;
	public var startMethod: Dynamic -> Void;
	
	private var totalScore: Int = 0;
	private var continueButton: SimpleButton;
	private var totalScoreField: TextField;
	private var scoreField: TextField;
	private var soundChannel: SoundChannel;
	private var cookFormat: TextFormat;
	private var titleFormat: TextFormat;
	private var bookSprite: Sprite;
	
	public function setScore(score: Int) : Int 
	{
		this.score = score;
		scoreField.text = "Level: "+score + "pts";
		totalScore += score;
		totalScoreField.text ="Total: "+ totalScore + "pts";
		return score;
	}
	
	private function setMenu() : Void 
	{
		var menu = new Sprite();
		menu.addChild(new Bitmap(Assets.getBitmapData("img/menu.png")));
		menu.y = height - menu.height;
		menu.x = 260;
		
		var title = new TextField();
		title.embedFonts = true;
		title.defaultTextFormat = new TextFormat(Assets.getFont("font/bebas.ttf").fontName, 50, TextFormatAlign.CENTER);
		title.text = "Menu";
		title.width = menu.width;
		title.y = 55;
		menu.addChild(title);
		
		var newIcon = new Bitmap(Assets.getBitmapData("img/b_newgame.png"));
		var newButton = new SimpleButton(newIcon, newIcon, newIcon, newIcon);
		newButton.x = 140;
		newButton.y = 180;
		newButton.addEventListener(MouseEvent.CLICK, startMethod);
		menu.addChild(newButton);
		
		var instrIcon = new Bitmap(Assets.getBitmapData("img/b_instructions.png"));
		var instrButton = new SimpleButton(instrIcon, instrIcon, instrIcon, instrIcon);
		instrButton.x = newButton.x;
		instrButton.y = newButton.y + 80;
		menu.addChild(instrButton);
		
		var optionsIcon = new Bitmap(Assets.getBitmapData("img/b_options.png"));
		var optionsButton = new SimpleButton(optionsIcon, optionsIcon, optionsIcon, optionsIcon);
		optionsButton.x = instrButton.x;
		optionsButton.y = instrButton.y + 80;
		menu.addChild(optionsButton);
		
		addChild(menu);
	}
	
	public function new(type: String, ?startMethod: Dynamic -> Void) 
	{
		super();
		
		addChild(new Bitmap(Assets.getBitmapData("img/menubackground.png")));
		this.startMethod = startMethod;
		cookFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 15);
		titleFormat = new TextFormat(Assets.getFont("font/bebas.ttf").fontName, 20, TextFormatAlign.CENTER);
		
		if (type == "interlevel")
			setInterlevel();
		else if(type == "menu"){
			setMenu();
		}
		else{
			setCookBook();
		}
	}
	
	public function update(level: Int) : Void 
	{
		while (bookSprite.numChildren > 1)
			bookSprite.removeChildAt(bookSprite.numChildren - 1);
		bookSprite.addChild(upgradeIngredients(level));
		bookSprite.addChild(upgradeRecipes(level));
	}
	
	private function setCookBook() : Void 
	{
		var cookbook = new Bitmap(Assets.getBitmapData("img/open-book.png"));
		cookbook.x = width - cookbook.width;
		cookbook.y = height - cookbook.height;
		addChild(cookbook);
	}
	
	private function onRemove(e:Event):Void 
	{
		soundChannel.stop();
		continueButton.enabled = continueButton.useHandCursor = false;
		continueButton.removeEventListener(MouseEvent.CLICK, startMethod);
	}
	
	private function onAdd(e:Event):Void 
	{
		var loop = Assets.getSound("sfx/interlevel.mp3");
		soundChannel = loop.play();
		var soundTransform = new SoundTransform(0.25);
		soundChannel.soundTransform = soundTransform;
	}
	
	private function setInterlevel():Void 
	{	
		// Score
		var textFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 22, 0x00FF00, true);
		scoreField = new TextField();
		scoreField.embedFonts = true;
		scoreField.defaultTextFormat = textFormat;
		scoreField.selectable = scoreField.mouseEnabled = false;
		
		totalScoreField = new TextField();
		totalScoreField.embedFonts = true;
		totalScoreField.defaultTextFormat = textFormat;
		totalScoreField.selectable = totalScoreField.mouseEnabled = false;
		
		setScore(0);
		scoreField.autoSize = TextFieldAutoSize.CENTER;
		scoreField.x = 10;
		scoreField.y = 400;
		addChild(scoreField);
		
		totalScoreField.autoSize = TextFieldAutoSize.CENTER;
		totalScoreField.x = 10;
		totalScoreField.y = 450;
		addChild(totalScoreField);
		
		// Upgrades
		bookSprite = new Sprite();
		var cookbook = new Bitmap(Assets.getBitmapData("img/open-book.png"));
		bookSprite.x = width - cookbook.width;
		bookSprite.y = height - cookbook.height;
		bookSprite.addChild(cookbook);
		
		update(0);
		
		addChild(bookSprite);
		
		addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		addEventListener(Event.ADDED_TO_STAGE, onAdd);
	}
	
	private function displayIngredient(name: String) : Sprite 
	{
		var ingredient = new Sprite();
		var icon = new Bitmap(Assets.getBitmapData("img/" + name + ".png"));
		if(name != "menthe" && name != "citron" && name != "coco")
			icon.scaleX = icon.scaleY = 70 / icon.height;
		var tf = new TextField();
		tf.embedFonts = true;
		tf.defaultTextFormat = cookFormat;
		tf.text = setTitleCase(name);
		tf.x = icon.width + 20;
		tf.selectable = tf.mouseEnabled = false;
		ingredient.addChild(icon);
		ingredient.addChild(tf);
		
		return ingredient;		
	}
	
	private function displayCocktail(cocktail: Cocktail) : Sprite 
	{
		var cocktailSprite = new Sprite();
		var icon = new Bitmap(cocktail.icon);
		var tf = new TextField();
		tf.embedFonts = true;
		tf.defaultTextFormat = cookFormat;
		var reg : EReg = ~/\n/g;
		tf.text = reg.replace(cocktail.name, "");
		for (ing in cocktail.recipe)
			tf.text += "\n\t- " + setTitleCase(ing);
		tf.x = icon.width + 20;
		tf.width = tf.textWidth+10;
		tf.height = tf.textHeight;
		tf.selectable = tf.mouseEnabled = false;
		cocktailSprite.addChild(icon);
		cocktailSprite.addChild(tf);
		
		return cocktailSprite;		
	}
	
	private function setTitleCase(name: String):String 
	{
		return name.charAt(0).toUpperCase() + name.substr(1);
	}
	
	private function upgradeRecipes(level: Int):Sprite 
	{
		var sprite = new Sprite();
		var newRecipes = LevelManager.getNewRecipes(level);
		if (Lambda.count(newRecipes) == 0)
			return sprite;

		var recipes = new TextField();
		recipes.embedFonts = true;
		recipes.defaultTextFormat = titleFormat;
		recipes.text = Lambda.count(newRecipes) > 1 ? "Nouveaux cocktails" : "Nouveau cocktail";
		recipes.width = bookSprite.width / 2;
		recipes.x = bookSprite.width / 2;
		recipes.y = 65;
		recipes.selectable = recipes.mouseEnabled = false;
		sprite.addChild(recipes);
		
		var yOffset: Float = 120;
		var xOffset: Float = 50 + bookSprite.width /2;
		for (recipe in newRecipes) {
			var rec = displayCocktail(recipe);
			rec.x = xOffset;
			rec.y = yOffset + 5;
			yOffset += rec.height;
			sprite.addChild(rec);
		}
		return sprite;
	}
	
	private function upgradeIngredients(level: Int):Sprite 
	{
		var sprite = new Sprite();
		var newIngredients = LevelManager.getNewIngredients(level);
		
		if(Lambda.count(newIngredients) > 0){
			var ingredients = new TextField();
			ingredients.embedFonts = true;
			ingredients.defaultTextFormat = titleFormat;
			ingredients.text = Lambda.count(newIngredients) > 1 ? "Nouveaux Ingredients" : "Nouvel Ingredient";
			ingredients.width = bookSprite.width / 2 ;
			ingredients.y = 65;
			ingredients.selectable = ingredients.mouseEnabled = false;
			sprite.addChild(ingredients);
			
			var yOffset: Float = 120;
			var xOffset: Float = 70;
			for (ingredient in newIngredients) {
				var ing = displayIngredient(ingredient);
				ing.x = xOffset;
				ing.y = yOffset + 15;
				yOffset += ing.height;
				sprite.addChild(ing);
			}
		}
		return sprite;
	}
	
	
	
	
	
}