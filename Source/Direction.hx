package ;

@:enum
abstract Direction(Int) {
	var Up = 0;
	var Right = 1;
	var Down = 2;
	var Left = 3;

	static public inline function isOpposite( self: Direction, direction: Direction ): Bool {
		return switch ( self ) {
			case Direction.Up: direction == Direction.Down;
			case Direction.Down: direction == Direction.Up;
			case Direction.Left: direction == Direction.Right;
			case Direction.Right: direction == Direction.Left;
		}
	}

	static public inline function isRotated( self: Direction, direction: Direction ): Bool {
		return switch ( self ) {
			case Direction.Up | Direction.Down: direction == Direction.Left || direction == Direction.Right;
			case Direction.Left | Direction.Right: direction == Direction.Up || direction == Direction.Down;
		}
	}
}
