package 
{
	/**
	 * ...
	 * @author Dave Pagurek
	 */
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.LineScaleMode;
	
	public class OrbitalMechanics extends MovieClip {
		
		public var bodies:Vector.<Body> = new Vector.<Body>();
		public const G:Number = 100;
		public var trails:Boolean = false;
		private var temp:Vector.<Body> = new Vector.<Body>();
		private var _paused:Boolean = false;
		
		public function OrbitalMechanics() {
			addEventListener(Event.ENTER_FRAME, calculate);
		}
		
		public function pause():void {
			if (!_paused) {
				removeEventListener(Event.ENTER_FRAME, calculate);
				_paused=true;
			}
		}
		
		public function resume():void {
			if (_paused) {
				addEventListener(Event.ENTER_FRAME, calculate);
				_paused=false;
			}
		}
		
		public function get paused():Boolean {
			return _paused;
		}
		
		public function addBody(b:Body):Boolean {
			for (var i:int=0; i<bodies.length; i++) {
				if (bodies[i]==b) {
					return false; //Already in list
				}
			}
			bodies.push(b);
			this.addChild(b);
			return true;
		}
		
		public function removeBody(b:Body):Boolean {
			for (var i:int=0; i<bodies.length; i++) {
				if (bodies[i]==b) {
					bodies[i].parent.removeChild(bodies[i]);
					bodies.splice(i, 1);
					return true;
				} 
			}
			return false; //not in list
		}
		
		public function calculate(e:Event):void {
			graphics.clear();
			for (var i:int=0; i<bodies.length; i++) {
				for (var j:int = i + 1; j < bodies.length; j++) {
					
					//If two bodies have collided
					if (Math.sqrt(Math.pow(bodies[i].x-bodies[j].x,2) + Math.pow(bodies[i].y-bodies[j].y,2))<=bodies[i].radius+bodies[j].radius) {
						
						//Find resultant vector assuming perfectly inelastic collisions
						var _x:Number = (bodies[i].mass*bodies[i].velocity.x() + bodies[j].mass*bodies[j].velocity.x())/(bodies[i].mass + bodies[j].mass);
						var _y:Number = (bodies[i].mass*bodies[i].velocity.y() + bodies[j].mass*bodies[j].velocity.y())/(bodies[i].mass + bodies[j].mass);
						var _angle:Number = Geovector.atan(_x, _y);
						var _velocity:Geovector = new Geovector(Math.sqrt(Math.pow(_x,2)+Math.pow(_y,2)), _angle);
						
						//Create new body
						var b:Body = new Body((bodies[i].x+bodies[j].x)/2, (bodies[i].y+bodies[j].y)/2, bodies[i].mass+bodies[j].mass, _velocity);
						var bi:Body = bodies[i];
						var bj:Body = bodies[j];
						
						removeBody(bi);
						removeBody(bj);
						
						//If trails are on, keep the original Bodies around until their trails run out
						if (trails) {
							temp.push(bi, bj);
						}
						
						addBody(b);
						if (i!=0) i--;
						if (j != 0) j--;
						
					//Otherwise, calculate forces and update vectors
					} else {
						//Update vectors
						var force:Number = (G*bodies[i].mass*bodies[j].mass)/Math.abs(Math.pow(bodies[j].x-bodies[i].x,2) + Math.pow(bodies[j].y-bodies[i].y,2));
						var angle:Number = Geovector.atan((bodies[j].x-bodies[i].x), (bodies[j].y-bodies[i].y));

						var anglei:Number=angle;
						var anglej:Number=angle;
						if (bodies[j].x>=bodies[i].x) {
							anglej+=Math.PI;
						} else if (bodies[j].x<bodies[i].x) {
							anglej-=Math.PI;
						}
						
						bodies[i].velocity.add(new Geovector(force/bodies[i].mass, anglei));
						bodies[j].velocity.add(new Geovector(force/bodies[j].mass, anglej));
					}
				}
				
				//Update position
				bodies[i].x+=bodies[i].velocity.x();
				bodies[i].y+=bodies[i].velocity.y();
				
				//If enabled, draw trails
				if (trails) {
					bodies[i].addHistory(new Point(bodies[i].x, bodies[i].y));
					
					for (var k:int=0; k<bodies[i].history.length-1; k++) {
						this.graphics.lineStyle(1, bodies[i].color, 1-k*(1/(bodies[i].history.length-1)), false, LineScaleMode.NONE);
						if (k==0) this.graphics.moveTo(bodies[i].history[k].x, bodies[i].history[k].y);
						this.graphics.lineTo(bodies[i].history[k+1].x, bodies[i].history[k+1].y);
					}
				}
			}
			
			//finish drawing trails of removed bodies if there are any
			if (trails) {
				for (i=0; i<temp.length; i++) {
					for (k=0; k<temp[i].history.length-1; k++) {
						this.graphics.lineStyle(1, temp[i].color, 1-k*(1/(temp[i].history.length-1)), false, LineScaleMode.NONE);
						if (k==0) this.graphics.moveTo(temp[i].history[k].x, temp[i].history[k].y);
						this.graphics.lineTo(temp[i].history[k+1].x, temp[i].history[k+1].y);
					}
					
					//Remove pieces of the trails
					temp[i].history.pop();
					
					//Remove body completely if the trail is removed completely
					if (temp[i].history.length==0) {
						temp.splice(i, 1);
						i--;
					}
				}
			} else {
				while (temp.length>0) {
					temp.pop();
				}
			}
		}
	}
}