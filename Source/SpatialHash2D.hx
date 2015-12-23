package ;

@:generic
class SpatialHash2D<T:SpatialEntity2D> {
	public var xy2es(default,null): Map<Int,Map<Int,Array<T>>>;
	public var nys(default,null): Map<Int,Int>;
	public var entities(default,null): Map<T,T>;
	public var cellsize(default,null): Float;

	public var NO_ENTITIES_ARRAY(default,null) = new Array<T>();

	public inline function new( cellsize: Float ) {
		xy2es = new Map<Int,Map<Int,Array<T>>>();
		nys = new Map<Int,Int>();
		entities = new Map<T,T>();
		this.cellsize = cellsize;
	}

	public inline function exists( e: T ) {
		return entities.exists( e );
	}

	inline function doInsert( e: T, x: Int, y: Int ) {
		if ( !xy2es.exists( x )) {
			xy2es[x] = [y => [e]];
			nys[x] = 1;
		} else if ( !xy2es[x].exists( y )) {
			xy2es[x][y] = [e];
			nys[x] += 1;
		} else {
			xy2es[x][y].push( e );
		}
	}

	inline function doRemove( e: T, x: Int, y: Int ) {	
		var es = xy2es[x][y];
		var i = es.indexOf( e );
		if ( i >= 0 ) {
			if ( es.length <= 1 ) {
				xy2es[x].remove( y );
				if ( nys[x] <= 1 ) {
					xy2es.remove( x );
					nys.remove( x );
				} else {
					nys[x] -= 1;
				}
			} else if ( i == es.length-1 ) {
				es.pop();
			} else {
				es[i] = es[es.length-1];
				es.pop();
			}
		}
	}

	public inline function update( e: T ) {
		remove( e );
		insert( e );
	}

	public function setPos( e: T, x: Float, y: Float ) {
		if ( Std.int( e.aabb.x ) != Std.int( x ) || Std.int( e.aabb.y ) != Std.int( y )) {
			remove( e );
			e.aabb.x = x;
			e.aabb.y = y;
			insert( e );
		} else {
			e.aabb.x = x;
			e.aabb.y = y;
		}
	}

	public function setSize( e: T, width: Float, height: Float ) {
		if ( Std.int( e.aabb.width ) != Std.int( width ) || Std.int( e.aabb.height ) != Std.int( height )) {
			remove( e );
			e.aabb.width = width;
			e.aabb.height = height;
			insert( e );
		} else {
			e.aabb.width = width;
			e.aabb.height = height;
		}
	}

	public inline function addPos( e: T, dx: Float, dy: Float ) {
		setPos( e, e.aabb.x + dx, e.aabb.y + dy );
	}

	public inline function addSize( e: T, dwidth: Float, dheight: Float ) {
		setSize( e, e.aabb.width + dwidth, e.aabb.height + dheight );
	}

	public inline function flip( e: T ) {
		setSize( e, e.aabb.height, e.aabb.width );
	}

	public inline function convertCoord( x: Float ) {
		return Std.int( x / cellsize );
	}

	public function insert( e: T ) {
		if ( exists( e )) {
			remove( e );
		}
		
		var aabb = e.aabb;
		var xmin = convertCoord( aabb.xmin );
		var xmax = convertCoord( aabb.xmax );
		var ymin = convertCoord( aabb.ymin );
		var ymax = convertCoord( aabb.ymax );
		
		for ( x in xmin...xmax+1 ) {
			for ( y in ymin...ymax+1 ) {
				doInsert( e, x, y );
			}
		}

		entities[e] = e;
	}

	public function remove( e: T ) {
		if ( exists( e )) {
			var aabb = e.aabb;
			var xmin = convertCoord( aabb.xmin );
			var xmax = convertCoord( aabb.xmax );
			var ymin = convertCoord( aabb.ymin );
			var ymax = convertCoord( aabb.ymax );	
			
			for ( x in xmin...xmax+1 ) {
				for ( y in ymin...ymax+1 ) {
					doRemove( e, x, y );
				}
			}

			entities.remove( e );
		}
	}

	public inline function existAt( x: Int, y: Int ) {
		return getAt( x, y ) == NO_ENTITIES_ARRAY;
	}

	public inline function getAt( x: Int, y: Int ) {
		var es = NO_ENTITIES_ARRAY;
		if ( xy2es.exists( x )) {
			if ( xy2es[x].exists( y )) {
				es = xy2es[x][y];
			}
		}
		return es;
	}

	public function getFirstIntersection( e1: T ) {
		if ( exists( e1 )) {
			var aabb = e1.aabb;
			var xmin = convertCoord( aabb.xmin );
			var xmax = convertCoord( aabb.xmax );
			var ymin = convertCoord( aabb.ymin );
			var ymax = convertCoord( aabb.ymax );	
			for ( x in xmin...xmax+1 ) {
				for ( y in ymin...ymax+1 ) {
					for ( e2 in getAt( x, y )) if (e2 != e1 && e2.aabb.intersects( aabb )) {
						return e2;
					}
				}
			}
		}
		return null;
	}

	public inline function hasIntersections( e: T ) {
		return getFirstIntersection( e ) != null;
	}

	public function getIntersections( e1: T ) {
		var intersections = new Array<T>();
		if ( exists( e1 )) {
			var aabb = e1.aabb;
			var checked = [e1 => true];
			var xmin = convertCoord( aabb.xmin );
			var xmax = convertCoord( aabb.xmax );
			var ymin = convertCoord( aabb.ymin );
			var ymax = convertCoord( aabb.ymax );	
			for ( x in xmin...xmax+1 ) {
				for ( y in ymin...ymax+1 ) {
					for ( e2 in getAt( x, y )) if (!checked[e2] && e2.aabb.intersects( aabb )) {
						intersections.push( e2 );
						checked[e2] = true;
					}
				}
			}
		}
		return intersections;
	}
}

private class ItersectionsIterator {
	public function new( spatial: SpatialHash2D, e: SpatialEntity2D, xmin: Float, xmax: Float, ymin: Float, ymax: Float ) {
		var aabb = e1.aabb;
		var checked = [e1 => true];
		var xmin = convertCoord( aabb.xmin );
		var xmax = convertCoord( aabb.xmax );
		var ymin = convertCoord( aabb.ymin );
		var ymax = convertCoord( aabb.ymax );	
			for ( x in xmin...xmax+1 ) {
				for ( y in ymin...ymax+1 ) {
					for ( e2 in getAt( x, y )) if (!checked[e2] && e2.aabb.intersects( aabb )) {
						intersections.push( e2 );
						checked[e2] = true;
					}
				}
			}
	}	
}
