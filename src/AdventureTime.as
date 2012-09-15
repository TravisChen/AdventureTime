package
{
	import org.flixel.*; 
//	[SWF(width="640", height="400", backgroundColor="#000000")] 
	[SWF(width="1280", height="800", backgroundColor="#8ad7e9")] 
	
	public class AdventureTime extends FlxGame
	{
		public static var currLevelIndex:uint = 0;
		
		public function AdventureTime()
		{
//			super(640,400,PlayState,1);
			super(640,400,PlayState,2);
		}
	}
}