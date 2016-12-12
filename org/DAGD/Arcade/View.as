package org.DAGD.Arcade {
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.Event;
	

	public class View extends Sprite {

		protected var w: int;
		protected var h: int;
		protected var selected: Boolean = false;

		public function View() {}
		/**
		 * dataUploaded() is primarily set for the MainView's children
		 * to tell them when to start doing the addChild to the MainView
		 *
		 */
		public function dataUpdated(): void {
			/* override this */
		}
		/**
		 * layout() is the base for the SideView and MainView
		 * layouts.
		 *
		 * @param w:int pulls in the width of the media window
		 * @param h:int pulls in a height from ArcadeOS for the media window
		 */
		public function layout(w: int, h: int): void {
			/* override this */
			this.w = w;
			this.h = h;
		}
		public function update(): void {
			/* override this */
		}
		public function dispose(): void {
			/* override this */
		}
		public function setSelected(isSelected: Boolean): void {
			selected = isSelected;
		}
		public function activate(): void {
			/* override this */
		}
		public function scroll(amount: Number): void {
			/* override this */
		}
		public function lookupLeft(): void {
			/* override this */
		}
		public function lookupRight(): void {
			/* override this */
		}
		public function lookupUp(): void {
			/* override this */
		}
		public function lookupDown(): void {
			/* override this */
		}
	}
}