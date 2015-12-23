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
		player = new Entity( 40, 100, EntityType.SmallTank );
		var level = new Level();
		level.createWallsFromASCII( 16.0,
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
		world.addEntity( player );
		world.setActive( player, true );	
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
			trace( renderer.context );
			switch (renderer.context) {
				case CANVAS (context):
					context.imageSmoothingEnabled = false;
					context.fillStyle = "#000";
					context.scale(SCALE,SCALE);
				case _:
			}
		}
		switch (renderer.context) {
			
			case CANVAS(context):
					
				context.fillStyle = "#000";
				context.fillRect (0, 0, window.width, window.height);
					for ( e in world.level.entities ) {
						var src = switch (e.type ) {
							case BrickWall: brick;
							case SteelWall: steel;
							case SmallTank: smalltank;
							case _: null;
						}
						if ( src != null ) {
							context.drawImage( src.src, e.aabb.x, e.aabb.y );
						}
					}
					
					context.fillStyle = "#f00";

					for ( e in world.spatial.entities ) {
					//	context.fillRect( e.aabb.x, e.aabb.y, e.aabb.width, e.aabb.height );
					}	

					for ( ys in world.spatial.xy2es ) {
						for ( es in ys ) {
							for ( e in es ) {

								context.fillRect( e.aabb.x, e.aabb.y, e.aabb.width, e.aabb.height );
							}
						}
					}

					for ( x in world.spatial.xy2es.keys() ) {
						for ( y in world.spatial.xy2es[x].keys()) {
							var es = world.spatial.xy2es[x][y];
							context.fillText( '${world.spatial.xy2es[x][y].length}', x*16, y*16); 
						}
					}
			case _:
		}

		var nextStamp = haxe.Timer.stamp();
		world.update( nextStamp - currentStamp );
		currentStamp = nextStamp;
	}

	public override function onKeyDown (window:Window, key:KeyCode, modifier:KeyModifier):Void {
		switch (key) {
			case LEFT: if ( world.trySetDirection( player, Direction.Left )) player.velocity = 50.0;
			case RIGHT: if ( world.trySetDirection( player, Direction.Right )) player.velocity = 50.0;
			case UP: if ( world.trySetDirection( player, Direction.Up )) player.velocity = 50.0;
			case DOWN: if ( world.trySetDirection( player, Direction.Down )) player.velocity = 50.0;
			case _:
		}
	}
	
	
	public override function onKeyUp (window:Window, key:KeyCode, modifier:KeyModifier):Void {
		switch (key) {
			case LEFT if ( player.direction == Direction.Left ): player.velocity = 0.0;
			case RIGHT if ( player.direction == Direction.Right ): player.velocity = 0.0;
			case UP if ( player.direction == Direction.Up ): player.velocity = 0.0;
			case DOWN if ( player.direction == Direction.Down ): player.velocity = 0.0;
			case _:
		};
	}
}
