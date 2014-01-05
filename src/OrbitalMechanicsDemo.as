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
			
			//Prepares page to be properly scalable
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
			
			//Creates the system and adds initial bodies
			addChild(system);
			system.x = stage.stageWidth/2;
			system.y = stage.stageHeight/2;
			
			system.addBody(new Body(0, -200, 14, new Geovector(2, 0)));
			system.addBody(new Body(0, 0, 15, new Geovector(3, Math.PI)));
			system.addBody(new Body(0, 50, 3, new Geovector(3, 0)));
			
			system.trails = true;
			
			//Add the info menu on the left
			addChild(menu);
			menu.x=15;
			menu.y=stage.stageHeight - 15;
			menu.github.addEventListener(MouseEvent.CLICK, openGitHub);
			menu.reset.addEventListener(MouseEvent.CLICK, clearBodies);
			
			//Add the "Press ESC to cancel" warning that appears when you start adding bodies
			addChild(warning);
			warning.x=stage.stageWidth/2;
			warning.y = stage.stageHeight + 50;
			
			//Add the scale meter
			addChild(scale);
			scale.autoSize = TextFieldAutoSize.RIGHT;
			scale.x = stage.stageWidth - 15;
			scale.textColor = 0xFFFFFF;
			scale.text = "Scale: 100%";
			format.font = "_sans";
			scale.setTextFormat(format);
			scale.y = stage.stageHeight - 15 - scale.height;
			
			//Begins the process of adding new bodies
			stage.addEventListener(MouseEvent.CLICK, setLocation);
			
			//Moves menu and scale meter when the window is resized
			stage.addEventListener(Event.RESIZE, resizeStage);
			
			//Centers and zooms the stage, along with moving the warning up and down
			stage.addEventListener(Event.ENTER_FRAME, centerStage);
		}
		
		public function centerStage(e:Event):void {
			if (!system.paused) {
				var _w:Number = system.width;
				var _h:Number = system.height;
				
				//Only make the camera zoom to as big as the smallest side to avoid awkward jumping
				var size:Number = 1;
				if (stage.stageWidth > stage.stageHeight) {
					size = stage.stageHeight;
				} else {
					size = stage.stageWidth;
				}
				
				//NOTE: smooth movements follow this formula: property += (target - current)/ease;
				
				//If there's more than one body, scale to fit everything in the frame
				if (system.bodies.length > 1) {
					if (_w > _h) {
						system.width += (size*0.5 - system.width) / 12;
						system.height = system.width * (_h / _w);
					} else {
						system.height += (size*0.5 - system.height) / 12;
						system.width = system.height * (_w / _h);
					}
					
				//Otherwise, we don't want to totally fill the screen with one object, so zoom to 1:1 scale
				} else {
					system.scaleX += (1 - system.scaleX)/4;
					system.scaleY = system.scaleX;
				}
				
				//Center the content on the stage
				var rect:Rectangle = system.getBounds(system);
				system.x += (stage.stageWidth/2 - (rect.x+rect.width/2)*system.scaleX - system.x) / 12;
				system.y += (stage.stageHeight/2 - (rect.y+rect.height/2)*system.scaleY - system.y) / 12;
				
				//Since the system is simulating, hide the warning
				warning.y += (stage.stageHeight + 50 - warning.y) / 12;
				
				//Update the scale text
				scale.text = "Scale: " + Math.round(system.scaleX * 100) + "%";
				scale.setTextFormat(format);
			} else {
				
				//The system is only paused when a new body is being added, so show the warning
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
			//Place the menu, warning, and scale meter in the correct positions when the window is resized
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
			//If the purple area is clicked, start placing a new body
			if (!menu.hitTestPoint(stage.mouseX, stage.mouseY, false)) {
				system.pause();
				
				stage.removeEventListener(MouseEvent.CLICK, setLocation);
				
				//Set the mouse position as the base x/y coordinate for the new body (global position for now)
				_x=e.stageX;
				_y=e.stageY;
				
				//Prepare for next step: setting mass
				stage.addEventListener(MouseEvent.MOUSE_MOVE, drawMass);
				stage.addEventListener(MouseEvent.CLICK, setMass);
				
				//Cancel if the escape key is pressed
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onEscapeKey);
			}
		}
		
		public function drawMass(e:MouseEvent):void {
			//Set the mass of the new body to the distance of the mouse from the body's coordinate (global position)
			_mass = Math.sqrt(Math.pow(e.stageX-_x, 2) + Math.pow(e.stageY-_y, 2))/2;
			
			//Draw the body's preview
			graphics.clear();
			this.graphics.beginFill(0xFFFFFF, 0.5);
			
			//Adjust the size according to the scale of the system
			this.graphics.drawCircle(_x, _y, (2+_mass/3)*system.scaleX);
			this.graphics.endFill();
		}
		
		public function setMass(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawMass);
			stage.removeEventListener(MouseEvent.CLICK, setMass);
			
			//Prepare for the next step: setting the velocity
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drawVelocity);
			stage.addEventListener(MouseEvent.CLICK, setVelocity);
			
			//Start drawing velocity line
			drawVelocity(e);
		}
		
		public function drawVelocity(e:MouseEvent):void {
			//Calculate magnitude and angle from the mouse's position relative to the body's coordinate (global position)
			_magnitude = Math.sqrt(Math.pow(e.stageX-_x, 2) + Math.pow(e.stageY-_y, 2))/15;
			_angle = Geovector.atan(e.stageX-_x, e.stageY-_y);
			
			//Draw the mass and velocity, sized according to the system's scale
			graphics.clear();
			this.graphics.beginFill(0xFFFFFF, 0.2);
			this.graphics.drawCircle(_x, _y, (2+_mass/3)*system.scaleX);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1, 0xFFFFFF, 1);
			this.graphics.moveTo(_x, _y);
			this.graphics.lineTo(e.stageX, e.stageY);
		}
		
		public function setVelocity(e:MouseEvent):void {
			//Clear drawings and add the body to the system
			graphics.clear();
			system.addBody(new Body((-system.x+_x)*(1/system.scaleX), (-system.y+_y)*(1/system.scaleY), _mass, new Geovector(_magnitude*(1/system.scaleX), _angle)));
			system.resume();
			
			//Reset listeners
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawVelocity);
			stage.removeEventListener(MouseEvent.CLICK, setVelocity);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onEscapeKey);
			
			stage.addEventListener(MouseEvent.CLICK, setLocation);
		}
		
		public function onEscapeKey(e:KeyboardEvent):void {
			//Cancel adding the new body and reset listeners.
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