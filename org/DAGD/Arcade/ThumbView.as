package org.DAGD.Arcade {

	public class ThumbView extends MainView {

		private var buttons: Array = new Array(); // holds MediaButton objects
		//private var tagButton:TagButton= new TagButton();

		public function ThumbView() {

			makeButtons();

		}
		public override function update(): void {
			super.update();
			for each(var bttn: MediaButton in buttons) {
				bttn.update();
			}
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
			makeButtons();
			trace("thumbView dataUPdated");

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

			removeButtons();

			var models:Array = ArcadeOS.getMediaByTags();

			for (var i = 0; i < models.length; i++) {
				var data: MediaModel = models[i];
				var bttn: MediaButton = new MediaButton(i, data);
				addChild(bttn);
				buttons.push(bttn);
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
			//trace("remove meeeee1");
			for each(var bttn: MediaButton in buttons) {
				
				//trace("remove meeeee2");

				bttn.dispose();
				removeChild(bttn);
			}
			buttons = new Array();
			//trace("remove meeeee3");

		}
		/**
		 * layout() lays out MainView as the ThumbView
		 *
		 * It figures out the size of the MainView stage and calculates
		 * how many collumns of media it can fit then figures
		 * Media Width and Height plus the size of its margins
		 *
		 * Afterwards, running through the "buttons" array and assigning
		 * the media to a grid position and placing them in their proper
		 * x and y coordinates.
		 *
		 * @param w:int pulls in the width of the stage minus the width of the SideView
		 * @param h:int pulls in a set height from ArcadeOS for the media window
		 */
		override public function layout(w: int, h: int): void {

			super.layout(w, h);

			var cols: Number = getColumns();
			var spaceX: int = MediaButton.WIDTH + MediaButton.MARGIN;
			var spaceY: int = MediaButton.HEIGHT + MediaButton.MARGIN;
			var sideMargins: int = (w - (spaceX * cols)) / 2;

			for (var i = 0; i < buttons.length; i++) {

				var gridX: int = i % cols;
				var gridY: int = Math.floor(i / cols);

				buttons[i].x = gridX * spaceX + sideMargins;
				//buttons[i].x = gridX * spaceX + MediaButton.MARGIN;
				buttons[i].y = gridY * spaceY;

			}
		}
		private function getColumns(): int {
			return Math.floor(w / MediaButton.WIDTH);
		}
		override public function dispose(): void {
			super.dispose();
			for each(var bttn: MediaButton in buttons) {
				bttn.dispose();
			}
		}
		override public function lookupLeft(): void {
			var index: int = buttons.indexOf(ArcadeOS.getSelectedView());
			index--;
			if (index >= 0) {
				ArcadeOS.setSelectedView(buttons[index]);
			}
		}
		override public function lookupRight(): void {
			var index: int = buttons.indexOf(ArcadeOS.getSelectedView());
			index++;
			if (index < buttons.length) {
				ArcadeOS.setSelectedView(buttons[index]);
			}
		}
		override public function lookupUp(): void {
			var index: int = buttons.indexOf(ArcadeOS.getSelectedView());
			index -= getColumns();
			if (index >= 0) {
				ArcadeOS.setSelectedView(buttons[index]);
			}
		}
		override public function lookupDown(): void {
			var index: int = buttons.indexOf(ArcadeOS.getSelectedView());
			index += getColumns();
			if (index < buttons.length) {
				ArcadeOS.setSelectedView(buttons[index]);
			}
		}
	}
}