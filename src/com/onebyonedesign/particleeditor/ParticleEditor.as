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
    import com.adobe.images.PNGEncoder;
    import com.bit101.components.ComboBox;
    import com.bit101.components.Component;
    import com.bit101.components.Label;
    import com.bit101.components.Window;
    import com.ww.PEXtoPlist;
    import flash.events.Event;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import flash.utils.ByteArray;
    import nochump.util.zip.ZipEntry;
    import nochump.util.zip.ZipOutput;
    import uk.co.soulwire.gui.SimpleGUI;
	
	/**
	 * Save, load, and modify particle properties
	 * @author Devon O.
	 */
	public class ParticleEditor
	{
		/** file reference to download particle */
		private var downloader:FileReference = new FileReference();
		
		/** UI */
		private var mGUI:SimpleGUI;
        
        /** Particle Configuration */
        private var mParticleConfig:ParticleConfiguration;
        
        /** Settings */
        private var mSettings:SettingsModel;
        
        /** Particle View */
        private var mParticleView:ParticleView;
        
        /** texture editor */
		private var mTexEditor:TextureEditor;
		
		/** background editor */
		private var mBGEditor:BackgroundEditor;
		
        /** Blend Mode values */
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
        
        /**
         * Create a new Particle Editor
         * @param settings
         * @param initialConfig
         * @param particleView
         */
		public function ParticleEditor(settings:SettingsModel, initialConfig:XML, particleView:ParticleView) 
		{
            mSettings = settings;
            mParticleConfig = new ParticleConfiguration(initialConfig);
            mSettings.addListener(mParticleConfig);
            mParticleView = particleView;
            mParticleView.particleConfig = mParticleConfig;
            mParticleView.settings = mSettings;
            
            initUI();
		}
		
		/** Create the SimpleGUI instance */
		private function initUI():void 
		{
			mGUI = new SimpleGUI(mSettings, "General");
			
			mGUI.addGroup("Save");
			mGUI.addButton("Export Particle", { name:"savePartBtn", callback:saveParticle } );
			mGUI.addToggle("savePlist", { label:"Include .PLIST file", name:"savePlist" } );
			mGUI.addGroup("Load");
			mGUI.addButton("Load Particle", { name:"loadButton", callback:onLoad } );
			mGUI.addGroup("Edit");
			mGUI.addButton("Edit Texture", { name:"editTexBtn", callback:editTexture } );
			mGUI.addButton("Edit Background", { name:"editBGBtn", callback:editBackground } );
            mGUI.addGroup("Random Settings");
            mGUI.addButton("Randomize!", { name:"randomSettings", callback:randomizeSettings } );
			
			mGUI.addColumn("Particles");
			mGUI.addGroup("Emitter Type");
			mGUI.addComboBox("emitterType", [ { label:"Gravity", data:0 }, { label:"Radial", data:1 } ], { name:"emitterType" } );
			
			mGUI.addGroup("Particle Configuration");
			mGUI.addSlider("maxParts", 1.0, 1000.0, { label:"Max Particles", name:"maxParts" } );
			mGUI.addSlider("lifeSpan", 0, 10.0, { label:"Lifespan", name:"lifeSpan" } );
			mGUI.addSlider("lifeSpanVar", 0, 10.0, { label:"Lifespan Variance", name:"lifeSpanVar" } );
			mGUI.addSlider("startSize", 0, 70.0, { label:"Start Size", name:"startSize" } );
			mGUI.addSlider("startSizeVar", 0, 70.0, { label:"Start Size Variance", name:"startSizeVar" } );
			mGUI.addSlider("finishSize", 0, 70.0, { label:"Finish Size", name:"finishSize" } );
			mGUI.addSlider("finishSizeVar", 0, 70.0, { label:"Finish Size Variance", name:"finishSizeVar" } );
			mGUI.addSlider("emitAngle", 0, 360.0, { label:"Emitter Angle", name:"emitAngle" } );
			mGUI.addSlider("emitAngleVar", 0, 360.0, { label:"Angle Variance", name:"emitAngleVar" } );
			mGUI.addSlider("stRot", 0, 360.0, { label:"Start Rot.", name:"stRot" } );
			mGUI.addSlider("stRotVar", 0, 360.0, { label:"Start Rot. Var.", name:"stRotVar" } );
			mGUI.addSlider("endRot", 0, 360.0, { label:"End Rot.", name:"endRot" } );
			mGUI.addSlider("endRotVar", 0, 360.0, { label:"End Rot. Var.", name:"endRotVar" } );
			
			mGUI.addColumn("Particle Behavior");
			mGUI.addGroup("Gravity (gravity emitter)");
			mGUI.addSlider("xPosVar", 0.0, 1000.0, { label:"X Variance", name:"xPosVar" } );
			mGUI.addSlider("yPosVar", 0.0, 1000.0, { label:"Y Variance", name:"yPosVar" } );
			mGUI.addSlider("speed", 0, 500.0, { label:"Speed", name:"speed" } );
			mGUI.addSlider("speedVar", 0, 500.0, { label:"Speed Variance", name:"speedVar" } );
			mGUI.addSlider("gravX", -500, 500.0, { label:"Gravity X", name:"gravX" } );
			mGUI.addSlider("gravY", -500, 500.0, { label:"Gravity Y", name:"gravY" } );
			mGUI.addSlider("tanAcc", -500, 500, { label:"Tan. Acc.", name:"tanAcc" } );
			mGUI.addSlider("tanAccVar", 0.0, 500, { label:"Tan. Acc. Var", name:"tanAccVar" } );
			mGUI.addSlider("radialAcc", -500.00, 500.0, { label:"Rad. Acc.", name:"radialAcc" } );
			mGUI.addSlider("radialAccVar", 0, 500.0, { label:"Rad. Acc. Var.", name:"radialAccVar" } );
			
			mGUI.addGroup("Rotation (radial emitter)");
			mGUI.addSlider("maxRadius", 0, 500.0, { label:"Max Radius", name:"maxRadius" } );
			mGUI.addSlider("maxRadiusVar", 0, 500.0, { label:"Max Rad Variance", name:"maxRadiusVar" } );
			mGUI.addSlider("minRadius", 0, 500.0, { label:"Min Radius", name:"minRadius" } );
			mGUI.addSlider("degPerSec", -360.0, 360.0, { label:"Deg/Sec", name:"degPerSec" } );
			mGUI.addSlider("degPerSecVar", 0.0, 360.0, { label:"Deg/Sec Var.", name:"degPerSecVar" } );
			
			mGUI.addColumn("Particle Color");
			mGUI.addGroup("Start");
			mGUI.addSlider("sr", 0, 1.0, { label:"R", name:"sr" } );
			mGUI.addSlider("sg", 0, 1.0, { label:"G", name:"sg" } );
			mGUI.addSlider("sb", 0, 1.0, { label:"B", name:"sb" } );
			mGUI.addSlider("sa", 0, 1.0, { label:"A", name:"sa" } );
			
			mGUI.addGroup("Finish");
			mGUI.addSlider("fr", 0, 1.0, { label:"R", name:"fr" } );
			mGUI.addSlider("fg", 0, 1.0, { label:"G", name:"fg" } );
			mGUI.addSlider("fb", 0, 1.0, { label:"B", name:"fb" } );
			mGUI.addSlider("fa", 0, 1.0, { label:"A", name:"fa" } );
			
			mGUI.addColumn("Particle Color Variance");
			mGUI.addGroup("Start");
			mGUI.addSlider("svr", 0, 1.0, { label:"R", name:"svr" } );
			mGUI.addSlider("svg", 0, 1.0, { label:"G", name:"svg" } );
			mGUI.addSlider("svb", 0, 1.0, { label:"B", name:"svb" } );
			mGUI.addSlider("sva", 0, 1.0, { label:"A", name:"sva" } );
			
			mGUI.addGroup("Finish");
			mGUI.addSlider("fvr", 0, 1.0, { label:"R", name:"fvr" } );
			mGUI.addSlider("fvg", 0, 1.0, { label:"G", name:"fvg" } );
			mGUI.addSlider("fvb", 0, 1.0, { label:"B", name:"fvb" } );
			mGUI.addSlider("fva", 0, 1.0, { label:"A", name:"fva" } );
			
			mGUI.addGroup("Blend Function");
			mGUI.addComboBox("srcBlend", mBlendArray, {  label:"Source", name:"srcBlend" } );
			mGUI.addComboBox("dstBlend", mBlendArray, { label:"Dest.  ", name:"dstBlend" } );
			
			mGUI.show();
		}
        
        //
        // Load a .pex file
        //
		
		/** Browse for particle files to load */
		private function onLoad(o:*):void
		{
			downloader.addEventListener(Event.SELECT, onLoadSelect);
			downloader.browse([new FileFilter("Particle Files (*.pex)", "*.pex")]);
		}
		
		/** After selecting particle file to load */
		private function onLoadSelect(event:Event):void
		{
			downloader.removeEventListener(Event.SELECT, onLoadSelect);
			downloader.addEventListener(Event.COMPLETE, onLoadComplete);
			downloader.load();
		}
		
		/** After particle file has been loaded */
		private function onLoadComplete(event:Event):void 
		{
			downloader.removeEventListener(Event.COMPLETE, onLoadComplete);
            
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
				showError("Particle file appears to be malformed");
			}
		}
        
        //
        // Error display 
        //
        
        /** Display an Error Window */
        private function showError(label:String):void
        {
            var errWindow:Window = new Window(mSettings, -300, 100, "ERROR!");
            errWindow.setSize(200, 100);
            errWindow.hasCloseButton = true;
            errWindow.addEventListener(Event.CLOSE, onErrClose);
            var lab:Label = new Label(errWindow.content, 5, 5, label);
        }
		
		/** remove error display window */
		private function onErrClose(event:Event):void 
		{
			var win:Window = event.currentTarget as Window;
			win.parent.removeChild(win);
		}
        
        // 
        // Save zipped particle (.pex and .png)
        //
        
		/** Save particle texture image source and config file and optional .plist config to .zip */
		private function saveParticle(o:*):void
		{
			var zip:ZipOutput = new ZipOutput();
			var filename:String;
			var filedata:ByteArray;
			var entry:ZipEntry;
            var xml:XML = mParticleConfig.xml;
			
			// add pex to zip
			filename = "particle.pex";
			filedata = new ByteArray();
			filedata.writeUTFBytes(xml.toXMLString());
			filedata.position = 0;
			
			entry = new ZipEntry(filename);
			zip.putNextEntry(entry);
			zip.write(filedata);
			zip.closeEntry();
			
			// texture to zip
			filename = "texture.png";
			filedata = PNGEncoder.encode(mParticleView.particleData);
			filedata.position = 0;
			
			entry = new ZipEntry(filename);
			zip.putNextEntry(entry);
			zip.write(filedata);
			zip.closeEntry();
			
			if (mSettings.savePlist)
			{
				filename = "particle.plist";
				var plist:String = PEXtoPlist.createPlist(xml.toXMLString());
				filedata = new ByteArray();
				filedata.writeUTFBytes(plist);
				filedata.position = 0;
				
				entry = new ZipEntry(filename);
				zip.putNextEntry(entry);
				zip.write(filedata);
				zip.closeEntry();
			}
			
			// finish the zip
			zip.finish();
			
			downloader.save(zip.byteArray, "particle.zip");
		}
        
        //
        // Edit Texture
        //
		
		/** open the texture editor panel */
		private function editTexture(o:*):void 
		{
			if ((mBGEditor)) 
                onDoneBGEditing(null);
			mTexEditor = new TextureEditor(mParticleView.particleData);
			mTexEditor.y = mSettings.height;
			mTexEditor.addEventListener(Event.COMPLETE, onDoneEditing);
			mSettings.addChild(mTexEditor);
		}
		
		/** after closing texture editor panel */
		private function onDoneEditing(event:Event):void
		{
			mTexEditor.removeEventListener(Event.COMPLETE, onDoneEditing);
            mParticleView.particleData = mTexEditor.mData;
			mSettings.removeChild(mTexEditor);
			mTexEditor = null;
		}
        
        // 
        // Edit Background color 
        //
		
		/** open background editor panel */
		private function editBackground(o:*):void 
		{
			if ((mTexEditor)) 
                onDoneEditing(null);
			mBGEditor = new BackgroundEditor();
			mBGEditor.y = mSettings.height;
			mBGEditor.addEventListener(Event.COMPLETE, onDoneBGEditing);
			mSettings.addChild(mBGEditor);
		}
        
        /** after closing background editor panel */
		private function onDoneBGEditing(event:Event):void 
		{
			mBGEditor.removeEventListener(Event.COMPLETE, onDoneBGEditing);
			mSettings.removeChild(mBGEditor);
			mBGEditor = null;
		}
        
        /** Randomize particle settings */
        private function randomizeSettings(o:*):void
        {
            mParticleConfig.randomize();
            
            buildParticleFromXML(mParticleConfig.xml);
        }
        
		/** Set all gui and particle settings from loaded .pex file */
		private function buildParticleFromXML(xml:XML):void 
		{
			var i:int = mGUI.components.length;
			
			while (i--) 
			{
				var comp:Component = mGUI.components[i];
				var val:Number;
				var idx:int;
                
                switch(comp.name)
                {
                    case "emitterType" :
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
                        
                        mSettings.emitterType = idx;
                        (comp as ComboBox).selectedIndex = idx;
                        break;
                        
                    case "maxParts" :
                        val = parseFloat(xml.maxParticles.@value);
                        mSettings.maxParts = val;
                        break;
                        
                    case "lifeSpan" :
                        val = parseFloat(xml.particleLifeSpan.@value);
                        mSettings.lifeSpan = val;
                        break;
                        
                    case "lifeSpanVar" :
                        val = parseFloat(xml.particleLifespanVariance.@value);
                        mSettings.lifeSpanVar = val;
                        break;
                        
                    case "startSize" :
                        val = parseFloat(xml.startParticleSize.@value);
                        mSettings.startSize = val;
                        break;
                        
                    case "startSizeVar" :
                        val = parseFloat(xml.startParticleSizeVariance.@value);
                        mSettings.startSizeVar = val;
                        break;
                        
                    case "finishSize" :
                        val = parseFloat(xml.finishParticleSize.@value);
                        mSettings.finishSize = val;
                        break;
                        
                    case "finishSizeVar" :
                        val = parseFloat(xml.FinishParticleSizeVariance.@value);
                        mSettings.finishSizeVar = val;
                        break;
                        
                    case "emitAngle" :
                        val = parseFloat(xml.angle.@value);
                        mSettings.emitAngle = val;
                        break;
                        
                    case "emitAngleVar" :      
                        val = parseFloat(xml.angleVariance.@value);
                        mSettings.emitAngleVar = val;
                        break;
                        
                    case "stRot" :
                        val = parseFloat(xml.rotationStart.@value);
                        mSettings.stRot = val;
                        break;
                        
                    case "stRotVar" :
                        val = parseFloat(xml.rotationStartVariance.@value);
                        mSettings.stRotVar = val;
                        break;
                        
                    case "endRot" :
                        val = parseFloat(xml.rotationEnd.@value);
                        mSettings.endRot = val;
                        break;
                        
                    case "endRotVar" :
                        val = parseFloat(xml.rotationEndVariance.@value);
                        mSettings.endRotVar = val;
                        break;
                        
                    case "xPosVar" :
                        val = parseFloat(xml.sourcePositionVariance.@x);
                        mSettings.xPosVar = val;
                        break;
                        
                    case "yPosVar" :
                        val = parseFloat(xml.sourcePositionVariance.@y);
                        mSettings.yPosVar = val;
                        break;
                        
                    case "speed" :
                        val = parseFloat(xml.speed.@value);
                        mSettings.speed = val;
                        break;
                        
                    case "speedVar" :
                        val = parseFloat(xml.speedVariance.@value);
                        mSettings.speedVar = val;
                        break;
                        
                    case "gravX" :
                        val = parseFloat(xml.gravity.@x);
                        mSettings.gravX = val;
                        break;
                        
                    case "gravY" :
                        val = parseFloat(xml.gravity.@y);
                        mSettings.gravY = val;
                        break;
                        
                    case "tanAcc" :
                        val = parseFloat(xml.tangentialAcceleration.@value);
                        mSettings.tanAcc = val;
                        break;
                        
                    case "tanAccVar" :
                        val = parseFloat(xml.tangentialAccelVariance.@value);
                        mSettings.tanAccVar = val;
                        break;
                        
                    case "radialAcc" :
                        val = parseFloat(xml.radialAcceleration.@value);
                        mSettings.radialAcc = val;
                        break;
                        
                    case "radialAccVar" :
                        val = parseFloat(xml.radialAccelVariance.@value);
                        mSettings.radialAccVar = val;
                        break;
                        
                    case "maxRadius" :
                        val = parseFloat(xml.maxRadius.@value);
                        mSettings.maxRadius = val;
                        break;
                        
                    case "maxRadiusVar" :
                        val = parseFloat(xml.maxRadiusVariance.@value);
                        mSettings.maxRadiusVar = val;
                        break;
                        
                    case "minRadius" :
                        val = parseFloat(xml.minRadius.@value);
                        mSettings.minRadius = val;
                        break;
                        
                    case "degPerSec" :
                        val = parseFloat(xml.rotatePerSecond.@value);
                        mSettings.degPerSec = val;
                        break; 
                        
                    case "degPerSecVar" :
                        val = parseFloat(xml.rotatePerSecondVariance.@value);
                        mSettings.degPerSecVar = val;
                        break;
                        
                    case "sr" :
                        val = parseFloat(xml.startColor.@red);
                        mSettings.sr = val;
                        break;
                        
                    case "sg" :
                        val = parseFloat(xml.startColor.@green);
                        mSettings.sg = val;
                        break;
                        
                    case "sb" :
                        val = parseFloat(xml.startColor.@blue);
                        mSettings.sb = val;
                        break;
                        
                    case "sa" :
                        val = parseFloat(xml.startColor.@alpha);
                        mSettings.sa = val;
                        break;
                        
                    case "fr" :
                        val = parseFloat(xml.finishColor.@red);
                        mSettings.fr = val;
                        break;
                        
                    case "fg" :
                        val = parseFloat(xml.finishColor.@green);
                        mSettings.fg = val;
                        break
                        
                    case "fb" :
                        val = parseFloat(xml.finishColor.@blue);
                        mSettings.fb = val;
                        break;
                        
                    case "fa" :
                        val = parseFloat(xml.finishColor.@alpha);
                        mSettings.fa = val;
                        break;
                        
                    case "svr" :
                        val = parseFloat(xml.startColorVariance.@red);
                        mSettings.svr = val;
                        break;
                        
                    case "svg" :
                        val = parseFloat(xml.startColorVariance.@green);
                        mSettings.svg = val;
                        break;
                        
                    case "svb" :
                        val = parseFloat(xml.startColorVariance.@blue);
                        mSettings.svb = val;
                        break;
                        
                    case "sva" :
                        val = parseFloat(xml.startColorVariance.@alpha);
                        mSettings.sva = val;
                        break;
                        
                    case "fvr" :
                        val = parseFloat(xml.finishColorVariance.@red);
                        mSettings.fvr = val;
                        break;
                        
                    case "fvg" :
                        val = parseFloat(xml.finishColorVariance.@green);
                        mSettings.fvg = val;
                        break;
                        
                    case "fvb" :
                        val = parseFloat(xml.finishColorVariance.@blue);
                        mSettings.fvb = val;
                        break;
                        
                    case "fva" :
                        val = parseFloat(xml.finishColorVariance.@alpha);
                        mSettings.fva = val;
                        break;
                        
                    case "srcBlend" :
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
                        mSettings.srcBlend = val;
                        (comp as ComboBox).selectedIndex = idx;
                        break;
                        
                    case "dstBlend" :
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
                        mSettings.dstBlend = val;
                        (comp as ComboBox).selectedIndex = idx;
                        break;
                        
                    default :
                        trace("Couldn't update setting for comp named: '" + comp.name + "'");
				}
			}
			xml = null;
		}
	}

}