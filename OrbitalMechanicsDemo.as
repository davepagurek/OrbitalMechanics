package  {
	
	import flash.display.MovieClip;
	
	
	public class OrbitalMechanicsDemo extends MovieClip {
		
		public var system:OrbitalMechanics = new OrbitalMechanics();
		
		public function OrbitalMechanicsDemo() {
			addChild(system);
			system.x = stage.stageWidth/2;
			system.y = stage.stageHeight/2;
			
			system.addBody(new Body(-100, 0, 10, new Geovector(5,5* Math.PI/4)));
			system.addBody(new Body(100, 0, 10, new Geovector(5, Math.PI/4)));
		}
	}
	
}
