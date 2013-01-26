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
	
	public function new(type: String, startMethod: Dynamic -> Void) 
	{
		super();
		
		addChild(new Bitmap(Assets.getBitmapData("img/menubackground.png")));
		this.startMethod = startMethod;
		if (type == "interlevel")
			setInterlevel();
		else{
			setMenu();
		}
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
	
	private function setInterlevel():Void 
	{
		var buttonIcon = new Bitmap(Assets.getBitmapData("img/BluePlank.png"));
		continueButton = new SimpleButton(buttonIcon,buttonIcon,buttonIcon,buttonIcon);
		continueButton.x = 300;
		continueButton.y = 25;
		continueButton.enabled = continueButton.useHandCursor = false;
		addChild(continueButton);
		
		
		var continueField = new TextField();
		continueField.defaultTextFormat = new TextFormat("_sans", 22, 0xFFFF00, true);
		continueField.x = 310;
		continueField.y = 85;
		continueField.selectable = continueField.mouseEnabled = false;
		continueField.text = "CONTINUE";
		continueField.autoSize = TextFieldAutoSize.CENTER;
		addChild(continueField);
		
		scoreField = new TextField();
		scoreField.defaultTextFormat = new TextFormat("_sans", 22, 0x00FF00, true);
		scoreField.selectable = scoreField.mouseEnabled = false;
		
		totalScoreField = new TextField();
		totalScoreField.defaultTextFormat = new TextFormat("_sans", 22, 0x00FF00, true);
		totalScoreField.selectable = totalScoreField.mouseEnabled = false;
		
		setScore(0);
		scoreField.autoSize = TextFieldAutoSize.CENTER;
		scoreField.x = 60;
		scoreField.y = 30;
		addChild(scoreField);
		
		totalScoreField.autoSize = TextFieldAutoSize.CENTER;
		totalScoreField.x = 60;
		totalScoreField.y = 70;
		addChild(totalScoreField);
		
		addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		addEventListener(Event.ADDED_TO_STAGE, onAdd);
	}
	
	
	
}