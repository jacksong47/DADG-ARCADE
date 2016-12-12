package org.DAGD.Arcade {
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;



	public class MainView extends View {

		private var targetY: Number = 0;
		public var selectedY: Number = 0;
		private var contentH: int;
		private var thumbHeight: Number = ProjectView.IMG_CONTAINER_HEIGHT;


		//var screenWidth: Number = Capabilities.screenResolutionX;
		var screenHeight: Number = Capabilities.screenResolutionY;

		//private var heightOfContent:int = this.height;
		public function MainView() {
			createBG();
		}
		public override function update(): void {
			var heightOfContent: int = this.height;
			contentH = heightOfContent;
			if (heightOfContent < screenHeight) {
				targetY = 0;
			} else if (selectedY > heightOfContent - screenHeight) {
				targetY = -heightOfContent + screenHeight;
			} else if (selectedY > screenHeight - thumbHeight) {
				targetY = -selectedY + thumbHeight;
			} else {
				targetY = 0;
			}
			//trace(screenHeight);
			//trace(heightOfContent);
			//trace(targetY);
			//trace(selectedY);
			//trace(thumbHeight);

			y += (targetY - y) * .1;


		}
		public override function scroll(amount: Number): void {
			// find height of content
			
			//contentH=heightOfContent;
			//trace(heightOfContent);//1369
			//trace(selectedY);
			// if content is less than container, no scrolling:
			if (contentH < h) {
				targetY = 0;
				return;
				
			}

			// "scroll" thhe targetY value:
			targetY += amount;

			// clamp max end:
			if (targetY > 0) targetY = 0;

			// clamp min end:
			var min: int = contentH - h; // heightOfContent - heightOfContainer
			if (targetY < -min) targetY = -min;

		}
		private function createBG(): void {
			var gradientScaling: Number = 2; // use this for easy scaling of the gradient
	
			var gradientMatrixWidth: Number = 1000 * gradientScaling;
			var gradientMatrixHeight: Number = 1000 * gradientScaling;
			var gradientMatrixRotation: Number = 0.63;
			var gradientTx: Number = 0 * gradientScaling;
			var gradientTy: Number = 0 * gradientScaling;

			var gradientDrawWidth: Number = 1000 * gradientScaling;
			var gradientDrawHeight: Number = 10000 * gradientScaling;
			var gradientOffsetX: Number = 0; // use this to move the gradient horizontally
			var gradientOffsetY: Number = 0; // use this to move the gradient vertically

			var gradientMatrix: Matrix = new Matrix();
			gradientMatrix.createGradientBox(gradientMatrixWidth, gradientMatrixHeight, gradientMatrixRotation, gradientTx + gradientOffsetX, gradientTy + gradientOffsetY);

			var gradientType: String = GradientType.LINEAR;
			var gradientColors: Array = [0x212121, 0x0]
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