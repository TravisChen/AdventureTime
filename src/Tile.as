package
{
	import org.flixel.*;
	
	public class Tile extends FlxSprite
	{
		[Embed(source='../data/tile-dark.png')] private var ImgTile0:Class;
		[Embed(source='../data/tile-light.png')] private var ImgTile1:Class;
		[Embed(source='../data/jake.png')] private var ImgTile2:Class;
		[Embed(source='../data/barrel.png')] private var ImgTile3:Class;
		
		public var type:int;
		public var baseType:int = -1;
		
		public var chainLength:int = 0;
		private var _moveTime:Number;
		private var _moveTimer:Number;
		private var _board:Board;
		
		public function Tile( tileType:Number, X:Number, Y:Number, board:Board ):void
		{
			_board = board;
			
			super(X,Y);
			
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
				case 0:
					loadGraphic(ImgTile0, true, true, width, height);
					alpha = 0;
					break;
				case 1:
					loadGraphic(ImgTile1, true, true, width, height);
					alpha = 0;
					break;
				case 2:
					// Bounding box tweaks
					width = 32;
					height = 32;
					offset.x = 0;
					offset.y = 20;
					
					loadGraphic(ImgTile2, true, true, width, height);
					break;
				case 3:		
					width = 32;
					height = 36;
					offset.x = 0;
					offset.y = 24;
					
					loadGraphic(ImgTile3, true, true, width, height);
					break;
			}
			type = tileType;
		}

		public function addSnakeChain( currChainLength:int, moveTime:Number ):void
		{
			chainLength = currChainLength;
			_moveTime = moveTime;
			_moveTimer = moveTime;
			
			updateGraphic( 2 );			
		}
		
		public function setCollect():void 
		{
			updateGraphic( 3 );		
		}
		
		public function isChain():Boolean 
		{
			if( type == 2 )
				return true;
			return false;
		}
		
		public function isCollect():Boolean 
		{
			if( type == 3 )
				return true;
			return false;	
		}
		
		public function removeCollect():Boolean
		{
			if( type == 3 )
			{
				updateGraphic( baseType );
				_board.removeCollect();
				return true;
			}
			
			return false;
		}
		
		override public function update():void
		{		
			if( chainLength >= 0 )
			{
				if( _moveTimer <= 0 )
				{
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
			
			super.update();
		}
	}
}