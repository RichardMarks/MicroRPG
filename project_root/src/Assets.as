package  
{
	public class Assets
	{
		// player graphics
		[Embed(source = "../assets/player.png")] static public const GFX_PLAYER:Class;
		
		// tileset graphics for the maps
		[Embed(source = "../assets/tiles.png")] static public const GFX_TILES:Class;
		
		// game maps
		[Embed(source = "../assets/world.oel", mimeType = "application/octet-stream")] static public const OEL_WORLD:Class;
		[Embed(source = "../assets/town.oel", mimeType = "application/octet-stream")] static public const OEL_TOWN:Class;	
		[Embed(source = "../assets/dungeon.oel", mimeType = "application/octet-stream")] static public const OEL_DUNGEON:Class;	
	}
}