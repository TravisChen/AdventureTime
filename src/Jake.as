package
{
	import org.flixel.*;
	
	public class Jake extends FlxSprite
	{
		[Embed(source="data/jake.png")] private var ImgDarwin:Class;
		
		public var startTime:Number;
		
		public var roundOver:Boolean = false;
		
		private var _board:Board;
		private var tileX:Number;
		private var tileY:Number;
		private var moveTo:Tile;
		private var moving:Boolean = false;
		private var direction:int = 0;

		private var chainArray:Array;
		
		public var chainLength:int = MIN_CHAIN;

		private var moveTimer:Number = MOVE_TIME;
		
		public const MOVE_TIME:Number = 0.1;	
		public const MIN_CHAIN:Number = 1;
	
		public function Jake( X:int, Y:int, board:Board)
		{
			_board = board;
			
			super(X,Y);
			loadGraphic(ImgDarwin,true,true,32,32);
			
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

			addAnimation("idle", [0]);
			addAnimation("run", [1,2,3,4], 18);
			addAnimation("dig", [5,6,7], 32);
			addAnimation("jump", [8,9,10], 18, false);
			addAnimation("land", [8], 20);
			addAnimation("stun", [11,12], 15);
		}

		public function moveToTile( x:int, y:int ):void
		{
			if( x >= 0 && x < _board.tileMatrix.length )
			{
				if( y >= 0 && y < _board.tileMatrix[x].length )
				{
					moveTo.addSnakeChain( chainLength, MOVE_TIME );		
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
					}
				}
				else
				{
					shrink();		
				}
			}
			else
			{
				shrink();
			}
		}
		
		public function shrink():void
		{
			if( chainLength > MIN_CHAIN )
			{
				chainLength--;
			
				for( var i:int = 0; i < chainArray.length; i++ )
				{
					var tile:Tile = chainArray[i];
					tile.chainLength--;
				}
			}
		}
		
		public function grow():void
		{
			chainLength++;
			
			for( var i:int = 0; i < chainArray.length; i++ )
			{
				var tile:Tile = chainArray[i];
				tile.chainLength++;
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
				tileX = x;
				tileY = y;
				moveTo = tile;
				this.x = tile.x;
				this.y = tile.y;
				return true;
			}
			return false;
		}
	
		override public function update():void
		{			
			super.update();
			checkChainArray();

			if( moveTimer <= 0 )
			{
				moveTimer = MOVE_TIME;
				if( direction == 0 )
					moveToTile( tileX - 1, tileY );
				else if ( direction == 1 )
					moveToTile( tileX + 1, tileY );
				else if ( direction == 2 )
					moveToTile( tileX, tileY - 1);
				else if (direction == 3 )
					moveToTile( tileX, tileY + 1);							
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
			
			// MOVEMENT Left, Right
			acceleration.x = 0;
			if(FlxG.keys.LEFT || FlxG.keys.A && direction != 1)
			{
				direction = 0;
			}
			else if(FlxG.keys.RIGHT || FlxG.keys.D && direction != 0)
			{
				direction = 1;
			}
			else if(FlxG.keys.UP || FlxG.keys.W && direction != 3)
			{
				direction = 2;
			}
			else if(FlxG.keys.DOWN || FlxG.keys.S && direction != 2)
			{
				direction = 3;
			}
		}
	}
}