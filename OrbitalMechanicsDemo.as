package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class OrbitalMechanicsDemo extends MovieClip {
		
		public var system:OrbitalMechanics = new OrbitalMechanics();
		public var _x:Number = 0;
		public var _y:Number = 0;
		public var _mass:Number = 1;
		public var _angle:Number = 0;
		public var _magnitude:Number = 0;
		
		public function OrbitalMechanicsDemo() {
			addChild(system);
			system.x = stage.stageWidth/2;
			system.y = stage.stageHeight/2;
			
			system.addBody(new Body(0, -300, 10, new Geovector(10, Math.PI)));
			system.addBody(new Body(0, 300, 10, new Geovector(12, 0)));
			system.addBody(new Body(0, 0, 10));
			/*system.addBody(new Body(-300, -300, 20, new Geovector(20, Math.PI/2)));
			system.addBody(new Body(-300, 300, 20, new Geovector(20, 0)));
			system.addBody(new Body(300, -300, 20, new Geovector(20, Math.PI)));
			system.addBody(new Body(300, 300, 20, new Geovector(20, 3*Math.PI/2)));*/
			
			stage.addEventListener(MouseEvent.CLICK, setLocation);
		}
		
		public function setLocation(e:MouseEvent):void {
			system.pause();
			
			stage.removeEventListener(MouseEvent.CLICK, setLocation);
			
			_x=e.stageX;
			_y=e.stageY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drawMass);
			stage.addEventListener(MouseEvent.CLICK, setMass);
		}
		
		public function drawMass(e:MouseEvent):void {
			_mass = Math.sqrt(Math.pow(e.stageX-_x, 2) + Math.pow(e.stageY-_y, 2))/2;
			
			graphics.clear();
			this.graphics.beginFill(0x000000, 0.5);
			this.graphics.drawCircle(_x, _y, 2+_mass/3);
			this.graphics.endFill();
		}
		
		public function setMass(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawMass);
			stage.removeEventListener(MouseEvent.CLICK, setMass);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drawVelocity);
			stage.addEventListener(MouseEvent.CLICK, setVelocity);
		}
		
		public function drawVelocity(e:MouseEvent):void {
			_magnitude = Math.sqrt(Math.pow(e.stageX-_x, 2) + Math.pow(e.stageY-_y, 2))/4;
			_angle = Geovector.atan(e.stageX-_x, e.stageY-_y);
			
			graphics.clear();
			this.graphics.beginFill(0x000000, 0.2);
			this.graphics.drawCircle(_x, _y, 2+_mass/3);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1, 0x000000, 1);
			this.graphics.moveTo(_x, _y);
			this.graphics.lineTo(e.stageX, e.stageY);
		}
		
		public function setVelocity(e:MouseEvent):void {
			graphics.clear();
			system.addBody(new Body(-system.x+_x, -system.y+_y, _mass, new Geovector(_magnitude, _angle)));
			system.resume();
			
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawVelocity);
			stage.removeEventListener(MouseEvent.CLICK, setVelocity);
			
			stage.addEventListener(MouseEvent.CLICK, setLocation);
		}
	}
	
}
