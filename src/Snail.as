package
{
	import org.flixel.*;
	
	public class Snail extends FlxSprite
	{
		[Embed(source="data/snail.png")] private var ImgSnail:Class;
		
		public var startTime:Number;
		
		public var roundOver:Boolean = false;
		public var background:Boolean = false;
		public var foreground:Boolean = true;
		
		private var _board:Board;
		public var tileX:Number;
		public var tileY:Number;
		private var moveTo:Tile;
		private var moving:Boolean = false;
		private var speed:Number = 0.05;
		private var direction:Number = 0.0;
		
		private var moveTimer:Number = MOVE_TIME;
		public const MOVE_TIME:Number = 5.0;	
		
		private var _jake:Jake;
		
		public function Snail( X:int, Y:int, board:Board, jake:Jake)
		{
			_board = board;
			_jake = jake;
			
			super(X,Y);
			loadGraphic(ImgSnail,true,true,32,32);
			
			// Move player to Tile
			setTilePosition( x, y );
			
			// Bounding box tweaks
			width = 32;
			height = 32;
			offset.x = -2;
			offset.y = 20;
			
			// Start time
			startTime = 0.5;
		}
		
		public function moveToTile( x:int, y:int ):void
		{
			if( x >= 0 && x < _board.tileMatrix.length )
			{
				if( y >= 0 && y < _board.tileMatrix[x].length )
				{
					var tile:Tile = _board.tileMatrix[x][y];	
					if( !tile.isChain() )
					{
						if( !(x == _jake.tileX && y == _jake.tileY) )
						{
							tileX = x;
							tileY = y;
							moveTo = tile;
							moving = true;
						}
					}
				}
			}
		}
		
		public function updateMovement():void
		{			
			var moveToX:Number = moveTo.x;
			var moveToY:Number = moveTo.y;
			
			if( x > moveToX )
				x -= 2 * speed;
			else if ( x < moveToX )
				x += 2 * speed;
			
			if( y > moveToY )
				y -= 1 * speed;
			else if ( y < moveToY )
				y += 1 * speed;
			
			if( Math.abs(x - moveToX) <= speed && Math.abs(y - moveToY) <= speed )
			{
				x = moveToX;
				y = moveToY;
				moving = false;
			}
		}
		
		public function setTilePosition( x:int, y:int ):void
		{
			tileX = x;
			tileY = y;
			
			var tile:Tile = _board.tileMatrix[tileX][tileY];	
			this.x = tile.x;
			this.y = tile.y;
			super.update();
		}
		
		override public function update():void
		{			
			super.update();
			
			if( moveTimer <= 0 )
			{
				direction = Math.floor(Math.random() * 4);
				moveTimer = MOVE_TIME;	
			}
			else
			{
				moveTimer -= FlxG.elapsed;
			}
			
			if( moving )
			{
				updateMovement();
				return;
			}
			
			if( direction == 0 )
			{
				moveToTile( tileX - 1, tileY );
			}
			else if( direction == 1 )
			{
				moveToTile( tileX + 1, tileY );
			}
			else if( direction == 2 )
			{
				moveToTile( tileX, tileY - 1);
			}
			else if( direction == 3 )
			{
				moveToTile( tileX, tileY + 1);
			}
		}
	}
}