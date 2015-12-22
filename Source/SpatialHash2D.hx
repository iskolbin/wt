package ;

class SpatialHash2D {
	var xy2e: Array<Array<Array<Int>>>;
	var e2aabb: Map<Int,AABB>;

	public var width(default,null): Int;
	public var height(default,null): Int;
	public var aabb(default,null): AABB;

	public inline function new( width: Int, height: Int ) {
		this.xy2e = [for ( x in 0...width ) [for ( y in 0...height ) []]];
		this.e2aabb = new Map<Int,AABB>();
		this.width = width;
		this.height = height;
		this.aabb = new AABB( 0.0, 0.0, width-1.0, height-1.0 );
	}

	public function insert( aabb: AABB, v: Int ) {
		var oldAabb = e2aabb[v];

		if ( oldAabb != null ) {
			if ( !oldAabb.equalInt( aabb )) {
				remove( v );		
			}
		} 
			
		if ( aabb.inside( this.aabb )) {
			var xmin = Std.int( aabb.xmin );
			var xmax = Std.int( aabb.xmax );
			var ymin = Std.int( aabb.ymin );
			var ymax = Std.int( aabb.ymax );
			xy2e[xmin][ymin].push( v );
			if ( ymin != ymax ) {
				xy2e[xmin][ymax].push( v );
			}
			if ( xmin != xmax ) {
				xy2e[xmax][ymin].push( v );
				if ( ymin != ymax ) {
					xy2e[xmax][ymax].push( v );
				}
			}
			e2aabb[v] = aabb;
		} else {
			throw 'Inserting outside of spatial hash: AABB=${aabb} id=${v}';
		}
	}

	public function remove( v: Int ) {
		var aabb = e2aabb[v];

		if ( aabb != null ) {
			var xmin = Std.int( aabb.xmin );
			var xmax = Std.int( aabb.xmax );
			var ymin = Std.int( aabb.ymin );
			var ymax = Std.int( aabb.ymax );
			e2aabb.remove( v );
			xy2e[xmin][ymin].remove( v );
			if ( ymin != ymax ) {
				xy2e[xmin][ymax].remove( v );
			}
			if ( xmin != xmax ) {
				xy2e[xmax][ymin].remove( v );
				if ( ymin != ymax ) {
					xy2e[xmax][ymax].remove( v );
				}
			}
		}
	}

	public inline function getAt( x: Int, y: Int ) {
		return this.xy2e[x][y];
	}

	public inline function getAABB( v: Int ) {
		return e2aabb[v];
	}

	public inline function exists( v: Int ) {
		return e2aabb[v] != null;
	}

	public function hasIntersections( v: Int ) {
		var aabb = getAABB( v );
		if ( aabb != null ) {
			var xmin = Std.int( aabb.xmin );
			var ymin = Std.int( aabb.ymin );
			for ( id in getAt( xmin, ymin )) if (id != v && e2aabb[id].intersects( aabb )) {
				return true;
			}
			var xmax = Std.int( aabb.xmax );
			if ( xmin != xmax ) {	
				for ( id in getAt( xmax, ymin )) if (id != v && e2aabb[id].intersects( aabb )) {
					return true;
				}
			}
			var ymax = Std.int( aabb.ymax );
			if ( ymin != ymax ) {
				for ( id in getAt( xmin, ymax )) if (id != v && e2aabb[id].intersects( aabb )) {
					return true;
				}
				if ( xmin != xmax ) {
					for ( id in getAt( xmax, ymax )) if (id != v && e2aabb[id].intersects( aabb )) {
						return true;
					}
				}
			}
		}
		return false;
	}

	public function getIntersections( v: Int ) {
		var intersections = new Array<Int>();
		var checked = [v => true];
		var aabb = getAABB( v );
		if ( aabb != null ) {
			var xmin = Std.int( aabb.xmin );
			var ymin = Std.int( aabb.ymin );
			var xmax = Std.int( aabb.xmax );
			var ymax = Std.int( aabb.ymax );
			for ( id in getAt( xmin, ymin )) if (!checked[id] && e2aabb[id].intersects( aabb )) {
				intersections.push( id );
				checked[id] = true;
			}
			if ( xmin != xmax ) {	
				for ( id in getAt( xmax, ymin )) if (!checked[id] && e2aabb[id].intersects( aabb )) {
					intersections.push( id );
					checked[id] = true;
				}
			}
			if ( ymin != ymax ) {
				for ( id in getAt( xmin, ymax )) if (!checked[id] && e2aabb[id].intersects( aabb )) {
					intersections.push( id );
					checked[id] = true;
				}
				if ( xmin != xmax ) {
					for ( id in getAt( xmax, ymax )) if (!checked[id] && e2aabb[id].intersects( aabb )) {
						intersections.push( id );
						checked[id] = true;
					}
				}
			}
		}
		return intersections;
	}
}
