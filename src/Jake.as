package
{
	import org.flixel.*;
	
	public class Jake extends FlxSprite
	{
		[Embed(source="data/jake.png")] private var ImgDarwin:Class;
		
		public var startTime:Number;
		
		public var roundOver:Boolean = false;
		
		private var _board:Board;
		public var tileX:Number;
		public var tileY:Number;
		private var moveTo:Tile;
		private var goalCollect:Tile;
		private var doGrow:Boolean = false;
		
		private var moving:Boolean = false;
		private var direction:int = 0;


		private var chainArray:Array;
		
		public var chainLength:int = MIN_CHAIN;

		private var moveTimer:Number = MOVE_TIME;

		private var _finn:Finn;
		
		public const MOVE_TIME:Number = 0.1;	
		public const MIN_CHAIN:Number = 3;

		public function Jake( X:int, Y:int, board:Board )
		{
			_board = board;
			
			super(X,Y);
			loadGraphic(ImgDarwin,true,true,32,32);
			alpha = 0;
			
			// Move player to Tile
			setTilePosition( x, y );
			
			// Bounding box tweaks
			width = 32;
			height = 32;
			offset.x = 0;
			offset.y = 20;
			
			// Chain
			chainArray = new Array();
			
			// Start time
			startTime = 0.5;
		}
		
		public function setFinn( finn:Finn ):void
		{
			_finn = finn;
		}

		public function moveToTile( x:int, y:int ):void
		{
			if( x >= 0 && x < _board.tileMatrix.length )
			{
				if( y >= 0 && y < _board.tileMatrix[x].length )
				{
					moveTo.addSnakeChain( chainLength, MOVE_TIME, direction);		
					chainArray.push( moveTo );
					
					if( setTilePosition( x, y ) )
					{
						if( moveTo.removeCollect() )
						{
							grow();
						}
					}
					else
					{
						shrink();
						return;
					}
				}
				else
				{
					shrink();		
					return;
				}
			}
			else
			{
				shrink();
				return;
			}
		}
		
		public function moveSafe( x:int, y:int ):Boolean
		{
			var moveSafe:Boolean = false;
			if( x >= 0 && x < _board.tileMatrix.length )
			{
				if( y >= 0 && y < _board.tileMatrix[x].length )
				{
					var tile:Tile = _board.tileMatrix[x][y];	
					if( !tile.isChain() )
					{
						if( !( x == _finn.tileX && y == _finn.tileY ) )
						{
							moveSafe = true;
						}
					}
				}
			}
			return moveSafe;
		}
		
		public function nextMoveSafe():Boolean
		{
			var nextMoveSafe:Boolean = false;
			if( direction == 0 )
				nextMoveSafe = moveSafe( tileX - 1, tileY );
			else if ( direction == 1 )
				nextMoveSafe = moveSafe( tileX + 1, tileY );
			else if ( direction == 2 )
				nextMoveSafe = moveSafe( tileX, tileY - 1);
			else if (direction == 3 )
				nextMoveSafe = moveSafe( tileX, tileY + 1);
			
			return nextMoveSafe;
		}
		
		public function shrink():void
		{
			trace( "SHRINK, CHAIN LENGTH: " + chainLength );
			if( chainLength >= MIN_CHAIN )
			{
				chainLength--;
			
				for( var i:int = 0; i < chainArray.length; i++ )
				{
					var tile:Tile = chainArray[i];
					tile.chainLength--;
				}
				
				checkChainArray();
			}
		}
		
		public function grow():void
		{
			trace( "GROW, CHAIN LENGTH: " + chainLength );
			
			chainLength++;
			
			for( var i:int = 0; i < chainArray.length; i++ )
			{
				var tile:Tile = chainArray[i];
				tile.increaseChainLength();
			}			
		}
		
		public function checkChainArray():void
		{
			for( var i:int = 0; i < chainArray.length; i++ )
			{
				var tile:Tile = chainArray[i];
				if( tile.chainLength <= 0 )
				{
					chainArray.splice(i,1);
				}
			}
		}
		
		public function setTilePosition( x:int, y:int ):Boolean
		{			
			var tile:Tile = _board.tileMatrix[x][y];	
			if( !tile.isChain() )
			{
				if( _finn )
				{
					if( x == _finn.tileX && y == _finn.tileY )
					{
						return false;
					}
				}
				
				tileX = x;
				tileY = y;
				moveTo = tile;
				this.x = tile.x;
				this.y = tile.y;
				return true;
			}
			return false;
		}
		
		public function newGoal():void
		{
			if( !goalCollect )
			{
				for( var x:int = 0; x < _board.tileMatrix.length; x++ )
				{
					for( var y:int = 0; y < _board.tileMatrix[x].length; y++ )
					{
						var tile:Tile = _board.tileMatrix[x][y];	
						if( tile.isCollect() )
						{
							goalCollect = tile;
							goalCollect.alpha = 0.5;
							break;
						}
					}
					
					if( goalCollect )
					{
						break;
					}
				}
			}
		}
		
		public function updateAIMovement():void
		{
			newGoal();

			if( goalCollect )
			{
				if( this.tileX > goalCollect.tileX )
				{
					direction = 0;
				}
				else if( this.tileX < goalCollect.tileX )
				{
					direction = 1;
				}
				else if( this.tileY > goalCollect.tileY )
				{
					direction = 2;		
				}
				else if ( this.tileY < goalCollect.tileY )
				{
					direction = 3;
				}
				
				var originalDirection:int = direction;
				
				if( !nextMoveSafe() )
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
					
					if( !nextMoveSafe() )
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
						
						if( !nextMoveSafe() )
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
		}
		
		public function updateKeyboardMovement():void 
		{
			if( FlxG.keys.A && direction != 1)
			{
				direction = 0;
			}
			else if( FlxG.keys.D && direction != 0)
			{
				direction = 1;
			}
			else if( FlxG.keys.W && direction != 3)
			{
				direction = 2;
			}
			else if( FlxG.keys.S && direction != 2)
			{
				direction = 3;
			}
		}
	
		override public function update():void
		{			
			super.update();
			checkChainArray();

			if( moveTimer <= 0 )
			{
				updateAIMovement();
				updateKeyboardMovement();
				
				moveTimer = MOVE_TIME;
				if( direction == 0 )
					moveToTile( tileX - 1, tileY );
				else if ( direction == 1 )
					moveToTile( tileX + 1, tileY );
				else if ( direction == 2 )
					moveToTile( tileX, tileY - 1);
				else if (direction == 3 )
					moveToTile( tileX, tileY + 1);		
			
				if( goalCollect && !goalCollect.isCollect() )
				{
					goalCollect = undefined;
					newGoal();
				}
			}
			else
			{
				moveTimer -= FlxG.elapsed;
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
		}
	}
}