package org.DAGD.Arcade {
	import flash.display.Sprite;

	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.events.Event;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;

	import flash.net.URLRequest;
	import flash.display.Loader;
	
	import flash.display.Bitmap;




	public class SideView extends View {
		private var tags: Array = new Array(); // holds MediaButton objects
		//private var tagContainer: Sprite = new Sprite();
		public var tagTriggered: Boolean = false;
		public var triggeredTags: Array = new Array();
		private var content: Sprite = new Sprite();
		private var mySize: Number;
		public function SideView() {

			createBG();
			makeButtons();
			addChild(content);
		}
		/**
		 * dataUpdated() is initiated after the data has finished loading
		 * in ArcadeOS
		 *
		 * Then tells the following function, makeButtons,
		 * it can now run
		 *
		 */
		public override function dataUpdated(): void {
			removeButtons();
			makeButtons();
		}
		public override function update(): void {
			super.update();
			for each(var tag: TagButton in tags) {
				tag.update();
			}
		}

		/**
		 * makeButtons() adds the clickable projects to the screen as buttons
		 *
		 * It goes through the ArcadeOS array "collection" and pulls the media data from
		 * MediaModel then inputs it into the MediaButton class
		 * This information is posted onto the MainView stage and then stored in the "buttons" array
		 *
		 */
		private function makeButtons(): void {

			//removeButtons();

			// CREATE NEW BUTTONS:
			for (var i = 0; i < ArcadeOS.tags.length; i++) {
				var data: String = ArcadeOS.tags[i];
				var tag: TagButton = new TagButton(i, data);
				addChild(tag);

				tags.push(tag);
			}
		}
		/**
		 * removeButtons() runs through the "buttons" array
		 * and removes all button information
		 * through the dispose function
		 * Then it removes the buttons from the screen
		 *
		 * Finally instantiating a new buttons array to replace the old one
		 */
		private function removeButtons(): void {
			// REMOVE ALL OLD BUTTONS:
			for each(var tag: TagButton in tags) {
				//tag.dispose();
				removeChild(tag);
			}
			tags = new Array();
		}

		/**
		 * layout() lays out the side bar
		 * and overrides the layout function in the View class
		 *
		 * @param w:int pulls in the width of the media window
		 * @param h:int pulls in a set height from ArcadeOS for the media window
		 */
		override public function layout(w: int, h: int): void {
			super.layout(w, h);
			//graphics.beginFill(0xFFAAAA);
			graphics.drawRect(0, 0, w, h);
			mySize=w;

			var cols: Number = getColumns();
			var spaceX: int = TagButton.WIDTH + TagButton.MARGIN;
			var spaceY: int = TagButton.HEIGHT + TagButton.MARGIN;
			var sideMargins: int = (w - (spaceX * cols)) / 2;

			for (var i = 0; i < tags.length; i++) {

				var gridX: int = i % cols;
				var gridY: int = Math.floor(i / cols);

				tags[i].x = gridX * spaceX + sideMargins;
				//buttons[i].x = gridX * spaceX + MediaButton.MARGIN;
				tags[i].y = gridY * spaceY + 150;

			}
		}
		private function getColumns(): int {
			return Math.floor(w / (TagButton.WIDTH + TagButton.MARGIN));
		}
		private function createBG(): void {
			var gradientScaling: Number = 1; // use this for easy scaling of the gradient
			var gradientMatrixWidth: Number = 1000 * gradientScaling;
			var gradientMatrixHeight: Number = 1000 * gradientScaling;
			var gradientMatrixRotation: Number = 1.6;
			var gradientTx: Number = 0 * gradientScaling;
			var gradientTy: Number = 0 * gradientScaling;

			var gradientDrawWidth: Number = 1000 * gradientScaling;
			var gradientDrawHeight: Number = 10000 * gradientScaling;
			var gradientOffsetX: Number = 0; // use this to move the gradient horizontally
			var gradientOffsetY: Number = 0; // use this to move the gradient vertically

			var gradientMatrix: Matrix = new Matrix();
			gradientMatrix.createGradientBox(gradientMatrixWidth, gradientMatrixHeight, gradientMatrixRotation, gradientTx + gradientOffsetX, gradientTy + gradientOffsetY);

			var gradientType: String = GradientType.LINEAR;
			var gradientColors: Array = [0x727272, 0x212121]
			var gradientAlphas: Array = [1, 1]
			var gradientRatios: Array = [0, 255]
			var gradientSpreadMethod: String = SpreadMethod.PAD;
			var gradientInterpolationMethod: String = InterpolationMethod.RGB;
			var gradientFocalPoint: Number = 0;

			var gradientGraphics: Graphics = this.graphics; // replace 'this' with the object you want to apply the gradient to

			gradientGraphics.beginGradientFill(gradientType, gradientColors, gradientAlphas, gradientRatios, gradientMatrix, gradientSpreadMethod, gradientInterpolationMethod, gradientFocalPoint);
			gradientGraphics.drawRect(gradientOffsetX, gradientOffsetY, gradientDrawWidth, gradientDrawHeight);
			gradientGraphics.endFill();
			fsuLogo();

		}
		private function fsuLogo(): void {
			var request: URLRequest = new URLRequest("./content/UI/bulldog.png");
			var loader: Loader = new Loader();

			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoaded);
			loader.load(request);
		}
		private function handleLoaded(e: Event): void {
			e.target.removeEventListener(Event.COMPLETE, handleLoaded);
			var img: Bitmap = e.target.content;
			content.addChild(img);
			trace(img);
			img.x=mySize/4;
			img.y=10;
		}
	}
}