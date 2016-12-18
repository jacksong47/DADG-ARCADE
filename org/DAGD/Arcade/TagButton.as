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
	import flash.display.BlendMode
	import flash.geom.ColorTransform

	public class TagButton extends View {
		public static const WIDTH: int = 100;
		public static const HEIGHT: int = 30;
		public static const MARGIN: int = 10;

		private static const TXT_BOX_HEIGHT: int = 30;

		private var txtBox: Sprite = new Sprite();
		private var content: Sprite = new Sprite();
		private var label: TextField;
		private var sayMyName: String;
		public var activated: Boolean = false;

		private static var colorOn: Boolean = false;
		private var defaultColor = new ColorTransform();
		private var hoverColor = new ColorTransform();
		private var clickedColor = new ColorTransform();

		private var sideView: SideView;
		//private var mainView:MainView;
		//private var sideView:SideView;

		//private var data: MediaModel;

		private var index: int;

		/**
		 * MediaButton() loads the information needed to display
		 * the media and other important information on the screen
		 *
		 * Then runs the loadImage function with the URL data
		 *
		 * @param data:MediaModel called in ThumbView to pull data from MediaModel
		 */
		public function TagButton(index: int, data: String) {
			this.index = index;
			var tagName: String = data;
			sayMyName = data;

			addChild(content);

			setupLabel(tagName);

			defaultColor.color = 0xebb83e;
			hoverColor.color = 0xeb3e3e;
			clickedColor.color = 0xff0000;
			

			//loadImage(data.imgURL);

			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			addEventListener(MouseEvent.CLICK, handleClick);
		}

		private function setupLabel(caption: String): void {

			txtBox.graphics.beginFill(0xebb83e);
			txtBox.graphics.drawRect(0, 0, WIDTH, TXT_BOX_HEIGHT);

			label = new TextField();
			label.multiline = false;
			label.selectable = false;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.defaultTextFormat = new TextFormat("Arial", 20, 0x0);
			label.text = caption;
			label.antiAliasType = AntiAliasType.NORMAL;
			label.x = 5;
			txtBox.addChild(label);
			content.addChild(txtBox);



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
			//e.target.removeEventListener(Event.COMPLETE, handleLoaded);
			//var img: Bitmap = e.target.content;
			//content.addChildAt(img, 0);
		}
		public override function update(): void {
			
			label.defaultTextFormat = new TextFormat("Arial", 20, 0x0);
			if (!colorOn) {
				//this.txtBox.transform.colorTransform = defaultColor;
				this.txtBox.graphics.beginFill(defaultColor);
			}

			if (selected) {
				//this.txtBox.transform.colorTransform = hoverColor;
				this.txtBox.graphics.beginFill(0xeb3e3e);
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
			this.txtBox.graphics.beginFill(hoverColor);
			colorOn = true;
			//trace("over it");
		}
		private function handleMouseOut(e: MouseEvent): void {
			this.txtBox.graphics.beginFill(defaultColor);
			colorOn = false;
			//trace("off it");
		}
		private function handleClick(e: MouseEvent): void {
			activate();
		}
		public override function activate(): void {
			//colorOn = !colorOn;
			activated = ArcadeOS.toggleTag(sayMyName);

		}
		private function handleLoaded(e: Event): void {

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