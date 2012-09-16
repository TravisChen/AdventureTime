package    {
		
	import org.flixel.*;
	
	public class Level_Main extends Level{
	
		// Points
		private var pointsText:FlxText;
		private var lengthText:FlxText;
		
		// Timer
		public var startTime:Number;
		public var endTime:Number;
		private var timerText:FlxText;

		// Round End
		private var roundEnd:Boolean;
		private var roundEndContinueText:FlxText;
		private var roundEndPointsText:FlxText;
		
		// Consts
		public const MAX_TIME:uint = 120;
		public const TEXT_COLOR:uint = 0xFFFFFFFF;
		
		public var board:Board;
		
		public function Level_Main( group:FlxGroup ) {
			
			levelSizeX = 640;
			levelSizeY = 480;

			// Create board
			board = new Board();	
			
			// Create jake
			jake = new Jake(8,8,board);
			PlayState.groupPlayer.add(jake);
			
			// Create snail
			snail = new Snail(1,5,board,jake);
			jake.setSnail( snail );
			PlayState.groupPlayer.add( snail );
			
			// Create finn
			finn = new Finn(16,16,board,jake,snail);
			jake.setFinn( finn );
			PlayState.groupPlayer.add(finn);
			
			// Create meemow
			meemow = new Meemow(4,4,board,jake,finn,snail);
			jake.setMeemow( meemow );
			finn.setMeemow( meemow );
			PlayState.groupPlayer.add( meemow );
	
			// Timer
			startTime = 1.0;
			endTime = 3.0;
			timer = MAX_TIME;
			timerText = new FlxText(0, 0, FlxG.width, "0:00");
			timerText.setFormat(null,32,TEXT_COLOR,"left");
			timerText.scrollFactor.x = timerText.scrollFactor.y = 0;
			PlayState.groupBackground.add(timerText);
			
			// Points
			points = 0;
			pointsText = new FlxText(0, 0, FlxG.width, "0");
			pointsText.setFormat(null,32,TEXT_COLOR,"right");
			pointsText.scrollFactor.x = pointsText.scrollFactor.y = 0;
			PlayState.groupBackground.add(pointsText);

			// Round end
			roundEnd = false;
			buildRoundEnd();
			
			super();
		}
		
		public function buildRoundEnd():void {
			roundEndContinueText = new FlxText(0, FlxG.height - 16, FlxG.width, "PRESS ANY KEY TO CONTINUE");
			roundEndContinueText.setFormat(null,8,TEXT_COLOR,"center");
			roundEndContinueText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndContinueText.visible = false;
			PlayState.groupForeground.add(roundEndContinueText);
			
			roundEndPointsText = new FlxText(0, FlxG.height - 48, FlxG.width, "0");
			roundEndPointsText.setFormat(null,16,TEXT_COLOR,"center");
			roundEndPointsText.scrollFactor.x = roundEndContinueText.scrollFactor.y = 0;	
			roundEndPointsText.visible = false;
			PlayState.groupForeground.add(roundEndPointsText);
		}
		
		private function updateTimer():void
		{
			// Timer
			var minutes:uint = timer/60;
			var seconds:uint = timer - minutes*60;
			if( startTime <= 0 )
			{
				timer -= FlxG.elapsed;
			}
			else
			{
				startTime -= FlxG.elapsed;
			}
			
			// Check round end
			if( timer <= 0 )
			{
				showEndPrompt();
				if( endTime <= 0 )
				{
					checkAnyKey();					
				}
				else
				{
					endTime -= FlxG.elapsed;
				}
				return;
			}
			
			// Update timer text
			if( seconds < 10 )
				timerText.text = "" + minutes + ":0" + seconds;
			else
				timerText.text = "" + minutes + ":" + seconds;
		}
		
		override public function update():void
		{
			// BG color
			FlxG.bgColor = 0xFF8ad7e9;
			
			// Update board
			board.update();
		
			// Timer
			updateTimer();

			// Update points text
			pointsText.text = "" + points + " (" + (jake.chainLength - 2) + "x)";
			roundEndPointsText.text = "" + points;
			
			super.update();
		}
		
		private function showEndPrompt():void 
		{
			PlayState._currLevel.finn.roundOver = true;
			PlayState._currLevel.jake.roundOver = true;
			PlayState._currLevel.meemow.roundOver = true;
			PlayState._currLevel.snail.roundOver = true;
			
			for( var x:int = 0; x < board.tileMatrix.length; x++ )
			{
				for( var y:int = 0; y < board.tileMatrix[x].length; y++ )
				{
					var tile:Tile = board.tileMatrix[x][y];
					tile.roundOver = true;
				}
			}
			
			roundEndPointsText.visible = true;
		}
		
		private function checkAnyKey():void 
		{
			roundEndContinueText.visible = true;
			if (FlxG.keys.any())
			{
				roundEnd = true;
			}		
		}
		
		override public function nextLevel():Boolean
		{
			if( roundEnd )
			{
				return true;
			}
			return false;
		}
	}
}
