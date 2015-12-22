package ;

import haxe.ds.Vector;

class Level {
	public var player(default,null): Entity;
	public var entities(default,null) = new Array<Entity>();
	public var passiveEntities(default,null) = new Array<Entity>();

	public function new( player ) {
		this.player = player;
		addEntity( player );
	}

	public function createWallsFromASCII( ascii: String ) {
		var y = 0;
		for ( row in ascii.split( "\n" )) {
			var x = 0;
			for ( char in row.split( "" )) {
				switch ( char ) {
					case "#": addPassiveEntity( new Entity( x, y, EntityType.SteelWall ));
					case "$": addPassiveEntity( new Entity( x, y, EntityType.BrickWall ));	
				}
				x++;
			}
			y++;
		}
	}

	public function setPassive( e: Entity, passive: Bool ) {
		if ( passive ) {
			entities.remove( e );
			passiveEntities.push( e );
		} else {
			entities.push( e );
			passiveEntities.remove( e );
		}
	}
	public inline function addEntity( e: Entity ) entities.push( e );
	public inline function removeEntity( e: Entity ) entities.remove( e );
	public inline function addPassiveEntity( e: Entity ) passiveEntities.push( e );
	public inline function removePassiveEntity( e: Entity ) passiveEntities.remove( e );
}
