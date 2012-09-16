package
{
	import flashx.textLayout.formats.BackgroundColor;
	
	import org.flixel.*;
	
	public class Finn extends FlxSprite
	{
		[Embed(source="data/finn.png")] private var ImgFinn:Class;
		
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
		private var _snail:Snail;
		
		public function Finn( X:int, Y:int, board:Board, jake:Jake, snail:Snail)
		{
			_board = board;
			_jake = jake;
			_snail = snail;
			
			super(X,Y);
			loadGraphic(ImgFinn,true,true,41,64);
			
			// Move player to Tile
			setTilePosition( x, y );
			
			// Bounding box tweaks
			width = 41;
			height = 64;
			offset.x = 2;
			offset.y = 52;
			
			addAnimation("idle", [0]);
			addAnimation("walk", [1,2,3,4,5,6], 20);
			
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
							if( !(x == _snail.tileX && y == _snail.tileY) )
							{
								tileX = x;
								tileY = y;
								moveTo = tile;
								moving = true;
													
								if( tile.isCollect() )
								{
									tile.setCollectActive();
								}
							}
						}
					}
				}
			}
		}
		
		public function updateZOrdering():void
		{
			var rightX:int = tileX + 1;
			var downY:int = tileY + 1;
			var behind:Boolean = false;
			if( rightX < _board.tileMatrix.length )
			{
				var rightTile:Tile = _board.tileMatrix[rightX][tileY];	
				if( rightTile.isChain() )
				{
					behind = true;
				}
			}
			
			if( downY < _board.tileMatrix.length )
			{
				var downTile:Tile = _board.tileMatrix[tileX][downY];	
				if( downTile.isChain() )
				{
					behind = true;
				}
			}
			
			if( rightX < _board.tileMatrix.length && downY < _board.tileMatrix.length )
			{
				var cornerTile:Tile = _board.tileMatrix[rightX][downY];	
				if( cornerTile.isChain() )
				{
					behind = true;
				}
			}
			
			if( behind )
			{
				PlayState.groupPlayer.remove( this );
				PlayState.groupPlayerBehind.add( this );
			}
			else
			{
				PlayState.groupPlayerBehind.remove( this );
				PlayState.groupPlayer.add( this );
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

			updateZOrdering();
			
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
				play( "walk" );
				moveToTile( tileX - 1, tileY );
			}
			else if(FlxG.keys.RIGHT )
			{
				play( "walk" );
				moveToTile( tileX + 1, tileY );
			}
			else if(FlxG.keys.UP )
			{
				play( "walk" );
				moveToTile( tileX, tileY - 1);
			}
			else if(FlxG.keys.DOWN )
			{
				play( "walk" );
				moveToTile( tileX, tileY + 1);
			}
			else
			{
				play( "idle" );
			}
		}
	}
}