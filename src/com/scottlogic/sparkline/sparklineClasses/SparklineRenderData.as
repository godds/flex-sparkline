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
     * Represents all the information required by a Sparkline
     * in order to render.
     */
    public class SparklineRenderData
    {
        /**
         * Constructor
         */
        public function SparklineRenderData()
        {
            xMin.xNumber = Number.POSITIVE_INFINITY;
            xMax.xNumber = Number.NEGATIVE_INFINITY;
            yMin.yNumber = Number.POSITIVE_INFINITY;
            yMax.yNumber = Number.NEGATIVE_INFINITY;
        }

        /**
         * The render data for each item representing a value
         * in the sparkline's data provider.
         */
        public var cache:Array /* of SparklineItem */ = [];

        /**
         * The item that has the minimum x value in the
         * sparkline's data provider.
         */
        public var xMin:SparklineItem = new SparklineItem();

        /**
         * The item that has the maximum x value in the
         * sparkline's data provider.
         */
        public var xMax:SparklineItem = new SparklineItem();

        /**
         * The item that has the minimum y value in the
         * sparkline's data provider.
         */
        public var yMin:SparklineItem = new SparklineItem();

        /**
         * The item that has the maximum y value in the
         * sparkline's data provider.
         */
        public var yMax:SparklineItem = new SparklineItem();

        /**
         * A sparkline item representing the minimum position
         * of the normal range for the sparkline.
         */
        public var normalRangeMin:SparklineItem;

        /**
         * A sparkline item representing the maximum position
         * of the normal range for the sparkline.
         */
        public var normalRangeMax:SparklineItem;

        /**
         * The number of sparkline items that are to be rendered.
         */
        public function get length():uint
        {
            return cache ? cache.length : 0;
        }
    }
}