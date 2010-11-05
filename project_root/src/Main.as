package  
{
	import net.flashpunk.*;
	import worlds.*;
	
	public class Main extends Engine
	{
		public function Main() { super(320, 240); }
		override public function init():void 
		{
			// we want a 640x480 screen so scale X2
			FP.screen.scale = 2;
			
			// start it up!
			FP.world = new GameWorld;
			
			super.init();
		}
	}

}