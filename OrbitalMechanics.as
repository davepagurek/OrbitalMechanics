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
		
		public function addBody(b:Body):Boolean {
			for (var i:int=0; i<bodies.length; i++) {
				if (bodies[i]==b) {
					return false; //Already in list
				}
			}
			bodies.push(b);
			addChild(b);
			return true;
		}
		
		public function removeBody(b:Body):Boolean {
			for (var i:int=0; i<bodies.length; i++) {
				if (bodies[i]==b) {
					bodies = bodies.splice(i, 1);
					removeChild(b);
					return true;
				} 
			}
			return false; //not in list
		}
		
		public function calculate(e:Event):void {
			for (var i:int=0; i<bodies.length; i++) {
				//Update vectors
				for (var j:int=i+1; j<bodies.length; j++) {
					var force:Number = (G*bodies[i].mass*bodies[j].mass)/Math.abs(Math.pow(bodies[i].x-bodies[j].x,2) + Math.pow(bodies[i].y-bodies[j].y,2));
					var angle:Number = Math.atan((bodies[j].y-bodies[i].y)/(bodies[j].x-bodies[i].x));
					
					var anglei:Number=angle;
					var anglej:Number=angle;
					if (bodies[j].x>bodies[i].x) {
						anglej+=Math.PI;
					} else {
						anglei+=Math.PI;
					}
					
					bodies[i].velocity.add(new Geovector(force, anglei));
					bodies[j].velocity.add(new Geovector(force, anglej));
				}
				
				//Update position
				bodies[i].x+=bodies[i].velocity.x();
				bodies[i].y+=bodies[i].velocity.y();
			}
		}
	}
	
}
