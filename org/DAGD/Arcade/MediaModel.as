package org.DAGD.Arcade {
	import flash.filesystem.File;

	
	public class MediaModel {

		public var title:String;
		public var desc:String;
		public var imgURL:String;
		public var mainPic:String;
		public var mainPic2:String;
		public var tagz: Array = new Array();
		public var pics: Array = new Array();
		
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
			
			for each(var tag:String in xml.tags.tag){
				tagz.push(tag);
			}
			for each(var pic:String in xml.images.image){
				pics.push(File.applicationDirectory.resolvePath(pic).nativePath);
			}
			
			mainPic2 = pics[0];
			imgURL = File.applicationDirectory.resolvePath(xml.thumb).nativePath;
			
			/*for (var t: int = 0; t < xml.media.tags.tag.length; t++) {
				trace("nupe");
				var tag = xml.media.tags.tag[t];
				trace("work"+tag);
				var alreadyExists = false;
				for each(var tag1: String in tags) {
					if (tag1 == tag) alreadyExists = true;

				}*/
		}
	}
}
