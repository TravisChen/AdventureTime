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
		private var speed:Number = 0.25;
		private var direction:Number = 0.0;
		
		private var dead:Boolean = true;
		private var deadTimer:Number = DEAD_TIME;
		public const DEAD_TIME:Number = 5;
		
		private var _jake:Jake;
		private var _finn:Finn;
		private var _snail:Snail;
		
		public function Meemow( X:int, Y:int, board:Board, jake:Jake, finn:Finn, snail:Snail)
		{
			_board = board;
			_jake = jake;
			_finn = finn;
			_snail = snail;
			
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
		
		public function moveSafe( x:int, y:int, avoidCollects:Boolean ):Boolean
		{
			var moveSafe:Boolean = false;
			if( x >= 0 && x < _board.tileMatrix.length )
			{
				if( y >= 0 && y < _board.tileMatrix[x].length )
				{
					var tile:Tile = _board.tileMatrix[x][y];	
					if( !tile.isChain() )
					{
						if( !( tile.isCollect() && avoidCollects ) )
						{
							if( !( x == _finn.tileX && y == _finn.tileY ) )
							{
								if( !( x == _snail.tileX && y == _snail.tileY ) )
								{
									moveSafe = true;
								}
							}
						}
					}
					else
					{
						_jake.shrink();
					}
				}
			}
			return moveSafe;
		}
		
		public function nextMoveSafe( avoidCollects:Boolean ):Boolean
		{
			var nextMoveSafe:Boolean = false;
			if( direction == 0 )
				nextMoveSafe = moveSafe( tileX - 1, tileY, avoidCollects);
			else if ( direction == 1 )
				nextMoveSafe = moveSafe( tileX + 1, tileY, avoidCollects );
			else if ( direction == 2 )
				nextMoveSafe = moveSafe( tileX, tileY - 1, avoidCollects );
			else if (direction == 3 )
				nextMoveSafe = moveSafe( tileX, tileY + 1, avoidCollects );
			
			return nextMoveSafe;
		}
		
		public function findSafeMove( avoidCollects:Boolean ):void
		{
			var originalDirection:int = direction;
			
			if( !nextMoveSafe( avoidCollects ) )
			{
				if( originalDirection == 0 )
				{
					direction = 1;
				} 
				else if ( originalDirection == 1 )
				{
					direction = 0;						
				}
				else if ( originalDirection == 2 )
				{
					direction = 3;
				}
				else if ( originalDirection == 3 )
				{
					direction = 2;
				}
				
				if( !nextMoveSafe( avoidCollects ) )
				{
					if( originalDirection == 0 )
					{
						direction = 2;
					} 
					else if ( originalDirection == 1 )
					{
						direction = 2;						
					}
					else if ( originalDirection == 2 )
					{
						direction = 0;
					}
					else if ( originalDirection == 3 )
					{
						direction = 0;
					}
					
					if( !nextMoveSafe( avoidCollects ) )
					{
						if( originalDirection == 0 )
						{
							direction = 3;
						} 
						else if ( originalDirection == 1 )
						{
							direction = 3;						
						}
						else if ( originalDirection == 2 )
						{
							direction = 1;
						}
						else if ( originalDirection == 3 )
						{
							direction = 1;
						}
					}
				}
			}		
		}
		
		public function kick():void
		{
			dead = true;
			deadTimer = DEAD_TIME;
		}
		
		private function moveTowardsJake():void
		{
			if( this.tileX > _jake.tileX )
			{
				direction = 0;
			}
			else if( this.tileX < _jake.tileX  )
			{
				direction = 1;
			}
			else if( this.tileY > _jake.tileY )
			{
				direction = 2;		
			}
			else if ( this.tileY < _jake.tileY )
			{
				direction = 3;
			}
			
			findSafeMove( false );
		}
		
		override public function update():void
		{		
			if( dead )
			{
				if( deadTimer <= 0 )
				{
					deadTimer = DEAD_TIME;
					alpha = 1.0;
					dead = false;
				}
				else
				{
					deadTimer -= FlxG.elapsed;
					alpha = 0.0;
				}
			}
			
			super.update();
			
			moveTowardsJake();
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