package  
{
	import entities.*;
	
	public class Globals
	{	
		// the current location (map)
		static public var location:MapEntity = null;
		
		// list of all available locations
		/*
		 * This is an Object - we are using it like a dictionary.
		 * The parameters are the "mapname": XML OGMO Editor Level Asset
		 * 
		 * The mapname cannot contain spaces and is used to identify the maps, so it should be unique.
		 * This example contains 3 small maps.
		 * 
		 * the "town", "world", and "dungeon" maps
		 * 
		 * Take note of the syntax used below.
		 */
		static public const locations:Object =
		{
			town: Assets.OEL_TOWN,
			world: Assets.OEL_WORLD,
			dungeon: Assets.OEL_DUNGEON
		};
		
		/*
		 * the collision detection we use is based on the tile IDs
		 * if you want to specify a tile as being able to be walked on,
		 * you add that tile ID to this string.
		 * Be sure to separate each tile ID with a comma and no spaces.
		 */
		static public var floorTiles:String = "0,2,4,5,7,19";
		
		// the player
		static public var player:PlayerEntity = null;
		
		/*
		 * we only want the player to use the <start> data from a map ONCE
		 * so that when we warp back to a map that contains <start>, we don't
		 * warp to that location.
		 */
		static public var playerStarted:Boolean = false;
	}
}