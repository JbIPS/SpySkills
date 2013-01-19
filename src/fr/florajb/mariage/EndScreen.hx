package fr.florajb.mariage;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author jb
 */

class EndScreen extends Sprite
{
	public static var instance (getInstance, null): EndScreen;
	
	public dynamic function onContinue(e: MouseEvent) : Void { }
	public dynamic function onRestart(e: MouseEvent) : Void { }
	
	private var lives: Int = 2;
	
	public static function getInstance() : EndScreen
	{
		if (instance == null)
			instance = new EndScreen();
		return instance;
	}
	
	private function new() 
	{
		super();
		
		addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		addEventListener(Event.ADDED_TO_STAGE, onAdd);
	}
	
	private function onAdd(e:Event):Void 
	{
		visible = true;
		addChild(new Bitmap(Assets.getBitmapData("img/canon.png")));
		var blood = new Bitmap(Assets.getBitmapData("img/blood.png"));
		blood.y = -blood.height;
		blood.alpha = 0.5;
		Actuate.tween(blood, 4, {y: 0}).ease(Cubic.easeOut).onComplete(checkContinue);
		addChild(blood);
		
	}
	
	private function onRemove(e:Event):Void 
	{
		visible = false;
		while (numChildren > 0)
			removeChildAt(numChildren - 1);
	}
	
	private function checkContinue() : Void 
	{
		var format = new TextFormat("_sans", 25, 0xFFFFFF, true, false, true);
		format.align = TextFormatAlign.CENTER;
		var continueField = new TextField();
		continueField.defaultTextFormat = format;
		continueField.text = "On ne vit que deux fois...";
		continueField.width = Lib.current.stage.stageWidth;
		continueField.y = Lib.current.stage.stageHeight / 4;
		continueField.selectable = continueField.mouseEnabled = false;
		continueField.alpha = 0;
		Actuate.tween(continueField, 1, { alpha: 1 } ).onComplete(createButton);
		addChild(continueField);
	}
	
	private function createButton() 
	{
		lives --;
		var button = new Sprite();
		var continueText = new TextField();
		var format = new TextFormat("_sans", 25, 0xFFFFFF, true);
		format.align = TextFormatAlign.CENTER;
		continueText.defaultTextFormat = format;
		continueText.width = Lib.current.stage.stageWidth;
		continueText.y = 3 * Lib.current.stage.stageHeight / 4;
		continueText.selectable = false;
		button.addChild(continueText);
		button.mouseChildren = false;
		button.buttonMode = button.useHandCursor = true;
		button.alpha = 0;
		if (lives > 0) {
			continueText.text = "Continue";
			button.addEventListener(MouseEvent.CLICK, onContinue);
		}
		else {
			continueText.text = "Restart";
			button.addEventListener(MouseEvent.CLICK, onRestart);
		}
		Actuate.tween(button, 1, { alpha: 1 } );
		addChild(button);
	}
	
}