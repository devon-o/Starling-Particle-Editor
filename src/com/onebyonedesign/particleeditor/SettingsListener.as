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
    
    public interface SettingsListener 
    {
        function updateXPosVariance(value:Number):void;
        function updateYPosVariance(value:Number):void;
        function updateMaxParticles(value:Number):void;
        function updateLifeSpan(value:Number):void;
        function updateLifeSpanVariance(value:Number):void;
        function updateStartSize(value:Number):void;
        function updateStartSizeVariance(value:Number):void;
        function updateFinishSize(value:Number):void;
        function updateFinishSizeVariance(value:Number):void;
        function updateEmitAngle(value:Number):void;
        function updateEmitAngleVariance(value:Number):void;
		
        function updateStartRotation(value:Number):void;
        function updateStartRotationVariance(value:Number):void;
        function updateEndRotation(value:Number):void;
        function updateEndRotationVariance(value:Number):void;
		
        function updateSpeed(value:Number):void;
        function updateSpeedVariance(value:Number):void;
        function updateGravityX(value:Number):void;
        function updateGravityY(value:Number):void;
        function updateTanAcceleration(value:Number):void;
        function updateTanAccelerationVariance(value:Number):void;
        function updateRadialAcceleration(value:Number):void;
        function updateRadialAccelerationVariance(value:Number):void;
		
        function updateEmitterType(value:int):void;
		
        function updateMaxRadius(value:Number):void;
        function updateMaxRadiusVariance(value:Number):void;
        function updateMinRadius(value:Number):void;
        function updateMinRadiusVariance(value:Number):void;
        function updateDegreesPerSecond(value:Number):void;
        function updateDegreesPerSecondVariance(value:Number):void;
		
        function updateStartRed(value:Number):void;
        function updateStartGreen(value:Number):void;
        function updateStartBlue(value:Number):void;
        function updateStartAlpha(value:Number):void;
		
        function updateFinishRed(value:Number):void;
        function updateFinishGreen(value:Number):void;
        function updateFinishBlue(value:Number):void;
        function updateFinishAlpha(value:Number):void;
		
        function updateStartRedVariance(value:Number):void;
        function updateStartGreenVariance(value:Number):void;
        function updateStartBlueVariance(value:Number):void;
        function updateStartAlphaVariance(value:Number):void;
        
        function updateFinishRedVariance(value:Number):void;
        function updateFinishGreenVariance(value:Number):void;
        function updateFinishBlueVariance(value:Number):void;
        function updateFinishAlphaVariance(value:Number):void;
		
        function updateSourceBlend(value:uint):void;
        function updateDestinationBlend(value:uint):void;
    }
    
}