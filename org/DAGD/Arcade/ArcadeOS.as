﻿package org.DAGD.Arcade {

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
	import flash.display.*
		import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.system.fscommand;
	import flash.events.MouseEvent;
	import flash.filesystem.File;


	public class ArcadeOS extends MovieClip {
		private static var main: ArcadeOS;
		private static var selectedView: View;
		private static const DATA_PATH: String = "./content/content.xml";
		//private static const DATA_PATH: String = "./content/projects/project.xml";
		private static const SCROLL_MULT: int = 10;

		var fillType: String = GradientType.LINEAR;
		var colors: Array = [0xFF0000, 0x0000FF];
		var alphas: Array = [1, 1];
		var ratios: Array = [0x00, 0xFF];
		var matr: Matrix = new Matrix();


		private var data: XML;
		/**
		 * This collection stores MediaModel objects.
		 */
		public static var collection: Array = new Array(); //all media files
		public static var tags: Array = new Array(); // collection of all tags used in projects
		public static var clickedTags: Array = new Array(); // tags user selected to filter out the collection
		public static var viewStorage: Array = new Array(); // array of views to be recalled when switching views

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
			createBG();
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
			var desktop: File = File.applicationDirectory.resolvePath("./content/projects");
			var files: Array = desktop.getDirectoryListing();
			for (var i: uint = 0; i < files.length; i++) {
				trace(files[i].nativePath); // gets the path of the files
				trace(files[i].name); // gets the name
				var folder: String = files[i].nativePath + "\\project.xml";
				trace(folder);
				//var request: URLRequest = new URLRequest(folder);
				var request: URLRequest = new URLRequest(DATA_PATH);
				trace(request);
				var loader: URLLoader = new URLLoader(request);
				loader.addEventListener(Event.COMPLETE, doneLoadingData);
			}




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
		//--------------------------------------------------------------------------Add to Array to be recalled later
		public static function goBackToTile(): void {
			if (viewStorage != null) {
				for each(var oldView: MainView in viewStorage) {
					changeMainView(oldView);
					viewStorage.splice(oldView, 1);
				}
				viewStorage = new Array;

			}
		}
		public static function changeMainView(newMainView: MainView): void {
			if (main.mainView != null) {
				viewStorage.push(main.mainView);
				//main.mainView.dispose();
				main.removeChild(main.mainView);
			}
			//main.mainView.selectedY=0;
			main.mainView = newMainView;
			main.addChild(newMainView);
			main.layout(false);
		}

		public static function toggleTag(tag: String): Boolean {

			var removedTag: Boolean = false;

			for (var i: int = clickedTags.length - 1; i >= 0; i--) {
				if (clickedTags[i] == tag) {
					clickedTags.splice(i, 1);
					removedTag = true;
				}
			}

			if (removedTag == false) {
				clickedTags.push(tag);
				main.layout(true);
				return true;
			}
			main.layout(true);
			return false;
		}
		public static function getMediaByTags(): Array {

			if (clickedTags.length == 0) return collection;

			var models: Array = new Array();

			for each(var model: MediaModel in collection) {
				for each(var tag: String in model.tagz) {
					var modelAdded: Boolean = false;
					for each(var ctag: String in clickedTags) {
						if (ctag == tag) {
							models.push(model);
							modelAdded = true;
							break;
						}
					}
					if (modelAdded) break;
				}
			}

			return models;
		}
		private function createBG(): void {
			var gradientScaling: Number = 1; // use this for easy scaling of the gradient

			var gradientMatrixWidth: Number = 50 * gradientScaling;
			var gradientMatrixHeight: Number = 50 * gradientScaling;
			var gradientMatrixRotation: Number = 0.63;
			var gradientTx: Number = 0 * gradientScaling;
			var gradientTy: Number = 0 * gradientScaling;

			var gradientDrawWidth: Number = 50 * gradientScaling;
			var gradientDrawHeight: Number = 50 * gradientScaling;
			var gradientOffsetX: Number = 0; // use this to move the gradient horizontally
			var gradientOffsetY: Number = 0; // use this to move the gradient vertically

			var gradientMatrix: Matrix = new Matrix();
			gradientMatrix.createGradientBox(gradientMatrixWidth, gradientMatrixHeight, gradientMatrixRotation, gradientTx + gradientOffsetX, gradientTy + gradientOffsetY);

			var gradientType: String = GradientType.LINEAR;
			var gradientColors: Array = [0x0, 0xffffff]
			var gradientAlphas: Array = [1, 1]
			var gradientRatios: Array = [0, 255]
			var gradientSpreadMethod: String = SpreadMethod.PAD;
			var gradientInterpolationMethod: String = InterpolationMethod.RGB;
			var gradientFocalPoint: Number = 0;

			var gradientGraphics: Graphics = this.graphics; // replace 'this' with the object you want to apply the gradient to

			gradientGraphics.beginGradientFill(gradientType, gradientColors, gradientAlphas, gradientRatios, gradientMatrix, gradientSpreadMethod, gradientInterpolationMethod, gradientFocalPoint);
			gradientGraphics.drawRect(gradientOffsetX, gradientOffsetY, gradientDrawWidth, gradientDrawHeight);
			gradientGraphics.endFill();
		}
	}
}