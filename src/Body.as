package 
{
	/**
	 * ...
	 * @author Dave Pagurek
	 */
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.geom.Point;
	
	public class Body extends MovieClip {
		
		public var velocity:Geovector = new Geovector(0, 0);
		public var trailLength:Number = 60;
		private var _history:Vector.<Point> = new Vector.<Point>();
		private var _color:uint = 0xFFFFFF;
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
			
			this.graphics.beginFill(_color, 1);
			this.graphics.drawCircle(0, 0, _radius);
			this.graphics.endFill();
		}
		
		public function addHistory(p:Point):void {
			_history.unshift(p);
			while (history.length > trailLength) {
				history.pop();
			}
		}
		
		public function get history():Vector.<Point> {
			return _history;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(value:uint):void {
			_color = value;
			this.graphics.clear();
			this.graphics.beginFill(_color, 1);
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