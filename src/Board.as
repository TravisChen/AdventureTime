package    {
	
	import org.flixel.*;
	
	public class Board {
		
		// Tiles
		public var tileMatrix:Array; 
		public var numCollects:int = 0;
		public const BOARD_TILE_WIDTH:uint = 19;
		public const BOARD_TILE_HEIGHT:uint = 19;
		public const MAX_COLLECTS:uint = 3;
		public var firstCollect:Boolean = true;
		
		public function Board()
		{
			createTiles();
		}
		
		public function update():void
		{
			if( numCollects < MAX_COLLECTS )
			{
				addCollect();
			}
		}
		
		private function createTiles():void {
			
			var offsetX:int = 16;
			var offsetY:int = 8;
			var isometrixOffsetY:int = -16;
			var isometrixOffsetX:int = 8;
			
			var startX:int = FlxG.width/2 - offsetX;
			var startY:int = FlxG.height/8;		
			var type:int = 0;
			tileMatrix = new Array();
			
			var alternate:Boolean = false;
			for( var x:int = 0; x < BOARD_TILE_WIDTH; x++)
			{
				var row:Array = new Array();
				for( var y:int = 0; y < BOARD_TILE_HEIGHT; y++ )
				{	
					if( alternate )
					{
						type = 1;
						alternate = false;
					}
					else
					{
						type = 0;
						alternate = true;
					}
					
					var tile:Tile = new Tile( type, startX + x*offsetX + y*isometrixOffsetY,  startY + y*offsetY + x*isometrixOffsetX, this, x, y );					
					PlayState.groupBoard.add(tile);
					row.push(tile);
					
					var tileBackground:TileBackground = new TileBackground( type, startX + x*offsetX + y*isometrixOffsetY,  startY + y*offsetY + x*isometrixOffsetX );				
					PlayState.groupBackground.add(tileBackground);
				}
				
				tileMatrix.push(row);
			}
		}

		public function removeCollect():void
		{
			numCollects--;
		}
		
		public function addCollect():void
		{
			var x:uint = Math.floor(Math.random() * BOARD_TILE_WIDTH);
			var y:uint = Math.floor(Math.random() * BOARD_TILE_HEIGHT);

			var tile:Tile = tileMatrix[x][y];	
			if( tile.type == 0 || tile.type == 1 )
			{
				tile.setCollect();
				numCollects++;
				
				if( firstCollect )
				{
					tile.setCollectActive();
					firstCollect = false;
				}
			}
		}
	}
	
}
