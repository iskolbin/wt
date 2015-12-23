package ;

class Level {
	public var entities(default,null) = new Array<Entity>();

	public function new() {
	}

	public function createWallsFromASCII( cellsize: Float, ascii: String ) {
		var y = 0;
		for ( row in ascii.split( "\n" )) {
			var x = 0;
			for ( char in row.split( "" )) {
				switch ( char ) {
					case "#": addEntity( new Entity( cellsize*x, cellsize*y, EntityType.SteelWall ));
					case "$": addEntity( new Entity( cellsize*x, cellsize*y, EntityType.BrickWall ));	
				}
				x++;
			}
			y++;
		}
	}

	public inline function addEntity( e: Entity ) entities.push( e );
	public inline function removeEntity( e: Entity ) entities.remove( e );
}
