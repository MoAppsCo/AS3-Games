package 
{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextFormat;
	import flash.text.engine.TextBaseline;
	
	public dynamic class Main extends MovieClip
	{
		// classes
		private var _physics:Physics;
		private var _timer:Timer;
		var interval_timer:TextField = new TextField();
		private var startTime:int;
		private var diff:int;
		private var _timer2:Timer
		private var _stage:MovieClip = container;
		private var _frame:int;
		private var fade:Number = 1.0;
		private var fadeAmount:Number = 0.01;
		private var _timer3:Timer = new Timer(25);
		private var retval:Boolean = false;
		var survive:TextField = new TextField();
		var survivedTime:Number;
		var isRight:Boolean=false
		var isLeft:Boolean=false
		var isUp:Boolean=false
		var isDown:Boolean=false
		var pause:TextField = new TextField();
		var pausedes:TextField = new TextField();
		
		
		public function Main()
		{
			_physics = new Physics(container);
			_physics.enable();
			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER, timerFunction);
			_timer.start();
			start.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			credits.addEventListener(MouseEvent.CLICK, buttonClickHandler2);
			stage.addEventListener(KeyboardEvent.KEY_UP, upKey);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, downKey);
		}
		
			 
			// the event listeners
			private function update(e:Event):void
			{
				var currentTime:int = getTimer();
				var _ballArray:Array = _physics._ballArray;
				var tempBall1:Ball;
				var i:int;	
				//check if we hit top
				if (((man.x - man.width / 2) <= _physics._minX))
				{
					man.x += 7;
				}
				else if (((man.x + man.width / 2) >= _physics._maxX))
				{
				
					man.x -= 7;
				}
						
				for (i = 0; i < _ballArray.length; i++)
				{
				// save a reference to ball
					tempBall1 = _ballArray[i] as Ball;
					
					if(_physics.hitTestCircle(tempBall1, man))
						{	
							
							man.gotoAndStop(2);
							retval = true;
							stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
							isRight=false;
							isLeft = false;
							
						}
					if(retval)
					{
						_physics.disable();
						_timer2.stop();
						survivedTime = diff;
						_timer3.addEventListener(TimerEvent.TIMER, darken);
						_timer3.start();
						stage.removeEventListener(Event.ENTER_FRAME, update);
						stage.removeEventListener(KeyboardEvent.KEY_UP, upKey);
						stage.removeEventListener(KeyboardEvent.KEY_DOWN, downKey);
						
						_physics._ballArray = [];
						//trace("you died!");
						retval = false;
						
					}
				}
					
					
					diff = currentTime*0.001 - startTime*0.001;
					interval_timer.text = String(diff);
				
			}
			
			private function darken(e:TimerEvent):void
			{
				fade-= fadeAmount;
				if(fade < 0.0)
				{
						fade = 0.0;
						_timer3.removeEventListener(TimerEvent.TIMER, darken);
						_timer3.stop();
						endGame();						
				}
			container.transform.colorTransform = new ColorTransform(fade, fade, fade, 1.0, 0, 0, 0, 0);
			
			}
			private function downKey(event:KeyboardEvent)
			{
				 if(event.keyCode==39)
				 {
					isRight=true;
					 stage.addEventListener(Event.ENTER_FRAME, move);
				 }
				 if(event.keyCode==37)
				 {
					isLeft=true;
					 stage.addEventListener(Event.ENTER_FRAME, move);
				 }
			}
			private function upKey(event:KeyboardEvent){
				 if(event.keyCode==39)
				 {
					isRight=false;
					 stage.removeEventListener(Event.ENTER_FRAME, move);
				 }
				 if(event.keyCode==37)
				 {
					isLeft=false;
					 stage.removeEventListener(Event.ENTER_FRAME, move);
					 
				 }
			}
			private function move(e:Event)
			{z
				 if(isRight==true)
					 {
					 man.x +=7;
					 }
				 if(isLeft==true)
					 {
					 man.x -= 7;
					 }
			}
			private function frame(e:Event):void
			{
				_frame = currentFrame;
				if(_frame == 25)
				{
					startGame();
				}
		
			}
			private function startGame():void
			{
				_physics._ballArray = [];
				stage.removeEventListener(Event.ENTER_FRAME, frame);
				//stage.removeEventListener(Event.ENTER_FRAME, startGame);
				stage.removeEventListener(Event.ENTER_FRAME, _physics.remove);
				_physics.enable();				
				stage.addEventListener(KeyboardEvent.KEY_UP, upKey);
					stage.addEventListener(KeyboardEvent.KEY_DOWN, downKey);
					
				// enable physics simulation
				_timer2 = new Timer(500);
				_timer2.addEventListener(TimerEvent.TIMER, timerFunction);
				_timer2.start();
				stage.addEventListener(Event.ENTER_FRAME, update);
				
				
				interval_timer.y = 18;
				interval_timer.x = 500;
				addChild(interval_timer);
				startTime = getTimer();
				
				
				
			}
			
			private function endGame()
			{
				var myFormat:TextFormat = new TextFormat();
				myFormat.size = 23;
				survive.defaultTextFormat = myFormat;
				gotoAndStop(26);
				survive.x = 179.45;
				survive.y = 177.90;
				survive.textColor = 0xFFFFFF;
				survive.text = String(survivedTime + " secs");
				addChild(survive);
				stage.addEventListener(Event.ENTER_FRAME, _physics.remove);
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
				stage.removeEventListener(KeyboardEvent.KEY_UP, upKey);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, downKey);
				mainmenu.addEventListener(MouseEvent.CLICK, buttonClickHandler5);
				retry.addEventListener(MouseEvent.CLICK, buttonClickHandler6);
				_physics._ballArray = [];
			}
			
			private function onKeyEvent(e:KeyboardEvent):void
			{
				if (stage.frameRate == 20)
				{
					if (e.keyCode == 80)
					{
						stage.frameRate = 8;
						stage.removeEventListener(Event.ENTER_FRAME, update);
						pauseGame();
						
					}
				}
				else if (stage.frameRate == 8)
				{
					if (e.keyCode == 80)
					{
						stage.frameRate = 20;
						stage.addEventListener(Event.ENTER_FRAME, update);						
						unpause();
					}
				}
			}
			
			private function pauseGame():void
			{
				_physics.disable();
				_timer2.stop();
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
				stage.removeEventListener(KeyboardEvent.KEY_UP, upKey);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, downKey);
				var myFormat:TextFormat = new TextFormat();
				var myFormat2:TextFormat = new TextFormat();
				myFormat.size = 30;
				myFormat2.size = 15;
				pause.defaultTextFormat = myFormat;
				pausedes.defaultTextFormat = myFormat2;
				pause.x = 239.95;
				pause.y = 165.90;
				pause.textColor = 0x000000;
				pausedes.x = 221.8;
				pausedes.y = 205.45;
				pausedes.width = 130.2;
				pausedes.textColor = 0x000000;
				pause.text = String("Paused");
				pausedes.text = String("Press P to Unpause");
				addChild(pause);
				addChild(pausedes);
				
			}
			private function unpause():void
			{
				
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
				stage.addEventListener(KeyboardEvent.KEY_UP, upKey);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, downKey);
				_physics.enable();
				_timer2.start();
				removeChild(pause);
				removeChild(pausedes);
				
			}
			public function timerFunction(e:TimerEvent):void
			{
				_physics.createBalls(1);				
			}
			//start button
			private function buttonClickHandler(event:MouseEvent):void
			{
				gotoAndStop(3);
				ok.addEventListener(MouseEvent.CLICK, buttonClickHandler4);
				_physics.disable();
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, timerFunction);
				stage.addEventListener(Event.ENTER_FRAME, _physics.remove);
				_physics._ballArray = [];
			}
			//credits button
			private function buttonClickHandler2(event:MouseEvent):void
			{
				gotoAndStop(2);
				stage.addEventListener(Event.ENTER_FRAME, _physics.remove);
				_physics.disable();
				_timer.removeEventListener(TimerEvent.TIMER, timerFunction);
				_timer.stop();
				back.addEventListener(MouseEvent.CLICK, buttonClickHandler3);
				_physics._ballArray = [];
				
			}
			//back button
			private function buttonClickHandler3(event:MouseEvent):void
			{
				gotoAndStop(1);
				_physics.enable();
				_timer.addEventListener(TimerEvent.TIMER, timerFunction);
				stage.removeEventListener(Event.ENTER_FRAME, _physics.remove);
				_timer.start();
				start.addEventListener(MouseEvent.CLICK, buttonClickHandler);
				credits.addEventListener(MouseEvent.CLICK, buttonClickHandler2);
				_physics._ballArray = [];
				
			}
			//ok button
			private function buttonClickHandler4(event:MouseEvent):void
			{
				stage.addEventListener(KeyboardEvent.KEY_UP, upKey);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, downKey);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
				gotoAndPlay(4);
				stage.addEventListener(Event.ENTER_FRAME, frame);
				_physics._ballArray = [];
				stage.stageFocusRect = false;
				stage.focus = man;
				
				//stage.addEventListener(Event.ENTER_FRAME, startGame);
						
			}
			//main menu button
			private function buttonClickHandler5(event:MouseEvent):void
			{
				gotoAndStop(1);
				container.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0); 
				removeChild(survive);	
				removeChild(interval_timer);	
				_physics.enable();
				_timer.addEventListener(TimerEvent.TIMER, timerFunction);
				stage.removeEventListener(Event.ENTER_FRAME, _physics.remove);
				_timer.start();
				start.addEventListener(MouseEvent.CLICK, buttonClickHandler);
				credits.addEventListener(MouseEvent.CLICK, buttonClickHandler2);
				_physics._ballArray = [];
				fade = 1.0;
				fadeAmount = 0.01;
			}
			//retry button
			private function buttonClickHandler6(event:MouseEvent):void
			{
				container.transform.colorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0); 
				removeChild(survive);	
				removeChild(interval_timer);	
				gotoAndPlay(4);
				stage.addEventListener(Event.ENTER_FRAME, frame);
				stage.addEventListener(KeyboardEvent.KEY_UP, upKey);
				stage.addEventListener(KeyboardEvent.KEY_DOWN, downKey);
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
				_physics._ballArray = [];
				fade = 1.0;
				fadeAmount = 0.01;
				man.x = 286.65;
				man.y = 391.85;
				man.gotoAndStop(1);
				stage.stageFocusRect = false;
				stage.focus = man;
					
			}
			

	}
	
}