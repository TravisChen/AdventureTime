package    {
	
	import org.flixel.*;
	
	public class Level {
		
		public var finn:Finn;
		public var jake:Jake;
		public var meemow:Meemow;
		public var snail:Snail;
		
		public var levelSizeX:Number = 0;
		public var levelSizeY:Number = 0;
		public var points:Number = 0;
		public var multiplier:Number = 1;
		public var timer:Number = 0;
		
		public function update():void
		{
			
		}
		
		public function nextLevel():Boolean
		{
			return false;
		}
		
		public function destroy():void
		{
			
		}
	}
	
}
