package fr.florajb.mariage;
import com.eclecticdesignstudio.motion.Actuate;
import nme.display.DisplayObject;
import nme.display.SimpleButton;
import nme.events.MouseEvent;

/**
 * ...
 * @author jbrichardet
 */

class Bottle extends SimpleButton
{
	public var scale (default, setScale): Float;
	
	public function new(name: String, ?icon: DisplayObject) 
	{
		super(icon, icon, icon, icon);
		this.name = name;
		addEventListener(MouseEvent.CLICK, onClick);
	}
	
	public function setScale(scale: Float) : Float 
	{
		scaleX = scaleY = scale;
		
		return scale;
	}
	
	private function onClick(e: MouseEvent) : Void 
	{
		Actuate.tween(this, 0.2, { rotation: 90 } ).repeat(1).reflect();
	}
	
}