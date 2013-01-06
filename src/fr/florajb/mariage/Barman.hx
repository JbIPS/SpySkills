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
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.Lib;
import nme.media.SoundChannel;
import nme.media.SoundTransform;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.ui.Keyboard;

/**
 * ...
 * @author jbrichardet
 */

class Barman extends Sprite 
{	
	private var shaker: Bitmap;
	private var score: Int;
	private var startTime: Int;
	private var remainingTime: Int;
	private var lastCommandTime: Int;
	private var level: Int = 1;
	private var objective: Int;
	private var maxCommand: Int = 1;
	private var scoreField: TextField;
	private var timerField: TextField;
	private var levelField: TextField;
	private var paused: Bool = false;
	private var pauseTime: Int;
	
	private var ingredients: Array<Bottle>;
	private var currentCommands: List<Command>;
	private var soundChannel: SoundChannel;
	
	private var event:Event;
	public function new() 
	{
		super();
		ingredients = new Array<Bottle>();
		currentCommands = new List<Command>();
		scoreField = new TextField();
		timerField = new TextField();
		levelField = new TextField();
		initCookbook();
		
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		addEventListener(Event.DEACTIVATE, onSpace);
		addEventListener(Event.ACTIVATE, onSpace);
		addEventListener(MouseEvent.CLICK, cheat);
		InterLevel.instance.startMethod = startProxy;
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
		shaker.x = 160;
		shaker.y = 10;
		shaker.scaleX = shaker.scaleY = 0.85;
		shakerSprite.addChild(shaker);
		
		shakerSprite.addEventListener(MouseEvent.CLICK, onShakerClick);
		shakerSprite.buttonMode = true;
		addChild(shakerSprite);
		
		var scoreFormat = new TextFormat("_sans", 17, 0xFF0000, false);
		
		levelField.defaultTextFormat = scoreFormat;
		levelField.selectable = levelField.mouseEnabled = false;
		levelField.x = 60;
		levelField.y = 35;
		levelField.text = "Niveau "+level;
		addChild(levelField);
		
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
		
		startLevel();
	}
	
	private function cheat(e:MouseEvent):Void 
	{
		if(e.altKey){
			score = objective;
			updateScore();
			endLevel();
		}
	}
	
	private function onSpace(e:Event) : Void 
	{
		setPause(!paused);
	}
	
	private function startLevel() : Void 
	{
		if(level > 1)
			removeChild(InterLevel.instance);
		setPause(false);
		startTime = Lib.getTimer();
		objective = 500 * level;
		
		scoreField.defaultTextFormat = new TextFormat("_sans", 17, 0xFF0000, false);
		updateScore();
		
		initLevel();
		var loop = Assets.getSound("sfx/loop.mp3");
		soundChannel = loop.play();
		var soundTransform = new SoundTransform(0.15);
		soundChannel.soundTransform = soundTransform;
		
		addCommand();
	}
	
	private function onShakerClick(e:MouseEvent):Void 
	{
		Actuate.tween(shaker, 0.05, { x: shaker.x + 10, y: shaker.y - 10 } ).repeat(5).reflect();
		
		for (command in currentCommands) {
			if (command.cocktail.equalsRecipe(bottleToString(ingredients))) {
				currentCommands.remove(command);
				validateCommand(command);
				break;
			}
		}
		Assets.getSound("sfx/shaker.mp3").play();
		clearIngredients();
	}
	
	private function validateCommand(command: Command) : Void 
	{
		var points = new TextField();
		var textFormat: TextFormat = new TextFormat("_sans", 15, 0xFFFFFF);
		points.defaultTextFormat = textFormat;
		points.selectable = points.mouseEnabled = false;
		points.text = "+" + command.points + "Pts";
		points.x = 350;
		points.y = 80;
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
		
		if(currentCommands.isEmpty())
			addCommand();
	}
	
	private function initCookbook():Void 
	{ 
		Cookbook.instance.setLevel(level);
	}
	
