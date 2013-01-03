package fr.florajb.mariage;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;
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
	private var result: TextField;
	private var score: Int;
	private var startTime: Int;
	private var remainingTime: Int;
	private var lastCommandTime: Int;
	private var level: Int;
	private var objective: Int;
	private var scoreField: TextField;
	private var timerField: TextField;
	private var levelField: TextField;
	
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
		timerField = new TextField();
		levelField = new TextField();
		level = 1;
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
		removeEventListener(MouseEvent.CLICK, init);
		
		var bkg = new Bitmap(Assets.getBitmapData("img/Background.png"));
		addChild(bkg);
		
		var shakerSprite = new Sprite();
		shakerSprite.x = 300;
		shakerSprite.y = 25;
		var plank = new Bitmap(Assets.getBitmapData("img/BluePlank.png"));
		shakerSprite.addChild(plank);
		shaker = new Bitmap(Assets.getBitmapData("img/shaker.png"));
		shaker.x = 120;
		shaker.scaleX = shaker.scaleY = 0.3;
		shakerSprite.addChild(shaker);
		
		shakerSprite.addEventListener(MouseEvent.CLICK, onShakerClick);
		shakerSprite.buttonMode = true;
		addChild(shakerSprite);
		
		var textFormat: TextFormat = new TextFormat("_sans", 15, 0xFFFFFF);
		result = new TextField();
		result.selectable = result.mouseEnabled = false;
		result.defaultTextFormat = textFormat;
		result.x = result.y = 200;
		addChild(result);
		
		createBottles();
		
		var scoreFormat = new TextFormat("_sans", 17, 0xFF0000, false);
		
		levelField.defaultTextFormat = scoreFormat;
		levelField.selectable = levelField.mouseEnabled = false;
		levelField.x = 60;
		levelField.y = 35;
		levelField.text = "Niveau "+level;
		addChild(levelField);
		
		scoreField.defaultTextFormat = scoreFormat;
		scoreField.selectable = scoreField.mouseEnabled = false;
		scoreField.x = levelField.x;
		scoreField.y = levelField.y+ 30;
		addChild(scoreField);
		
		timerField.defaultTextFormat = scoreFormat;
		timerField.selectable = timerField.mouseEnabled = false;
		updateTimer();
		timerField.y = scoreField.y + 30;
		timerField.x = scoreField.x;
		addChild(timerField);
		
		startGame();
	}
	
	private function startGame() : Void 
	{
		startTime = Lib.getTimer();
		objective = 500 * level;
		updateScore();
		addCommand();
	}
	
	private function onShakerClick(e:MouseEvent):Void 
	{
		Actuate.tween(shaker, 0.05, { x: shaker.x + 10, y: shaker.y - 10 } ).repeat(5).reflect();
		
		for (command in currentCommands) {
			if (command.cocktail.equalsRecipe(ingredients)) {
				currentCommands.remove(command);
				validateCommand(command);
				break;
			}
		}
		
		result.text = "";
		clearIngredients();
	}
	
	private function validateCommand(command: Command) : Void 
	{
		var points = new TextField();
		var textFormat: TextFormat = new TextFormat("_sans", 15, 0xFFFFFF);
		points.defaultTextFormat = textFormat;
		points.selectable = points.mouseEnabled = false;
		points.text = "+" + command.points + "Pts";
		points.x = 250;
		points.y = 100;
		Actuate.tween(points, 3, { y: 50, alpha: 0 } );
		addChild(points);
		
		score += command.points;
		updateScore();
		
		Actuate.tween(command, 0.2, { x: Lib.current.stage.stageWidth } ).onComplete(removeChild, [command]);
		
		for (com in currentCommands) {
			if (com.y > command.y) {
				Actuate.tween(com, 0.9, { y: com.y-com.height-10 }, false );
			}
		}
		
		addCommand();
	}
	
	private function initCookbook():Void 
	{
		switch(level){
			case 1:	var bloody: Cocktail = new Cocktail("Bloody Mary", Assets.getBitmapData("img/bloodymary.png"), [ "vodka", "tomato" ]);
					var vodka: Cocktail = new Cocktail("Vodka", Assets.getBitmapData("img/bloodymary.png"), [ "vodka"]);
					cookbook.set("bloodymary", bloody);
					pointScale.set("bloodymary", 500);
					cookbook.set("vodka", vodka);
					pointScale.set("vodka", 100);
			case 2:	var pina: Cocktail = new Cocktail("Pina Colada", null, [ "rhum", "ananas", "coco"]);
					cookbook.set("pinacolada", pina);
					pointScale.set("pinacolada", 1000);
		}
	}
	
	private function addCommand() : Void 
	{
		lastCommandTime = Lib.getTimer();
		var numCommand = currentCommands.length;
		var command = new Command();
		command.x = Lib.current.stage.stageWidth;
		command.y = 50 + (numCommand*command.height + 10);
		currentCommands.add(command);
		Actuate.tween(command, 0.9, { x: Lib.current.stage.stageWidth - command.width } ).ease(Cubic.easeOut).delay(0.1);
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
		if (score >= objective)
			scoreField.defaultTextFormat = new TextFormat("_sans", 17, 0x00FF00, true);
		scoreField.text = "Score: " + score + "/" + objective;
		scoreField.width = scoreField.textWidth+10;
	}
	
	private function updateTimer() : Void 
	{
		timerField.text = remainingTime + "s";
	}
	
	private function onEnterFrame(e: Event) : Void 
	{
		remainingTime = 30 - Math.round((Lib.getTimer() - startTime) / 1000);
		updateTimer();
		if (remainingTime <= 0) {
			endLevel();
		}
		else if (Math.round((Lib.getTimer() - lastCommandTime)/1000) > 3) {
			if(currentCommands.length < level)
				addCommand();
		}
	}
	
	private function endLevel() : Void 
	{
		clearStage();
		clearCommands();
		clearIngredients();
		scoreField.y = Lib.current.stage.stageHeight / 2;
		addChild(scoreField);
		
		if (score >= objective) {
			level++;
			levelField.text = "Niveau "+level;
			initCookbook();
			addEventListener(MouseEvent.CLICK, init);
		}
		score = 0;
		
	}
	
	private function clearStage() : Void 
	{
		while (numChildren > 0)
			removeChildAt(numChildren - 1);
	}
	
	private function clearIngredients():Void 
	{
		while (ingredients.length != 0)
			ingredients.pop();
	}
	
	private function clearCommands():Void 
	{
		while (!currentCommands.isEmpty())
			currentCommands.pop();
	}
	
	private function createBottles():Void 
	{
		var vodka = BottleFactory.createBottle("vodka");
		vodka.setScale(0.3);
		vodka.addEventListener(MouseEvent.CLICK, onIngredientClick);
		addChild(vodka);
		
		var tomato = BottleFactory.createBottle("tomato");
		tomato.setScale(0.3);
		tomato.addEventListener(MouseEvent.CLICK, onIngredientClick);
		addChild(tomato);
		
		if (level > 1) {
			var rhum = BottleFactory.createBottle("rhum");
			rhum.addEventListener(MouseEvent.CLICK, onIngredientClick);
			addChild(rhum);
			
			var ananas = BottleFactory.createBottle("ananas");
			ananas.addEventListener(MouseEvent.CLICK, onIngredientClick);
			addChild(ananas);
			
			var coco = BottleFactory.createBottle("coco");
			coco.addEventListener(MouseEvent.CLICK, onIngredientClick);
			addChild(coco);
		}
	}
}
