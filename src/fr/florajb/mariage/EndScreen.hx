package fr.florajb.mariage;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Cubic;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.FocusEvent;
import nme.events.MouseEvent;
import nme.events.HTTPStatusEvent;
import nme.events.SecurityErrorEvent;
import nme.events.IOErrorEvent;
import nme.events.TextEvent;
import nme.Lib;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.net.URLLoader;
import nme.net.URLRequest;
import nme.net.URLLoaderDataFormat;
import nme.net.URLRequestMethod;
import nme.net.URLVariables;
import nme.text.TextFieldType;


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
	private var nameField: TextField;
	
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
			continueText.text = "Continuer";
			button.addEventListener(MouseEvent.CLICK, onContinue);
		}
		else {
			continueText.text = "Rejouer";
			continueText.width = Lib.current.stage.stageWidth/2;
			button.addEventListener(MouseEvent.CLICK, onRestart);
			var button2 = new Sprite();
			var submitText = new TextField();
			submitText.defaultTextFormat = format;
			submitText.text = "Envoyer mon score";
			submitText.width = Lib.current.stage.stageWidth/2;
			submitText.x = Lib.current.stage.stageWidth/2;
			submitText.y = 3 * Lib.current.stage.stageHeight / 4;
			submitText.selectable = false;
			button2.addChild(submitText);
			button2.mouseChildren = false;
			button2.buttonMode = button2.useHandCursor = true;
			button2.alpha = 0;
			button2.addEventListener(MouseEvent.CLICK, onSubmit);
			Actuate.tween(button2, 1, { alpha: 1 } );
			addChild(button2);
			nameField = new TextField();
			nameField.type = TextFieldType.INPUT;
			nameField.border = true;
			nameField.borderColor = 0xFFFFFF;
			nameField.defaultTextFormat = format;
			nameField.text = "Entre votre nom";
			nameField.width = 300;
			nameField.height = nameField.textHeight + 20;
			nameField.y = submitText.y - submitText.height;
			nameField.x = submitText.x;
			nameField.alpha = 0;
			nameField.addEventListener(FocusEvent.FOCUS_IN, onActivate);
			addChild(nameField);
			Actuate.tween(nameField, 1, { alpha: 1 } );
		}
		Actuate.tween(button, 1, { alpha: 1 } );
		addChild(button);
	}
	
	private function onActivate(e: Event) : Void 
	{
		nameField.text = "";
	}
	
	public function onSubmit(e: MouseEvent): Void
	{
		var request:URLRequest = new URLRequest("jbdb.php");
		request.method = URLRequestMethod.POST;
		var variables = new URLVariables();
		variables.name = nameField.text;
		variables.score = InterLevel.totalScore;
		request.data = variables;

		var loader = new URLLoader(request);
		loader.dataFormat = URLLoaderDataFormat.VARIABLES;
		loader.addEventListener(Event.COMPLETE, onComplete);
		loader.addEventListener(IOErrorEvent.NETWORK_ERROR, onNetworkError);
		loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
	}

	private function onComplete(evt:Event) {
		//trace("Result: "+evt.target.data.result);
	}

	private function onNetworkError(evt:IOErrorEvent) {
		trace(evt);
	}

	private function onIOError(evt:IOErrorEvent) {
		trace(evt);
	}
	
}