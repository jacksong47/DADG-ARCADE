package org.DAGD.Arcade {
	import flash.events.MouseEvent;
	import flash.system.Capabilities;



	public class MainView extends View {

		private var targetY: Number = 0;
		public var selectedY: Number = 0;
		private var contentH: int;
		private var thumbHeight: Number = ProjectView.IMG_CONTAINER_HEIGHT;


		//var screenWidth: Number = Capabilities.screenResolutionX;
		var screenHeight: Number = Capabilities.screenResolutionY;

		//private var heightOfContent:int = this.height;
		public function MainView() {

		}
		public override function update(): void {
			var heightOfContent: int = this.height;
			contentH = heightOfContent;
			
			if(selectedY>heightOfContent-screenHeight){
				targetY=-heightOfContent+screenHeight;
				//trace("two");
				}
			else if(selectedY>screenHeight-thumbHeight){
				targetY = -selectedY+thumbHeight;
				//trace("one");
			}else{
				targetY=0;
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
	}

}