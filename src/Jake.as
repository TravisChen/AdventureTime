package
{
	import org.flixel.*;
	
	public class Jake extends FlxSprite
	{
		[Embed(source="data/jake.png")] private var ImgDarwin:Class;
		[Embed(source="../data/particle.png")] private var ImgParticle:Class;
		
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
		
		public var chainLength:int = 3;

		private var moveTimer:Number = MOVE_TIME;

		private var _finn:Finn;
		private var _meemow:Meemow;
		private var _snail:Snail;
		
		public const MOVE_TIME:Number = 0.25;	
		public const MIN_CHAIN:Number = 3;
		
		private var particle:FlxEmitterExt;

		public function Jake( X:int, Y:int, board:Board )
		{
			_board = board;
			
			super(X,Y);
			loadGraphic(ImgDarwin,true,true,32,32);
			alpha = 0;
			
			// Particle
			particle = new FlxEmitterExt(0,0,-1);
			particle.makeParticles(ImgParticle,100,15,true,0.2);
			PlayState.groupForeground.add(particle);
			
			// Move player to Tile
			setTilePosition( x, y );
			
			// Bounding box tweaks
			width = 32;
			height = 32;
			offset.x = 0;
			offset.y = 20;
			
			// Start time
			startTime = 0.5;
		}
		
		public function setFinn( finn:Finn ):void
		{
			_finn = finn;
		}

		public function setMeemow( meemow:Meemow ):void
		{
			_meemow = meemow;
		}
		
		public function setSnail( snail:Snail ):void
		{
			_snail = snail;
		}
		
		public function moveToTile( x:int, y:int ):void
		{
			if( x >= 0 && x < _board.tileMatrix.length )
			{
				if( y >= 0 && y < _board.tileMatrix[x].length )
				{
					var prevMoveTo:Tile = moveTo;
					
					if( setTilePosition( x, y ) )
					{
						prevMoveTo.addSnakeChain( chainLength, MOVE_TIME, direction);
						
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
		
		public function shrink():void
		{
			chainLength--;
		}
		
		public function grow():void
		{
			chainLength++;
			particleExplode();
		}
		
		public function particleExplode():void
		{
			particle.x = this.x;
			particle.y = this.y;
			
			particle.gravity = 100;
			particle.setXSpeed(-2, 2);
			particle.setYSpeed(-2, 2 );		
			
			particle.on = true;
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
						if( tile.isCollect() && tile.isCollectActive() )
						{
							goalCollect = tile;
							goalCollect.alpha = 1.0;
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
		
		public function roam():void 
		{
			direction = Math.floor(Math.random() * 4);
			findSafeMove( true );			
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
				
				findSafeMove( false );
			}
			else
			{
				roam();
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

			if( moveTimer <= 0 )
			{
				updateAIMovement();
//				updateKeyboardMovement();
				
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