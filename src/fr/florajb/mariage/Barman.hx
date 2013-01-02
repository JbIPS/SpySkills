package fr.florajb.mariage;

import com.eclecticdesignstudio.motion.Actuate;
import haxe.FastList;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author jbrichardet
 */

class Barman extends Sprite 
{
	public static var cookbook: Hash<Cocktail>;
	public static var pointScale: Hash<Int>;
	
	private var shaker: Bitmap;
	private var vodka: Bottle;
	private var tomato: Bottle;
	private var result: TextField;
	private var score: Int;
	private var scoreField: TextField;
	private var startTime: Int;
	private var elapsedTime: Float;
	
	private var ingredients: Array<String>;
	private var currentCommands: List<Command>;
	
	
	public function new() 
	{
		super();
		ingredients = new Array<String>();
		cookbook = new Hash<Cocktail>();
		currentCommands = new List<Command>();
		pointScale = new Hash<Int>();
		scoreField = new TextField();
		initCookbook();
		
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function init(e: Event) 
	{
		shaker = new Bitmap(Assets.getBitmapData("img/shaker.png"));
		shaker.scaleX = shaker.scaleY = 0.5;
		var shakerSprite = new Sprite();
		shakerSprite.addChild(shaker);
		shakerSprite.addEventListener(MouseEvent.CLICK, onShakerClick);
		addChild(shakerSprite);
		
		var textFormat: TextFormat = new TextFormat("_sans", 15, 0xFFFFFF);
		result = new TextField();
		result.selectable = result.mouseEnabled = false;
		result.defaultTextFormat = textFormat;
		result.x = result.y = 200;
		addChild(result);
		
		vodka = new Bottle("vodka", new Bitmap(Assets.getBitmapData("img/vodka.png")));
		vodka.scale = 0.5;
		vodka.y = 300;
		vodka.x = 100;
		vodka.addEventListener(MouseEvent.CLICK, onIngredientClick);
		addChild(vodka);
		
		tomato = new Bottle("tomato", new Bitmap(Assets.getBitmapData("img/tomato.png")));
		tomato.scale = 0.5;
		tomato.x = tomato.y = 300;
		tomato.addEventListener(MouseEvent.CLICK, onIngredientClick);
		addChild(tomato);
		
		scoreField.defaultTextFormat = new TextFormat(17, 0xFFFFFF, TextFormatAlign.CENTER);
		scoreField.selectable = scoreField.mouseEnabled = false;
		updateScore();
		scoreField.width = Lib.current.stage.stageWidth;
		addChild(scoreField);
		
		startGame();
	}
	
	private function startGame() : Void 
	{
		startTime = Lib.getTimer();
		addCommand();
	}
	
	private function onShakerClick(e:MouseEvent):Void 
	{
		Actuate.tween(shaker, 0.05, { x: shaker.x + 10, y: shaker.y - 10 } ).repeat(5).reflect();
		
		for (command in currentCommands) {
			if (command.cocktail.equalsRecipe(ingredients)) {
				//addChild(command.cocktail.icon);
				currentCommands.remove(command);
				validateCommand(command);
			}
		}
		
		result.text = "";
		while (ingredients.length != 0)
			ingredients.pop();
	}
	
	private function validateCommand(command: Command) : Void 
	{
		var points = new TextField();
		var textFormat: TextFormat = new TextFormat("_sans", 15, 0xFFFFFF);
		points.defaultTextFormat = textFormat;
		points.text = "+" + command.points + "Pts";
		points.x = 250;
		points.y = 100;
		Actuate.tween(points, 3, { y: 50, alpha: 0 } );
		addChild(points);
		
		score += command.points;
		updateScore();
		
		Actuate.tween(command, 0.9, { x: Lib.current.stage.stageWidth } );
		
		addCommand();
	}
	
	private function initCookbook():Void 
	{
		var bloody: Cocktail = new Cocktail("Bloody Mary", new Bitmap(Assets.getBitmapData("img/bloodymary.png")), [ "vodka", "tomato" ]);
		var vodka: Cocktail = new Cocktail("Vodka", new Bitmap(Assets.getBitmapData("img/bloodymary.png")), [ "vodka"]);
		
		cookbook.set("bloodymary", bloody);
		pointScale.set("bloodymary", 500);
		cookbook.set("vodka", vodka);
		pointScale.set("vodka", 100);
	}
	
	private function addCommand() : Void 
	{
		var numCommand = currentCommands.length;
		var command = new Command();
		command.x = Lib.current.stage.stageWidth;
		command.y = 50 + (numCommand*command.height + 10);
		currentCommands.add(command);
		Actuate.tween(command, 0.9, { x: Lib.current.stage.stageWidth - command.width } ).delay(0.1);
		addChild(command);
	}
	
	private function onIngredientClick(e: MouseEvent) : Void 
	{
		var ingredient = cast(e.target, Bottle).name;
		if(!ArrayTools.contains(ingredients, ingredient))
			ingredients.push(ingredient);
		result.text = ingredients.join(" + ");
		result.width = result.textWidth+10;
		
	}
	
	private function updateScore() : Void 
	{
		scoreField.text = "Score: " + score;
	}
	
	private function onEnterFrame(e: Event) : Void 
	{
		elapsedTime = (Lib.getTimer() - startTime) / 1000;
		if (elapsedTime > 30) {
			//Fin
			while (numChildren > 0)
				removeChildAt(numChildren - 1);
			scoreField.y = Lib.current.stage.stageHeight / 2;
			addChild(scoreField);
		}
	}
}
