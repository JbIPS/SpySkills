package fr.florajb.mariage;

import com.eclecticdesignstudio.motion.Actuate;
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

/**
 * ...
 * @author jbrichardet
 */

class Main extends Sprite 
{
	private var shaker: Bitmap;
	private var vodka: Bottle;
	private var tomato: Bottle;
	private var result: TextField;
	private var currentCommand: Command;
	public var ingredients: Array<String>;
	
	public static var cookbook: Hash<Array<String>>;
	
	public function new() 
	{
		super();
		ingredients = new Array<String>();
		cookbook = new Hash<Array<String>>();
		initCookbook();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
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
		result.defaultTextFormat = textFormat;
		result.x = result.y = 200;
		addChild(result);
		
		vodka = new Bottle("vodka", new Bitmap(Assets.getBitmapData("img/vodka.png")));
		vodka.scale = 0.5;
		vodka.y = 300;
		vodka.x = 100;
		addEventListener(MouseEvent.CLICK, onIngredientClick);
		addChild(vodka);
		
		tomato = new Bottle("tomato", new Bitmap(Assets.getBitmapData("img/tomato.png")));
		tomato.scale = 0.5;
		tomato.x = tomato.y = 300;
		addEventListener(MouseEvent.CLICK, onIngredientClick);
		addChild(tomato);
		
		startGame();
	}
	
	private function startGame() : Void 
	{
		var command = new Command();
		command.x = Lib.current.stage.stageWidth;
		command.y = 50;
		currentCommand = command;
		Actuate.tween(command, 0.9, { x: Lib.current.stage.stageWidth - command.width } ).delay(1);
		addChild(command);
	}
	
	private function onShakerClick(e:MouseEvent):Void 
	{
		e.stopImmediatePropagation();
		Actuate.tween(shaker, 0.05, { x: shaker.x + 10, y: shaker.y - 10 } ).repeat(5).reflect();
		
		if (ArrayTools.equalsArray(ingredients, cookbook.get("bloodymary"))) {
			addChild(new Bitmap(Assets.getBitmapData("img/bloodymary.png")));
			earnPoint(500);
		}
	}
	
	private function earnPoint(nbPoint: Int) : Void 
	{
		var points = new TextField();
		var textFormat: TextFormat = new TextFormat("_sans", 15, 0xFFFFFF);
		points.defaultTextFormat = textFormat;
		points.text = "+" + nbPoint + "Pts";
		points.x = 250;
		points.y = 100;
		Actuate.tween(points, 3, { y: 50, alpha: 0 } );
		addChild(points);
		Actuate.tween(currentCommand, 0.9, { x: Lib.current.stage.stageWidth } );
	}
	
	private function initCookbook():Void 
	{
		cookbook.set("bloodymary",[ "vodka", "tomato" ]);
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
	private function onIngredientClick(e: MouseEvent) : Void 
	{
		var ingredient = cast(e.target, Bottle).name;
		if(!ArrayTools.contains(ingredients, ingredient))
			ingredients.push(ingredient);
		result.text = ingredients.join(" + ");
		
	}
	
}
