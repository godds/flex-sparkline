/*
    SL-Sparkline - Flex implementation of sparkline variations.
    Copyright (C) 2010  Graham Odds (http://www.scottlogic.co.uk/blog/graham/)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.scottlogic.sparkline.sparklineClasses
{
    /**
     * Utility class to maintain values and rendering information for
     * a specific item in the sparkline's data provider.
     */
    public class SparklineItem
    {
        /**
         * Constructor
         */
        public function SparklineItem(item:Object = null)
        {
            this.item = item;
        }

        /**
         * The item in the data provider this sparkline item represents.
         */
        public var item:Object;

        private var _xValue:Object;
        /**
         * The x value of this item.
         */
        public function get xValue():Object
        {
            return _xValue;
        }
        /**
         * @private
         */
        public function set xValue(value:Object):void
        {
            _xValue = value;
            xNumber = getAsNumber(_xValue);
        }

        /**
         * The x value of this item as a number.
         */
        public var xNumber:Number;

        /**
         * The x screen coordinate of this item.
         */
        public var x:Number;

        private var _yValue:Object;
        /**
         * The y value of this item.
         */
        public function get yValue():Object
        {
            return _yValue;
        }
        /**
         * @private
         */
        public function set yValue(value:Object):void
        {
            _yValue = value;
            yNumber = getAsNumber(_yValue);
        }

        /**
         * The y value of this item as a number.
         */
        public var yNumber:Number;

        /**
         * The y screen coordinate of this item.
         */
        public var y:Number;

        /**
         * Attempts to get the specified object as a Number.
         */
        private function getAsNumber(obj:Object):Number
        {
            if (obj is Number || obj is int || obj is uint)
                return Number(obj);
            if (obj is Date)
                return (obj as Date).millisecondsUTC;
            if (!obj || obj == "")
                return NaN;
            return parseFloat(obj.toString());
        }
    }
}