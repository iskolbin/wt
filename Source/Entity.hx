package ;

class Entity implements SpatialEntity2D {
	public var aabb: AABB; 
	
	public var direction: Direction = Direction.Up;
	public var velocity: Float = 0.0;
	public var type(default,null): EntityType;
	public var cooldown: Float;

	public inline function new( x: Float, y: Float, type: EntityType ) {
		this.aabb = createAABB( x, y, type );
		this.type = type;
	}

	function createAABB( x: Float, y: Float, type: EntityType ) {
		return switch( type ) {
			case Bullet | AIBullet: return new AABB( x, y, 4, 4 );
			case BrickWall | SteelWall: return new AABB( x, y, 16, 16 );
			case SmallTank | AISmallTank: return new AABB( x,y,20,30 );
			case _: return new AABB( x, y, 0, 0 );	
		}
	}

	public function update( dt: Float ) {
 	}
}
