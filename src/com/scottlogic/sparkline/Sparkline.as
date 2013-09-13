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
package com.scottlogic.sparkline
{
    import com.scottlogic.sparkline.sparklineClasses.SparklineBase;
    import com.scottlogic.sparkline.sparklineClasses.SparklineItem;
    import com.scottlogic.sparkline.sparklineClasses.SparklineRenderData;

    import flash.display.Graphics;
    import flash.geom.Rectangle;

    import mx.core.IFlexModuleFactory;
    import mx.graphics.IFill;
    import mx.graphics.IStroke;
    import mx.graphics.SolidColor;
    import mx.graphics.SolidColorStroke;
    import mx.styles.CSSStyleDeclaration;

    /**
     * Sets the stroke for the actual line.
     * The default colour for a sparkline is grey (<code>0x828282</code>).
     * The default value for the width is 1.
     */
    [Style(name="lineStroke", type="mx.graphics.IStroke", inherit="no")]

    /**
     * Sets the fill for the x-axis minimum, x-axis maximum, y-axis
     * minimum and y-axis maximum markers.  Note that this will be
     * overridden by any values set for xMinFill, xMaxFill, yMinFill
     * and yMaxFill.
     * The default colour for a marker is blue (<code>0x2963a3</code>).
     */
    [Style(name="markerFill", type="mx.graphics.IFill", inherit="no")]

    /**
     * Sets the radius for the x-axis minimum, x-axis maximum, y-axis
     * minimum and y-axis maximum markers.  Note that this will be
     * overridden by any values set for xMinRadius, xMaxRadius,
     * yMinRadius and yMaxRadius.
     * @default 2
     */
    [Style(name="markerRadius", type="Number", format="Length", inherit="no")]

    /**
     * Sets the stroke for the x-axis minimum, x-axis maximum, y-axis
     * minimum and y-axis maximum markers.  Note that this will be
     * overridden by any values set for xMinStroke, xMaxStroke,
     * yMinStroke and yMaxStroke.
     * The default stroke used for a marker is none.
     */
    [Style(name="markerStroke", type="mx.graphics.IStroke", inherit="no")]

    /**
     * Sets the fill for the normal range.
     * The default fill is semi-transparent black, i.e. grey.
     */
    [Style(name="normalRangeFill", type="mx.graphics.IFill", inherit="no")]

    /**
     * Sets the fill for the x-axis maximum marker.
     * No default, i.e. the marker fill is used.
     */
    [Style(name="xMaxFill", type="mx.graphics.IFill", inherit="no")]

    /**
     * Sets the radius for the x-axis maximum marker.
     * No default, i.e. the marker radius is used.
     */
    [Style(name="xMaxRadius", type="Number", format="Length", inherit="no")]

    /**
     * Sets the stroke for the x-axis maximum stroke.
     * No default, i.e. the marker stroke is used.
     */
    [Style(name="xMaxStroke", type="mx.graphics.IStroke", inherit="no")]

    /**
     * Sets the fill for the x-axis minimum marker.
     * No default, i.e. the marker fill is used.
     */
    [Style(name="xMinFill", type="mx.graphics.IFill", inherit="no")]

    /**
     * Sets the radius for the x-axis minimum marker.
     * No default, i.e. the marker radius is used.
     */
    [Style(name="xMinRadius", type="Number", format="Length", inherit="no")]

    /**
     * Sets the stroke for the x-axis minimum marker.
     * No default, i.e. the marker stroke is used.
     */
    [Style(name="xMinStroke", type="mx.graphics.IStroke", inherit="no")]

    /**
     * Sets the fill for the y-axis maximum marker.
     * No default, i.e. the marker fill is used.
     */
    [Style(name="yMaxFill", type="mx.graphics.IFill", inherit="no")]

    /**
     * Sets the radius for the y-axis maximum marker.
     * No default, i.e. the marker radius is used.
     */
    [Style(name="yMaxRadius", type="Number", format="Length", inherit="no")]

    /**
     * Sets the stroke for the y-axis maximum marker.
     * No default, i.e. the marker stroke is used.
     */
    [Style(name="yMaxStroke", type="mx.graphics.IStroke", inherit="no")]

    /**
     * Sets the fill for the y-axis minimum marker.
     * No default, i.e. the marker fill is used.
     */
    [Style(name="yMinFill", type="mx.graphics.IFill", inherit="no")]

    /**
     * Sets the radius for the y-axis minimum marker.
     * No default, i.e. the marker radius is used.
     */
    [Style(name="yMinRadius", type="Number", format="Length", inherit="no")]

    /**
     * Sets the stroke for the y-axis minimum marker.
     * No default, i.e. the marker stroke is used.
     */
    [Style(name="yMinStroke", type="mx.graphics.IStroke", inherit="no")]

    /**
     * Sparklines are a small, intense, simple dataword devised by
     * Edward Tufte and first presented in his book entitled
     * <i>Beautiful Evidence</i>.  They present a trend line without
     * scale, optionally with markers for the first, last, minimum
     * and maximum values.  For further information, please read
     * http://www.edwardtufte.com/bboard/q-and-a-fetch-msg?msg_id=0001OR.
     *
     * <p>The <code>Sparkline</code> class implements the <code>IListItemRenderer</code>
     * and <code>IDropInListItemRenderer</code>, thereby allowing it to be
     * used as an item renderer in a list control or a data grid.  The class
     * also supports standalone instances.
     */
    public class Sparkline extends SparklineBase
    {
        //------------------------------------
        //
        //          Class Variables
        //
        //------------------------------------

        /**
         * A cache of the data required for rendering the sparkline, i.e. with
         * the data values appropriately mapped to screen coordinates.
         */
        private var renderData:SparklineRenderData;

        /**
         * @private
         */
        private var _moduleFactoryInitialized:Boolean;


        //------------------------------------
        //
        //          Constructor
        //
        //------------------------------------

        /**
         * Constructor
         */
        public function Sparkline()
        {
            super();
        }


        //------------------------------------
        //
        //        Overridden Properties
        //
        //------------------------------------

        //----------------------------------
        //  moduleFactory
        //----------------------------------

        /**
         * @private
         */
        public override function set moduleFactory(factory:IFlexModuleFactory):void
        {
            super.moduleFactory = factory;
            if (_moduleFactoryInitialized)
                return;
            _moduleFactoryInitialized = true;
            initStyles();
        }


        //------------------------------------
        //
        //          Properties
        //
        //------------------------------------

        //----------------------------------
        //  normalRange
        //----------------------------------

        /**
         * Storage for the normalRange property.
         */
        private var _normalRange:Array;

        [Inspectable(category="General")]

        /**
         * Specifies the normal range of values on the y-axis.
         * Specified as an <code>Array</code> of two values:
         * the minimum value and the maximum value.  When
         * <code>null</code> is set, no normal range is drawn.
         *
         * @default null
         */
        public function get normalRange():Array
        {
            return _normalRange;
        }
        /**
         * @private
         */
        public function set normalRange(value:Array):void
        {
            _normalRange = value;
            invalidateData();
        }

        //----------------------------------
        //  xMinMarkerEnabled
        //----------------------------------

        /**
         * Storage for the xMinMarkerEnabled property.
         */
        private var _xMinMarkerEnabled:Boolean = false;

        [Inspectable(category="General")]

        /**
         * Indicates whether the x-axis minimum marker is visible.  Note
         * that this value will be overridden when <code>markersEnabled</code>
         * is set to false.
         *
         * @default false
         */
        public function get xMinMarkerEnabled():Boolean
        {
            return _xMinMarkerEnabled;
        }
        /**
         * @private
         */
        public function set xMinMarkerEnabled(value:Boolean):void
        {
            _xMinMarkerEnabled = value;
            invalidateDisplayList();
        }

        //----------------------------------
        //  xMaxMarkerEnabled
        //----------------------------------

        /**
         * Storage for the xMaxMarkerEnabled property.
         */
        private var _xMaxMarkerEnabled:Boolean = false;

        [Inspectable(category="General")]

        /**
         * Indicates whether the x-axis maximum marker is visible.  Note
         * that this value will be overridden when <code>markersEnabled</code>
         * is set to false.
         *
         * @default true
         */
        public function get xMaxMarkerEnabled():Boolean
        {
            return _xMaxMarkerEnabled;
        }
        /**
         * @private
         */
        public function set xMaxMarkerEnabled(value:Boolean):void
        {
            _xMaxMarkerEnabled = value;
            invalidateDisplayList();
        }

        //----------------------------------
        //  yMinMarkerEnabled
        //----------------------------------

        /**
         * Storage for the yMinMarkerEnabled property.
         */
        private var _yMinMarkerEnabled:Boolean = false;

        [Inspectable(category="General")]

        /**
         * Indicates whether the y-axis minimum marker is visible.  Note
         * that this value will be overridden when <code>markersEnabled</code>
         * is set to false.
         *
         * @default true
         */
        public function get yMinMarkerEnabled():Boolean
        {
            return _yMinMarkerEnabled;
        }
        /**
         * @private
         */
        public function set yMinMarkerEnabled(value:Boolean):void
        {
            _yMinMarkerEnabled = value;
            invalidateDisplayList();
        }

        //----------------------------------
        //  yMaxMarkerEnabled
        //----------------------------------

        /**
         * Storage for the yMaxMarkerEnabled property.
         */
        private var _yMaxMarkerEnabled:Boolean = false;

        [Inspectable(category="General")]

        /**
         * Indicates whether the y-axis maximum marker is visible.  Note
         * that this value will be overridden when <code>markersEnabled</code>
         * is set to false.
         *
         * @default true
         */
        public function get yMaxMarkerEnabled():Boolean
        {
            return _yMaxMarkerEnabled;
        }
        /**
         * @private
         */
        public function set yMaxMarkerEnabled(value:Boolean):void
        {
            _yMaxMarkerEnabled = value;
            invalidateDisplayList();
        }


        //------------------------------------
        //
        //       Overidden Functions
        //
        //------------------------------------

        /**
         * @private
         */
        protected override function updateDisplayList(unscaledWidth:Number,
                                                      unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (!renderData || renderData.length == 0)
            {
                return;
            }

            drawNormalRange(unscaledWidth,
                            renderData.normalRangeMin,
                            renderData.normalRangeMax);
            drawLine(renderData.cache);
            drawMarkers(renderData);
        }

        /**
         * Ensures the bounds are up to date.
         */
        protected override function updateBounds(width:Number, height:Number):void
        {
            var left:Number = getStyle("paddingLeft");
            var right:Number = getStyle("paddingRight");
            var top:Number = getStyle("paddingTop");
            var bottom:Number = getStyle("paddingBottom");

            if (xMinMarkerEnabled)
            {
                var xMinRadius:Number = getStyle("xMinRadius");
                if (!xMinRadius)
                    xMinRadius = getStyle("markerRadius");
                left += xMinRadius / 2;
                var xMinStroke:IStroke = getStyle("xMinStroke");
                if (!xMinStroke)
                    xMinStroke = getStyle("markerStroke");
                if (xMinStroke)
                    left += xMinStroke.weight;
            }
            if (xMaxMarkerEnabled)
            {
                var xMaxRadius:Number = getStyle("xMaxRadius");
                if (!xMaxRadius)
                    xMaxRadius = getStyle("markerRadius");
                right += xMaxRadius / 2;
                var xMaxStroke:IStroke = getStyle("xMaxStroke");
                if (!xMaxStroke)
                    xMaxStroke = getStyle("markerStroke");
                if (xMaxStroke)
                    right += xMaxStroke.weight;
            }
            if (yMinMarkerEnabled)
            {
                var yMinRadius:Number = getStyle("yMinRadius");
                if (!yMinRadius)
                    yMinRadius = getStyle("markerRadius");
                bottom += yMinRadius / 2;
                var yMinStroke:IStroke = getStyle("yMinStroke");
                if (!yMinStroke)
                    yMinStroke = getStyle("markerStroke");
                if (yMinStroke)
                    bottom += yMinStroke.weight;
            }
            if (yMaxMarkerEnabled)
            {
                var yMaxRadius:Number = getStyle("yMaxRadius");
                if (!yMaxRadius)
                    yMaxRadius = getStyle("markerRadius");
                top += yMaxRadius / 2;
                var yMaxStroke:IStroke = getStyle("yMaxStroke");
                if (!yMaxStroke)
                    yMaxStroke = getStyle("markerStroke");
                if (yMaxStroke)
                    top += yMaxStroke.weight;
            }

            bounds = new Rectangle(left,
                                   top,
                                   width - (left + right),
                                   height - (top + bottom));
        }

        /**
         * Updates the render data cache to reflect the current data
         * provider values.  Maps the data provider values to screen
         * coordinates.
         */
        protected override function updateData():void
        {
            renderData = new SparklineRenderData();
            if (dataProvider)
            {
                var i:uint = 0;
                var item:SparklineItem;
                // build up the sparkline items, transform the value to a number
                // and pick up the min and max values
                for each(var obj:Object in dataProvider)
                {
                    item = new SparklineItem(obj);
                    // decide whether the x value is based on a field or the item's index
                    if (!xField || xField == "")
                        item.xValue = i;
                    else
                        item.xValue = obj[xField];
                    // decide whether the y value is based on a field or the value itself
                    if (!yField || yField == "")
                        item.yValue = obj;
                    else
                        item.yValue = obj[yField];
                    // check if the item is the x-min, x-max, y-min and y-max
                    if (item.xNumber < renderData.xMin.xNumber)
                        renderData.xMin = item;
                    if (item.xNumber > renderData.xMax.xNumber)
                        renderData.xMax = item;
                    if (item.yNumber < renderData.yMin.yNumber)
                        renderData.yMin = item;
                    if (item.yNumber > renderData.yMax.yNumber)
                        renderData.yMax = item;

                    renderData.cache[i] = item;
                    i++;
                }

                // map the x and y values to screen coordinates
                var xOffset:Number = bounds.x;
                var yOffset:Number = bounds.y;
                var width:Number = bounds.width;
                var height:Number = bounds.height;
                var xMinMaxDelta:Number = renderData.xMax.xNumber - renderData.xMin.xNumber;
                var yMinMaxDelta:Number = renderData.yMax.yNumber - renderData.yMin.yNumber;
                var n:uint = renderData.length;
                var x:Number;
                var y:Number;
                for (i = 0; i < n; i++)
                {
                    item = SparklineItem(renderData.cache[i]);
                    x = (item.xNumber - renderData.xMin.xNumber) / xMinMaxDelta;
                    y = (item.yNumber - renderData.yMin.yNumber) / yMinMaxDelta;
                    item.x = (x * width) + xOffset;
                    item.y = ((1 - y) * height) + yOffset;
                }

                // build the normal range items and map their values to screen coordinates
                if (normalRange)
                {
                    renderData.normalRangeMin = new SparklineItem();
                    renderData.normalRangeMax = new SparklineItem();

                    renderData.normalRangeMin.yValue = normalRange[0];
                    renderData.normalRangeMax.yValue = normalRange[1];

                    var minY:Number =
                        (renderData.normalRangeMin.yNumber - renderData.yMin.yNumber) / yMinMaxDelta;
                    renderData.normalRangeMin.y = ((1 - minY) * height) + yOffset;

                    var maxY:Number =
                        (renderData.normalRangeMax.yNumber - renderData.yMin.yNumber) / yMinMaxDelta;
                    renderData.normalRangeMax.y = ((1 - maxY) * height) + yOffset;
                }
            }
        }


        //------------------------------------
        //
        //           Functions
        //
        //------------------------------------

        /**
         * @private
         */
        private function initStyles():Boolean
        {
            var sd:CSSStyleDeclaration = styleManager.getStyleDeclaration("com.scottlogic.sparkline.Sparkline");
            if (!sd)
            {
                sd = new CSSStyleDeclaration();
                styleManager.setStyleDeclaration("com.scottlogic.sparkline.Sparkline", sd, false);
            }
            sd.defaultFactory = function():void
            {
                this.lineStroke = new SolidColorStroke(0x828282, 1);
                this.markerFill = new SolidColor(0x2963a3);
                this.markerStroke = new SolidColorStroke(0x2963a3, 0, 0);
                this.markerRadius = 2;
                this.normalRangeFill = new SolidColor(0x000000, 0.1);
            }
            return true;
        }

        /**
         * Draws the normal range if there is one.
         */
        private function drawNormalRange(width:Number,
                                         minItem:SparklineItem = null,
                                         maxItem:SparklineItem = null):void
        {
            if (minItem && maxItem)
            {
                var fill:IFill = getStyle("normalRangeFill");
                if (!fill)
                    fill = new SolidColor(0x000000, 0.1);

                graphics.lineStyle(0,0,0);

                var rect:Rectangle =
                        new Rectangle(0, maxItem.y,
                                      width, Math.abs(maxItem.y - minItem.y));
                fill.begin(graphics, rect, null);
                graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
                fill.end(graphics);
            }
        }

        /**
         * Draws the actual line of the sparkline.
         */
        private function drawLine(items:Array /* of SparklineItem */):void
        {
            var g:Graphics = graphics;

            var stroke:IStroke = getStyle("lineStroke");
            if (!stroke)
                stroke = new SolidColorStroke(0x000000, 0, 0);

            stroke.apply(graphics, null, null);

            var item:SparklineItem = SparklineItem(items[0]);
            g.moveTo(item.x, item.y);
            for (var i:int = 1; i < items.length; i++)
            {
                item = SparklineItem(items[i]);
                g.lineTo(item.x, item.y);
            }
        }

        /**
         * Draws the various minimum and maximum markers of the sparkline.
         */
        private function drawMarkers(renderData:SparklineRenderData):void
        {
            var xMinFill:IFill = getStyle("xMinFill");
            if (!xMinFill)
                xMinFill = getStyle("markerFill");
            var xMinStroke:IStroke = getStyle("xMinStroke");
            if (!xMinStroke)
                xMinStroke = getStyle("markerStroke");
            var xMinRadius:Number = getStyle("xMinRadius");
            if (!xMinRadius)
                xMinRadius = getStyle("markerRadius");
            var xMaxFill:IFill = getStyle("xMaxFill");
            if (!xMaxFill)
                xMaxFill = getStyle("markerFill");
            var xMaxStroke:IStroke = getStyle("xMaxStroke");
            if (!xMaxStroke)
                xMaxStroke = getStyle("markerStroke");
            var xMaxRadius:Number = getStyle("xMaxRadius");
            if (!xMaxRadius)
                xMaxRadius = getStyle("markerRadius");
            var yMinFill:IFill = getStyle("yMinFill");
            if (!yMinFill)
                yMinFill = getStyle("markerFill");
            var yMinStroke:IStroke = getStyle("yMinStroke");
            if (!yMinStroke)
                yMinStroke = getStyle("markerStroke");
            var yMinRadius:Number = getStyle("yMinRadius");
            if (!yMinRadius)
                yMinRadius = getStyle("markerRadius");
            var yMaxFill:IFill = getStyle("yMaxFill");
            if (!yMaxFill)
                yMaxFill = getStyle("markerFill");
            var yMaxStroke:IStroke = getStyle("yMaxStroke");
            if (!yMaxStroke)
                yMaxStroke = getStyle("markerStroke");
            var yMaxRadius:Number = getStyle("yMaxRadius");
            if (!yMaxRadius)
                yMaxRadius = getStyle("markerRadius");

            if (xMinMarkerEnabled)
                drawMarker(renderData.xMin, xMinFill, xMinStroke, xMinRadius);
            if (xMaxMarkerEnabled)
                drawMarker(renderData.xMax, xMaxFill, xMaxStroke, xMaxRadius);
            if (yMinMarkerEnabled)
                drawMarker(renderData.yMin, yMinFill, yMinStroke, yMinRadius);
            if (yMaxMarkerEnabled)
                drawMarker(renderData.yMax, yMaxFill, yMaxStroke, yMaxRadius);
        }

        /**
         * Draws a single marker for the specified item, using the
         * specified fill, stroke and radius.
         */
        private function drawMarker(item:SparklineItem,
                                    fill:IFill = null,
                                    stroke:IStroke = null,
                                    radius:Number = 2):void
        {
            if (!fill)
                fill = new SolidColor(0x000000, 0);
            if (!stroke)
                stroke = new SolidColorStroke(0x000000, 0, 0);

            fill.begin(graphics, new Rectangle(), null);
            stroke.apply(graphics, null, null);

            graphics.drawCircle(item.x, item.y, radius);

            fill.end(graphics);
        }
    }
}