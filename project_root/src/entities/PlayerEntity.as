package entities
{
	import flash.geom.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import types.*;
	
	/**
	 * implements the player object
	 * @author Richard Marks
	 */
	public class PlayerEntity extends Entity
	{
		// only create the graphics one time
		// so all the player's we create will use this one image
		static private var playerImage:Image = new Image(Assets.GFX_PLAYER);
		
		/**
		 * class constructor - sets up the player
		 * @param	xPos - x coordinate in pixels
		 * @param	yPos - y coordinate in pixels
		 */
		public function PlayerEntity(xPos:Number = 0, yPos:Number = 0) 
		{
			// position the player
			x = xPos;
			y = yPos;
			
			// set the collision hitbox for the player to match the image dimensions
			setHitbox(playerImage.width, playerImage.height);
			
			// set the player's graphic
			graphic = playerImage;
		}
		
		/**
		 * updates the player - we handle player controls here
		 * player moves tile by tile
		 */
		override public function update():void 
		{
			// if we've pressed the up arrow
			if (Input.pressed(Key.UP)) 
			{
				// if the space above the player is not solid
				if (!collide("map", x, y - Constants.TILE_HEIGHT)) 
				{
					// move up
					y -= Constants.TILE_HEIGHT; 
				} 
				// handle any warp points
				CheckWarp(); 
			}
			
			// if we've pressed the down arrow
			if (Input.pressed(Key.DOWN)) 
			{
				// if the space below the player is not solid
				if (!collide("map", x, y + Constants.TILE_HEIGHT)) 
				{ 
					// move down
					y += Constants.TILE_HEIGHT; 
				}
				// handle any warp points
				CheckWarp(); 
			}
			
			// if we've pressed the left arrow
			if (Input.pressed(Key.LEFT)) 
			{
				// if the space to the left of the player is not solid
				if (!collide("map", x - Constants.TILE_WIDTH, y)) 
				{
					// move left
					x -= Constants.TILE_WIDTH; 
				} 
				// handle any warp points
				CheckWarp(); 
			}
			
			// if we've pressed the right arrow
			if (Input.pressed(Key.RIGHT)) 
			{ 
				// if the space to the right of the player is not solid
				if (!collide("map", x + Constants.TILE_WIDTH, y)) 
				{
					// move right
					x += Constants.TILE_WIDTH; 
				} 
				// handle any warp points
				CheckWarp(); 
			}
			
			super.update();
		}
		
		/**
		 * check the player's location for a warp
		 */
		private function CheckWarp():void
		{
			var warp:WarpPoint = Globals.location.CheckWarp(x, y);
			if (warp)
			{
				// perform the warp
				warp.Go();
			}
		}
	}
}