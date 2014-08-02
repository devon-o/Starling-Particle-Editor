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
	import flash.display.Sprite;

	/**
	 * Because the SoulWire SimpleGUI works by modifying the properties of a display object, 
	 * this class was created to contain all modifiable properties.
     * SimpleGUI is attached to this and its changes are sent to SettingsListener objects
	 * @author Devon O.
	 */
	public final class SettingsModel extends Sprite
	{
        private var mListeners:Vector.<SettingsListener>;
		
		private var _xPosVar:Number = 0.0;
		private var _yPosVar:Number = 0.0;
		private var _maxParts:Number = 500.0;
		private var _lifeSpan:Number = 2.0;
		private var _lifeSpanVar:Number = 1.9;
		private var _startSize:Number = 70.0;
		private var _startSizeVar:Number = 49.53;
		private var _finishSize:Number = 10.0;
		private var _finishSizeVar:Number = 5.0;
		private var _emitAngle:Number = 270.0;
		private var _emitAngleVar:Number = 0.0;
		
		private var _stRot:Number = 0.0;
		private var _stRotVar:Number = 0.0;
		private var _endRot:Number = 0.0;
		private var _endRotVar:Number = 0.0;
		
		private var _speed:Number = 100;
		private var _speedVar:Number = 30.0;
		private var _gravX:Number = 0.0;
		private var _gravY:Number = 0.0;
		private var _tanAcc:Number = 0.0;
		private var _tanAccVar:Number = 0.0;
		private var _radialAcc:Number = 0.0;
		private var _radialAccVar:Number = 0.0;
		
		private var _emitterType:int = 0;
		
		private var _maxRadius:Number = 100;
		private var _maxRadiusVar:Number = 0.0;
		private var _minRadius:Number = 0.0;
        private var _minRadiusVar:Number = 0.0;
		private var _degPerSec:Number = 0.0;
		private var _degPerSecVar:Number = 0.0;
		
		
		// <startColor red="1.00" green="0.31" blue="0.00" alpha="0.62"/>
		private var _sr:Number = 1.0;
		private var _sg:Number = .31;
		private var _sb:Number = 0.0;
		private var _sa:Number = .62;
		
		// <finishColor red="1.00" green="0.31" blue="0.00" alpha="0.00"/>
		private var _fr:Number = 1.0;
		private var _fg:Number = .31;
		private var _fb:Number = 0.0;
		private var _fa:Number = 0.0;
		
		private var _svr:Number = 0.0;
		private var _svg:Number = 0.0;
		private var _svb:Number = 0.0;
		private var _sva:Number = 0.0;
		
		private var _fvr:Number = 0.0;
		private var _fvg:Number = 0.0;
		private var _fvb:Number = 0.0;
		private var _fva:Number = 0.0;
		
		private var _srcBlend:uint = 0x302;
		private var _dstBlend:uint = 0x01;
		
		private var _savePlist:Boolean = false;
		
		public function SettingsModel() 
		{
            mListeners = new Vector.<SettingsListener>();
        }
        
        public function addListener(listener:SettingsListener):void
        {
            mListeners.push(listener);
        }
        
        public function get xPosVar():Number 
        {
            return _xPosVar;
        }
        
        public function set xPosVar(value:Number):void 
        {
            _xPosVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateXPosVariance(value);
            }
        }
        
        public function get yPosVar():Number 
        {
            return _yPosVar;
        }
        
        public function set yPosVar(value:Number):void 
        {
            _yPosVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateYPosVariance(value);
            }
        }
        
        public function get maxParts():Number 
        {
            return _maxParts;
        }
        
        public function set maxParts(value:Number):void 
        {
            _maxParts = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateMaxParticles(value);
            }
        }
        
        public function get lifeSpan():Number 
        {
            return _lifeSpan;
        }
        
        public function set lifeSpan(value:Number):void 
        {
            _lifeSpan = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateLifeSpan(value);
            }
        }
        
        public function get lifeSpanVar():Number 
        {
            return _lifeSpanVar;
        }
        
        public function set lifeSpanVar(value:Number):void 
        {
            _lifeSpanVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateLifeSpanVariance(value);
            }
        }
        
        public function get startSize():Number 
        {
            return _startSize;
        }
        
        public function set startSize(value:Number):void 
        {
            _startSize = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartSize(value);
            }
        }
        
        public function get startSizeVar():Number 
        {
            return _startSizeVar;
        }
        
        public function set startSizeVar(value:Number):void 
        {
            _startSizeVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartSizeVariance(value);
            }
        }
        
        public function get finishSize():Number 
        {
            return _finishSize;
        }
        
        public function set finishSize(value:Number):void 
        {
            _finishSize = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishSize(value);
            }
        }
        
        public function get finishSizeVar():Number 
        {
            return _finishSizeVar;
        }
        
        public function set finishSizeVar(value:Number):void 
        {
            _finishSizeVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishSizeVariance(value);
            }
        }
        
        public function get emitAngle():Number 
        {
            return _emitAngle;
        }
        
        public function set emitAngle(value:Number):void 
        {
            _emitAngle = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateEmitAngle(value);
            }
        }
        
        public function get emitAngleVar():Number 
        {
            return _emitAngleVar;
        }
        
        public function set emitAngleVar(value:Number):void 
        {
            _emitAngleVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateEmitAngleVariance(value);
            }
        }
        
        public function get stRot():Number 
        {
            return _stRot;
        }
        
        public function set stRot(value:Number):void 
        {
            _stRot = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartRotation(value);
            }
        }
        
        public function get stRotVar():Number 
        {
            return _stRotVar;
        }
        
        public function set stRotVar(value:Number):void 
        {
            _stRotVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartRotationVariance(value);
            }
        }
        
        public function get endRot():Number 
        {
            return _endRot;
        }
        
        public function set endRot(value:Number):void 
        {
            _endRot = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateEndRotation(value);
            }
        }
        
        public function get endRotVar():Number 
        {
            return _endRotVar;
        }
        
        public function set endRotVar(value:Number):void 
        {
            _endRotVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateEndRotationVariance(value);
            }
        }
        
        public function get speed():Number 
        {
            return _speed;
        }
        
        public function set speed(value:Number):void 
        {
            _speed = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateSpeed(value);
            }
        }
        
        public function get speedVar():Number 
        {
            return _speedVar;
        }
        
        public function set speedVar(value:Number):void 
        {
            _speedVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateSpeedVariance(value);
            }
        }
        
        public function get gravX():Number 
        {
            return _gravX;
        }
        
        public function set gravX(value:Number):void 
        {
            _gravX = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateGravityX(value);
            }
        }
        
        public function get gravY():Number 
        {
            return _gravY;
        }
        
        public function set gravY(value:Number):void 
        {
            _gravY = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateGravityY(value);
            }
        }
        
        public function get tanAcc():Number 
        {
            return _tanAcc;
        }
        
        public function set tanAcc(value:Number):void 
        {
            _tanAcc = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateTanAcceleration(value);
            }
        }
        
        public function get tanAccVar():Number 
        {
            return _tanAccVar;
        }
        
        public function set tanAccVar(value:Number):void 
        {
            _tanAccVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateTanAccelerationVariance(value);
            }
        }
        
        public function get radialAcc():Number 
        {
            return _radialAcc;
        }
        
        public function set radialAcc(value:Number):void 
        {
            _radialAcc = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateRadialAcceleration(value);
            }
        }
        
        public function get radialAccVar():Number 
        {
            return _radialAccVar;
        }
        
        public function set radialAccVar(value:Number):void 
        {
            _radialAccVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateRadialAccelerationVariance(value);
            }
        }
        
        public function get emitterType():int 
        {
            return _emitterType;
        }
        
        public function set emitterType(value:int):void 
        {
            _emitterType = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateEmitterType(value);
            }
        }
        
        public function get maxRadius():Number 
        {
            return _maxRadius;
        }
        
        public function set maxRadius(value:Number):void 
        {
            _maxRadius = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateMaxRadius(value);
            }
        }
        
        public function get maxRadiusVar():Number 
        {
            return _maxRadiusVar;
        }
        
        public function set maxRadiusVar(value:Number):void 
        {
            _maxRadiusVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateMaxRadiusVariance(value);
            }
        }
        
        public function get minRadius():Number 
        {
            return _minRadius;
        }
        
        public function set minRadius(value:Number):void 
        {
            _minRadius = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateMinRadius(value);
            }
        }
        
        public function get minRadiusVar():Number
        {
            return _minRadiusVar;
        }
        
        public function set minRadiusVar(value:Number):void
        {
            _minRadiusVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateMinRadiusVariance(value);
            }
        }
        
        public function get degPerSec():Number 
        {
            return _degPerSec;
        }
        
        public function set degPerSec(value:Number):void 
        {
            _degPerSec = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateDegreesPerSecond(value);
            }
        }
        
        public function get degPerSecVar():Number 
        {
            return _degPerSecVar;
        }
        
        public function set degPerSecVar(value:Number):void 
        {
            _degPerSecVar = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateDegreesPerSecondVariance(value);
            }
        }
        
        public function get sr():Number 
        {
            return _sr;
        }
        
        public function set sr(value:Number):void 
        {
            _sr = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartRed(value);
            }
        }
        
        public function get sg():Number 
        {
            return _sg;
        }
        
        public function set sg(value:Number):void 
        {
            _sg = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartGreen(value);
            }
        }
        
        public function get sb():Number 
        {
            return _sb;
        }
        
        public function set sb(value:Number):void 
        {
            _sb = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartBlue(value);
            }
        }
        
        public function get sa():Number 
        {
            return _sa;
        }
        
        public function set sa(value:Number):void 
        {
            _sa = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartAlpha(value);
            }
        }
        
        public function get fr():Number 
        {
            return _fr;
        }
        
        public function set fr(value:Number):void 
        {
            _fr = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishRed(value);
            }
        }
        
        public function get fg():Number 
        {
            return _fg;
        }
        
        public function set fg(value:Number):void 
        {
            _fg = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishGreen(value);
            }
        }
        
        public function get fb():Number 
        {
            return _fb;
        }
        
        public function set fb(value:Number):void 
        {
            _fb = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishBlue(value);
            }
        }
        
        public function get fa():Number 
        {
            return _fa;
        }
        
        public function set fa(value:Number):void 
        {
            _fa = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishAlpha(value);
            }
        }
        
        public function get svr():Number 
        {
            return _svr;
        }
        
        public function set svr(value:Number):void 
        {
            _svr = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartRedVariance(value);
            }
        }
        
        public function get svg():Number 
        {
            return _svg;
        }
        
        public function set svg(value:Number):void 
        {
            _svg = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartGreenVariance(value);
            }
        }
        
        public function get svb():Number 
        {
            return _svb;
        }
        
        public function set svb(value:Number):void 
        {
            _svb = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartBlueVariance(value);
            }
        }
        
        public function get sva():Number 
        {
            return _sva;
        }
        
        public function set sva(value:Number):void 
        {
            _sva = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateStartAlphaVariance(value);
            }
        }
        
        public function get fvr():Number 
        {
            return _fvr;
        }
        
        public function set fvr(value:Number):void 
        {
            _fvr = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishRedVariance(value);
            }
        }
        
        public function get fvg():Number 
        {
            return _fvg;
        }
        
        public function set fvg(value:Number):void 
        {
            _fvg = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishGreenVariance(value);
            }
        }
        
        public function get fvb():Number 
        {
            return _fvb;
        }
        
        public function set fvb(value:Number):void 
        {
            _fvb = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishBlueVariance(value);
            }
        }
        
        public function get fva():Number 
        {
            return _fva;
        }
        
        public function set fva(value:Number):void 
        {
            _fva = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateFinishAlphaVariance(value);
            }
        }
        
        public function get srcBlend():uint 
        {
            return _srcBlend;
        }
        
        public function set srcBlend(value:uint):void 
        {
            _srcBlend = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateSourceBlend(value);
            }
        }
        
        public function get dstBlend():uint 
        {
            return _dstBlend;
        }
        
        public function set dstBlend(value:uint):void 
        {
            _dstBlend = value;
            
            for each(var listener:SettingsListener in mListeners)
            {
                listener.updateDestinationBlend(value);
            }
        }
        
        public function get savePlist():Boolean 
        {
            return _savePlist;
        }
        
        public function set savePlist(value:Boolean):void 
        {
            _savePlist = value;
        }
        
	}

}