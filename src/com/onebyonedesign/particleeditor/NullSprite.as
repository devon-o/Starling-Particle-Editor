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
	 * Because the SoulWire SimpleGUI works by modifying the properties of a displa object, 
	 * this class was created to contain all motifiable properties. This is held as a static property of Main.as
	 * @author Devon O.
	 */
	public final class NullSprite extends Sprite
	{
		
		public var xPosVar:Number = 0.0;
		public var yPosVar:Number = 0.0
		public var maxParts:Number = 500;
		public var lifeSpan:Number = 2.0;
		public var lifeSpanVar:Number = 1.9;
		public var startSize:Number = 70.0;
		public var startSizeVar:Number = 49.53;
		public var finishSize:Number = 10.0;
		public var finishSizeVar:Number = 5.0;
		public var emitAngle:Number = 270;
		public var emitAngleVar:Number = 0;
		
		public var stRot:Number = 0;
		public var stRotVar:Number = 0;
		public var endRot:Number = 0;
		public var endRotVar:Number = 0;
		
		public var speed:Number = 100;
		public var speedVar:Number = 30.0;
		public var gravX:Number = 0;
		public var gravY:Number = 0;
		public var tanAcc:Number = 0;
		public var tanAccVar:Number = 0;
		public var radialAcc:Number = 0.0;
		public var radialAccVar:Number = 0.0;
		
		public var emitterType:int = 0;
		
		public var maxRadius:Number = 100;
		public var maxRadiusVar:Number = 0;
		public var minRadius:Number = 0;
		public var degPerSec:Number = 0;
		public var degPerSecVar:Number = 0;
		
		
		// <startColor red="1.00" green="0.31" blue="0.00" alpha="0.62"/>
		public var sr:Number = 1;
		public var sg:Number = .31;
		public var sb:Number = 0;
		public var sa:Number = .62;
		
		// <finishColor red="1.00" green="0.31" blue="0.00" alpha="0.00"/>
		public var fr:Number = 1.0;
		public var fg:Number = .31;
		public var fb:Number = 0;
		public var fa:Number = 0;
		
		public var svr:Number = 0;
		public var svg:Number = 0;
		public var svb:Number = 0;
		public var sva:Number = 0;
		
		public var fvr:Number = 0;
		public var fvg:Number = 0;
		public var fvb:Number = 0;
		public var fva:Number = 0;
		
		public var srcBlend:uint = 0x302;
		public var dstBlend:uint = 0x01;
		
		public var savePlist:Boolean;
		
		public function NullSprite() 
		{}
		
	}

}