package
{
	/**
	 * @author  Lee
	 * @e-Mail  seemefly1982@gmail.com
	 * @ver v1.0
	 * @created Apr 15, 2013 12:37:28 AM
	 *
	 */
	import com.greensock.TweenLite;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import org.kxm.utils.IBg;
	import org.kxm.utils.ILoding;
	import org.kxm.utils.IMenu;
	import org.kxm.utils.IShowMenu;
	import org.kxm.utils.ISoundBox;
	
	[SWF(backgroundColor="#100606")]
	public class Main extends Sprite
	{
		private var _loading:ILoding;
		private var _menu:IMenu;
		private var _bg:IBg;
		private var _menuBtn:SimpleButton;
		private var _loader:Loader;
		private var _loadingLayer:Sprite;
		private var _bgLayer:Sprite;
		private var _contentLayer:Sprite;
		private var _menuLayer:Sprite;
		private var _topLayer:Sprite;
		private var _bgW:Number = 1280;
		private var _bgH:Number = 768;
		private var _menuBtnW:Number = 247;
		
		private var _soundBtn:ISoundBox;
		private var _isOn:Boolean = true;
		private var _sound:Sound;
		private var _music:SoundChannel;
		private var _t:SoundTransform;
		
		public function Main()
		{
			super();
			if(stage) onStage();
			else addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(e:Event = null):void{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.addEventListener(Event.RESIZE, onResize);
			init();
			initLoader();
		}
		
		private function init():void{
			_loadingLayer = new Sprite();
			_bgLayer = new Sprite();
			_contentLayer = new Sprite();
			_menuLayer = new Sprite();
			_topLayer = new Sprite();
			
			addChild(_bgLayer);
			addChild(_loadingLayer);
			addChild(_contentLayer);
			addChild(_menuLayer);
			addChild(_topLayer);
			
			_isOn = true;
			playMp3();
		}
		
		private function playMp3():void{
			_sound = new Sound(new URLRequest("./bgbj.mp3"));
			_music = _sound.play();
			_t = new SoundTransform(0.3);
			_music.soundTransform = _t;
		}
		
		private function initLoader():void{
			if(_loader == null)
				_loader =new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler1);
			_loader.load(new URLRequest("./loading.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
		}
		
		private function completeHandler1(event:Event):void{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler1);
			var clazz:Class = ApplicationDomain.currentDomain.getDefinition("LoadingMc") as Class;
			_loading = ILoding(new clazz());
			_loading.reset();
			var mc:MovieClip = MovieClip(_loading);
			mc.x = (stage.stageWidth - mc.width) >> 1;
			mc.y = (stage.stageHeight - mc.height) >> 1;
			_loadingLayer.addChild(mc);
			
			loadMenu();
		}
		
		private function loadMenu():void{
			if(_loader == null)
				_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler2);
			_loader.load(new URLRequest("./menu.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
			_loading.reset();
			_loading.show();
		}
		
		private function completeHandler2(event:Event):void{
			_loading.hide();
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler2);
			var clazz:Class = ApplicationDomain.currentDomain.getDefinition("Menu") as Class;
			_menu = IMenu(new clazz());
			_menu.setLoadFunc(loadCase);
			
			var mc:MovieClip = MovieClip(_menu);
			mc.x = (stage.stageWidth - mc.width) >> 1;
			mc.y = (stage.stageHeight - mc.height) >> 1;
			_menuLayer.addChild(mc);
			
			
			var clazz2:Class = ApplicationDomain.currentDomain.getDefinition("Bg") as Class;
			_bg = IBg(new clazz2());
			
			var mc2:MovieClip = MovieClip(_bg);
			mc2.x = (stage.stageWidth - _bgW) >> 1;
			mc2.y = 0;
			_bgLayer.addChild(mc2);
			
			var btnClass:Class = ApplicationDomain.currentDomain.getDefinition("MenuBtn") as Class;
			_menuBtn = SimpleButton(new btnClass());
			_menuBtn.x = stage.stageWidth - _menuBtnW;
			_menuBtn.y = 0;
			_topLayer.addChild(_menuBtn);
			_menuBtn.addEventListener(MouseEvent.CLICK, openMenu);
			
			
			var clazz3:Class = ApplicationDomain.currentDomain.getDefinition("SoundBtn") as Class;
			_soundBtn = ISoundBox(new clazz3());
			var btn:MovieClip = MovieClip(_soundBtn);
			btn.scaleX = btn.scaleY = 0.3;
			btn.x = stage.stageWidth - 80;
			btn.y = stage.stageHeight - 70;
			_topLayer.addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, soundBtnClick);
		}
		
		private function loadCase(id:String):void{
			while(_contentLayer.numChildren > 0){
				_contentLayer.removeChildAt(0);
			}
			if(_loader){
				try{
					_loader.unloadAndStop();
				}catch(e:Error){
					
				}
				
				_loader = null;
			}
			if(_loader == null)
				_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler3);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_loader.load(new URLRequest("./" + id +".swf"));
			_loading.reset();
			_loading.show();
			
			if(_menu){
				_menu.setLoadFunc(loadCase);
				
				var mc:MovieClip = MovieClip(_menu);
				TweenLite.killTweensOf(mc);
				TweenLite.to(mc, 0.5, {alpha:0, onComplete:hideMenu});
			}
		}
		
		private function hideMenu():void{
			while(_menuLayer.numChildren){
				_menuLayer.removeChildAt(0);
			}
		}
		
		private function progressHandler(e:ProgressEvent):void{
			var info:String = Math.floor(e.bytesLoaded / e.bytesTotal * 100).toString();;
			if(_loading)
				_loading.update(info);
		}
		private function completeHandler3(event:Event):void{
			_loading.hide();
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler3);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			
			var mc:MovieClip = MovieClip(_loader.content);
			
			mc.x = (stage.stageWidth - mc.width) >> 1;
			mc.y = (stage.stageHeight - mc.height) >> 1;
			_contentLayer.addChild(mc);
			
			var iMc:IShowMenu = IShowMenu(mc);
			iMc.setShowMenu(showMenu);
		}
		
		private function openMenu(e:MouseEvent):void{
			if(_menu){
				var mc:MovieClip = MovieClip(_menu);
				mc.x = (stage.stageWidth - mc.width) >> 1;
				mc.y = (stage.stageHeight - mc.height) >> 1;
				mc.visible = true;
				TweenLite.killTweensOf(mc);
				mc.alpha = 0;
				_menuLayer.addChild(mc);
				TweenLite.to(mc, 0.5, {alpha:1});
			}
		}
		
		private function showMenu():void{
			trace("showMenu");
			while(_contentLayer.numChildren > 0){
				_contentLayer.removeChildAt(0);
			}
			if(_menu){
				var mc:MovieClip = MovieClip(_menu);
				mc.x = (stage.stageWidth - mc.width) >> 1;
				mc.y = (stage.stageHeight - mc.height) >> 1;
				mc.visible = true;
				TweenLite.killTweensOf(mc);
				mc.alpha = 0;
				_menuLayer.addChild(mc);
				TweenLite.to(mc, 0.5, {alpha:1});
			}
		}
		
		private function soundBtnClick(e:MouseEvent):void{
			pauseAndPlay();
		}
		
		private function pauseAndPlay():void{
			var s:ISoundBox = ISoundBox(_soundBtn);
			if(!_isOn){
				_t.volume = 0.3;
				_music.soundTransform = _t;
				s.callOn();
			}else{
				_t.volume = 0;
				_music.soundTransform = _t;
				s.callOff();
			}
			_isOn = !_isOn;
		}
		
		private function onResize(e:Event):void{
			var mc:MovieClip = MovieClip(_loading);
			if(mc.stage){
				mc.x = (stage.stageWidth - mc.width) >> 1;
				mc.y = (stage.stageHeight - mc.height) >> 1;
			}
			var content:MovieClip;
			if(_contentLayer.numChildren > 0){
				content = MovieClip(_contentLayer.getChildAt(0));
				if(content){
					content.x = (stage.stageWidth - content.width) >> 1;
					content.y = (stage.stageHeight - content.height) >> 1;
				}
			}
			
			if(_menu){
				mc = MovieClip(_menu);
				mc.x = (stage.stageWidth - mc.width) >> 1;
				mc.y = (stage.stageHeight - mc.height) >> 1;
			}
			
			if(_menuBtn){
				_menuBtn.x = stage.stageWidth - _menuBtnW;
				_menuBtn.y = 0;
			}
			
			if(_bg){
				mc = MovieClip(_bg);
				mc.x = (stage.stageWidth - _bgW) >> 1;
				mc.y = 0;
			}
			
			if(_soundBtn){
				mc = MovieClip(_soundBtn);
				mc.x = stage.stageWidth - 80;
				mc.y = stage.stageHeight - 70;
			}
		}
	}
}