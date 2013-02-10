package fr.florajb.mariage;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.MouseEvent;
import nme.filters.DropShadowFilter;
import nme.Lib;
import nme.media.SoundChannel;
import nme.media.SoundTransform;
import nme.net.SharedObject;
import nme.net.SharedObjectFlushStatus;
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
	private var shakerSprite: Sprite;
	private var score: Int;
	private var startTime: Int;
	private var remainingTime: Int;
	private var lastCommandTime: Int;
	private var level: Int = 1;
	private var objective: Int;
	private var scoreField: TextField;
	private var timerField: TextField;
	private var levelField: TextField;
	private var paused: Bool = false;
	private var pauseTime: Int;
	private var interLevel: InterLevel;
	private var highScore: SharedObject;
	
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
		scoreField.embedFonts = true;
		timerField = new TextField();
		timerField.embedFonts = true;
		levelField = new TextField();
		levelField.embedFonts = true;
		
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		addEventListener(Event.DEACTIVATE, onSpace);
		addEventListener(Event.ACTIVATE, onSpace);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, cheat);
		interLevel = new InterLevel("interlevel", startProxy);
		EndScreen.instance.onContinue = restartLevel;
		EndScreen.instance.onRestart = restartGame;
		
	}

	private function init(e: Event) 
	{
		highScore = SharedObject.getLocal( "storage-test" );
		Lib.trace("highScore: " + highScore.data.meesage);
		
		removeEventListener(MouseEvent.CLICK, init);
		
		var bkg = new Bitmap(Assets.getBitmapData("img/Background.png"));
		addChild(bkg);
		
		shakerSprite = new Sprite();
		shakerSprite.x = 400;
		shakerSprite.y = 25;
		var plank = new Bitmap(Assets.getBitmapData("img/BluePlank.png"));
		shakerSprite.addChild(plank);
		shaker = new Bitmap(Assets.getBitmapData("img/shaker.png"));
		shaker.x = 36;
		shaker.y = 15;
		shaker.scaleX = shaker.scaleY = 0.85;
		shakerSprite.addChild(shaker);
		shakerSprite.filters = [new DropShadowFilter(5, 135, 0, 0.5, 10)];
		
		shakerSprite.addEventListener(MouseEvent.MOUSE_DOWN, onShakerClick);
		shakerSprite.addEventListener(MouseEvent.MOUSE_UP, onShakerClickEnd);
		shakerSprite.buttonMode = true;
		addChild(shakerSprite);
		
		var scoreFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 17, 0xFF0000, false);
		
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
		
		var recipeIcon = new Bitmap(Assets.getBitmapData("img/book.png"));
		var recipeButton = new SimpleButton(recipeIcon, recipeIcon, recipeIcon, recipeIcon);
		recipeButton.addEventListener(MouseEvent.CLICK, onRecipe);
		recipeButton.x = width - recipeIcon.width;
		recipeButton.y = height - recipeButton.height;
		addChild(recipeButton);
		
		startLevel();
	}
	
	private function cheat(e:KeyboardEvent):Void 
	{
		if(e.keyCode == Keyboard.SPACE){
			score = objective;
			updateScore();
			endLevel();
		}
		else if (e.keyCode == Keyboard.A){
			endLevel();
		}
	}
	
	private function onSpace(e:Event) : Void 
	{
		setPause(!paused);
	}
	
	private function onRecipe(e: MouseEvent) : Void 
	{
		setPause(true);
		addChild(new InterLevel("cookbook", removeRecipe));
	}
	
	private function removeRecipe(e: MouseEvent) : Void 
	{
		setPause(false);
		removeChildAt(numChildren - 1);
	}
	
	private function startLevel(restart: Bool = false) : Void 
	{
		setPause(false);
		clearCommands();
		clearIngredients();
		
		if(!restart){
			if(level > 1)
				removeChild(interLevel);
			initLevel();
			initCookbook();
		}
		
		startTime = Lib.getTimer();
		objective = 500 * level;
		
		scoreField.defaultTextFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 17, 0xFF0000, false);
		score = 0;
		updateScore();
		
		var loop = Assets.getSound("sfx/loop.mp3");
		soundChannel = loop.play();
		var soundTransform = new SoundTransform(0.15);
		soundChannel.soundTransform = soundTransform;
		
		addCommand();
	}
	
	private function onShakerClick(e:MouseEvent):Void 
	{
		shakerSprite.filters = [new DropShadowFilter(4, 135, 0, 0.4, 5)];
		Actuate.tween(shaker, 0.05, { x: shaker.x + 10, y: shaker.y - 10 } ).repeat(5).reflect();
		var correct = false;
		
		for (command in currentCommands) {
			if (command.cocktail.equalsRecipe(bottleToString(ingredients))) {
				currentCommands.remove(command);
				correct = true;
				validateCommand(command);
				Assets.getSound("sfx/shaker.mp3").play();
				break;
			}
		}
		if (!correct)
			Assets.getSound("sfx/shaker_wrong.mp3").play();
		clearIngredients();
	}
	
	private function onShakerClickEnd(e:MouseEvent):Void 
	{
		shakerSprite.filters = [new DropShadowFilter(5, 135, 0, 0.5, 10)];
	}
	
	private function validateCommand(command: Command) : Void 
	{
		var points = new TextField();
		points.embedFonts = true;
		var textFormat: TextFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 15, 0xFFFFFF);
		points.defaultTextFormat = textFormat;
		points.selectable = points.mouseEnabled = false;
		points.text = "+" + command.points + "Pts";
		points.x = shakerSprite.x;
		points.y = shakerSprite.y;
		Actuate.tween(points, 3, { y: y-10, alpha: 0 } ).ease(Cubic.easeOut);
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
		command.y = 5+ (numCommand * (command.height+10));
		currentCommands.add(command);
		Actuate.tween(command, 0.9, { x: Lib.current.stage.stageWidth - command.width + 30 } ).ease(Cubic.easeOut).delay(0.1);
		addChild(command);
	}
	
	private function onIngredientClick(e: MouseEvent) : Void 
	{
		var ingredient = cast(e.target, Bottle);
		if(ingredient.used){
			ingredients.remove(ingredient);
		}
		else{
			ingredients.push(ingredient);
		}
		ingredient.used = !ingredient.used;
		
	}
	
	private function updateScore() : Void 
	{
		if (score >= objective){
			scoreField.defaultTextFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 17, 0x00FF00, true);
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
			if (currentCommands.length < LevelManager.getMaxCommand(level))
				addCommand();
		}
	}
	
	private function endLevel() : Void 
	{
		soundChannel.stop();
		
		if (score >= objective) {
			setPause(true);
			if (level == 10) {
				var black = new Sprite();
				black.graphics.beginFill(0x000000);
				black.graphics.drawRect(0, 0, width, height);
				black.graphics.endFill();
				addChild(black);
				addChild(new Bitmap(Assets.getBitmapData("img/canon.png")));
				var tf = new TextField();
				tf.embedFonts = true;
				tf.defaultTextFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 17, 0xFF0000, true, TextFormatAlign.CENTER);
				tf.text = " Félicitations, vous maitrisez vos cocktails";
				tf.text += "\n\n score : " + interLevel.totalScore;
				tf.width = Lib.current.stage.stageWidth;
				tf.selectable = tf.mouseEnabled = false;
				tf.y = 200;
				addChild(tf);
				
				var submitSprite = new Sprite();
				var submit = new TextField();
				submit.embedFonts = true;
				submit.defaultTextFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 17, 0xFF0000, true);
				submit.text = "Soumettre";
				submit.selectable = false;
				submit.y = 300;
				submit.x = 300;
				submit.height = submit.textHeight + 10;
				submitSprite.addChild(submit);
				submitSprite.mouseChildren = false;
				submitSprite.buttonMode = submitSprite.useHandCursor = true;
				submitSprite.addEventListener(MouseEvent.CLICK, onSubmit);
				addChild(submitSprite);
				
				var restartSprite = new Sprite();
				var restart = new TextField();
				restart.embedFonts = true;
				restart.defaultTextFormat = new TextFormat(Assets.getFont("font/blue_highway.ttf").fontName, 17, 0xFF0000, true);
				restart.text = "Rejouer";
				restart.selectable = false;
				restart.y = 300;
				restart.x = 450;
				restart.height = restart.textHeight + 10;
				restartSprite.addChild(restart);
				restartSprite.mouseChildren = false;
				restartSprite.buttonMode = restartSprite.useHandCursor = true;			
				restartSprite.addEventListener(MouseEvent.CLICK, restartGame);
				addChild(restartSprite);
			}
			else{
				level++;
				interLevel.score = score;
				interLevel.update(level);
				addChild(interLevel);
				levelField.text = "Niveau "+level;
				score = 0;				
			}
		}
		else{
			endGame();
		}
		
	}
	
	private function onSubmit(e: MouseEvent) : Void 
	{
		highScore.data.message = interLevel.totalScore;
		#if ( cpp || neko )
			var flushStatus:SharedObjectFlushStatus = null;
		#else
			var flushStatus:String = null;
		#end
		
		try {
			flushStatus = highScore.flush() ;
			Lib.trace("Ok. "+highScore.data.message);
		} catch ( e: Dynamic ) {
			Lib.trace("Impossible to write highscore");
		}
		restartGame(null);
	}
	
	private function startProxy(e:MouseEvent) : Void
	{
		startLevel();
	}
	
	private function setStageVisible(visible: Bool) : Void 
	{
		for (i in 0...numChildren) {
			getChildAt(i).visible = visible;
		}
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
		for (ingredient in LevelManager.getNewIngredients(level)) {
			createIngredient(ingredient);
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
	
	private function endGame():Void 
	{
		setStageVisible(false);
		setPause(true);
		addChild(EndScreen.instance);
	}
	
	private function restartLevel(e: MouseEvent) : Void 
	{
		setStageVisible(true);
		removeChild(EndScreen.instance);
		startLevel(true);
	}
	
	private function restartGame(e: MouseEvent) : Void 
	{
		Lib.current.removeChild(this);
		Cookbook.instance.empty();
		dispatchEvent(new Event(Event.COMPLETE));
	}
}