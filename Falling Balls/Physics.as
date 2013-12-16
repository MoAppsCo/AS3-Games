package  {
	import flash.display.DisplayObjectContainer;
    import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Stage;
	import flash.display.DisplayObject;
	
	public class Physics
	{

		// reference to container (stage, movieclip or sprite)
		 private var _canvas:DisplayObjectContainer;
		
		// boundries
		 var _minX:int;
		 var _minY:int;
		 var _maxX:int;
		 var _maxY:int;
		
		// balls array
		 public var _ballArray:Array = [];
		
		// settings
		 private var _friction:Number = .99;
		 private var _gravity:Number = .98;
		private var _boundries:Rectangle;
		
		/**
		 * Constructor
		 * @param	$canvas	Takes DisplayObjectContainer (MovieClip, Sprite, Stage)
		 */
		public function Physics($canvas:DisplayObjectContainer)
		{
			
			
			_canvas = $canvas;
			setBoundries(_canvas);
		}
		
		/**
		 * Enables physics engine
		 */
		public function enable():void
		{
			_canvas.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Disables physics engine
		 */
		public function disable():void
		{
			_canvas.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
			public function setBoundries($container:DisplayObjectContainer):void
		{
			
			_boundries = new Rectangle(0, 0, $container.width, $container.height);
			_minX = 0;
			_minY = 0;
			_maxX = $container.width;
			_maxY = $container.height;
		}
		
			public function createBalls(numberOfBalls:Number):void
		{
			
			
			for (var i:int = 0; i < numberOfBalls; i++)
			{
				createBall();
			}
		}
		
		/**
		 * Use this to create a single ball
		 */
		public function createBall():void
		{
			// Create new ball
			// precalculate ball properties
			var newX:Number = -50 + Math.floor(Math.random()*-151);//newX (-250)-(-200)
			//Min + Math.floor((Math.random() * ((Max - Min) + 1)))
			var newY:Number = 50 + Math.floor(Math.random()*150); //newY 100-200
			var newSpeed:Number = 12;
			var newRadius:Number = 50 + Math.floor(Math.random() * 31); //radius 30-50
			// Ball(x, y, radius, rotation, speed, mass) 
			var ball:Ball = new Ball(newX, newY, newRadius, newSpeed);
			
			// test if ball can start here
			// add to display list
			_canvas.addChild(ball)
				
				// save ball in balls array
			_ballArray.push(ball);
			// ball can't start here, try again
		}
		public function remove(e:Event):void
		{
			
			for (var i = _canvas.numChildren-1; i >= 0; i--) {
				var child:DisplayObject = _canvas.getChildAt(i);
				if (child is Ball)
				{
						_canvas.removeChild(child);
				}
			}
		}
		private function update():void 
		{
			// define common vars
			var tempBall1:Ball;			
			var i:int;
			
			// loop thru balls array
			for (i = 0; i < _ballArray.length; i++)
			{
				// save a reference to ball
				tempBall1 = _ballArray[i] as Ball;
/*				
				//check if we hit top
				if (((tempBall1.x - tempBall1.width / 2) <= _minX) && (tempBall1.velocityX < 0))
				{
					tempBall1.velocityX = -tempBall1.velocityX;
				}
				// Check if we hit bottom
				if ((tempBall1.x + tempBall1.width / 2) >= _maxX && (tempBall1.velocityX > 0))
				{
					tempBall1.velocityX = -tempBall1.velocityX;
				}
			
*/
				// Check Y
				// Check if we hit left side
				if (((tempBall1.y - tempBall1.height / 2) <= _minY) && (tempBall1.velocityY < 0))
				{
					tempBall1.velocityY = -tempBall1.velocityY
				}
				// Check if we hit right side
				if (((tempBall1.y + tempBall1.height / 2) >= _maxY) && (tempBall1.velocityY > 0))
				{
					tempBall1.velocityY = -tempBall1.velocityY;
				}
	
			// apply friction to ball velocity
			tempBall1.velocityX *= _friction;
			tempBall1.velocityY *= _friction;
			
			// apply gravity (only to Y axis)
			tempBall1.velocityY += _gravity;
			
			
			// Update X
			// Update position
			tempBall1.x += tempBall1.velocityX;
			
			// Update Y
			// Make sure we dont fall thru the bottom
			if ((tempBall1.y + tempBall1.velocityY + (tempBall1.height / 2)) > _maxY)
			{
				// if we're falling thru, set ball y at maxY, minus ball size
				tempBall1.y = _maxY - (tempBall1.height / 2);
			}
			else
			{
				// update position
				tempBall1.y += tempBall1.velocityY;
			}			

		}
		
	}
	public function hitTestCircle(ball1:Ball, $person:DisplayObjectContainer):Boolean
	{
		var retval:Boolean = false;
		if((ball1.hitTestObject($person)) && (ball1.velocityY != 0))
		{
			retval = true;
			
		}
		return retval;
	}
private function onEnterFrame(e:Event):void 
    {
		update();
	}
}
}
