package entities
{
	import flash.geom.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.Draw;
	import types.*;
	
	/**
	 * implements a game map - all maps are created as XML data and 
	 * loaded using the Load() method of this class.
	 * @author Richard Marks
	 */
	public class MapEntity extends Entity
	{
		// unique identifier of the map
		private var name:String = "?";
		
		// the map of tiles for the map
		private var myTileMap:Tilemap;
		
		// the collision mask for the map
		private var myGrid:Grid;
		
		// list of warps on the map
		private var warps:Vector.<WarpPoint> = new Vector.<WarpPoint>();
		
		// public accessor for the name of the map - the name cannot be modified by outside classes.
		public function get Name():String { return name; }
		
		// constructor - don't need to do anything here
		public function MapEntity() {}
		
		public function Load(mapName:String):void
		{
			// check if the requested map is valid
			if (!Globals.locations.hasOwnProperty(mapName))
			{
				throw new Error("The map \"" + mapName + "\" is not valid. Double check your call to [MapEntity].Load()");
			}
			
			// set the map's name
			name = mapName;
			
			// load the map XML data
			var xml:XML = new XML(new Globals.locations[name]);
			
			// create the tile map
			myTileMap = new Tilemap(Assets.GFX_TILES, xml.width, xml.height, Constants.TILE_WIDTH, Constants.TILE_HEIGHT);
			
			// create the collision mask for the map
			myGrid = new Grid(xml.width, xml.height, Constants.TILE_WIDTH, Constants.TILE_HEIGHT, 0, 0);
			
			// load the player data
			LoadPlayerData(xml);
			
			// load the map data
			LoadTileData(xml);
			
			// load the map warp data
			LoadWarpData(xml);
			
			// set this entity type as "map" to simplify collision checking
			type = "map";
			
			// set this entity's layer to be really far from the viewer
			// this is so that the tile map is always rendered below our player 
			// and any other objects on the screen
			layer = 10000;
			
			// set this entity graphic to the tile map, this is how the tilemap is actually rendered
			graphic = myTileMap;
			
			// set this entity's mask to the tile map collision grid so that collision detection works
			mask = myGrid;
		}
		
		/**
		 * loads in the player data from the xml object
		 * @param	xml - valid XML data stream containing the player data
		 */
		private function LoadPlayerData(xml:XML):void
		{
			// since we want to be able to warp from map to map
			// we only want a player start location in one of the game's maps
			// if the map does not have a player start location, then it is
			// assumed that we have warped from another map to this map
			// and the player is not re-positioned
			var playerWarped:Boolean = !("start" in xml.objects[0]);
			
			// is the player object already created?
			if (Globals.player)
			{
				// if the player is currently added to the world
				if (Globals.player.world == FP.world)
				{
					// remove the player from the world
					FP.world.remove(Globals.player);
				}
			}
			else
			{
				// the player object has not been created, so we need to create it
				Globals.player = new PlayerEntity();
			}
			
			// if the player didn't warp here, we set the player's position
			if (!playerWarped)
			{
				// get the player's starting position from the XML data
				if (!Globals.playerStarted)
				{
					Globals.player.x = (int)(xml.objects[0].start.@x);
					Globals.player.y = (int)(xml.objects[0].start.@y);
					Globals.playerStarted = true;
				}
			}
			
			// add the player to the world
			FP.world.add(Globals.player);
		}
		
		/**
		 * loads in the tile map data from the xml object
		 * Note: tile map collision grid data is determined by the tile IDs
		 * @param	xml - valid XML data stream containing the tile map data
		 */
		private function LoadTileData(xml:XML):void
		{
			// loop through all of the tile map data
			for each(var t:XML in xml.tiles.tile)
			{
				// calculate the map column and row for the current tile
				// the XML holds the tile positions in pixel coordinates
				var column:int = Math.floor(t.@x / Constants.TILE_WIDTH);
				var row:int = Math.floor(t.@y / Constants.TILE_HEIGHT);
				
				// set the tile in the tile map
				myTileMap.setTile(column, row, t.@id);
				
				// set the tile map collision grid data
				// if this tile's ID is NOT a floor tile
				if (!IsFloor(t.@id))
				{
					// set the collision data for this tile to be solid
					myGrid.setCell(column, row, true);
				}
			}
		}
		
		/**
		 * loads in the map warp data from the xml object
		 * @param	xml - valid XML data stream containing the map warp data
		 */
		private function LoadWarpData(xml:XML):void
		{
			// clear the warps container so that we only have 
			// the warps for the current map in memory
			warps = new Vector.<WarpPoint>();
			
			// loop through all of the warps
			for each(var w:XML in xml.objects[0].warp)
			{
				// the position of the warp in pixels
				var warpPos:Point = new Point(w.@x, w.@y);
				
				// the destiantion map to which the player will warp
				var destMapName:String = w.@to_map;
				
				// the position to which the player will warp in pixels
				var destPos:Point = new Point(w.@to_x, w.@to_y);
				
				// create the warp
				var warp:WarpPoint = WarpPoint.Create(warpPos, destMapName, destPos);
				
				// add the warp to the warps container
				warps.push(warp);
			}
		}
		
		/**
		 * checks if there is a warp at the specified map position
		 * @param	xPos - X coordinate in pixels
		 * @param	yPos - Y coordinate in pixels
		 * @return null if no warp is found, and the WarpPoint object if there is one
		 */
		public function CheckWarp(xPos:Number, yPos:Number):WarpPoint
		{
			// loop through each warp in the warps container
			for each(var w:WarpPoint in warps)
			{
				// if the warp is located in the position we are looking
				if (w.Position.x == xPos && w.Position.y == yPos)
				{
					// return the warp object
					return w;
				}
			}
			// we didn't find any warps in this position, so we return null
			return null;
		}
		
		/**
		 * checks if the specified tile ID is a floor tile
		 * @param	t - the tile ID to check
		 * @return true if the tile ID is a floor tile
		 */
		private function IsFloor(t:Number):Boolean
		{
			// to add more floor tiles (tiles you can walk on)
			// simply add their ID to the floorTiles string in Globals.as
			return Find(t.toString(), Globals.floorTiles.split(","));
		}
		
		/**
		 * searches the list array for the search term
		 * @param	searchTerm - what to search for
		 * @param	list - array to search [ should contain only strings ]
		 * @return true if the search term is found in the list array, false otherwise
		 */
		private function Find(searchTerm:String, list:Array):Boolean
		{
			// loop through each item in the list
			for each(var item:String in list)
			{
				// if there is a match
				if (item == searchTerm)
				{
					// found the search term
					return true;
				}
			}
			// did not find the search term
			return false;
		}
		
		// uncomment this block if you want to have visual feedback on solid tiles
		/*
		override public function render():void 
		{
			super.render();
			
			for (var ty:Number = 0; ty < myGrid.rows; ty++)
			{
				for (var tx:Number = 0; tx < myGrid.columns; tx++)
				{
					if (myGrid.getCell(tx, ty))
					{
						Draw.rect(tx * 8, ty * 8, 8, 8, 0xFF0000, 0.8);
					}
				}
			}
		}
		*/
	}
}