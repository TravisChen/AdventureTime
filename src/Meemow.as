package
{
	import org.flixel.*;
	
	public class Meemow extends FlxSprite
	{
		[Embed(source="data/meemow.png")] private var ImgMeemow:Class;
		
		public var startTime:Number;

		public var roundOver:Boolean = false;
		public var background:Boolean = false;
		public var foreground:Boolean = true;
		
		private var _board:Board;
		public var tileX:Number;
		public var tileY:Number;
		private var moveTo:Tile;
		private var moving:Boolean = false;
		private var speed:Number = 2.0;
		
		private var _jake:Jake;
		
		public function Meemow( X:int, Y:int, board:Board, jake:Jake)
		{
			_board = board;
			_jake = jake;
			
			super(X,Y);
			loadGraphic(ImgMeemow,true,true,32,32);
			
			// Move player to Tile
			setTilePosition( x, y );
			
			// Bounding box tweaks
			width = 32;
			height = 32;
			offset.x = -4;
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
			
			if( x == moveToX && y == moveToY )
				moving = false;
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
			
//			Need to move this to board, should account  for all jake chains
//			if( tileY > _jake.tileY || tileX > _jake.tileX )
//			{
//				foreground = false;
//				if( !background )
//				{
//					background = true;
//					PlayState.groupPlayer.remove(this);
//					PlayState.groupBackground.add(this);
//				}
//			}
//			else
//			{
//				background = false;
//				if( !foreground )
//				{
//					foreground = true;
//					PlayState.groupBackground.remove(this);
//					PlayState.groupPlayer.add(this);
//				}
//			}
			
			if( moving )
			{
				updateMovement();
				return;
			}

			if( startTime > 0 )
			{
				startTime -= FlxG.elapsed;
				return;
			}
			
			if( roundOver )
			{
				play("idle");
				return;
			}
			
			if(FlxG.keys.LEFT )
			{
				moveToTile( tileX - 1, tileY );
			}
			else if(FlxG.keys.RIGHT )
			{
				moveToTile( tileX + 1, tileY );
			}
			else if(FlxG.keys.UP )
			{
				moveToTile( tileX, tileY - 1);
			}
			else if(FlxG.keys.DOWN )
			{
				moveToTile( tileX, tileY + 1);
			}
		}
	}
}