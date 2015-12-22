package;

import lime.app.Application;
import lime.graphics.Image;
import lime.graphics.Renderer;
import lime.Assets;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;

class Main extends Application {
	
	private var image:Image;
	var world: World;
	var player: Entity;

	public function new () {
		super ();
		player = new Entity( 3, 8, EntityType.SmallTank );
		var level = new Level( player );
		level.createWallsFromASCII(
			"##########################\n" + 
			"#                        #\n" +
			"#                        #\n" +
			"#       #############    #\n" + 
			"#####  ##         ###    #\n" +
			"#      $    $            #\n" +
			"#      $$$$$$$$$         #\n" +
			"#       $$$ $$           #\n" +
			"#          $$    $$$$$$$$#\n" +
			"#             $$        $#\n" +
			"#              $       $$#\n" +
			"#              $$$       #\n" +
			"#            $$$$$       #\n" +
			"#              $$$       #\n" +
			"#                        #\n" +
			"##########################" );
		world = new World( level );
	}
	
	static inline var SCALE = 1;

	var brick: Image;
	var steel: Image;
	var smalltank: Image;	
	var currentStamp: Float;
	
	public override function render (renderer:Renderer):Void {
		if (image == null && preloader.complete) {
			currentStamp = haxe.Timer.stamp();
			image = Assets.getImage("assets/lime.png");
			brick = Assets.getImage("assets/wall_brick.png");
			steel = Assets.getImage("assets/wall_steel.png");
			smalltank = Assets.getImage("assets/tank_small.png");
			switch (renderer.context) {
				
				case CANVAS (context):
					context.imageSmoothingEnabled = false;
					context.fillStyle = "#fff";
					context.scale(SCALE,SCALE);
				case _:
			}
		}
		switch (renderer.context) {
			
			case CANVAS(context):
					
				context.fillRect (0, 0, window.width, window.height);
					for ( e in world.level.passiveEntities ) {
						var src = switch (e.type ) {
							case BrickWall: brick;
							case SteelWall: steel;
							case _: null;
						}
						if ( src != null ) {
							context.drawImage( src.src, e.aabb.x * 16, e.aabb.y *16 );
						}
					}

					var player = world.level.player;
					context.drawImage( smalltank.src, player.aabb.x * 16, player.aabb.y * 16);
			
			case _:
		}

		var nextStamp = haxe.Timer.stamp();
		world.update( nextStamp - currentStamp );
		currentStamp = nextStamp;
	}

	public override function onKeyDown (window:Window, key:KeyCode, modifier:KeyModifier):Void {
		var player = world.level.player;
		switch (key) {
			case LEFT: player.direction = Direction.Left; player.velocity = 1.0;
			case RIGHT: player.direction = Direction.Right; player.velocity = 1.0;
			case UP: player.direction = Direction.Up; player.velocity = 1.0;
			case DOWN: player.direction = Direction.Down; player.velocity = 1.0;
			default:
		}
	}
	
	
	public override function onKeyUp (window:Window, key:KeyCode, modifier:KeyModifier):Void {
		var player = world.level.player;
		switch (key) {
			case LEFT if ( player.direction == Direction.Left ): player.velocity = 0.0;
			case RIGHT if ( player.direction == Direction.Right ): player.velocity = 0.0;
			case UP if ( player.direction == Direction.Up ): player.velocity = 0.0;
			case DOWN if ( player.direction == Direction.Down ): player.velocity = 0.0;
			default:
		};
	}
}
