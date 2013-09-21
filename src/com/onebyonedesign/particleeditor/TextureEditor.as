/**
 *	Copyright (c) 2013 Devon O. Wolfgang
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy
 *	of this software and associated documentation files (the "Software"), to deal
 *	in the Software without restriction, including without limitation the rights
 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *	copies of the Software, and to permit persons to whom the Software is
 *	furnished to do so, subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in
 *	all copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *	THE SOFTWARE.
 */

package com.onebyonedesign.particleeditor
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * Small panel to select or upload a texture image
	 * @author Devon O.
	 */
	public class TextureEditor extends Sprite 
	{
		
		private var mGUI:SimpleGUI;
		
		private var mBitmapDisplayBG:Sprite;
		private var mDisplayBmp:Bitmap;
		
		public var mData:BitmapData;
		
		private var mUploader:FileReference = new FileReference();
		
		
		private var mDataArray:Array = 
		[
			{ label:"Circle", data:ParticleDisplay.CIRCLE_DATA },
			{ label:"Star", data:ParticleDisplay.STAR_DATA },
			{ label:"Blob", data:ParticleDisplay.BLOB_DATA },
			{ label:"Heart", data:ParticleDisplay.HEART_DATA },
			{ label:"Custom", data:ParticleDisplay.CUSTOM_DATA }
		];
		
		public function TextureEditor(data:BitmapData) 
		{
			mData = data;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		private function destroy(event:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			mDisplayBmp = null;
			removeChild(mBitmapDisplayBG);
			mBitmapDisplayBG = null;
			mUploader = null;
			mGUI = null;
		}
		
		private function init(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			initUI();
			initBmpDisplay();
		}
		
		private function initUI():void 
		{
			mGUI = new SimpleGUI(this, "Texture Editor");
			mGUI.showToggle = false;
			
			mGUI.addComboBox("mData", mDataArray, { label:"Texture", callback:onTextureSelect } );
			mGUI.addButton("Upload Texture", { callback:onUpload } );
			mGUI.addButton("Done", { callback:onDone } );
			
			mGUI.show();	
		}
		
		private function initBmpDisplay():void 
		{
			mBitmapDisplayBG = new Sprite();
			mBitmapDisplayBG.graphics.beginFill(0x000000);
			mBitmapDisplayBG.graphics.drawRect(0, 0, 128, 128);
			mBitmapDisplayBG.graphics.endFill();
			mBitmapDisplayBG.x = 200;
			addChild(mBitmapDisplayBG);
			showBitmap();
		}
		
		private function showBitmap():void 
		{
			if (mBitmapDisplayBG) 
			{
				mBitmapDisplayBG.removeChildren();
				mDisplayBmp = new Bitmap(mData);
				mDisplayBmp.scaleX = mDisplayBmp.scaleY = 2;
				mDisplayBmp.x = (128 - mDisplayBmp.width) >> 1;
				mDisplayBmp.y = (128 - mDisplayBmp.height) >> 1;
				mBitmapDisplayBG.addChild(mDisplayBmp);
			}
		}
		
		private function onTextureSelect(o:*):void
		{
			showBitmap();
		}
		
		private function onDone(o:*):void 
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onUpload(o:*):void 
		{
			mUploader.addEventListener(Event.SELECT, onUploadSelected);
			mUploader.browse([new FileFilter("Images: (*.jpeg, *.jpg, *.gif, *.png)", "*.jpeg; *.jpg; *.gif; *.png")]);
		}
		
		private function onUploadSelected(event:Event):void 
		{
			mUploader.removeEventListener(Event.SELECT, onUploadSelected);
			mUploader.addEventListener(Event.COMPLETE, onUploadCompleted);
			mUploader.load();
		}
		
		private function onUploadCompleted(event:Event):void 
		{
			mUploader.removeEventListener(Event.COMPLETE, onUploadCompleted);
			
			var imgLoader:Loader = new Loader();
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imgLoader.loadBytes(mUploader.data);
			
		}
		
		private function onImageLoaded(event:Event):void {
			event.currentTarget.removeEventListener(Event.COMPLETE, onImageLoaded);
			var loader:Loader = (event.currentTarget as LoaderInfo).loader;
			var data:BitmapData = (loader.content as Bitmap).bitmapData;
			
			var mat:Matrix = new Matrix();
			var w:int = data.width
			var h:int = data.height;
			if (data.width > 64) 
			{
				mat.scale(64 / data.width, 1);
				w *= 64 / data.width;
			}
			
			if (data.height > 64) 
			{
				mat.scale(1, 64 / data.height);
				h *= 64 / data.height;
			}
			
			ParticleDisplay.CUSTOM_DATA.dispose();
			ParticleDisplay.CUSTOM_DATA = new BitmapData(w, h, true, 0x00000000);
			ParticleDisplay.CUSTOM_DATA.draw(data, mat);
			mDataArray[3] = { label:"Custom", data:ParticleDisplay.CUSTOM_DATA };
			
			mData = ParticleDisplay.CUSTOM_DATA;
			data.dispose();
			showBitmap();
		}

	}

}