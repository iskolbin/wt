package ;

class Entity {
	public var direction: Direction = Direction.Up;
	public var velocity: Float = 0.0;
	public var aabb(default,null): AABB; 
	public var type(default,null): EntityType;
	public var cooldown: Float;
	public var id(default,null): Int = -0x7fffffff;
	public var world(default,null): World = null;
	var toUndo: Float = 0.0;

	public inline function setId( world: World, id: Int ) {
		if ( world != null ) {
			this.id = id;
		}
	}

	public inline function new( x: Float, y: Float, type: EntityType ) {
		this.aabb = createAABB( x, y, type );
		this.type = type;
	}

	function createAABB( x: Float, y: Float, type: EntityType ) {
		return switch( type ) {
			case Bullet | AIBullet: return new AABB( x+0.45, y+0.45, 0.1, 0.1 );
			case BrickWall | SteelWall: return new AABB( x, y, 1, 1 );
			case SmallTank | AISmallTank: return new AABB( x,y,1.25,1.875 );
			case _: return new AABB( x, y, 0, 0 );	
		}
	}

	public function update( dt: Float ) {
		if ( this.velocity != 0.0 ) {
			this.toUndo = dt*this.velocity;
			switch ( direction ) {
				case Direction.Up: aabb.y -= this.toUndo;
				case Direction.Down: aabb.y += this.toUndo;
				case Direction.Left: aabb.x -= this.toUndo;
				case Direction.Right: aabb.x += this.toUndo;
			}
			return true;
		}
		return false;
 	}

	var predDirection: Direction = Direction.Up;

	public function setDirection( newDirection: Direction ) {
		predDirection = direction;
		if (( direction == Direction.Up || direction == Direction.Down ) && (newDirection == Direction.Left || newDirection == Direction.Right) ||
			 ( direction == Direction.Left || direction == Direction.Right ) && (newDirection == Direction.Up || newDirection == Direction.Down)) {
			direction = newDirection;
			aabb.flipWidthHeight();
			return true;	
		}
		direction = newDirection;
		return false;
	}

	public inline function undoDirection() {
		setDirection( predDirection );
	}

	public function undoUpdate() {
		switch (direction) {
			case Direction.Up: aabb.y += this.toUndo;
			case Direction.Down: aabb.y -= this.toUndo;
			case Direction.Left: aabb.x += this.toUndo;
			case Direction.Right: aabb.x -= this.toUndo;		
		}
	}
}
