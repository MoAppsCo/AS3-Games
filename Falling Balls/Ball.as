package  {
	
	import flash.display.MovieClip;
	
	
		public class Ball extends MovieClip
	    {
			private var _velocityX:Number = 0;
			private var _velocityY:Number = 0;
			private var _speed:Number;
			private var _radius:Number;
			public function Ball(x:Number, y:Number, radius:Number, speed:Number) 
			{
				
				// set parameters
				this.x = x;
				this.y = y;
				this.radius = radius;
				this.speed = speed;
				this.velocityX = this.speed;
				this.velocityY = this.speed;

				
				// draw ball
				this.graphics.lineStyle(1);
				this.graphics.beginFill(0xFFFFFF, 0.0);
				this.graphics.drawCircle(0, 0, _radius);
				this.graphics.endFill();
				
			}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function set speed(value:Number):void 
		{
			_speed = value;
		}
		
		
		public function get radius():Number 
		{
			return _radius;
		}
		
		public function set radius(value:Number):void 
		{
			_radius = value;
		}
		
		
		
		public function get velocityX():Number
		{
			return _velocityX;
		}
		
		public function set velocityX(value:Number):void 
		{
			_velocityX = value;
		}
		
		public function get velocityY():Number
		{
			return _velocityY;
		}
		
		public function set velocityY(value:Number):void 
		{
			_velocityY = value;
		}
		
	}
	
}
