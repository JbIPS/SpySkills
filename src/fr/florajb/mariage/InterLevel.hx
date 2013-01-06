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
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;

/**
 * ...
 * @author jb
 */

class InterLevel extends Sprite
{
	public static var instance (getInstance, null) : InterLevel;
	
	public var score (default, setScore): Int;
	public var startMethod: Dynamic -> Void;
	
	private var continueButton: SimpleButton;
	private var scoreField: TextField;
	private var soundChannel: SoundChannel;
	
	static public function getInstance() 
	{
		if (instance == null)
			instance = new InterLevel();
		return instance;
	}
	
	public function setScore(score: Int) : Int 
	{
		this.score = score;
		scoreField.text = score + "pts";
		return score;
	}
	
	private function new() 
	{
		super();
		
		addChild(new Bitmap(Assets.getBitmapData("img/Background.png")));
		
		var buttonIcon = new Bitmap(Assets.getBitmapData("img/BluePlank.png"));
		continueButton = new SimpleButton(buttonIcon,buttonIcon,buttonIcon,buttonIcon);
		continueButton.x = 300;
		continueButton.y = 25;
		continueButton.enabled = continueButton.useHandCursor = false;
		addChild(continueButton);
		
		
		var continueField = new TextField();
		continueField.defaultTextFormat = new TextFormat("_sans", 22, 0xFFFF00, true);
		continueField.x = 380;
		continueField.y = 85;
		continueField.selectable = continueField.mouseEnabled = false;
		continueField.text = "CONTINUE";
		continueField.autoSize = TextFieldAutoSize.CENTER;
		addChild(continueField);
		
		scoreField = new TextField();
		scoreField.defaultTextFormat = new TextFormat("_sans", 22, 0x00FF00, true);
		scoreField.selectable = scoreField.mouseEnabled = false;
		setScore(0);
		scoreField.autoSize = TextFieldAutoSize.CENTER;
		scoreField.x = 60;
		scoreField.y = 60;
		addChild(scoreField);
		
		addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		addEventListener(Event.ADDED_TO_STAGE, onAdd);
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
		Timer.delay(activateButton, 500);
	}
	
	private function activateButton() 
	{
		continueButton.enabled = continueButton.useHandCursor = true;
		continueButton.addEventListener(MouseEvent.CLICK, startMethod);
	}
	
	
	
}