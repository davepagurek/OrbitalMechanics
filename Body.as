package  {
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Body extends MovieClip {
		
		public var velocity:Geovector = new Geovector(0, 0);
		private var _mass:Number = 1;
		private var _radius:Number = 1;
		
		public static const blank:Geovector = new Geovector(0, 0);

		public function Body(_x:Number = 0, _y:Number = 0, __mass:Number = 1, _velocity:*=null) {
			_mass = __mass;

			if (_velocity && Class(getDefinitionByName(getQualifiedClassName(_velocity)))==Geovector) {
				velocity = _velocity;
			}
			x = _x;
			y = _y;
			_radius = 2+_mass/3;
			
			this.graphics.beginFill(0x000000, 1);
			this.graphics.drawCircle(0, 0, _radius);
			this.graphics.endFill();
		}

		public function get mass():Number {
			return _mass;
		}

		public function get radius():Number {
			return _radius;
		}

	}
	
}
