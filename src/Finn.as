package
{
	import org.flixel.*;
	
	public class Finn extends FlxSprite
	{
		[Embed(source="data/jake.png")] private var ImgDarwin:Class;
		
		public var startTime:Number;
		
		private var jumpPower:int;
		private var lastVelocityY:int;
		private var jumping:Boolean;
		public var landing:Boolean;
		public var roundOver:Boolean;
		
		private var _board:Board;
		private var tileX:Number;
		private var tileY:Number;
		private var moveTo:Tile;
		private var moving:Boolean = false;
		private var speed:Number = 2.0;
		
		public function Finn( X:int, Y:int, board:Board)
		{
			_board = board;
			
			super(X,Y);
			loadGraphic(ImgDarwin,true,true,32,32);
			
			// Move player to Tile
			setTilePosition( x, y );
			
			// Bounding box tweaks
			width = 16;
			height = 16;
			offset.x = 0;
			offset.y = 20;
			
			// Init
			jumping = false;
			roundOver = false;
			
			// Start time
			startTime = 0.5;
			lastVelocityY = velocity.y;
			
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
					tileX = x;
					tileY = y;
					
					var tile:Tile = _board.tileMatrix[tileX][tileY];	
					moveTo = tile;
					moving = true;
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

			if( landing ) 
			{
				play("land");
				if(finished)
				{
					landing = false;					
				}
				return;
			}	
			
			// MOVEMENT Left, Right
			acceleration.x = 0;
			if(FlxG.keys.LEFT || FlxG.keys.A)
			{
				moveToTile( tileX - 1, tileY );
			}
			else if(FlxG.keys.RIGHT || FlxG.keys.D)
			{
				moveToTile( tileX + 1, tileY );
			}
			else if(FlxG.keys.UP || FlxG.keys.W)
			{
				moveToTile( tileX, tileY - 1);
			}
			else if(FlxG.keys.DOWN || FlxG.keys.S)
			{
				moveToTile( tileX, tileY + 1);
			}
		}
	}
}