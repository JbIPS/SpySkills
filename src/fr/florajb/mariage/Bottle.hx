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
	public var used (default, setUsed): Bool = false;
	
	public function new(name: String, ?icon: DisplayObject) 
	{
		super(icon, icon, icon, icon);
		this.name = name;
	}
	
	public function setScale(scale: Float) : Float 
	{
		scaleX = scaleY = scale;
		
		return scale;
	}
	
	public function setUsed(use: Bool) : Bool
	{
		used = use;
		if(use)
			Actuate.tween(this, 0.2, { y: y-20 } );
		else
			Actuate.tween(this, 0.2, { y: y+20 } );
			
		return used;
	}	
}