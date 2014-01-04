﻿package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class OrbitalMechanicsDemo extends MovieClip {
		
		public var system:OrbitalMechanics = new OrbitalMechanics();
		public var _x:Number = 0;
		public var _y:Number = 0;
		public var _mass:Number = 1;
		public var _angle:Number = 0;
		public var _magnitude:Number = 0;
		public var menu:Menu = new Menu();
		
		public function OrbitalMechanicsDemo() {
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
			
			addChild(system);
			system.x = stage.stageWidth/2;
			system.y = stage.stageHeight/2;
			
			system.addBody(new Body(0, -200, 14, new Geovector(2, 0)));
			system.addBody(new Body(0, 0, 15, new Geovector(3, Math.PI)));
			system.addBody(new Body(0, 50, 3, new Geovector(3, 0)));
			
			system.trails = true;
			
			addChild(menu);
			menu.x=15;
			menu.y=stage.stageHeight - 15;
			menu.github.addEventListener(MouseEvent.CLICK, openGitHub);
			menu.reset.addEventListener(MouseEvent.CLICK, clearBodies);

			stage.addEventListener(MouseEvent.CLICK, setLocation);
			stage.addEventListener(Event.RESIZE, resizeStage);
		}
		
		public function openGitHub(e:MouseEvent):void {
			navigateToURL(new URLRequest("https://github.com/pahgawk/OrbitalMechanics"), "_blank");
		}
		
		public function clearBodies(e:MouseEvent):void {
			while (system.bodies.length>0) {
				system.removeBody(system.bodies[0]);
			}
		}
		
		public function resizeStage(e:Event):void {
			menu.x=15;
			menu.y=stage.stageHeight - 15;
			system.x = stage.stageWidth/2;
			system.y = stage.stageHeight/2;
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
			this.graphics.beginFill(0xFFFFFF, 0.5);
			this.graphics.drawCircle(_x, _y, 2+_mass/3);
			this.graphics.endFill();
		}
		
		public function setMass(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawMass);
			stage.removeEventListener(MouseEvent.CLICK, setMass);
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drawVelocity);
			stage.addEventListener(MouseEvent.CLICK, setVelocity);
			
			drawVelocity(e);
		}
		
		public function drawVelocity(e:MouseEvent):void {
			_magnitude = Math.sqrt(Math.pow(e.stageX-_x, 2) + Math.pow(e.stageY-_y, 2))/20;
			_angle = Geovector.atan(e.stageX-_x, e.stageY-_y);
			
			graphics.clear();
			this.graphics.beginFill(0xFFFFFF, 0.2);
			this.graphics.drawCircle(_x, _y, 2+_mass/3);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1, 0xFFFFFF, 1);
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
