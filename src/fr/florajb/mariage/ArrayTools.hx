package fr.florajb.mariage;

/**
 * ...
 * @author jbrichardet
 */

class ArrayTools 
{	
	public static function contains(a1: Array<String>, elem: String) : Bool
	{
		for (string in a1) {
			if (string == elem)
				return true;
		}
		return false;
	}
	
	private function new() 
	{
		
	}
}