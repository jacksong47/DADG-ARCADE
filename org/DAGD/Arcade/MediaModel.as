package org.DAGD.Arcade {
	import flash.filesystem.File;

	
	public class MediaModel {

		public var title:String;
		public var desc:String;
		public var imgURL:String;
		public var tagz: Array = new Array();
		
		/**
		* MediaModel() is the model of media data and what should be stored
		* for each piece of media presented in the MainView
		*
		* @param xml:XML pulls information from the XML doc to be used in its respective view
		*/
		public function MediaModel(xml:XML) {
			title = xml.name;
			desc = xml.desc;
			//trace(xml.media.tags.tag.length);
			//trace(xml.tags.tag);
			/*for (var i:int = 0; i<xml.media.tags.tag.length(); i++){
				trace(xml.media.tags.tag.length);
				tagz.push(xml.tags.tag);
				//trace(xml.media.tags.tag[i]);
			}*/
			tagz.push(xml.tags);
			trace("these are my tags"+tagz);
			//trace("boom");
			//trace(xml.media.tags.tag);
			
			imgURL = File.applicationDirectory.resolvePath(xml.thumb).nativePath;
		}
	}
}
