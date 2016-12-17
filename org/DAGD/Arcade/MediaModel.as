package org.DAGD.Arcade {
	import flash.filesystem.File;

	
	public class MediaModel {

		public var title:String;
		public var desc:String;
		public var imgURL:String;
		public var mainPic:String;
		public var tagz: Array = new Array();
		public var pics: Array = new Array();
		public var currentPic: int=0;
		
		/**
		* MediaModel() is the model of media data and what should be stored
		* for each piece of media presented in the MainView
		*
		* @param xml:XML pulls information from the XML doc to be used in its respective view
		*/
		public function MediaModel(xml:XML) {
			title = xml.name;
			desc = xml.desc;
			
			for each(var tag:String in xml.tags.tag){
				tagz.push(tag);
			}
			for each(var pic:String in xml.images.image){
				pics.push(File.applicationDirectory.resolvePath(pic).nativePath);
				
			}
			
			trace(pics.length);
			mainPic = pics[currentPic];
			imgURL = File.applicationDirectory.resolvePath(xml.thumb).nativePath;
			
		}
	}
}
