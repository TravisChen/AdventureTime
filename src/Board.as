package    {
	
	import org.flixel.*;
	
	public class Board {
		
		// Tiles
		public var tileMatrix:Array; 
		public const BOARD_TILE_WIDTH:uint = 19;
		public const BOARD_TILE_HEIGHT:uint = 19;

		public function Board()
		{
			createTiles();
		}
		
		public function update():void
		{
			
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
			
			var blockRow:Boolean = false;
			var blockColumn:Boolean = false;
			for( var x:int = 0; x < BOARD_TILE_WIDTH; x++)
			{
				var row:Array = new Array();
				for( var y:int = 0; y < BOARD_TILE_HEIGHT; y++ )
				{	
					if( blockColumn && blockRow )
					{
						type = 1;
						blockColumn = false;
					}
					else
					{
						type = 0;
						blockColumn = true;
					}
					
					var tile:Tile = new Tile( type, startX + x*offsetX + y*isometrixOffsetY,  startY + y*offsetY + x*isometrixOffsetX );					
					PlayState.groupBoard.add(tile);
					row.push(tile);
				}
				
				if( blockRow )
				{
					blockRow = false;
				}
				else
				{
					blockRow = true;
				}
				blockColumn = false;
				
				tileMatrix.push(row);
			}
			
		}
	}
	
}
