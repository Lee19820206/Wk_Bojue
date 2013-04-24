package
{
	/**
	 * @author  Lee
	 * @e-Mail  seemefly1982@gmail.com
	 * @ver v1.0
	 * @created Apr 19, 2013 12:17:15 AM
	 *
	 */
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.kxm.utils.IIndex;
	

	
	public class Index extends MovieClip implements IIndex
	{
		public var fishBtn:SimpleButton;
		public var freeBtn:SimpleButton;
		//public var soundBtn:SoundBox;###
		
		private var _freeFunc:Function;
		private var _fishFunc:Function;
		private var _pauseAndPlay:Function;
		
		private var _isOn:Boolean = true;
		
		public function Index()
		{
			super();
			fishBtn.addEventListener(MouseEvent.CLICK, jumpFish);
			freeBtn.addEventListener(MouseEvent.CLICK, jumpFree);
			//soundBtn.addEventListener(MouseEvent.CLICK, onOrOff);
		}
		
		private function init(e:Event):void{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			fishBtn.addEventListener(MouseEvent.CLICK, jumpFish);
			freeBtn.addEventListener(MouseEvent.CLICK, jumpFree);
			//soundBtn.addEventListener(MouseEvent.CLICK, onOrOff);
		}
		
		private function jumpFish(e:MouseEvent):void{
			//navigateToURL(new URLRequest("./main.html"), "_blank");
			if(_fishFunc is Function)
				_fishFunc();
		}
		
		private function jumpFree(e:MouseEvent):void{
			if(_freeFunc is Function)
				_freeFunc();
		}
		
		public function setFreeFunc(func:Function):void{
			_freeFunc = func;
		};
		public function setFishFunc(func:Function):void{
			_fishFunc = func; 
		};
		public function setPauseAndPlay(func:Function):void{
			_pauseAndPlay = func; 
		};
		
		private function onOrOff(e:MouseEvent):void{
			if(_pauseAndPlay is Function)
				_pauseAndPlay();

		}
		
	}
}