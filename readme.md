<h1>OrbitalMechanics</h1>
An Actionscript 3 planetary physics simulator. A live demo is available at http://www.davepagurek.com/orbit/

<h2>Features</h2>
<ul>
	<li>Calculates gravitational force</li>
	<li>Simulates inelastic collisions</li>
	<li>Provides example UI</li>
</ul>

<h2>Example</h2>
Here is an example body with an initial velocity being added to the system:
```actionscript
var system:OrbitalMechanics = new OrbitalMechanics();
system.addBody(new Body(0, 50, 3, new Geovector(6, Math.PI)));
system.x = 0;
system.y = 0;
stage.addChild(system);
```

<h2>Usage</h2>
<h3>The System</h3>
The simulation is a MovieClip-based object, which can be created like so:
```actionscript
var system:OrbitalMechanics = new OrbitalMechanics();
system.x = 0;
system.y = 0;
stage.addChild(system);
```
Bodies can be added and removed from the system:
```actionscript
system.addBody(b:Body);
system.removeBody(b:Body);
```

The system can stop and start updating on ENTER_FRAME using the following functions:
```actionscript
system.pause();
system.resume();
```
The system is calculating on ENTER_FRAME by default when it is initialized.

<h3>Bodies</h3>
Bodies are initialized in the following way:
```actionscript
var b:Body = new Body(x:Number, y:Number, mass:Number, velocity:Geovector);
```

Bodies have the following public properties:
```actionscript
velocity:Geovector
mass:Number //read-only
radius:Number //read-only
```

<h3>Geometric Vectors</h3>
Geometric vectors (class Geovector) are initialized like this:
```actionscript
var v:Geovector = new Geovector(magnitude:Number, angle:Number);
```
All angles are in radians.

Geovectors can be added or subtracted from other geovectors:
```actionscript
v.add(v2:Geovector);
v.subtract(v2:Geovector);
```

Geovectors can be split into their components using their x and y functions:
```actionscript
v.x():Number
v.y():Number
```

Geovectors have the following public properties:
```actionscript
magnitude:Number
angle:Number
```

<h2>Math</h2>
Gravitational force is calculated using the formula F = (G * m<sub>1</sub> * m<sub>2</sub>)/(d<sup>2</sup>), where G is the arbitrary number 100, masses are in arbitrrary units where mass = 1 is comparable to a small asteroid, and distance is measured in Flash units.

When two bodies collide (when the distance between them is less than the sum of their radii), they are replaced with a single body with their combined mass. The resulting body's velocity is found assuming it is a perfectly inelastic collision using the formula m<sub>1</sub>v<sub>1</sub> + m<sub>2</sub>v<sub>2</sub> = (m<sub>1</sub> + m<sub>2</sub>)v'
