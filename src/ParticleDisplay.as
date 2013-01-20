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


package  
{
	import com.adobe.images.PNGEncoder;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Component;
	import com.bit101.components.HUISlider;
	import com.bit101.components.Label;
	import com.bit101.components.Window;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipOutput;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import uk.co.soulwire.gui.SimpleGUI;
	
	
	/**
	 * The main work horse of the particle editor. This displays, updates, and modifies the particle properties
	 * @author Devon O.
	 */
	public class ParticleDisplay extends Sprite 
	{
		
		[Embed(source = "../assets/fire.pex", mimeType = "application/octet-stream")]
		private const DEFAULT_CONFIG:Class;
		
		[Embed(source = "../assets/fire_particle.png")]
		public static const DEFAULT_PARTICLE:Class;
		
		[Embed(source = "../assets/blob.png")]
		private const BLOB:Class;
		
		[Embed(source = "../assets/star.png")]
		private const STAR:Class;
		
		[Embed(source = "../assets/heart.png")]
		private const HEART:Class;
		
		public static var CIRCLE_DATA:BitmapData;
		public static var STAR_DATA:BitmapData;
		public static var BLOB_DATA:BitmapData;
		public static var CUSTOM_DATA:BitmapData;
		public static var SELECTED_DATA:BitmapData;
		public static var HEART_DATA:BitmapData;
		
		/** the user created particle config file */
		private var mConfig:XML;
		
		/** the particle system */
		private var mParticleSystem:PDParticleSystem;
		
		/** particle texture */
		private var mTexture:Texture;
		
		private var downloader:FileReference = new FileReference();
		
		private var mGUI:SimpleGUI;
		
		private var mBlendArray:Array = 
		[
			{label:"Zero", data:0x00 },
			{label:"One", data:0x01 },
			{label:"Src", data:0x300 },
			{label:"One - Src", data:0x301 },
			{label:"Src Alpha", data:0x302 },
			{label:"One - Src Alpha", data:0x303 },
			{label:"Dst Alpha", data:0x304 },
			{label:"One - Dst Alpha", data:0x305 },
			{label:"Dst Color", data:0x306 },
			{label:"One - Dst Color", data:0x307}
		];
		
		private var mEditor:TextureEditor;
		private var mBGEditor:BackgroundEditor;
		
		public function ParticleDisplay() 
		{
			CIRCLE_DATA = new DEFAULT_PARTICLE().bitmapData;
			STAR_DATA = new STAR().bitmapData;
			BLOB_DATA = new BLOB().bitmapData;
			HEART_DATA = new HEART().bitmapData;
			CUSTOM_DATA = new BitmapData(64, 64, true, 0x00000000);
			
			SELECTED_DATA = CIRCLE_DATA;
			
			mConfig = XML(new DEFAULT_CONFIG());
			mTexture = Texture.fromBitmapData(SELECTED_DATA);
			mParticleSystem = new PDParticleSystem(mConfig, mTexture);
			mParticleSystem.emitterX = 200;
            mParticleSystem.emitterY = 300;
            mParticleSystem.start();
            addChild(mParticleSystem);
			
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddedToStage(event:starling.events.Event):void
        {
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			Starling.juggler.add(mParticleSystem);
			
			initUI();
        }
        
        private function onRemovedFromStage(event:starling.events.Event):void
        {
            stage.removeEventListener(TouchEvent.TOUCH, onTouch);
			mParticleSystem.stop();
            Starling.juggler.remove(mParticleSystem);
        }
        
		/** Move the particle system with mouse click and drag */
        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage);
            if (touch && touch.phase != TouchPhase.HOVER)
            {
				if (touch.globalX <= 400 && touch.globalY <= 500) 
				{
					mParticleSystem.emitterX = touch.globalX;
					mParticleSystem.emitterY = touch.globalY;
				}
            }
        }
		
		/** Create the SimpleGUI instance */
		private function initUI():void 
		{
			mGUI = new SimpleGUI(Main.PARTICLE_SETTINGS, "General");
			
			mGUI.addGroup("Save");
			mGUI.addButton("Export Particle", { name:"savePartBtn", callback:saveParticle } );
			mGUI.addGroup("Load");
			mGUI.addButton("Load Particle", { name:"loadButton", callback:onLoad } );
			mGUI.addGroup("Edit");
			mGUI.addButton("Edit Texture", { name:"editTexBtn", callback:editTexture } );
			mGUI.addButton("Edit Background", { name:"editBGBtn", callback:editBackground } );
			
			mGUI.addColumn("Particles");
			mGUI.addGroup("Emitter Type");
			mGUI.addComboBox("emitterType", [ { label:"Gravity", data:0 }, { label:"Radial", data:1 } ], { name:"emitterType", callback:onEmitter } );
			
			mGUI.addGroup("Particle Configuration");
			mGUI.addSlider("maxParts", 1.0, 1000.0, { label:"Max Particles",  callback:onParticles, name:"maxParts" } );
			mGUI.addSlider("lifeSpan", 0, 10.0, { label:"Lifespan", callback:onLife, name:"lifeSpan" } );
			mGUI.addSlider("lifeSpanVar", 0, 10.0, { label:"Lifespan Variance", callback:onLifeVar, name:"lifeSpanVar" } );
			mGUI.addSlider("startSize", 0, 70.0, { label:"Start Size", callback:onStartSize, name:"startSize" } );
			mGUI.addSlider("startSizeVar", 0, 70.0, { label:"Start Size Variance", callback:onStartSizeVar, name:"startSizeVar" } );
			mGUI.addSlider("finishSize", 0, 70.0, { label:"Finish Size", callback:onFinishSize, name:"finishSize" } );
			mGUI.addSlider("finishSizeVar", 0, 70.0, { label:"Finish Size Variance", callback:onFinishSizeVar, name:"finishSizeVar" } );
			mGUI.addSlider("emitAngle", 0, 360.0, { label:"Emitter Angle", callback:onEmitterAngle, name:"emitAngle" } );
			mGUI.addSlider("emitAngleVar", 0, 360.0, { label:"Angle Variance", callback:onEmitterAngleVar, name:"emitAngleVar" } );
			mGUI.addSlider("stRot", 0, 360.0, { label:"Start Rot.", callback:onStartRot, name:"stRot" } );
			mGUI.addSlider("stRotVar", 0, 360.0, { label:"Start Rot. Var.", callback:onStartRotVar, name:"stRotVar" } );
			mGUI.addSlider("endRot", 0, 360.0, { label:"End Rot.", callback:onEndRot, name:"endRot" } );
			mGUI.addSlider("endRotVar", 0, 360.0, { label:"End Rot. Var.", callback:onEndRotVar, name:"endRotVar" } );
			
			mGUI.addColumn("Particle Behavior");
			mGUI.addGroup("Gravity (gravity emitter)");
			mGUI.addSlider("xPosVar", 0.0, 1000.0, { label:"X Variance", callback:onXVar, name:"xPosVar" } );
			mGUI.addSlider("yPosVar", 0.0, 1000.0, { label:"Y Variance", callback:onYVar, name:"yPosVar" } );
			mGUI.addSlider("speed", 0, 500.0, { label:"Speed", callback:onSpeed, name:"speed" } );
			mGUI.addSlider("speedVar", 0, 500.0, { label:"Speed Variance", callback:onSpeedVar, name:"speedVar" } );
			mGUI.addSlider("gravX", -500, 500.0, { label:"Gravity X", callback:onGravityX, name:"gravX" } );
			mGUI.addSlider("gravY", -500, 500.0, { label:"Gravity Y", callback:onGravityY, name:"gravY" } );
			mGUI.addSlider("tanAcc", -500, 500, { label:"Tan. Acc.", callback:onTanAcc, name:"tanAcc" } );
			mGUI.addSlider("tanAccVar", 0.0, 500, { label:"Tan. Acc. Var", callback:onTanAccVar, name:"tanAccVar" } );
			mGUI.addSlider("radialAcc", -400.00, 400.0, { label:"Rad. Acc.", callback:onRadAcc, name:"radialAcc" } );
			mGUI.addSlider("radialAccVar", 0, 500.0, { label:"Rad. Acc. Var.", callback:onRadAccVar, name:"radialAccVar" } );
			
			mGUI.addGroup("Rotation (radial emitter)");
			mGUI.addSlider("maxRadius", 0, 500.0, { label:"Max Radius", callback:onMaxRad, name:"maxRadius" } );
			mGUI.addSlider("maxRadiusVar", 0, 500.0, { label:"Max Rad Variance", callback:onMaxRadVar, name:"maxRadiusVar" } );
			mGUI.addSlider("minRadius", 0, 500.0, { label:"Min Radius", callback:onMinRadius, name:"minRadius" } );
			mGUI.addSlider("degPerSec", -360.0, 360.0, { label:"Deg/Sec", callback:onDegPerSec, name:"degPerSec" } );
			mGUI.addSlider("degPerSecVar", 0.0, 360.0, { label:"Deg/Sec Var.", callback:onDegPerSecVar, name:"degPerSecVar" } );
			
			
			mGUI.addColumn("Particle Color");
			mGUI.addGroup("Start");
			mGUI.addSlider("sr", 0, 1.0, { label:"R", callback:onStartRed, name:"sr" } );
			mGUI.addSlider("sg", 0, 1.0, { label:"G", callback:onStartGreen, name:"sg" } );
			mGUI.addSlider("sb", 0, 1.0, { label:"B", callback:onStartBlue, name:"sb" } );
			mGUI.addSlider("sa", 0, 1.0, { label:"A", callback:onStartAlpha, name:"sa" } );
			
			mGUI.addGroup("Finish");
			mGUI.addSlider("fr", 0, 1.0, { label:"R", callback:onEndRed, name:"fr" } );
			mGUI.addSlider("fg", 0, 1.0, { label:"G", callback:onEndGreen, name:"fg" } );
			mGUI.addSlider("fb", 0, 1.0, { label:"B", callback:onEndBlue, name:"fb" } );
			mGUI.addSlider("fa", 0, 1.0, { label:"A", callback:onEndAlpha, name:"fa" } );
			
			mGUI.addColumn("Particle Color Variance");
			mGUI.addGroup("Start");
			mGUI.addSlider("svr", 0, 1.0, { label:"R", callback:onStartRedVar, name:"svr" } );
			mGUI.addSlider("svg", 0, 1.0, { label:"G", callback:onStartGreenVar, name:"svg" } );
			mGUI.addSlider("svb", 0, 1.0, { label:"B", callback:onStartBlueVar, name:"svb" } );
			mGUI.addSlider("sva", 0, 1.0, { label:"A", callback:onStartAlphaVar, name:"sva" } );
			
			mGUI.addGroup("Finish");
			mGUI.addSlider("fvr", 0, 1.0, { label:"R", callback:onEndRedVar, name:"fvr" } );
			mGUI.addSlider("fvg", 0, 1.0, { label:"G", callback:onEndGreenVar, name:"fvg" } );
			mGUI.addSlider("fvb", 0, 1.0, { label:"B", callback:onEndBlueVar, name:"fvb" } );
			mGUI.addSlider("fva", 0, 1.0, { label:"A", callback:onEndAlphaVar, name:"fva" } );
			
			
			mGUI.addGroup("Blend Function");
			mGUI.addComboBox("srcBlend", mBlendArray, {  label:"Source", callback:onSourceBlend, name:"srcBlend" } );
			mGUI.addComboBox("dstBlend", mBlendArray, { label:"Dest.  ", callback:onDestBlend, name:"dstBlend" } );
			
			mGUI.show();
		}
		
		/** Browse for particle files to load */
		private function onLoad(o:*):void
		{
			downloader.addEventListener(flash.events.Event.SELECT, onLoadSelect);
			downloader.browse([new FileFilter("Particle Files (*.pex)", "*.pex")]);
		}
		
		/** After selecting particle file to load */
		private function onLoadSelect(event:flash.events.Event):void
		{
			downloader.removeEventListener(flash.events.Event.SELECT, onLoadSelect);
			downloader.addEventListener(flash.events.Event.COMPLETE, onLoadComplete);
			downloader.load();
		}
		
		/** After particle file has been loaded */
		private function onLoadComplete(event:flash.events.Event):void 
		{
			downloader.removeEventListener(flash.events.Event.COMPLETE, onLoadComplete);
			var xml:XML;
			try
			{
				xml = new XML(downloader.data);
			}
			catch (err:Error) 
			{
				trace(err);
			}
			if (xml != null) 
			{
				buildParticleFromXML(xml);
			}
			else 
			{
				var errWindow:Window = new Window(Main.PARTICLE_SETTINGS, -300, 100, "ERROR!");
				errWindow.setSize(200, 100);
				errWindow.hasCloseButton = true;
				errWindow.addEventListener(flash.events.Event.CLOSE, onErrClose);
				var lab:Label = new Label(errWindow.content, 5, 5, "Particle file appears to be malformed");
			}
		}
		
		/** remove error display window */
		private function onErrClose(event:flash.events.Event):void 
		{
			var win:Window = event.currentTarget as Window;
			win.parent.removeChild(win);
		}
		
		private function randRange(max:Number, min:Number = 0, decimals:int = 0):Number {
			if (min > max) return NaN;
			var rand:Number = Math.random() * (max - min) + min;
			var d:Number = Math.pow(10, decimals);
			return ~~((d * rand) + 0.5) / d;
		}
		
		
		// COLUMN ONE - PARTICLES
		private function onEmitter(o:*):void 
		{
			mConfig.emitterType.@value = o.selectedItem.data;
			mParticleSystem.mEmitterType = o.selectedItem.data;
		}
		
		private function onXVar(o:*):void
		{
			mConfig.sourcePositionVariance.@x = o.value;
			mParticleSystem.mEmitterXVariance = o.value;
		}
		
		private function onYVar(o:*):void 
		{
			mConfig.sourcePositionVariance.@y = o.value;
			mParticleSystem.mEmitterYVariance = o.value;
		}
		
		private function onParticles(o:*):void 
		{
			mConfig.maxParticles.@value = o.value;
			mParticleSystem.mMaxNumParticles = o.value;
			mParticleSystem.emissionRate = mParticleSystem.mMaxNumParticles / mParticleSystem.mLifespan;
		}
		
		private function onLife(o:*):void 
		{
			mConfig.particleLifeSpan.@value = o.value;
			mParticleSystem.mLifespan = o.value;
		}
		
		private function onLifeVar(o:*):void 
		{
			mConfig.particleLifespanVariance.@value = o.value;
			mParticleSystem.mLifespanVariance = o.value;
		}
		
		private function onStartSize(o:*):void 
		{
			mConfig.startParticleSize.@value = o.value;
			mParticleSystem.mStartSize = o.value;
		}
		
		private function onStartSizeVar(o:*):void 
		{
			mConfig.startParticleSizeVariance.@value = o.value;
			mParticleSystem.mStartSizeVariance = o.value;
		}
		
		private function onFinishSize(o:*):void 
		{
			mConfig.finishParticleSize.@value = o.value;
			mParticleSystem.mEndSize = o.value;
		}
		
		private function onFinishSizeVar(o:*):void 
		{
			mConfig.FinishParticleSizeVariance.@value = o.value;
			mParticleSystem.mEndSizeVariance = o.value;
		}
		
		private function onEmitterAngle(o:*):void 
		{
			mConfig.angle.@value = o.value;
			mParticleSystem.mEmitAngle = o.value * Math.PI / 180;
		}
		
		private function onEmitterAngleVar(o:*):void 
		{
			mConfig.angleVariance.@value = o.value;
			mParticleSystem.mEmitAngleVariance = o.value * Math.PI / 180;
		}
		
		private function onStartRot(o:*):void
		{
			mConfig.angleVariance.@value = o.value;
			mParticleSystem.mStartRotation = o.value * Math.PI / 180;
		}
		
		private function onStartRotVar(o:*):void
		{
			mConfig.rotationStartVariance.@value = o.value;
			mParticleSystem.mStartRotationVariance = o.value * Math.PI / 180;
		}
		
		private function onEndRot(o:*):void
		{
			mConfig.rotationEnd.@value = o.value;
			mParticleSystem.mEndRotation = o.value * Math.PI / 180;
		}
		
		private function onEndRotVar(o:*):void
		{
			mConfig.rotationEndVariance.@value = o.value;
			mParticleSystem.mEndRotationVariance = o.value * Math.PI / 180;
		}
		
		//****************************************************
		
		
		// COLUMN TWO - PARTICLE BEHAVIOR
		private function onSpeed(o:*):void 
		{
			mConfig.speed.@value = o.value;
			mParticleSystem.mSpeed = o.value;
		}
		
		private function onSpeedVar(o:*):void 
		{
			mConfig.speedVariance.@value = o.value;
			mParticleSystem.mSpeedVariance = o.value;
		}
		
		private function onGravityX(o:*):void 
		{
			mConfig.gravity.@x = o.value;
			mParticleSystem.mGravityX = o.value;
		}
		
		private function onGravityY(o:*):void 
		{
			mConfig.gravity.@y = o.value;
			mParticleSystem.mGravityY = o.value;
		}
		
		private function onTanAcc(o:*):void 
		{
			mConfig.tangentialAcceleration.@value = o.value;
			mParticleSystem.mTangentialAcceleration = o.value;
		}
		
		private function onTanAccVar(o:*):void 
		{
			mConfig.tangentialAccelVariance.@value = o.value;
			mParticleSystem.mTangentialAccelerationVariance = o.value;
		}
		
		private function onRadAcc(o:*):void 
		{
			mConfig.radialAcceleration.@value = o.value;
			mParticleSystem.mRadialAcceleration = o.value;
		}
		
		private function onRadAccVar(o:*):void
		{
			mConfig.radialAccelVariance.@value = o.value;
			mParticleSystem.mRadialAccelerationVariance = o.value;
		}
		
		private function onMaxRad(o:*):void 
		{
			mConfig.maxRadius.@value = o.value;
			mParticleSystem.mMaxRadius = o.value;
		}
		
		private function onMaxRadVar(o:*):void 
		{
			mConfig.maxRadiusVariance.@value = o.value;
			mParticleSystem.mMaxRadiusVariance = o.value;
		}
		
		private function onMinRadius(o:*):void 
		{
			mConfig.minRadius.@value = o.value;
			mParticleSystem.mMinRadius = o.value;
		}
		
		private function onDegPerSec(o:*):void 
		{
			mConfig.rotatePerSecond.@value = o.value;
			mParticleSystem.mRotatePerSecond = o.value * Math.PI / 180;
		}
		
		private function onDegPerSecVar(o:*):void 
		{
			mConfig.rotatePerSecondVariance.@value = o.value;
			mParticleSystem.mRotatePerSecondVariance = o.value * Math.PI / 180;
		}
		

		//******************************************************************
		
		
		
		// COLUMN THREE - PARTICLE COLOR
		private function onStartRed(o:*):void 
		{
			mConfig.startColor.@red = o.value;
			mParticleSystem.mStartColor.red = o.value;
		}
		
		private function onStartGreen(o:*):void 
		{
			mConfig.startColor.@green = o.value;
			mParticleSystem.mStartColor.green = o.value;
		}
		
		private function onStartBlue(o:*):void 
		{
			mConfig.startColor.@blue = o.value;
			mParticleSystem.mStartColor.blue = o.value;
		}
		
		private function onStartAlpha(o:*):void 
		{
			mConfig.startColor.@alpha = o.value;
			mParticleSystem.mStartColor.alpha = o.value;
		}
		
		private function onEndRed(o:*):void 
		{
			mConfig.finishColor.@red = o.value;
			mParticleSystem.mEndColor.red = o.value;
		}
		
		private function onEndGreen(o:*):void 
		{
			mConfig.finishColor.@green = o.value;
			mParticleSystem.mEndColor.green = o.value;
		}
		
		private function onEndBlue(o:*):void 
		{
			mConfig.finishColor.@blue = o.value;
			mParticleSystem.mEndColor.blue = o.value;
		}
		
		private function onEndAlpha(o:*):void 
		{
			mConfig.finishColor.@alpha = o.value;
			mParticleSystem.mEndColor.alpha = o.value;
		}
		
		//*********************************************************
		
		
		
		
		// COLUMN FOUR - PARTICLE COLOR VARIANCE
		private function onStartRedVar(o:*):void 
		{
			mConfig.startColorVariance.@red = o.value;
			mParticleSystem.mStartColorVariance.red = o.value;
		}
		
		private function onStartGreenVar(o:*):void 
		{
			mConfig.startColorVariance.@green = o.value;
			mParticleSystem.mStartColorVariance.green = o.value;
		}
		
		private function onStartBlueVar(o:*):void 
		{
			mConfig.startColorVariance.@blue = o.value;
			mParticleSystem.mStartColorVariance.blue = o.value;
		}
		
		private function onStartAlphaVar(o:*):void 
		{
			mConfig.startColorVariance.@alpha = o.value;
			mParticleSystem.mStartColorVariance.alpha = o.value;
		}
		
		private function onEndRedVar(o:*):void 
		{
			mConfig.finishColorVariance.@red = o.value;
			mParticleSystem.mEndColorVariance.red = o.value;
		}
		
		private function onEndGreenVar(o:*):void 
		{
			mConfig.finishColorVariance.@green = o.value;
			mParticleSystem.mEndColorVariance.green = o.value;
		}
		
		private function onEndBlueVar(o:*):void 
		{
			mConfig.finishColorVariance.@blue = o.value;
			mParticleSystem.mEndColorVariance.blue = o.value;
		}
		
		private function onEndAlphaVar(o:*):void 
		{
			mConfig.finishColorVariance.@alpha = o.value;
			mParticleSystem.mEndColorVariance.alpha = o.value;
		}
		
		//*******************************************************************
		
		
		
		
		private function onSourceBlend(o:*):void 
		{
			mConfig.blendFuncSource.@value = o.selectedItem.data;
			recreateSystem();
		}
		
		private function onDestBlend(o:*):void 
		{
			mConfig.blendFuncDestination.@value = o.selectedItem.data;
			recreateSystem();
		}
		
		/** destroy then recreate particle system from updated config */
		private function recreateSystem():void 
		{
			var ex:Number = mParticleSystem.emitterX;
			var ey:Number = mParticleSystem.emitterY;
			mParticleSystem.stop();
			Starling.juggler.remove(mParticleSystem);
			removeChild(mParticleSystem);
			mParticleSystem.dispose();
			
			mTexture = Texture.fromBitmapData(SELECTED_DATA);
			mParticleSystem = new PDParticleSystem(mConfig, mTexture);
			mParticleSystem.emitterX = ex;
			mParticleSystem.emitterY = ey;
			mParticleSystem.start();
			Starling.juggler.add(mParticleSystem);
			addChild(mParticleSystem);
		}
		
		/** Save particle texture image source and config file to .zip */
		private function saveParticle(o:*):void
		{
			var zip:ZipOutput = new ZipOutput();
			var filename:String;
			var filedata:ByteArray;
			var entry:ZipEntry;
			
			// add pex to zip
			filename = "particle.pex";
			filedata = new ByteArray();
			filedata.writeUTFBytes(mConfig.toXMLString());
			filedata.position = 0;
			
			entry = new ZipEntry(filename);
			zip.putNextEntry(entry);
			zip.write(filedata);
			zip.closeEntry();
			
			// texture to zip
			filename = "texture.png";
			filedata = PNGEncoder.encode(SELECTED_DATA);
			filedata.position = 0;
			
			entry = new ZipEntry(filename);
			zip.putNextEntry(entry);
			zip.write(filedata);
			zip.closeEntry();
			
			// finish the zip
			zip.finish();
			
			downloader.save(zip.byteArray, "particle.zip");
		}
		
		/** open the texture editor panel */
		private function editTexture(o:*):void 
		{
			if ((mBGEditor)) onDoneBGEditing(null);
			mEditor = new TextureEditor(SELECTED_DATA);
			mEditor.y = Main.PARTICLE_SETTINGS.height;
			mEditor.addEventListener(flash.events.Event.COMPLETE, onDoneEditing);
			Main.PARTICLE_SETTINGS.addChild(mEditor);
		}
		
		/** after closing texture editor panel */
		private function onDoneEditing(event:flash.events.Event):void
		{
			mEditor.removeEventListener(flash.events.Event.COMPLETE, onDoneEditing);
			SELECTED_DATA = mEditor.mData;
			Main.PARTICLE_SETTINGS.removeChild(mEditor);
			mEditor = null;
			recreateSystem();
		}
		
		/** open background editor panel */
		private function editBackground(o:*):void 
		{
			if ((mEditor)) onDoneEditing(null);
			mBGEditor = new BackgroundEditor(stage);
			mBGEditor.y = Main.PARTICLE_SETTINGS.height;
			mBGEditor.addEventListener(flash.events.Event.COMPLETE, onDoneBGEditing);
			Main.PARTICLE_SETTINGS.addChild(mBGEditor);
		}
		
		/** after closing background editor panel */
		private function onDoneBGEditing(event:flash.events.Event):void 
		{
			mBGEditor.removeEventListener(flash.events.Event.COMPLETE, onDoneBGEditing);
			Main.PARTICLE_SETTINGS.removeChild(mBGEditor);
			mBGEditor = null;
		}
		
		//************************
		
		/** set all gui and particle setting from loaded .pex file */
		private function buildParticleFromXML(xml:XML):void 
		{
			var i:int = mGUI.components.length;
			
			while (i--) 
			{
				var comp:Component = mGUI.components[i];
				var val:Number;
				var idx:int;
				
				if (comp.name == "emitterType") 
				{
					val = parseFloat(xml.emitterType.@value);
					switch(val) 
					{
						case 0:
							idx = 0;
							break;
						case 1 :
							idx = 1;
							break;
						default :
							idx = 0;
					}
					
					Main.PARTICLE_SETTINGS.emitterType = idx;
					(comp as ComboBox).selectedIndex = idx;
					onEmitter(comp);
				}
				
				if (comp.name == "maxParts") 
				{
					val = parseFloat(xml.maxParticles.@value);
					Main.PARTICLE_SETTINGS.maxParts = val;
					(comp as HUISlider).value = val;
					onParticles(comp);
				}
				
				if (comp.name == "lifeSpan") 
				{
					val = parseFloat(xml.particleLifeSpan.@value);
					Main.PARTICLE_SETTINGS.lifeSpan = val;
					(comp as HUISlider).value = val;
					onLife(comp);
				}
				
				if (comp.name == "lifeSpanVar") 
				{
					val = parseFloat(xml.particleLifespanVariance.@value);
					Main.PARTICLE_SETTINGS.lifeSpanVar = val;
					(comp as HUISlider).value = val;
					onLifeVar(comp);
				}
				
				if (comp.name == "startSize") 
				{
					val = parseFloat(xml.startParticleSize.@value);
					Main.PARTICLE_SETTINGS.startSize = val;
					(comp as HUISlider).value = val;
					onStartSize(comp);
				}
				
				if (comp.name == "startSizeVar") 
				{
					val = parseFloat(xml.startParticleSizeVariance.@value);
					Main.PARTICLE_SETTINGS.startSizeVar = val;
					(comp as HUISlider).value = val;
					onStartSizeVar(comp);
				}
				
				if (comp.name == "finishSize") 
				{
					val = parseFloat(xml.finishParticleSize.@value);
					Main.PARTICLE_SETTINGS.finishSize = val;
					(comp as HUISlider).value = val;
					onFinishSize(comp);
				}
				
				if (comp.name == "finishSizeVar") 
				{
					val = parseFloat(xml.FinishParticleSizeVariance.@value);
					Main.PARTICLE_SETTINGS.finishSizeVar = val;
					(comp as HUISlider).value = val;
					onFinishSizeVar(comp);
				}
				
				if (comp.name == "emitAngle") 
				{
					val = parseFloat(xml.angle.@value);
					Main.PARTICLE_SETTINGS.emitAngle = val;
					(comp as HUISlider).value = val;
					onEmitterAngle(comp);
				}
				
				if (comp.name == "emitAngleVar") 
				{
					val = parseFloat(xml.angleVariance.@value);
					Main.PARTICLE_SETTINGS.emitAngleVar = val;
					(comp as HUISlider).value = val;
					onEmitterAngleVar(comp);
				}
				
				if (comp.name == "stRot")
				{
					val = parseFloat(xml.rotationStart.@value);
					Main.PARTICLE_SETTINGS.stRot = val;
					(comp as HUISlider).value = val;
					onStartRot(comp);
				}
				
				if (comp.name == "stRotVar")
				{
					val = parseFloat(xml.rotationStartVariance.@value);
					Main.PARTICLE_SETTINGS.stRotVar = val;
					(comp as HUISlider).value = val;
					onStartRotVar(comp);
				}
				
				if (comp.name == "endRot")
				{
					val = parseFloat(xml.rotationEnd.@value);
					Main.PARTICLE_SETTINGS.endRot = val;
					(comp as HUISlider).value = val;
					onEndRot(comp);
				}
				
				if (comp.name == "endRotVar")
				{
					val = parseFloat(xml.rotationEndVariance.@value);
					Main.PARTICLE_SETTINGS.endRotVar = val;
					(comp as HUISlider).value = val;
					onEndRotVar(comp);
				}

				if (comp.name == "xPosVar") 
				{
					val = parseFloat(xml.sourcePositionVariance.@x);
					Main.PARTICLE_SETTINGS.xPosVar = val;
					(comp as HUISlider).value = val;
					onXVar(comp);
				}
				
				if (comp.name == "yPosVar") 
				{
					val = parseFloat(xml.sourcePositionVariance.@y);
					Main.PARTICLE_SETTINGS.yPosVar = val;
					(comp as HUISlider).value = val;
					onYVar(comp);
				}
				
				if (comp.name == "speed") 
				{
					val = parseFloat(xml.speed.@value);
					Main.PARTICLE_SETTINGS.speed = val;
					(comp as HUISlider).value = val;
					onSpeed(comp);
				}
				
				if (comp.name == "speedVar") 
				{
					val = parseFloat(xml.speedVariance.@value);
					Main.PARTICLE_SETTINGS.speedVar = val;
					(comp as HUISlider).value = val;
					onSpeedVar(comp);
				}
				
				if (comp.name == "gravX") 
				{
					val = parseFloat(xml.gravity.@x);
					Main.PARTICLE_SETTINGS.gravX = val;
					(comp as HUISlider).value = val;
					onGravityX(comp);
				}
				
				if (comp.name == "gravY") 
				{
					val = parseFloat(xml.gravity.@y);
					Main.PARTICLE_SETTINGS.gravY = val;
					(comp as HUISlider).value = val;
					onGravityY(comp);
				}
				
				if (comp.name == "tanAcc") 
				{
					val = parseFloat(xml.tangentialAcceleration.@value);
					Main.PARTICLE_SETTINGS.tanAcc = val;
					(comp as HUISlider).value = val;
					onTanAcc(comp);
				}
				
				if (comp.name == "maxRadius") 
				{
					val = parseFloat(xml.maxRadius.@value);
					Main.PARTICLE_SETTINGS.maxRadius = val;
					(comp as HUISlider).value = val;
					onMaxRad(comp);
				}
				
				if (comp.name == "maxRadiusVar") 
				{
					val = parseFloat(xml.maxRadiusVariance.@value);
					Main.PARTICLE_SETTINGS.maxRadiusVar = val;
					(comp as HUISlider).value = val;
					onMaxRadVar(comp);
				}
				
				if (comp.name == "minRadius") 
				{
					val = parseFloat(xml.minRadius.@value);
					Main.PARTICLE_SETTINGS.minRadius = val;
					(comp as HUISlider).value = val;
					onMinRadius(comp);
				}
				
				if (comp.name == "degPerSec") 
				{
					val = parseFloat(xml.rotatePerSecond.@value);
					Main.PARTICLE_SETTINGS.degPerSec = val;
					(comp as HUISlider).value = val;
					onDegPerSec(comp);
				}
				
				if (comp.name == "degPerSecVar") 
				{
					val = parseFloat(xml.rotatePerSecondVariance.@value);
					Main.PARTICLE_SETTINGS.degPerSecVar = val;
					(comp as HUISlider).value = val;
					onDegPerSecVar(comp);
				}
				
				if (comp.name == "sr") 
				{
					val = parseFloat(xml.startColor.@red);
					Main.PARTICLE_SETTINGS.sr = val;
					(comp as HUISlider).value = val;
					onStartRed(comp);
				}
				
				if (comp.name == "sg") 
				{
					val = parseFloat(xml.startColor.@green);
					Main.PARTICLE_SETTINGS.sg = val;
					(comp as HUISlider).value = val;
					onStartGreen(comp);
				}
				
				if (comp.name == "sb") 
				{
					val = parseFloat(xml.startColor.@blue);
					Main.PARTICLE_SETTINGS.sb = val;
					(comp as HUISlider).value = val;
					onStartBlue(comp);
				}
				
				if (comp.name == "sa") 
				{
					val = parseFloat(xml.startColor.@alpha);
					Main.PARTICLE_SETTINGS.sa = val;
					(comp as HUISlider).value = val;
					onStartAlpha(comp);
				}
				
				if (comp.name == "fr") 
				{
					val = parseFloat(xml.finishColor.@red);
					Main.PARTICLE_SETTINGS.fr = val;
					(comp as HUISlider).value = val;
					onEndRed(comp);
				}
				
				if (comp.name == "fg") 
				{
					val = parseFloat(xml.finishColor.@green);
					Main.PARTICLE_SETTINGS.fg = val;
					(comp as HUISlider).value = val;
					onEndGreen(comp);
				}
				
				if (comp.name == "fb") 
				{
					val = parseFloat(xml.finishColor.@blue);
					Main.PARTICLE_SETTINGS.fb = val;
					(comp as HUISlider).value = val;
					onEndBlue(comp);
				}
				
				if (comp.name == "fa") 
				{
					val = parseFloat(xml.finishColor.@alpha);
					Main.PARTICLE_SETTINGS.fa = val;
					(comp as HUISlider).value = val;
					onEndAlpha(comp);
				}
				
				if (comp.name == "svr") 
				{
					val = parseFloat(xml.startColorVariance.@red);
					Main.PARTICLE_SETTINGS.svr = val;
					(comp as HUISlider).value = val;
					onStartRedVar(comp);
				}
				
				if (comp.name == "svg") 
				{
					val = parseFloat(xml.startColorVariance.@green);
					Main.PARTICLE_SETTINGS.svg = val;
					(comp as HUISlider).value = val;
					onStartGreenVar(comp);
				}
				
				if (comp.name == "svb") 
				{
					val = parseFloat(xml.startColorVariance.@blue);
					Main.PARTICLE_SETTINGS.svb = val;
					(comp as HUISlider).value = val;
					onStartBlueVar(comp);
				}
				
				if (comp.name == "sva") 
				{
					val = parseFloat(xml.startColorVariance.@alpha);
					Main.PARTICLE_SETTINGS.sva = val;
					(comp as HUISlider).value = val;
					onStartAlphaVar(comp);
				}
				
				if (comp.name == "fvr") 
				{
					val = parseFloat(xml.finishColorVariance.@red);
					Main.PARTICLE_SETTINGS.fvr = val;
					(comp as HUISlider).value = val;
					onEndRedVar(comp);
				}
				
				if (comp.name == "fvg") 
				{
					val = parseFloat(xml.finishColorVariance.@green);
					Main.PARTICLE_SETTINGS.fvg = val;
					(comp as HUISlider).value = val;
					onEndGreenVar(comp);
				}
				
				if (comp.name == "fvb") 
				{
					val = parseFloat(xml.finishColorVariance.@blue);
					Main.PARTICLE_SETTINGS.fvb = val;
					(comp as HUISlider).value = val;
					onEndBlueVar(comp);
				}
				
				if (comp.name == "fva") 
				{
					val = parseFloat(xml.finishColorVariance.@alpha);
					Main.PARTICLE_SETTINGS.fva = val;
					(comp as HUISlider).value = val;
					onEndAlphaVar(comp);
				}
				
				if (comp.name == "srcBlend") 
				{
					val = parseFloat(xml.blendFuncSource.@value);
					switch(val) 
					{
						case 0x00 :
							idx = 0;
							break;
						case 0x01 :
							idx = 1;
							break;
						case 0x300 :
							idx = 2;
							break;
						case 0x301 :
							idx = 3;
							break;
						case 0x302 :
							idx = 4;
							break;
						case 0x303 :
							idx = 5;
							break;
						case 0x304 :
							idx = 6;
							break;
						case 0x305 :
							idx = 7;
							break;
						case 0x306 :
							idx = 8;
							break;
						case 0x307 :
							idx = 9;
							break;	
					}
					Main.PARTICLE_SETTINGS.srcBlend = val;
					(comp as ComboBox).selectedIndex = idx;
					onSourceBlend(comp);
				}
				
				if (comp.name == "dstBlend") 
				{
					val = parseFloat(xml.blendFuncDestination.@value);
					switch(val) 
					{
						case 0x00 :
							idx = 0;
							break;
						case 0x01 :
							idx = 1;
							break;
						case 0x300 :
							idx = 2;
							break;
						case 0x301 :
							idx = 3;
							break;
						case 0x302 :
							idx = 4;
							break;
						case 0x303 :
							idx = 5;
							break;
						case 0x304 :
							idx = 6;
							break;
						case 0x305 :
							idx = 7;
							break;
						case 0x306 :
							idx = 8;
							break;
						case 0x307 :
							idx = 9;
							break;
						default :
							idx = 1;
					}
					Main.PARTICLE_SETTINGS.dstBlend = val;
					(comp as ComboBox).selectedIndex = idx;
					onDestBlend(comp);
				}
				
				
			}
			
			xml = null;
			recreateSystem();
		}
	}

}