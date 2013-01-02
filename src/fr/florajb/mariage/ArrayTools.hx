package fr.florajb.mariage;

/**
 * ...
 * @author jbrichardet
 */

class ArrayTools 
{
	public static function equalsArray(a1: Array<String>, a2: Array<String>) : Bool 
	{
		var equals = true;
		a1.sort(sort);
		a2.sort(sort);
		var i = 0;
		for (string in a1) {
			if (string != a2[i])
				equals = false;
			i++;
		}
		return equals;
	}
	
	public static function contains(a1: Array<String>, elem: String) : Bool
	{
		for (string in a1) {
			if (string == elem)
				return true;
		}
		return false;
	}
	
	private static function sort(x: String, y: String) : Int 
	{
		var scoreX = x.charCodeAt(0) + x.charCodeAt(1) + x.charCodeAt(2) + x.charCodeAt(3);
		var scoreY = y.charCodeAt(0) + y.charCodeAt(1) + y.charCodeAt(2) + y.charCodeAt(3);
		return scoreX - scoreY;
	}
	
	private function new() 
	{
		
	}
}