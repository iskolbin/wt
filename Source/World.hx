package ;

class World {
	public var level(default,null): Level;
	public var spatial(default,null): SpatialHash2D;
	public var idCounter(default,null): Int = 0;

	public function new( level ) {
		this.level = level;
		this.spatial = new SpatialHash2D( 100, 100 );
		for ( e in level.entities ) {
			e.setId( this, idCounter++ );
			spatial.insert( e.aabb, e.id );
		}
		for ( e in level.passiveEntities ) {
			e.setId( this, idCounter++ );
			spatial.insert( e.aabb, e.id );
		}
	}

	public function update( dt: Float ) {		
		var checked = new Map<Int,Bool>();
		for ( e in level.entities ) {
			if ( e.update( dt )) {
				spatial.remove( e.id );
				spatial.insert( e.aabb, e.id );
				if ( spatial.hasIntersections( e.id )) {
					if (!processCollisions( e.id, spatial.getIntersections( e.id ), checked )) {
						e.undoUpdate();
						spatial.remove( e.id );
						spatial.insert( e.aabb, e.id );
					}
					checked[e.id] = true;
				}
			}
		}		
	}

	public function setDirection( id: Int, direction: Direction ) {
		var checked = new Map<Int,Bool>();
		var e = level.entities[id];
		if ( e != null ) {
			if ( e.setDirection( direction )) {
				spatial.remove( e.id );
				spatial.insert( e.aabb, e.id );
				if ( spatial.hasIntersections( e.id )) {
					if (!processCollisions( e.id, spatial.getIntersections( e.id ), checked )) {
						e.undoDirection();
						spatial.remove( e.id );
						spatial.insert( e.aabb, e.id );
					}
					checked[e.id] = true;
				}
			}
		}
	}

	inline function entityOf( id: Int ) {
		return level.entities[id] == null ? level.passiveEntities[id]: level.entities[id];
	}

	function destroyEntity( e: Entity ) {
		level.removeEntity( e );
		spatial.remove( e.id );
	}

	function processCollisions( id: Int, intersections: Array<Int>, checked: Map<Int,Bool> ) {
		var ok = true;
		for (	otherId in intersections ) if (!checked.exists( otherId )) {
			var e1 = entityOf( id );
			var e2 = entityOf( otherId );
			if ( e2.type < e1.type ) {
				var tmp = e1;
				e1 = e2;
				e2 = tmp;
			}
			switch ( e1.type ) {
				case Bullet: switch ( e2.type ) {
					case SmallTank: e2.velocity = 0; destroyEntity( e1 );
					case AISmallTank | BrickWall: destroyEntity( e1 ); destroyEntity( e2 );
					case SteelWall: destroyEntity( e1 );
					case _:
				}

				case SmallTank: switch( e2.type ) {
					case SmallTank | AISmallTank | BrickWall | SteelWall: ok = false;
					case AIBullet: destroyEntity( e1 ); destroyEntity( e2 );
					case _:
				}

				case AIBullet: switch( e2.type ) {
					case AISmallTank: e2.velocity = 0; destroyEntity( e1 );
					case BrickWall: destroyEntity( e1 ); destroyEntity( e2 );
					case SteelWall: destroyEntity( e1 );
					case _:
				}

				case _:
			}
		}
		return ok;
	}
}
