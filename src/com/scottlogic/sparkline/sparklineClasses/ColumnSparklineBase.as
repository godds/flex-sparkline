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
    import flash.display.Graphics;

    import mx.core.IFlexModuleFactory;
    import mx.graphics.SolidColor;
    import mx.graphics.SolidColorStroke;
    import mx.styles.CSSStyleDeclaration;

    /**
     * Sets the horizontal gap between columns.
     * @default 1
     */
    [Style(name="horizontalGap", type="Number", format="Length", inherit="no")]

    /**
     * Sets the fill for positive value columns.
     * The default is solid grey (<code>0x828282</code>).
     */
    [Style(name="negativeFill", type="mx.graphics.IFill", inherit="no")]

    /**
     * Sets the stroke for negative value columns.
     * The default is no stroke.
     */
    [Style(name="negativeStroke", type="mx.graphics.IStroke", inherit="no")]

    /**
     * Sets the fill for positive value columns.
     * The default is solid grey (<code>0x828282</code>).
     */
    [Style(name="positiveFill", type="mx.graphics.IFill", inherit="no")]

    /**
     * Sets the stroke for positive value columns.
     * The default is no stroke.
     */
    [Style(name="positiveStroke", type="mx.graphics.IStroke", inherit="no")]

    /**
     * Sets the stroke for the line used to indicate a zero value.
     * The default colour is grey (<code>0x828282</code>).
     * The default value for the width is 1.
     */
    [Style(name="zeroStroke", type="mx.graphics.IStroke", inherit="no")]

    /**
     * Base functionality for all column sparkline types.
     */
    public class ColumnSparklineBase extends SparklineBase
    {
        //------------------------------------
        //
        //          Class Variables
        //
        //------------------------------------

        /**
         * A cache of the data required for rendering the column sparkline,
         * i.e. with the data values appropriately mapped to screen coordinates.
         */
        protected var renderData:ColumnSparklineRenderData;

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
        public function ColumnSparklineBase()
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
        //  zeroValue
        //----------------------------------

        private var _zeroValue:Number = 0;
        /**
         *
         */
        public function get zeroValue():Number
        {
            return _zeroValue;
        }
        /**
         * @private
         */
        public function set zeroValue(value:Number):void
        {
            _zeroValue = value;
            invalidateData();
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

            drawMarks(renderData);
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
            var sd:CSSStyleDeclaration =
                styleManager.getStyleDeclaration("com.scottlogic.sparkline.sparklineClasses.ColumnSparklineBase");
            if (!sd)
            {
                sd = new CSSStyleDeclaration();
                styleManager.setStyleDeclaration("com.scottlogic.sparkline.sparklineClasses.ColumnSparklineBase", sd, false);
            }
            sd.defaultFactory = function():void
            {
                this.horizontalGap = 1;
                this.negativeFill = new SolidColor(0x828282, 1);
                this.negativeStroke = new SolidColorStroke(0, 0, 0);
                this.positiveFill = new SolidColor(0x828282, 1);
                this.positiveStroke = new SolidColorStroke(0, 0, 0);
                this.verticalGap = 0;
                this.zeroStroke = new SolidColorStroke(0x828282, 1, 1);
            }

            return true;
        }
        /**
         * @private
         */
        private function drawMarks(renderData:ColumnSparklineRenderData):void
        {
            var g:Graphics = graphics;

            var items:Array = renderData.cache;
            var base:Number = renderData.rendererBase;
            var width:Number = renderData.renderedWidth;
            var height:Number;
            var item:ColumnSparklineItem;
            for (var i:int = 0; i < items.length; i++)
            {
                item = ColumnSparklineItem(items[i]);
                if (item.stroke)
                    item.stroke.apply(g, null, null);
                if (item.fill)
                    item.fill.begin(g, bounds, null);
                g.drawRect(item.x, base, width, item.y);
                if (item.fill)
                    item.fill.end(g);
            }
        }
    }
}