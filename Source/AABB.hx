package ;

class AABB {
	public var x: Float;
	public var y: Float;
	public var width: Float;
	public var height: Float;

	public inline function new( x, y, width, height ) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public var xmin(get,null): Float;
	public var xmax(get,null): Float;
	public var ymin(get,null): Float;
	public var ymax(get,null): Float;

	public inline function get_xmin() return x;
	public inline function get_ymin() return y;
	public inline function get_xmax() return x + width;
	public inline function get_ymax() return y + height;

	public inline function clone() {
		return new AABB( x, y, width, height );
	}

	public inline function intersects( aabb: AABB ) {
		return xmin <= aabb.xmax && aabb.xmin <= xmax && ymin <= aabb.ymax && aabb.ymin <= ymax;
	}	

	public inline function inside( aabb: AABB ) {
		return xmin >= aabb.xmin && xmax <= aabb.xmax && ymin >= aabb.ymin && ymax <= aabb.ymax;
	}

	public inline function equal( aabb: AABB ) {
		return x == aabb.x && y == aabb.y && width == aabb.width && height == aabb.height;
	}

	public inline function equalInt( aabb: AABB ) {
		return Std.int( x ) == Std.int( aabb.x ) && Std.int( y ) == Std.int( aabb.y ) && Std.int( width ) == Std.int( aabb.width ) && Std.int( height ) == Std.int( aabb.height );
	}

	public inline function intersects2( xmin: Float, ymin: Float, xmax: Float, ymax: Float ) {
		return xmin <= this.xmax && this.xmin <= xmax && ymin <= this.ymax && this.ymin <= ymax;
	}	

	public inline function inside2( xmin: Float, ymin: Float, xmax: Float, ymax: Float ) {
		return xmin >= this.xmin && xmax <= this.xmax && ymin >= this.ymin && ymax <= this.ymax;
	}

	public inline function equal2( xmin: Float, ymin: Float, width: Float, height: Float ) {
		return x == this.x && y == this.y && width == this.width && height == this.height;
	}
	
	public inline function equalInt2( x: Float, y: Float, width: Float, height: Float ) {
		return Std.int( x ) == Std.int( this.x ) && Std.int( y ) == Std.int( this.y ) && Std.int( width ) == Std.int( this.width ) && Std.int( height ) == Std.int( this.height );
	}

	public inline function equalInt3( x: Int, y: Int, width: Int, height: Int ) {
		return x == Std.int( this.x ) && y == Std.int( this.y ) && width == Std.int( this.width ) && height == Std.int( this.height );
	}
}
