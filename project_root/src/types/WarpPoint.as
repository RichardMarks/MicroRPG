package types 
{
	import flash.geom.*;
	
	/**
	 * implements a warp point - an invisible object on a map that when touched
	 * will magically warp the player to a new map!
	 * @author Richard Marks
	 */
	public class WarpPoint
	{
		/**
		 * creates a new WarpPoint with the given data
		 * @param	pos - position of the warp point in pixels
		 * @param	destMapName - name of the destination map
		 * @param	destCoordinate - position on the destination map to which the player should be warped
		 * @return the created WarpPoint
		 */
		static public function Create(pos:Point, destMapName:String, destCoordinate:Point):WarpPoint
		{
			var warp:WarpPoint = new WarpPoint();
			warp.Position = new Point(pos.x, pos.y);
			warp.Map = destMapName;
			warp.To = new Point(destCoordinate.x, destCoordinate.y);
			return warp;
		}
		
		// position of the warp point in pixels
		private var pos:Point = new Point;
		
		// name of the destination map
		private var map:String = "undefined";
		
		// position on the destination map to which the player should be warped
		private var to:Point = new Point;
		
		// getters and setters for each property of the warp point
		public function get Position():Point { return pos; }
		public function set Position(value:Point):void { pos = value; }
		
		public function get Map():String { return map; }
		public function set Map(value:String):void { map = value; }
		
		public function get To():Point { return to; }
		public function set To(value:Point):void { to = value; }
		
		/**
		 * performs the warp of the player
		 */
		public function Go():void
		{
			// do we need to change the map?
			if (Globals.location.Name != map)
			{
				// load new map
				Globals.location.Load(map);
			}
			
			// change the player's position
			Globals.player.x = to.x;
			Globals.player.y = to.y;
		}
		
		// constructor - does not need to do anything
		public function WarpPoint() {}
	}

}