package worlds
{
	import entities.*;
	import net.flashpunk.*;
	
	public class GameWorld extends World
	{	
		public function GameWorld() { }
		
		override public function begin():void 
		{
			// add the map to the world
			add(Globals.location = new MapEntity());
			
			// load the map
			Globals.location.Load("world");
			
			super.begin();
		}
	}
}