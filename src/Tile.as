package
{
	import org.flixel.*;
	
	public class Tile extends FlxSprite
	{
		[Embed(source='../data/tile-dark.png')] private var ImgTile0:Class;
		[Embed(source='../data/tile-light.png')] private var ImgTile1:Class;
		
		public var type:int;
		
		public function Tile( tileType:Number, X:Number, Y:Number ):void
		{
			super(X,Y);
			
			updateGraphic(tileType);
		}
		
		private function updateGraphic( tileType:int ):void
		{
			width = 32;
			height = 32;
			offset.x = 0;
			offset.y = 0;
			alpha = 1;
			
			switch (tileType){
				case 0:
					loadGraphic(ImgTile0, true, true, width, height);
					break;
				case 1:
					loadGraphic(ImgTile1, true, true, width, height);
					break;
			}
			type = tileType;
		}
		
		override public function update():void
		{			
			super.update();
			if( finished )
			{
				updateGraphic( 0 );
			}
		}
	}
}