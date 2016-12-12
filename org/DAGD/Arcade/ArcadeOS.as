package org.DAGD.Arcade {

	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.xml.XMLDocument;
	import flash.filesystem.File;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.display.Loader;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.system.fscommand;
	import flash.events.MouseEvent;

	public class ArcadeOS extends MovieClip {
		private static var main: ArcadeOS;
		private static var selectedView: View;
		private static const DATA_PATH: String = "./content/content.xml";
		private static const SCROLL_MULT: int = 10;

		private var data: XML;
		/**
		 * This collection stores MediaModel objects.
		 */
		public static var collection: Array = new Array();
		public static var tags: Array = new Array();

		public static var clickedTags: Array = new Array();

		private var sideView: SideView;
		private var mainView: MainView;
		private var thumbView: ThumbView;

		private var windowH: Number = stage.fullScreenHeight;
		private var windowW: Number = stage.fullScreenWidth;


		/**
		 * ArcadeOS() sets up the screen and loads data by
		 * instantiating a new SideView and MainView,
		 * adding them to the display tree, then
		 * runs the screenSetup and loadData functions
		 */
		public function ArcadeOS() {
			Keyboard.setup(stage);

			main = this;
			sideView = new SideView();
			addChild(sideView);

			changeMainView(new ThumbView());

			//launchExe("content/procexp.exe", "/t");
			screenSetup();
			loadData();

			stage.addEventListener(MouseEvent.MOUSE_WHEEL, handleScrollWheel);
			addEventListener(Event.ENTER_FRAME, handleFrame);
		}
		private function handleFrame(e: Event): void {

			if (Keyboard.onDown(Keyboard.LEFT)) {
				if (selectedView) selectedView.lookupLeft();
			}
			if (Keyboard.onDown(Keyboard.RIGHT)) {
				if (selectedView) selectedView.lookupRight();
			}
			if (Keyboard.onDown(Keyboard.UP)) {
				if (selectedView) selectedView.lookupUp();
			}
			if (Keyboard.onDown(Keyboard.DOWN)) {
				if (selectedView) selectedView.lookupDown();
			}

			if (mainView) mainView.update();
			if (sideView) sideView.update();
			Keyboard.update();

			for each(var t: String in tags) {

			}
			//trace(clickedTags);
		}
		/**
		 * loadData() pulls data from the .xml file and
		 * loads it into the URLLOader, when it is finished,
		 * it launches an event and runs doneLoadingData()
		 */
		private function loadData(): void {
			var request: URLRequest = new URLRequest(DATA_PATH);
			var loader: URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, doneLoadingData);
		}
		/**
		 * doneLoadingData() is used to initate the use of data after
		 * the screen is set up
		 *
		 * The function runs through the xml media segments and
		 * pushes the data into the "collection" array
		 *
		 * when finished, it launches the layout function with
		 * a boolean perameter of true
		 *
		 * @param e:Event this peram launches doneLoadingData()
		 */
		private function doneLoadingData(e: Event): void {
			var data: String = (e.target as URLLoader).data;
			var xml: XML = new XML(data);

			for (var t: int = 0; t < xml.media.tags.tag.length(); t++) {
				var tag = xml.media.tags.tag[t];
				var alreadyExists = false;
				for each(var tag1: String in tags) {
					if (tag1 == tag) alreadyExists = true;
				}
				if (alreadyExists == false) tags.push(tag);
			}
			for (var i: int = 0; i < xml.media.length(); i++) {
				collection.push(new MediaModel(xml.media[i]));
			}
			layout(true);
		}
		/**
		 * screenSetup() sets the stage's scaleMode, alignment,
		 * and its window bounds to be fullscreen
		 */
		private function screenSetup(): void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.nativeWindow.bounds = new Rectangle(0, 0, windowW, windowH);
		}
		/**
		 * layout() places the MainView and the SideView on the screen
		 *
		 * @param dataUploaded:Boolean this peram launches layout() when doneLoadingData() has finished loading data
		 */
		private function layout(dataUpdated: Boolean): void {
			var w: int = stage.stageWidth;
			var h: int = stage.stageHeight;

			if (dataUpdated) {
				mainView.dataUpdated();
				sideView.dataUpdated();
			}

			var sideViewWidth: int = 300;

			mainView.layout(w - sideViewWidth, h);
			mainView.x = sideViewWidth;

			sideView.layout(sideViewWidth, h);

		}
		private function handleScrollWheel(e: MouseEvent): void {
			if (mainView) mainView.scroll(e.delta * SCROLL_MULT);
		}
		private static function launchExe(path: String, args: String = ""): void {
			var appInfo: NativeProcessStartupInfo = new NativeProcessStartupInfo();
			appInfo.executable = File.applicationDirectory.resolvePath(path);
			if (args != "") appInfo.arguments.push(args);

			var app: NativeProcess = new NativeProcess();
			app.start(appInfo);
		}
		public static function setSelectedView(view: View): void {

			if (selectedView != null) selectedView.setSelected(false);
			selectedView = view;
			selectedView.setSelected(true);
			main.mainView.selectedY = selectedView.y
			//trace(selectedView.y);

		}
		public static function getSelectedView(): View {
			return selectedView;
		}
		public static function changeMainView(newMainView: MainView): void {
			if (main.mainView != null) {
				main.mainView.dispose();
				main.removeChild(main.mainView);
			}
			main.mainView = newMainView;
			main.addChild(newMainView);
			main.layout(false);
		}
		public static function toggleTags(): void {
			var thumbView: ThumbView = new ThumbView();
			thumbView.dataUpdated();



			//for each(var t:int = 0; t<xml.media.tags.tag.length(); t++){
			//var tag = xml.media.tags.tag[t];
			//var alreadyExists = false;

			trace("clickedTagsArray  "+clickedTags);
			for each(var tag1: String in clickedTags) {
				trace("clickedTag  "+tag1);
				for each(var tagged1: MediaModel in collection) {
					for each(var tagged2: String in tagged1.tagz) {
						if (tag1 == ("<tag>"+tagged2+"<tag>")) {
							trace("Tag Match!");
						}else{
							trace("No tag matches");
						}
					}
				}
			}
			//if(alreadyExists == false)tags.push(tag);
			//}			

			//activated = !activated;
			//if (activated)ArcadeOS.clickedTags.push(sayMyName);
			//if(!activated)ArcadeOS.clickedTags.splice(sayMyName);*/
		}
	}
}