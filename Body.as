package  {
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Body extends MovieClip {
		
		public var velocity:Geovector = new Geovector(0, 0);
		public var mass:Number = 1;
		public var radius:Number = 1;
		
		public static const blank:Geovector = new Geovector(0, 0);

		public function Body(_x:Number = 0, _y:Number = 0, _mass:Number = 1, _velocity:*=null) {
			mass = _mass;

			if (_velocity && Class(getDefinitionByName(getQualifiedClassName(_velocity)))==Geovector) {
				velocity = _velocity;
			}
			x = _x;
			y = _y;
			radius = 2+mass/3;
			
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawCircle(0, 0, radius);
			this.graphics.endFill();
		}

	}
	
}
