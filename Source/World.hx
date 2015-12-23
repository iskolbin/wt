package ;

class World {
	public var level(default,null): Level;
	public var spatial(default,null): SpatialHash2D<Entity>;
	public var activeEntities(default,null): Map<Entity,Entity>;
	var toDestroy: Array<Entity>;

	public function new( level ) {
		this.level = level;
		this.spatial = new SpatialHash2D( 32.0 );
		this.activeEntities = new Map<Entity,Entity>();
		this.toDestroy = [];
		for ( e in level.entities ) {
			spatial.insert( e );
		}
	}

	public function addEntity( e: Entity ) {
		if ( !spatial.exists( e )) {
			spatial.insert( e );
			level.addEntity( e );
		}
	}

	public function setActive( e: Entity, active: Bool ) {
		if ( active ) {
			if ( !activeEntities.exists( e )) {
				activeEntities[e] = e;
			}
		} else {
			if ( activeEntities.exists( e )) {
				activeEntities.remove( e );
			}
		}
	}

	public function trySetPos( e: Entity, x: Float, y: Float ) {
		var ok = true;
		var x0 = e.aabb.x;
		var y0 = e.aabb.y;
		spatial.setPos( e, x, y );
		if ( spatial.hasIntersections( e )) {
			if ( !processCollisions( e )) {
				ok = false;
				spatial.setPos( e, x0, y0 );
			}
		}
		return ok;
	}

	public inline function tryAddPos( e: Entity, dx: Float, dy: Float ) {
		return trySetPos( e, e.aabb.x + dx, e.aabb.y + dy );
	}

	public function update( dt: Float ) {		
		for ( e in activeEntities ) {
			if ( e.velocity != 0.0 ) {
				var dx = dt*e.velocity;
				switch ( e.direction ) {
					case Direction.Up: tryAddPos( e, 0, -dx );
					case Direction.Down: tryAddPos( e, 0, dx );
					case Direction.Left: tryAddPos( e, -dx, 0 );
					case Direction.Right: tryAddPos( e, dx, 0 );
				}
			}
		}	
		doDestoryEntities();	
	}

	public function trySetDirection( e: Entity, direction: Direction ) {
		var ok = true;
		if ( Direction.isRotated( e.direction, direction )) { 
			spatial.flip( e );
			if ( spatial.hasIntersections( e )) {
				if ( !processCollisions( e )) {
					spatial.flip( e );
					ok = false;
				} else {
					e.direction = direction;
				}
			} else {
				e.direction = direction;
			}
		} else {
			e.direction = direction;
		}
		return ok;
	}

	function doDestoryEntities() {
		while ( toDestroy.length > 0 ) {
			var e = toDestroy.pop();
			spatial.remove( e );
			level.removeEntity( e );
			activeEntities.remove( e );
		}
	}

	function destroyEntity( e: Entity ) {
		toDestroy.push( e );
	}

	function processCollisions( e1: Entity ) {
		var ok = true;
		for (	e2 in spatial.getIntersections( e1 )) {
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
