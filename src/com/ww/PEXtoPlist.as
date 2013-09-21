/**
 *	Copyright (c) 2013 Devon O. Wolfgang, Jack Ront
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

package com.ww 
{
	/**
	 * Converts an xml string into a plist string. 
	 * Primarily the work of Jack Ront of allplaynowork.com
	 * 
	 * @author Devon O.
	 * @author Jack Ront
	 */
	
	public class PEXtoPlist 
	{
		
		public function PEXtoPlist() 
		{}
		
		/**
		 * Creates a plist from the passed xml string
		 * @param	$pexData	XML String of .pex file
		 * @return
		 */
		public static function createPlist($pexData:String):String
		{
			var pexXML:XML = new XML($pexData);
			var plistXML:XML = getBlankPlist();
			var dictXML:XML = XML(plistXML.dict);
			
			// Do conversions.
			convertToInteger(dictXML, "maxParticles", pexXML);
			
			// Angle.
			convertToNumber(dictXML, "angle", pexXML);
			convertToNumber(dictXML, "angleVariance", pexXML);
			
			// Duration.
			convertToNumber(dictXML, "duration", pexXML);
			
			// Blend func.
			convertToInteger(dictXML, "blendFuncSource", pexXML);
			convertToInteger(dictXML, "blendFuncDestination", pexXML);
			
			// Colours.
			convertToNumber(dictXML, "startColorRed", pexXML, "startColor", "red");
			convertToNumber(dictXML, "startColorGreen", pexXML, "startColor", "green");
			convertToNumber(dictXML, "startColorBlue", pexXML, "startColor", "blue");
			convertToNumber(dictXML, "startColorAlpha", pexXML, "startColor", "alpha");
			
			convertToNumber(dictXML, "startColorVarianceRed", pexXML, "red", "startColorVariance");
			convertToNumber(dictXML, "startColorVarianceGreen", pexXML, "green", "startColorVariance");
			convertToNumber(dictXML, "startColorVarianceBlue", pexXML, "blue", "startColorVariance");
			convertToNumber(dictXML, "startColorVarianceAlpha", pexXML, "alpha", "startColorVariance");
			
			convertToNumber(dictXML, "finishColorRed", pexXML, "finishColor", "red");
			convertToNumber(dictXML, "finishColorGreen", pexXML, "finishColor", "green");
			convertToNumber(dictXML, "finishColorBlue", pexXML, "finishColor", "blue");
			convertToNumber(dictXML, "finishColorAlpha", pexXML, "finishColor", "alpha");
			
			convertToNumber(dictXML, "finishColorVarianceRed", pexXML, "finishColorVariance", "red");
			convertToNumber(dictXML, "finishColorVarianceGreen", pexXML, "finishColorVariance", "green");
			convertToNumber(dictXML, "finishColorVarianceBlue", pexXML, "finishColorVariance", "blue");
			convertToNumber(dictXML, "finishColorVarianceAlpha", pexXML, "finishColorVariance", "alpha");
			
			// Particle size.
			convertToNumber(dictXML, "startParticleSize", pexXML);
			convertToNumber(dictXML, "startParticleSizeVariance", pexXML);
			convertToNumber(dictXML, "finishParticleSize", pexXML);
			convertToNumber(dictXML, "finishParticleSizeVariance", pexXML, "FinishParticleSizeVariance");
			
			//Position.
			convertToNumber(dictXML, "sourcePositionx", pexXML, "sourcePosition", "x");
			convertToNumber(dictXML, "sourcePositiony", pexXML, "sourcePosition", "y");
			convertToNumber(dictXML, "sourcePositionVariancex", pexXML, "sourcePositionVariance", "x");
			convertToNumber(dictXML, "sourcePositionVariancey", pexXML, "sourcePositionVariance", "y");
			
			// Spinning.
			convertToNumber(dictXML, "rotationStart", pexXML);
			convertToNumber(dictXML, "rotationStartVariance", pexXML);
			convertToNumber(dictXML, "rotationEnd", pexXML);
			convertToNumber(dictXML, "rotationEndVariance", pexXML);
			
			// Emitter mode.
			convertToInteger(dictXML, "emitterType", pexXML);
			
			///// Mode A: Gravity + tangential accel + radial accel.
			
			// Gravity.
			convertToNumber(dictXML, "gravityx", pexXML, "gravity", "x");
			convertToNumber(dictXML, "gravityy", pexXML, "gravity", "y");
			
			// Speed.
			convertToNumber(dictXML, "speed", pexXML);
			convertToNumber(dictXML, "speedVariance", pexXML);
			
			// Radial acceleration.
			convertToNumber(dictXML, "radialAcceleration", pexXML);
			convertToNumber(dictXML, "radialAccelVariance", pexXML);
			
			// Tangential acceleration.
			convertToNumber(dictXML, "tangentialAcceleration", pexXML);
			convertToNumber(dictXML, "tangentialAccelVariance", pexXML);

			///// Mode B: radius movement.
			
			//Radius.
			convertToNumber(dictXML, "maxRadius", pexXML);
			convertToNumber(dictXML, "maxRadiusVariance", pexXML);
			convertToNumber(dictXML, "minRadius", pexXML);
			
			// Rotations per second.
			convertToNumber(dictXML, "rotatePerSecond", pexXML);
			convertToNumber(dictXML, "rotatePerSecondVariance", pexXML);
			
			///// End of mode specific params.
			
			// Life span.
			convertToNumber(dictXML, "particleLifeSpan", pexXML);
			convertToNumber(dictXML, "particleLifespanVariance", pexXML);
			
			// Texture.
			convertToString(dictXML, "textureFileName", pexXML, "texture", "name");
			
			
			// Print plist.
			return getExportXML(plistXML);
		}
		
		private static function getBlankPlist():XML {
			return new XML('<plist version="1.0"><dict></dict></plist>');
		}
		
		private static function getExportXML($xml:XML):String {
			var str:String;
			
			str = '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">\n';
			str += $xml.toXMLString();
			
			str = str.replace("        ", "\t");
			
			return str;
		}
		
		private static function extractValue($pex:XML, $plistKey:String, $pexChildName:String, $pexAttributeKey:String):String {
			var str:String;
			
			if(!$pexAttributeKey) {
				$pexAttributeKey = "value";
			}
			
			if(!$pexChildName) {
				$pexChildName = $plistKey;
			}
			
			str = $pex[$pexChildName].attribute($pexAttributeKey);
			
			return str;
		}
		
		private static function convertToNumber($plist:XML, $plistKey:String, $pex:XML, $pexChildName:String = null, $pexAttributeKey:String = null, $mult:Number = 1):void {
//			trace("convertToNumber(" + $plistKey + ", " + $pexAttributeKey + ", " + $pexChildName + ")");
			var str:String = extractValue($pex, $plistKey, $pexChildName, $pexAttributeKey);
			var value:Number = Number(str) * $mult;
			
//			trace(" --- '" + str + "'" + ($mult != 1 ? " x " + $mult : "") + " => " + value);

			$plist.appendChild(new XML("<key>" + $plistKey + "</key>"));
			$plist.appendChild(new XML("<real>" + value + "</real>"));
		}
		
		private static function convertToInteger($plist:XML, $plistKey:String, $pex:XML, $pexChildName:String = null, $pexAttributeKey:String = null, $mult:Number = 1):void {
//			trace("convertToInteger(" + $plistKey + ", " + $pexAttributeKey + ", " + $pexChildName + ")");
			var str:String = extractValue($pex, $plistKey, $pexChildName, $pexAttributeKey);
			var value:int = int(str) * $mult;
			
//			trace(" --- '" + str + "'" + ($mult != 1 ? " x " + $mult : "") + " => " + value);

			$plist.appendChild(new XML("<key>" + $plistKey + "</key>"));
			$plist.appendChild(new XML("<integer>" + value + "</integer>"));
		}
		
		private static function convertToString($plist:XML, $plistKey:String, $pex:XML, $pexChildName:String = null, $pexAttributeKey:String = null):void {
//			trace("convertToString(" + $plistKey + ", " + $pexAttributeKey + ", " + $pexChildName + ")");
			var str:String = extractValue($pex, $plistKey, $pexChildName, $pexAttributeKey);
			
//			trace(" --- '" + str + "'");

			$plist.appendChild(new XML("<key>" + $plistKey + "</key>"));
			$plist.appendChild(new XML("<string>" + str + "</string>"));
		}
	}

}