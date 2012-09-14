package
{
	import org.flixel.*; 
	[SWF(width="640", height="480", backgroundColor="#000000")] 
	
	public class AdventureTime extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		
		public function AdventureTime()
		{
			super(320,240,PlayState,2);
		}
	}
}