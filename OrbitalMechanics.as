package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class OrbitalMechanics extends MovieClip {
		
		private var bodies:Vector.<Body> = new Vector.<Body>();
		public const G:Number = 100;
		
		private var paused:Boolean = false;
		
		public function OrbitalMechanics() {
			addEventListener(Event.ENTER_FRAME, calculate);
		}
		
		public function pause():void {
			if (!paused) {
				removeEventListener(Event.ENTER_FRAME, calculate);
				paused=true;
			}
		}
		
		public function resume():void {
			if (paused) {
				addEventListener(Event.ENTER_FRAME, calculate);
				paused=false;
			}
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
			for (var i:int=0; i<bodies.length; i++) {
				for (var j:int=i+1; j<bodies.length; j++) {
					//Check for collisions
					if (Math.sqrt(Math.pow(bodies[i].x-bodies[j].x,2) + Math.pow(bodies[i].y-bodies[j].y,2))<=bodies[i].radius+bodies[j].radius) {
						
						//Find resultant vector assuming perfectly inelastic collisions
						var _x = (bodies[i].mass*bodies[i].velocity.x() + bodies[j].mass*bodies[j].velocity.x())/(bodies[i].mass + bodies[j].mass);
						var _y = (bodies[i].mass*bodies[i].velocity.y() + bodies[j].mass*bodies[j].velocity.y())/(bodies[i].mass + bodies[j].mass);
						var _angle = Geovector.atan(_x, _y);
						var _velocity:Geovector = new Geovector(Math.sqrt(Math.pow(_x,2)+Math.pow(_y,2)), _angle);
						
						//Create new body
						var b:Body = new Body((bodies[i].x+bodies[j].x)/2, (bodies[i].y+bodies[j].y)/2, bodies[i].mass+bodies[j].mass, _velocity);
						var bi:Body = bodies[i];
						var bj:Body = bodies[j];
						removeBody(bi);
						removeBody(bj);
						addBody(b);
						if (i!=0) i--;
						if (j!=0) j--;
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
			}
		}
	}
	
}
