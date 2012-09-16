package
{
	import org.flixel.*;
	
	public class Tile extends FlxSprite
	{
		[Embed(source='../data/tile-dark.png')] private var ImgTile0:Class;
		[Embed(source='../data/tile-light.png')] private var ImgTile1:Class;
		[Embed(source='../data/jake.png')] private var ImgTile2:Class;
		[Embed(source='../data/pie.png')] private var ImgTile3:Class;
		
		public var type:int;
		public var baseType:int = -1;
		
		public var chainLength:int = 0;
		public var tileX:int = 0;
		public var tileY:int = 0;
		public var front:Boolean = false;
		private var _direction:int = 0;
		
		public var collectActive:Boolean = false;
		
		private var _moveTime:Number;
		private var _moveTimer:Number;
		private var _board:Board;
		
		public const NONE:Number = 0;
		public const CHAIN:Number = 2;
		public const COLLECT:Number = 3;

		public var roundOver:Boolean = false;
		public var stab:Boolean = false;
		
		public function Tile( tileType:Number, X:Number, Y:Number, board:Board, setTileX:int, setTileY:int ):void
		{
			tileX = setTileX;
			tileY = setTileY;
			_board = board;
			
			super(X,Y);
			
			addAnimation("idle", [0]);
			addAnimation("frontRight", [0]);
			addAnimation("frontDown", [1]);
			addAnimation("frontLeft", [6]);
			addAnimation("frontUp", [7]);
			addAnimation("middle", [2]);
			addAnimation("buttRight", [8]);
			addAnimation("buttDown", [9]);
			addAnimation("buttLeft", [4]);
			addAnimation("buttUp", [5]);
			addAnimation("stab", [3], 10, false );
			
			addAnimation("freshPie", [2,3,4,5], 10);
			
			updateGraphic(tileType);
		}
		
		private function updateGraphic( tileType:int ):void
		{
			if( baseType < 0 )
				baseType = tileType;
			
			width = 32;
			height = 32;
			offset.x = 0;
			offset.y = 0;
			alpha = 1;
			
			switch (tileType){
				case NONE:
					loadGraphic(ImgTile0, true, true, width, height);
					alpha = 0;
					break;
				case 1:
					loadGraphic(ImgTile1, true, true, width, height);
					alpha = 0;
					break;
				case CHAIN:
					// Bounding box tweaks
					width = 32;
					height = 32;
					offset.x = 0;
					offset.y = 20;
					
					loadGraphic(ImgTile2, true, true, width, height);
					break;
				case COLLECT:		
					width = 32;
					height = 32;
					offset.x = 0;
					offset.y = 14;
					
					loadGraphic(ImgTile3, true, true, width, height);
					break;
			}
			type = tileType;
		}

		// CHAIN
		public function addSnakeChain( currChainLength:int, moveTime:Number, direction:Number ):void
		{
			front = true;
			chainLength = currChainLength;
			_moveTime = moveTime;
			_moveTimer = moveTime;
			_direction = direction;
			
			updateGraphic( CHAIN );	
			if( direction == 0 )
				play( "frontLeft" );
			else if( direction == 1 )
				play( "frontRight" );
			else if( direction == 2 )
				play( "frontUp" );
			else if( direction == 3 )
				play( "frontDown" );
		}
		
		public function increaseChainLength():void
		{
			chainLength++;
		}
		
		public function isChain():Boolean 
		{
			if( type == CHAIN )
				return true;
			return false;
		}
		
		public function doStab():void
		{
			stab = true;
			play( "stab" );
		}
		
		// COLLECT
		public function setCollect():void 
		{
			collectActive = false;
			updateGraphic( COLLECT );		
		}
		
		public function setCollectActive():void 
		{
			alpha = 1.0;
			play("freshPie");
			collectActive = true;
		}
		
		public function isCollect():Boolean 
		{
			if( type == COLLECT )
				return true;
			return false;	
		}
		
		public function isCollectActive():Boolean 
		{
			return collectActive;
		}
		
		public function removeCollect():Boolean
		{
			if( type == COLLECT )
			{
				updateGraphic( baseType );
				_board.removeCollect();
				return true;
			}
			
			return false;
		}
		
		// UPDATE
		override public function update():void
		{
			if( roundOver )
			{
				return;
			}	
			
			if( chainLength >= 0 )
			{				
				if( chainLength == 1 )
				{
					if( _direction == 0 )
						play( "buttLeft" );
					else if( _direction == 1 )
						play( "buttRight" );
					else if( _direction == 2 )
						play( "buttUp" );
					else if( _direction == 3 )
						play( "buttDown" );
				}
				else
				{
					if( stab )
					{
						if( finished )
						{
							play( "middle" );
							stab = false;
						}
					}
				}
				
				if( _moveTimer <= 0 )
				{
					if( front )
					{
						front = false;
						play( "middle" );
					}
					
					chainLength--;
					_moveTimer = _moveTime;
					if( chainLength <= 0 )
					{
						updateGraphic( baseType );
					}
				}
				else
				{
					_moveTimer -= FlxG.elapsed;
				}
			}
			else
			{
				if( type == COLLECT )
				{
					if( this.isCollectActive() )
					{
						play("freshPie");
					}
					else
					{
						play( "idle" );
					}
				}
				else
				{
					play( "idle" );
				}
			}
			
			super.update();
		}
	}
}