package org.DAGD.Arcade {
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.AntiAliasType;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.display.BlendMode;

	public class MediaButton extends View {

		public static const WIDTH: int = 460;
		public static const HEIGHT: int = 215;
		public static const MARGIN: int = 10;

		private static const TXT_BOX_HEIGHT: int = 30;

		private var imgMask: Sprite = new Sprite();
		private var txtBox: Sprite = new Sprite();
		private var content: Sprite = new Sprite();
		private var label: TextField;

		private var data: MediaModel;

		private var index: int;

		/**
		 * MediaButton() loads the information needed to display
		 * the media and other important information on the screen
		 *
		 * Then runs the loadImage function with the URL data
		 *
		 * @param data:MediaModel called in ThumbView to pull data from MediaModel
		 */
		public function MediaButton(index: int, data: MediaModel) {
			this.index = index;
			this.data = data;

			addChild(content);
			addChild(imgMask);
			imgMask.graphics.beginFill(0x0);
			imgMask.graphics.drawRect(0, 0, WIDTH, HEIGHT);

			content.mask = imgMask;

			setupLabel(data.title);
			loadImage(data.imgURL);

			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			addEventListener(MouseEvent.CLICK, handleClick);
		}

		private function setupLabel(caption: String): void {

			content.addChild(txtBox);

			label = new TextField();
			label.multiline = false;
			label.selectable = false;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.defaultTextFormat = new TextFormat("Arial", 20, 0xFFFFFF);
			label.text = caption;
			label.antiAliasType = AntiAliasType.NORMAL;
			label.x = 5;
			txtBox.addChild(label);
			txtBox.graphics.beginFill(0x000000, .8);
			txtBox.graphics.drawRect(0, 0, WIDTH, TXT_BOX_HEIGHT);

		}
		/**
		 * loadImage() uses the information gathered from MediaButton
		 * and loads the file URL
		 *
		 * Then it runs the following function, handleLoaded, after
		 * the event is completed
		 *
		 * @param imgURL takes the url data from the MediaButton function and uses it for the URLRequest
		 */
		private function loadImage(imgURL): void {
			var request: URLRequest = new URLRequest(imgURL);
			var loader: Loader = new Loader();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaded);
			loader.load(request);
		}
		/**
		 * handleLoaded() takes the loaded url from the loadImage
		 * function and uses the url's information and turns it
		 * into a bitmap to be displayed
		 *
		 * Uses the media's width and height to create a mask
		 * insuring each media is displayed at the same size
		 *
		 * @param e:Event an event listener waiting for the data to finish loading before running handleLoaded()
		 */
		private function handleLoaded(e: Event): void {
			e.target.removeEventListener(Event.COMPLETE, handleLoaded);
			var img: Bitmap = e.target.content;
			content.addChildAt(img, 0);
		}
		public override function update(): void {
			if (selected) {
				txtBox.y += ((HEIGHT - TXT_BOX_HEIGHT) - txtBox.y) * .5;
			} else {
				txtBox.y += (HEIGHT - txtBox.y) * .5;
			}
		}
		/**
		 * This function disposes of all MediaButton information
		 *
		 */
		public override function dispose(): void {
			// do cleanup here
			super.dispose();
			removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			removeEventListener(MouseEvent.CLICK, handleClick);
		}
		private function handleMouseOver(e: MouseEvent): void {
			ArcadeOS.setSelectedView(this);
		}
		private function handleClick(e: MouseEvent): void {
			activate();
		}
		public override function activate(): void {
			ArcadeOS.changeMainView(new ProjectView(data));
		}
		public override function lookupLeft(): void {
			View(parent).lookupLeft();
		}
		public override function lookupRight(): void {
			View(parent).lookupRight();
		}
		public override function lookupUp(): void {
			View(parent).lookupUp();
		}
		public override function lookupDown(): void {
			View(parent).lookupDown();
		}
	}
}