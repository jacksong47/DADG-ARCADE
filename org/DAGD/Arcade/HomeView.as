﻿
package org.DAGD.Arcade {

	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;

	public class HomeView extends MainView {

		private var content: Sprite = new Sprite();
		public static const IMG_CONTAINER_WIDTH: int = 1176;
		public static const IMG_CONTAINER_HEIGHT: int = 520;
		public static const LEFT_MARGIN: int = 60;
		public static const TOP_MARGIN: int = 232;

		private var imgH: Number = 0;
		private var imgContainer: Sprite = new Sprite();

		public function HomeView(data: MediaModel) {
			// load image and add  
			// create text box and add 
			loadImage(data.imgURL);

			addChild(content);
			setupDesc(data.desc);
			setupTitle(data.title);
		}
		private function loadImage(imgURL): void {
			var request: URLRequest = new URLRequest(imgURL);
			var loader: Loader = new Loader();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaded);
			loader.load(request);
		}
		private function handleLoaded(e: Event): void {
			imgContainer.graphics.beginFill(0x0);
			imgContainer.graphics.drawRect(0, 0, IMG_CONTAINER_WIDTH, IMG_CONTAINER_HEIGHT);

			e.target.removeEventListener(Event.COMPLETE, handleLoaded);
			var img: Bitmap = e.target.content;

			//img.scaleX=2.56; 
			//img.scaleY=2.42; 

			imgContainer.x = LEFT_MARGIN;
			imgContainer.y = TOP_MARGIN;
			img.x = LEFT_MARGIN;
			img.y = TOP_MARGIN;
			imgH = img.height;

			addChildAt(imgContainer, 0);
			content.addChild(img);

		}
		private function setupDesc(caption: String): void {

			var description: TextField = new TextField();
			description.multiline = true;
			description.wordWrap = true;
			description.selectable = false;
			description.autoSize = TextFieldAutoSize.LEFT;
			description.defaultTextFormat = new TextFormat("Arial", 14, 0x0);
			description.text = caption;
			description.antiAliasType = AntiAliasType.NORMAL;
			//description.height = IMG_CONTAINER_HEIGHT; 
			description.width = IMG_CONTAINER_WIDTH;
			description.x = LEFT_MARGIN;
			description.y = IMG_CONTAINER_HEIGHT + TOP_MARGIN + 20;

			addChild(description);

		}
		private function setupTitle(caption: String): void {

			var description: TextField = new TextField();
			description.multiline = false;
			description.wordWrap = false;
			description.selectable = false;
			description.autoSize = TextFieldAutoSize.LEFT;
			description.defaultTextFormat = new TextFormat("Arial", 48, 0x0);
			description.text = caption;
			description.antiAliasType = AntiAliasType.NORMAL;
			//description.height = IMG_CONTAINER_HEIGHT; 
			description.width = IMG_CONTAINER_WIDTH;
			description.x = LEFT_MARGIN;
			description.y = 175;

			addChild(description);

		}
	}
}