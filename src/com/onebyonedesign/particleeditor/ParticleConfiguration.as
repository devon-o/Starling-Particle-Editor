/**
 *	Copyright (c) 2014 Devon O. Wolfgang
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
	/**
     * Holds and updates the XML Config for the given particle
     * @author Devon O.
     */
    public class ParticleConfiguration implements SettingsListener
    {
        
        /** Particle configuration (.pex) */
        private var mConfig:XML;
        
        public function ParticleConfiguration(initialConfig:XML) 
        {
            mConfig = initialConfig;
        }
        
        /** Randomize all particle settings */
        public function randomize():void
        {
            var randSetting:Number;
            
            randSetting = randRange(1000, 1, 2);
            mConfig..maxParticles.@value = String(randSetting);
            
            randSetting = randRange(10, 0, 2);
            mConfig..particleLifeSpan.@value = String(randSetting);
            
            randSetting = randRange(10, 0, 2);
            mConfig..particleLifespanVariance.@value = String(randSetting);

            randSetting = randRange(70, 0, 2);
            mConfig..startParticleSize.@value = String(randSetting);
   
            randSetting = randRange(70, 0, 2);
            mConfig..startParticleSizeVariance.@value = String(randSetting);
            
            randSetting = randRange(70, 0, 2);
            mConfig..finishParticleSize.@value = String(randSetting);
            
            randSetting = randRange(70, 0, 2);
            mConfig..FinishParticleSizeVariance.@value = String(randSetting);
            
            randSetting = randRange(360, 0, 2);
            mConfig..angle.@value = String(randSetting);
            
            randSetting = randRange(360, 0, 2);
            mConfig..angleVariance.@value = String(randSetting);
            
            randSetting = randRange(360, 0, 2);
            mConfig..rotationStart.@value = String(randSetting);
            
            randSetting = randRange(360, 0, 2);
            mConfig..rotationStartVariance.@value = String(randSetting);
            
            randSetting = randRange(360, 0, 2);
            mConfig..rotationEnd.@value = String(randSetting);
            
            randSetting = randRange(360, 0, 2);
            mConfig..rotationEndVariance.@value = String(randSetting);
            
            randSetting = randRange(1000, 0, 2);
            mConfig..sourcePositionVariance.@x = String(randSetting);

            randSetting = randRange(1000, 0, 2);
            mConfig..sourcePositionVariance.@y = String(randSetting);
            
            randSetting = randRange(500, 0, 2);
            mConfig..speed.@value = String(randSetting);
            
            randSetting = randRange(500, 0, 2);
            mConfig..speedVariance.@value = String(randSetting);
            
            randSetting = randRange(500, -500, 2);
            mConfig..gravity.@x = String(randSetting);
            
            randSetting = randRange(500, -500, 2);
            mConfig..gravity.@y = String(randSetting);
            
            randSetting = randRange(500, -500, 2);
            mConfig..tangentialAcceleration.@value = String(randSetting);
            
            randSetting = randRange(500, 0, 2);
            mConfig..tangentialAccelVariance.@value = String(randSetting);
            
            randSetting = randRange(500, -500, 2);
            mConfig..radialAcceleration.@value = String(randSetting);
            
            randSetting = randRange(500, 0, 2);
            mConfig..radialAccelVariance.@value = String(randSetting);
            
            randSetting = randRange(500, 0, 2);
            mConfig..maxRadius.@value = String(randSetting);
            
            randSetting = randRange(500, 0, 2);
            mConfig..maxRadiusVariance.@value = String(randSetting);
            
            randSetting = randRange(500, 0, 2);
            mConfig..minRadius.@value = String(randSetting);
            
            randSetting = randRange(360, -360, 2);
            mConfig..rotatePerSecond.@value = String(randSetting);
            
            randSetting = randRange(360, 0, 2);
            mConfig..rotatePerSecondVariance.@value = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..startColor.@red = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..startColor.@green = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..startColor.@blue = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..startColor.@alpha = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..finishColor.@red = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..finishColor.@green = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..finishColor.@blue = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..finishColor.@alpha = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..startColorVariance.@red = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..startColorVariance.@green = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..startColorVariance.@blue = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..startColorVariance.@alpha = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..finishColorVariance.@red = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..finishColorVariance.@green = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..finishColorVariance.@blue = String(randSetting);
            
            randSetting = randRange(1, 0, 2);
            mConfig..finishColorVariance.@alpha = String(randSetting);
        }
        
         /* INTERFACE com.onebyonedesign.particleeditor.SettingsListener */
        
        public function updateXPosVariance(value:Number):void 
        {
            mConfig.sourcePositionVariance.@x = value;
        }
        
        public function updateYPosVariance(value:Number):void 
        {
            mConfig.sourcePositionVariance.@y = value;
        }
        
        public function updateMaxParticles(value:Number):void 
        {
            mConfig.maxParticles.@value = value;
        }
        
        public function updateLifeSpan(value:Number):void 
        {
            mConfig.particleLifeSpan.@value = value;
        }
        
        public function updateLifeSpanVariance(value:Number):void 
        {
            mConfig.particleLifespanVariance.@value = value;
        }
        
        public function updateStartSize(value:Number):void 
        {
            mConfig.startParticleSize.@value = value;
        }
        
        public function updateStartSizeVariance(value:Number):void 
        {
            mConfig.startParticleSizeVariance.@value = value;
        }
        
        public function updateFinishSize(value:Number):void 
        {
            mConfig.finishParticleSize.@value = value;
        }
        
        public function updateFinishSizeVariance(value:Number):void 
        {
            mConfig.FinishParticleSizeVariance.@value = value;
        }
        
        public function updateEmitAngle(value:Number):void 
        {
            mConfig.angle.@value = value;
        }
        
        public function updateEmitAngleVariance(value:Number):void 
        {
            mConfig.angleVariance.@value = value;
        }
        
        public function updateStartRotation(value:Number):void 
        {
            mConfig.rotationStart.@value = value;
        }
        
        public function updateStartRotationVariance(value:Number):void 
        {
            mConfig.rotationStartVariance.@value = value;
        }
        
        public function updateEndRotation(value:Number):void 
        {
            mConfig.rotationEnd.@value = value;
        }
        
        public function updateEndRotationVariance(value:Number):void 
        {
            mConfig.rotationEndVariance.@value = value;
        }
        
        public function updateSpeed(value:Number):void 
        {
            mConfig.speed.@value = value;
        }
        
        public function updateSpeedVariance(value:Number):void 
        {
            mConfig.speedVariance.@value = value;
        }
        
        public function updateGravityX(value:Number):void 
        {
            mConfig.gravity.@x = value;
        }
        
        public function updateGravityY(value:Number):void 
        {
            mConfig.gravity.@y = value;
        }
        
        public function updateTanAcceleration(value:Number):void 
        {
            mConfig.tangentialAcceleration.@value = value;
        }
        
        public function updateTanAccelerationVariance(value:Number):void 
        {
            mConfig.tangentialAccelVariance.@value = value;
        }
        
        public function updateRadialAcceleration(value:Number):void 
        {
            mConfig.radialAcceleration.@value = value;
        }
        
        public function updateRadialAccelerationVariance(value:Number):void 
        {
            mConfig.radialAccelVariance.@value = value;
        }
        
        public function updateEmitterType(value:int):void 
        {
            mConfig.emitterType.@value = value;
        }
        
        public function updateMaxRadius(value:Number):void 
        {
            mConfig.maxRadius.@value = value;
        }
        
        public function updateMaxRadiusVariance(value:Number):void 
        {
            mConfig.maxRadiusVariance.@value = value;
        }
        
        public function updateMinRadius(value:Number):void 
        {
            mConfig.minRadius.@value = value;
        }
        
        public function updateMinRadiusVariance(value:Number):void
        {
            mConfig.minRadiusVariance.@value = value;
        }
        
        public function updateDegreesPerSecond(value:Number):void 
        {
            mConfig.rotatePerSecond.@value = value;
        }
        
        public function updateDegreesPerSecondVariance(value:Number):void 
        {
            mConfig.rotatePerSecondVariance.@value = value;
        }
        
        public function updateStartRed(value:Number):void 
        {
            mConfig.startColor.@red = value;
        }
        
        public function updateStartGreen(value:Number):void 
        {
            mConfig.startColor.@green = value;
        }
        
        public function updateStartBlue(value:Number):void 
        {
            mConfig.startColor.@blue = value;
        }
        
        public function updateStartAlpha(value:Number):void 
        {
            mConfig.startColor.@alpha = value;
        }
        
        public function updateFinishRed(value:Number):void 
        {
            mConfig.finishColor.@red = value;
        }
        
        public function updateFinishGreen(value:Number):void 
        {
            mConfig.finishColor.@green = value;
        }
        
        public function updateFinishBlue(value:Number):void 
        {
            mConfig.finishColor.@blue = value;
        }
        
        public function updateFinishAlpha(value:Number):void 
        {
            mConfig.finishColor.@alpha = value;
        }
        
        public function updateStartRedVariance(value:Number):void 
        {
            mConfig.startColorVariance.@red = value;
        }
        
        public function updateStartGreenVariance(value:Number):void 
        {
            mConfig.startColorVariance.@green = value;
        }
        
        public function updateStartBlueVariance(value:Number):void 
        {
            mConfig.startColorVariance.@blue = value;
        }
        
        public function updateStartAlphaVariance(value:Number):void 
        {
            mConfig.startColorVariance.@alpha = value;
        }
        
        public function updateFinishRedVariance(value:Number):void 
        {
            mConfig.finishColorVariance.@red = value;
        }
        
        public function updateFinishGreenVariance(value:Number):void 
        {
            mConfig.finishColorVariance.@green = value;
        }
        
        public function updateFinishBlueVariance(value:Number):void 
        {
            mConfig.finishColorVariance.@blue = value;
        }
        
        public function updateFinishAlphaVariance(value:Number):void 
        {
            mConfig.finishColorVariance.@alpha = value;
        }
        
        public function updateSourceBlend(value:uint):void 
        {
            mConfig.blendFuncSource.@value = value;
        }
        
        public function updateDestinationBlend(value:uint):void 
        {
            mConfig.blendFuncDestination.@value = value;
        }
        
        public function get xml():XML
        {
            return mConfig;
        }
        
        /** Create a random number between min and max with decimals decimal places */
		private function randRange(max:Number, min:Number = 0, decimals:int = 0):Number {
			if (min > max) return NaN;
			var rand:Number = Math.random() * (max - min) + min;
			var d:Number = Math.pow(10, decimals);
			return ~~((d * rand) + 0.5) / d;
		}
    }

}