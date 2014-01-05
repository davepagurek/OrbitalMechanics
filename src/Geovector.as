package 
{
	/**
	 * ...
	 * @author Dave Pagurek
	 */
	public class Geovector {
		
		public var magnitude:Number = 0;
		public var angle:Number = 0;

		public function Geovector(_magnitude:Number = 0, _angle:Number = 0) {
			magnitude = _magnitude;
			while (_angle<0) _angle+=2*Math.PI;
			while (_angle>2*Math.PI) _angle-=2*Math.PI;
			angle = _angle;
		}
		
		public static function atan(_x:Number, _y:Number):Number {
			var _angle:Number=0;
			if (_x==0) {
				if (_y>0) {
					_angle = Math.PI/2;
				} else {
					_angle = 3*Math.PI/2;
				}
			} else if (_y==0) {
				if (_x>0) {
					_angle = 0;
				} else {
					_angle = Math.PI;
				}
			} else {
				_angle = Math.atan(_y/_x);
				if (_x<0) {
					_angle += Math.PI;
				}
			}
			return _angle;
		}
		
		public function setComponents(_x:Number, _y:Number):void {
			magnitude = Math.sqrt(Math.pow(_x, 2) + Math.pow(_y, 2));
			angle = Geovector.atan(_x, _y);
		}
		
		public function x():Number {
			return magnitude*Math.cos(angle);
		}
		
		public function y():Number {
			return magnitude*Math.sin(angle);
		}
		
		public function add(v:Geovector):Geovector {
			var _x:Number = x()+v.x();
			var _y:Number = y()+v.y();
			setComponents(_x, _y);
			return this;
		}
		
		public function subtract(v:Geovector):Geovector {
			var _x:Number = x()-v.x();
			var _y:Number = y()-v.y();
			setComponents(_x, _y);
			return this;
		}

	}

}