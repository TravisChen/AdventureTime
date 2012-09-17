package
{
	import flashx.textLayout.formats.BackgroundColor;
	
	import org.flixel.*;
	
	public class Finn extends FlxSprite
	{
		[Embed(source="data/finn.png")] private var ImgFinn:Class;
		[Embed(source="data/wasd.png")] private var ImgWasd:Class;
		[Embed(source="data/space.png")] private var ImgSpace:Class;
		[Embed(source = '../data/Audio/slash-alt.mp3')] private var SndSlash:Class;
		[Embed(source = '../data/Audio/slash.mp3')] private var SndSlashBacking:Class;
		[Embed(source = '../data/Audio/pie-unveal.mp3')] private var SndPie:Class;
		
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
		private var kicking:Boolean = false;
		
		private var _jake:Jake;
		private var _snail:Snail;
		private var _meemow:Meemow;
		
		public var wasd:FlxSprite;
		public var wasdFadeOutTime:Number = 0;
		public var wasdBounceTime:Number = 0;
		public var wasdBounceToggle:Boolean = true;
		
		public var space:FlxSprite;
		public var spaceFadeOutTime:Number = 0;
		public var spaceBounceTime:Number = 0;
		public var spaceBounceToggle:Boolean = true;
		public var collectedFirstPie:Boolean = false;
		
		public function Finn( X:int, Y:int, board:Board, jake:Jake, snail:Snail)
		{
			_board = board;
			_jake = jake;
			_snail = snail;
			
			super(X,Y);
			loadGraphic(ImgFinn,true,true,74,64);
			
			// Move player to Tile
			setTilePosition( x, y );
			
			// Bounding box tweaks
			width = 74;
			height = 64;
			offset.x = 22;
			offset.y = 53;
			
			// WASD
			wasd = new FlxSprite(0,0);
			wasd.loadGraphic(ImgWasd, true, true, 32, 32);
			wasd.alpha = 1;
			PlayState.groupForeground.add(wasd);
			
			// SPACE
			space = new FlxSprite(0,0);
			space.loadGraphic(ImgSpace, true, true, 32, 32);
			space.alpha = 1;
			PlayState.groupForeground.add(space);
			
			addAnimation("idle", [0]);
			addAnimation("walk", [1,2,3,4,5,6], 20);
			addAnimation("kick", [7,8,9,10], 20, false );
			
			// Start time
			startTime = 0.0;
		}

		public function setMeemow( meemow:Meemow ):void
		{
			_meemow = meemow;
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
											
//								if( tile.isCollect() )
//								{
//									collectedFirstPie = true;
//									tile.setCollectActive();
//								}
							}
						}
					}
				}
			}
		}
		
		public function kick():void
		{
			var startX:int = tileX - 1;
			var startY:int = tileY - 1;
			var incrementX:int = startX;
			var incrementY:int = startY;
			
			var ex:Number = 0.03;
			var explodeDelayArray:Array = new Array(ex*2,ex,0,ex*3,ex*8,ex*7,ex*4,ex*5,ex*6);
			
			FlxG.play(SndSlash,0.35);
			FlxG.play(SndSlashBacking,0.25);
			
			for( var i:int = 0; i < 3; i++ )
			{
				for( var j:int = 0; j < 3; j++ )
				{
					if( incrementX >= 0 && incrementX < _board.tileMatrix.length )
					{
						if( incrementY >= 0 && incrementY < _board.tileMatrix[incrementX].length )
						{
							var tile:Tile = _board.tileMatrix[incrementX][incrementY];
							
							// Create explosion
							var explosion:Explosion = new Explosion(tile.x,tile.y,explodeDelayArray[(i*3) + j]);
							PlayState.groupPlayerBehind.add(explosion);
							
							if( tile.isCollect() )
							{
								collectedFirstPie = true;
								tile.setCollectActive();
								
								FlxG.play(SndPie,0.75);
							}
							else if ( _meemow.tileX == incrementX && _meemow.tileY == incrementY )
							{
								_meemow.kick();
							}
						}
					}
					incrementY += 1;
				}
				incrementX += 1;
				incrementY = startY;
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
	
		public function updateWasd():void 
		{
			wasd.y = y - 76;
			wasd.x = x;
			
			if( moving )
			{
				wasd.alpha -= 0.05;		
			}
			else
			{
				if( wasdBounceTime <= 0 )
				{
					wasdBounceTime = 0.02;
					if( wasdBounceToggle )
					{
						wasd.y += 1;
						wasdBounceToggle = false;
					}
					else
					{
						wasd.y -= 1;
						wasdBounceToggle = true;
					}
				}
				else
				{
					wasdBounceTime -= FlxG.elapsed;
				}
			}
		}
		
		public function updateSpace():void 
		{
			space.y = y - 76;
			space.x = x;
			
			if( wasd.alpha == 1 )
			{
				space.alpha = 0;
				return;
			}
			else
			{
				if( !collectedFirstPie )
				{
					space.alpha += 0.05;
				}
			}
			
			if( collectedFirstPie )
			{
				space.alpha -= 0.05;		
			}
			else
			{
				if( spaceBounceTime <= 0 )
				{
					spaceBounceTime = 0.02;
					if( wasdBounceToggle )
					{
						space.y += 1;
						spaceBounceToggle = false;
					}
					else
					{
						space.y -= 1;
						spaceBounceToggle = true;
					}
				}
				else
				{
					spaceBounceTime -= FlxG.elapsed;
				}
			}
		}
		
		override public function update():void
		{	
			if( startTime > 0 )
			{
				startTime -= FlxG.elapsed;
				return;
			}
			
			if( roundOver )
			{
				play( "idle" );
				return;
			}

			updateWasd();
			updateSpace();
			
			super.update();			

			updateZOrdering();
			
			if( moving )
			{
				updateMovement();
				return;
			}
			
			if( kicking )
			{
				if( finished )
				{
					kicking = false;
				}
				return;
			}
			
			if( FlxG.keys.SPACE )
			{
				kick();
				kicking = true;
				play( "kick" );
			}
			else if(FlxG.keys.LEFT )
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