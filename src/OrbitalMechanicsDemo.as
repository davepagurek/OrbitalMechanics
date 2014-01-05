package 
{
	/**
	 * ...
	 * @author Dave Pagurek
	 */
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.geom.Rectangle;
	
	public class OrbitalMechanicsDemo extends MovieClip {
		
		public var system:OrbitalMechanics = new OrbitalMechanics();
		public var _x:Number = 0;
		public var _y:Number = 0;
		public var _mass:Number = 1;
		public var _angle:Number = 0;
		public var _magnitude:Number = 0;
		public var menu:Menu = new Menu();
		public var warning:Warning = new Warning();
		public var scale:TextField = new TextField();
		public var format:TextFormat = new TextFormat();
		
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
			
			addChild(warning);
			warning.x=stage.stageWidth/2;
			warning.y = stage.stageHeight + 50;
			
			addChild(scale);
			scale.autoSize = TextFieldAutoSize.RIGHT;
			scale.x = stage.stageWidth - 15;
			scale.textColor = 0xFFFFFF;
			scale.text = "Scale: 100%";
			format.font = "_sans";
			scale.setTextFormat(format);
			scale.y = stage.stageHeight - 15 - scale.height;

			stage.addEventListener(MouseEvent.CLICK, setLocation);
			stage.addEventListener(Event.RESIZE, resizeStage);
			stage.addEventListener(Event.ENTER_FRAME, centerStage);
		}
		
		public function centerStage(e:Event):void {
			if (!system.paused) {
				var _w:Number = system.width;
				var _h:Number = system.height;
				var size:Number = 1;
				if (stage.stageWidth > stage.stageHeight) {
					size = stage.stageHeight;
				} else {
					size = stage.stageWidth;
				}
				
				if (system.bodies.length > 1) {
					if (_w > _h) {
						system.width += (size*0.5 - system.width) / 12;
						system.height = system.width * (_h / _w);
					} else {
						system.height += (size*0.5 - system.height) / 12;
						system.width = system.height * (_w / _h);
					}
				} else {
					system.scaleX += (1 - system.scaleX)/4;
					system.scaleY = system.scaleX;
				}
				
				var rect:Rectangle = system.getBounds(system);
				system.x += (stage.stageWidth/2 - (rect.x+rect.width/2)*system.scaleX - system.x) / 12;
				system.y += (stage.stageHeight/2 - (rect.y+rect.height/2)*system.scaleY - system.y) / 12;
				
				warning.y += (stage.stageHeight + 50 - warning.y) / 12;
				
				
				scale.text = "Scale: " + Math.round(system.scaleX * 100) + "%";
				scale.setTextFormat(format);
			} else {
				warning.y += (stage.stageHeight-15 - warning.y)/12;
			}
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
			warning.x=stage.stageWidth/2;
			warning.y = stage.stageHeight + 50;
			scale.text = "";
			scale.x = stage.stageWidth - 15;
			scale.text = "Scale: " + Math.round(system.scaleX * 100) + "%";
			scale.setTextFormat(format);
			scale.y = stage.stageHeight - 15 - scale.height;
		}
		
		public function setLocation(e:MouseEvent):void {
			if (!menu.hitTestPoint(stage.mouseX, stage.mouseY, false)) {
				system.pause();
				
				stage.removeEventListener(MouseEvent.CLICK, setLocation);
				
				_x=e.stageX;
				_y=e.stageY;
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE, drawMass);
				stage.addEventListener(MouseEvent.CLICK, setMass);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onEscapeKey);
			}
		}
		
		public function drawMass(e:MouseEvent):void {
			_mass = Math.sqrt(Math.pow(e.stageX-_x, 2) + Math.pow(e.stageY-_y, 2))/2;
			
			graphics.clear();
			this.graphics.beginFill(0xFFFFFF, 0.5);
			this.graphics.drawCircle(_x, _y, (2+_mass/3)*system.scaleX);
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
			_magnitude = Math.sqrt(Math.pow(e.stageX-_x, 2) + Math.pow(e.stageY-_y, 2))/15;
			_angle = Geovector.atan(e.stageX-_x, e.stageY-_y);
			
			graphics.clear();
			this.graphics.beginFill(0xFFFFFF, 0.2);
			this.graphics.drawCircle(_x, _y, (2+_mass/3)*system.scaleX);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1, 0xFFFFFF, 1);
			this.graphics.moveTo(_x, _y);
			this.graphics.lineTo(e.stageX, e.stageY);
		}
		
		public function setVelocity(e:MouseEvent):void {
			graphics.clear();
			system.addBody(new Body((-system.x+_x)*(1/system.scaleX), (-system.y+_y)*(1/system.scaleY), _mass, new Geovector(_magnitude*(1/system.scaleX), _angle)));
			system.resume();
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawVelocity);
			stage.removeEventListener(MouseEvent.CLICK, setVelocity);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onEscapeKey);
			
			stage.addEventListener(MouseEvent.CLICK, setLocation);
		}
		
		public function onEscapeKey(e:KeyboardEvent):void {
			if (e.keyCode == Keyboard.ESCAPE) {
				graphics.clear();
				system.resume();
				
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawVelocity);
				stage.removeEventListener(MouseEvent.CLICK, setVelocity);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onEscapeKey);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawMass);
				stage.removeEventListener(MouseEvent.CLICK, setMass);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onEscapeKey);
				
				stage.addEventListener(MouseEvent.CLICK, setLocation);
			}
		}
	}

}