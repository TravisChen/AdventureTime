package
{
	import org.flixel.*;
	
	public class TileBackground extends FlxSprite
	{
		[Embed(source='../data/tile-dark.png')] private var ImgTile0:Class;
		[Embed(source='../data/tile-light.png')] private var ImgTile1:Class;
		
		public var type:int;
		public var baseType:int = -1;
		
		public function TileBackground( tileType:Number, X:Number, Y:Number ):void
		{			
			super(X,Y);
			
			updateGraphic(tileType);
		}
		
		private function updateGraphic( tileType:int ):void
		{
			if( baseType < 0 )
				baseType = tileType;
			
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
		}
	}
}