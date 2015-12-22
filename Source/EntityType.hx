package ;

@:enum
abstract EntityType(Int) {
	var Bullet = 0;
	
	var SmallTank = 1000;

	var AIBullet = 2000;
	
	var AISmallTank = 3000;
		
	var BrickWall = 4000;
	var SteelWall = 4002;

	var VegetationCeil = 5000;

	var WaterFloor = 6000;

	@:op(A < B) static function lt( a: EntityType, b: EntityType ) : Bool;
	@:op(A > B) static function lt( a: EntityType, b: EntityType ) : Bool;
}
