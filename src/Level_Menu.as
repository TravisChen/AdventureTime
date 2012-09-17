package    {
	
	import org.flixel.*;
	
	public class Level_Menu extends Level{
		
		[Embed(source = '../data/sky.png')] private var ImgBackground:Class;
		[Embed(source = '../data/adventure.png')] private var ImgAdventure:Class;
		[Embed(source = '../data/space-big.png')] private var ImgWasd:Class;
		
		public var wasd:FlxSprite;
		public var wasdFadeInTime:Number;
		public var wasdBounceTime:Number;
		public var wasdBounceToggle:Boolean;
		
		public var startTime:Number;

		public function Level_Menu( group:FlxGroup ) {
			
			super();
			
			levelSizeX = 680;
			levelSizeY = 400;
			
			startTime = 1.0;
			
			createForegroundAndBackground();
		}
		
		override public function nextLevel():Boolean
		{
			if( startTime > 0 )
			{
				startTime -= FlxG.elapsed;
				return false;
			}
			
			if(FlxG.keys.any() )
			{
				return true;
			}
			return false;
		}
		
		public function createForegroundAndBackground():void {
			
			var backgroundSprite:FlxSprite;
			backgroundSprite = new FlxSprite(0,0);
			backgroundSprite.loadGraphic(ImgBackground, true, true, levelSizeX, levelSizeY);	
			PlayState.groupLowest.add(backgroundSprite);
			
			var introPlayer:PlayerIntro = new PlayerIntro(FlxG.width/2 - 110,FlxG.height/2 + 6);
			PlayState.groupBackground.add(introPlayer);
			
			backgroundSprite = new FlxSprite(0,0);
			backgroundSprite.loadGraphic(ImgAdventure, true, true, levelSizeX, levelSizeY);	
			PlayState.groupBackground.add(backgroundSprite);
			
			var introSplash:IntroSplash = new IntroSplash(0,0);
			PlayState.groupBackground.add(introSplash);
			
			// Create wasd
			createWasd();
		}
		
		public function createWasd():void {
			// Create wasd
			wasd = new FlxSprite(0,0);
			wasd.loadGraphic(ImgWasd, true, true, 64, 64);	
			wasd.x = FlxG.width/2 - 32;
			wasd.y = -12;
			wasd.alpha = 0;
			
			// Add to foreground
			PlayState.groupForeground.add(wasd);
			
			// Timer
			wasdFadeInTime = 0.5;
			wasdBounceToggle = true;
			wasdBounceTime = 0;
		}
		
		public function updateWasd():void 
		{		
			if( wasdFadeInTime <= 0 )
			{
				if( wasd.alpha < 1 )
				{
					wasd.alpha += 0.025;		
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
			else
			{
				wasdFadeInTime -= FlxG.elapsed;
			}
		}
		
		override public function update():void
		{		
			// BG color
			FlxG.bgColor = 0xFF8ad7e9;
			
			updateWasd();
			
			super.update();
		}	
	}
}