	private function addCommand() : Void 
	{
		lastCommandTime = Lib.getTimer();
		var numCommand = currentCommands.length;
		var command = new Command();
		command.x = Lib.current.stage.stageWidth;
		command.y = 50 + (numCommand*command.height + 10);
		currentCommands.add(command);
		Actuate.tween(command, 0.9, { x: Lib.current.stage.stageWidth - command.width + 5 } ).ease(Cubic.easeOut).delay(0.1);
		addChild(command);
	}
	
	private function onIngredientClick(e: MouseEvent) : Void 
	{
		var ingredient = cast(e.target, Bottle);
		if(ingredient.used){
			ingredients.remove(ingredient);
			ingredient.used = false;
		}
		else{
			ingredients.push(ingredient);
			ingredient.used = true;
		}
		
	}
	
	private function updateScore() : Void 
	{
		if (score >= objective){
			scoreField.defaultTextFormat = new TextFormat("_sans", 17, 0x00FF00, true);
		}
		scoreField.text = "Score: " + score + "/" + objective;
		scoreField.width = scoreField.textWidth+10;
	}
	
	private function updateTimer() : Void 
	{
		timerField.text = remainingTime + "s";
	}
	
	private function onEnterFrame(e: Event) : Void 
	{
		if (paused)
			return;
			
		remainingTime = 90 - Math.round((Lib.getTimer() - startTime) / 1000);
		updateTimer();
		if (remainingTime <= 0) {
			endLevel();
		}
		else if (Math.round((Lib.getTimer() - lastCommandTime)/1000) > 3) {
			if(currentCommands.length < maxCommand)
				addCommand();
		}
	}
	
	private function endLevel() : Void 
	{
		setPause(true);
		soundChannel.stop();
		InterLevel.instance.score = score;
		addChild(InterLevel.instance);
		clearCommands();
		clearIngredients();
		
		if (score >= objective) {
			level++;
			levelField.text = "Niveau "+level;
			initCookbook();
		}
		score = 0;
		
	}
	
	private function startProxy(e:MouseEvent) : Void
	{
		startLevel();
	}
	
	private function clearStage() : Void 
	{
		while (numChildren > 0)
			removeChildAt(numChildren - 1);
	}
	
	private function clearIngredients():Void 
	{
		while (ingredients.length != 0){
			var ingredient = ingredients.pop();
			ingredient.used = false;
		}
	}
	
	private function clearCommands():Void 
	{
		while (!currentCommands.isEmpty())
			removeChild(currentCommands.pop());
	}
	
	private function initLevel():Void 
	{		
		switch(level){
			case 1:	createIngredient("vodka");
					createIngredient("orange");
					createIngredient("cola");
					createIngredient("vermouth");
					createIngredient("ananas");
			case 2:	maxCommand++;
					createIngredient("rhum");
					createIngredient("citron");
					createIngredient("sucre");
			case 3:	createIngredient("coco");
					createIngredient("tequila");
					createIngredient("grenadine");
			case 4:	createIngredient("gin");
					createIngredient("triplesec");
			case 5:	maxCommand++;
			case 7:	createIngredient("menthe");
		}
	}
	
	private function createIngredient(name: String)
	{
		var ingredient = BottleFactory.createBottle(name);
		ingredient.addEventListener(MouseEvent.CLICK, onIngredientClick);
		addChild(ingredient);
	}
	
	private function bottleToString(array: Array<Bottle>) : Array<String>
	{
		var stringArray = new Array<String>();
		for(bottle in array)
			stringArray.push(bottle.name);
		
		return stringArray;
	}
	
	private function setPause(pause: Bool) : Void 
	{
		paused = pause;
		if (pause) {
			pauseTime = Lib.getTimer();
			removeEventListener(Event.DEACTIVATE, onSpace);
			addEventListener(Event.ACTIVATE, onSpace);
		}
		else {
			startTime += Lib.getTimer() - pauseTime;
			addEventListener(Event.DEACTIVATE, onSpace);
			removeEventListener(Event.ACTIVATE, onSpace);
		}
	}
}