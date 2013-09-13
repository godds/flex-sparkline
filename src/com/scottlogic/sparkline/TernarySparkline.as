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
    import com.scottlogic.sparkline.sparklineClasses.ColumnSparklineBase;
    import com.scottlogic.sparkline.sparklineClasses.ColumnSparklineItem;
    import com.scottlogic.sparkline.sparklineClasses.ColumnSparklineRenderData;

    import mx.charts.chartClasses.GraphicsUtilities;
    import mx.graphics.IFill;
    import mx.graphics.IStroke;
    import mx.graphics.SolidColor;
    import mx.graphics.Stroke;

    /**
     * A three-state column sparkline.  Values above the zero value
     * will be indicated using an upward column and values below the
     * zero value with a downward column.  No further indication is
     * given of the actual value, i.e. all positive values and negative
     * value columns will have the same height.
     */
    public class TernarySparkline extends ColumnSparklineBase
    {
        //------------------------------------
        //
        //          Constructor
        //
        //------------------------------------

        /**
         * Constructor
         */
        public function TernarySparkline()
        {
            super();
        }


        //------------------------------------
        //
        //       Overidden Functions
        //
        //------------------------------------

        /**
         * Updates the render data cache to reflect the current data
         * provider values.  Maps the data provider values to screen
         * coordinates.
         */
        protected override function updateData():void
        {
            renderData = new ColumnSparklineRenderData();
            if (dataProvider)
            {
                var posStroke:IStroke = getStyle("positiveStroke");
                if (!posStroke)
                    posStroke = new Stroke(0x000000, 0, 0);
                var posFill:IFill = GraphicsUtilities.fillFromStyle(getStyle("positiveFill"));
                if (!posFill)
                    posFill = new SolidColor(0x828282, 1);
                var negStroke:IStroke = getStyle("negativeStroke");
                if (!negStroke)
                    negStroke = new Stroke(0x000000, 0, 0);
                var negFill:IFill = GraphicsUtilities.fillFromStyle(getStyle("negativeFill"));
                if (!negFill)
                    negFill = new SolidColor(0x828282, 1);
                var zeroStroke:IStroke = getStyle("zeroStroke");
                if (!zeroStroke)
                    zeroStroke = new Stroke(0x828282, 1, 1);
                var horizontalGap:Number = getStyle("horizontalGap");
                if (isNaN(horizontalGap))
                    horizontalGap = 1;

                var i:uint = 0;
                var item:ColumnSparklineItem;
                // build up the sparkline items, transform the value to a number
                // and pick up the min and max values
                for each(var obj:Object in dataProvider)
                {
                    item = new ColumnSparklineItem(obj);
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
                // and work out the fills/strokes
                var xOffset:Number = bounds.x;
                var yOffset:Number = bounds.y;
                var width:Number = bounds.width;
                var height:Number = bounds.height;
                var xMinMaxDelta:Number = renderData.xMax.xNumber - renderData.xMin.xNumber;
                var posY:Number = (height / 2) * -1;
                var negY:Number = height / 2;
                var n:uint = renderData.length;

                renderData.renderedWidth = (width - (horizontalGap * (n - 1))) / n;
                renderData.rendererBase = (height / 2) + yOffset;

                width -= renderData.renderedWidth;

                var x:Number;
                var y:Number;
                var fill:IFill;
                var stroke:IStroke;
                for (i = 0; i < n; i++)
                {
                    item = ColumnSparklineItem(renderData.cache[i]);
                    x = (item.xNumber - renderData.xMin.xNumber) / xMinMaxDelta;
                    item.x = (x * width) + xOffset + (x * horizontalGap);
                    item.y = 0;
                    item.fill = null;
                    item.stroke = zeroStroke;
                    if (item.yNumber > zeroValue)
                    {
                        item.y = posY;
                        item.fill = posFill;
                        item.stroke = posStroke;
                    }
                    else if (item.yNumber < zeroValue)
                    {
                        item.y = negY;
                        item.fill = negFill;
                        item.stroke = negStroke;
                    }
                }
            }
        }
    }
}