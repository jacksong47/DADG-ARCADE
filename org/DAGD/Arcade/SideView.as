package org.DAGD.Arcade {
	import flash.display.Sprite;
	
	import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldType;
	import flash.events.Event;
	
	public class SideView extends View {
		private var tags: Array = new Array(); // holds MediaButton objects
		//private var tagContainer: Sprite = new Sprite();
		public var tagTriggered:Boolean=false;
		public var triggeredTags:Array = new Array();
		
		public function SideView() {
			makeButtons();
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
			graphics.beginFill(0xFFAAAA);
			graphics.drawRect(0, 0, w, h);
			
			var cols: Number = getColumns();
			var spaceX: int = TagButton.WIDTH + TagButton.MARGIN;
			var spaceY: int = TagButton.HEIGHT + TagButton.MARGIN;
			var sideMargins: int = (w - (spaceX * cols)) / 2;

			for (var i = 0; i < tags.length; i++) {

				var gridX: int = i % cols;
				var gridY: int = Math.floor(i / cols);

				tags[i].x = gridX * spaceX + sideMargins;
				//buttons[i].x = gridX * spaceX + MediaButton.MARGIN;
				tags[i].y = gridY * spaceY;

			}
		}
		private function getColumns():int {
			return Math.floor(w / (TagButton.WIDTH+TagButton.MARGIN));
		}
	}
}