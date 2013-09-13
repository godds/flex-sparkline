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
    import flash.geom.Rectangle;

    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.collections.IList;
    import mx.collections.ListCollectionView;
    import mx.collections.XMLListCollection;
    import mx.controls.dataGridClasses.DataGridListData;
    import mx.controls.listClasses.BaseListData;
    import mx.controls.listClasses.IDropInListItemRenderer;
    import mx.controls.listClasses.IListItemRenderer;
    import mx.core.IFlexModuleFactory;
    import mx.core.UIComponent;
    import mx.events.CollectionEvent;
    import mx.graphics.IFill;
    import mx.graphics.SolidColor;
    import mx.styles.CSSStyleDeclaration;
    import mx.styles.StyleManager;

    /**
     * Sets the background fill for the sparkline.
     * The default background fill is transparent.
     */
    [Style(name="fill", type="mx.graphics.IFill", inherit="no")]

    /**
     * Sets the padding to the bottom of the sparkline.
     * @default 2
     */
    [Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

    /**
     * Sets the padding to the left of the sparkline.
     * @default 2
     */
    [Style(name="paddingLeft", type="Number", format="Length", inherit="no")]

    /**
     * Sets the padding to the right of the sparkline.
     * @default 2
     */
    [Style(name="paddingRight", type="Number", format="Length", inherit="no")]

    /**
     * Sets the padding to the top of the sparkline.
     * @default 2
     */
    [Style(name="paddingTop", type="Number", format="Length", inherit="no")]

    /**
     * Base functionality for all sparkline types.
     */
    public class SparklineBase extends UIComponent
                               implements IListItemRenderer,
                                          IDropInListItemRenderer
    {
        //------------------------------------
        //
        //          Class Variables
        //
        //------------------------------------

        /**
         * Indicates whether the current render data cache is considered dirty.
         */
        private var dataDirty:Boolean;

        /**
         * The bounds within which the line part of the sparkline should be
         * restricted.
         */
        protected var bounds:Rectangle;

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
        public function SparklineBase()
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
        //  data
        //----------------------------------

        /**
         * Storage for the data property.
         */
        private var _data:Object;

        [Bindable]
        [Inspectable(environment="none")]

        /**
         * The <code>data</code> property lets you pass a value
         * to the component when you use it as an item renderer or item editor.
         * You typically use data binding to bind a field of the <code>data</code>
         * property to a property of this component.
         *
         * <p>When you use the control as a drop-in item renderer or drop-in
         * item editor, Flex automatically writes the current value of the item
         * to the <code>selected</code> property of this control.</p>
         *
         * <p>You do not set this property in MXML.</p>
         *
         * @default null
         * @see mx.core.IDataRenderer
         */
        public function get data():Object
        {
            return _data;
        }
        /**
         * @private
         */
        public function set data(value:Object):void
        {
            _data = value;

            if (_listData &&
                _listData is DataGridListData &&
                DataGridListData(_listData).dataField)
            {
                dataProvider = _data[DataGridListData(_listData).dataField];
            }
            else
            {
                dataProvider = _data;
            }
        }

        //----------------------------------
        //  listData
        //----------------------------------

        /**
         * Storage for the listData property.
         */
        private var _listData:BaseListData;

        [Bindable]
        [Inspectable(environment="none")]

        /**
         * When a component is used as a drop-in item renderer or drop-in
         * item editor, Flex initializes the <code>listData</code> property
         * of the component with the appropriate data from the list control.
         * The component can then use the <code>listData</code> property
         * to initialize the <code>data</code> property
         * of the drop-in item renderer or drop-in item editor.
         *
         * <p>You do not set this property in MXML or ActionScript;
         * Flex sets it when the component is used as a drop-in item renderer
         * or drop-in item editor.</p>
         *
         * @default null
         * @see mx.controls.listClasses.IDropInListItemRenderer
         */
        public function get listData():BaseListData
        {
            return _listData;
        }
        /**
         * @private
         */
        public function set listData(value:BaseListData):void
        {
            _listData = value;
        }

        //----------------------------------
        //  dataProvider
        //----------------------------------

        /**
         * Storage for the dataProvider property.
         */
        private var _dataProvider:ICollectionView;

        [Inspectable(category="General")]

        /**
         * The data provider for this sparkline.
         *
         * When used as an item renderer or item editor this will be
         * intialised to the value set on <code>data</code>.
         */
        public function get dataProvider():Object
        {
            return _dataProvider;
        }
        /**
         * @private
         */
        public function set dataProvider(value:Object):void
        {
            if (value is Array)
            {
                value = new ArrayCollection(value as Array);
            }
            else if (value is ICollectionView)
            {
            }
            else if (value is IList)
            {
                value = new ListCollectionView(IList(value));
            }
            else if (value is XMLList)
            {
                value = new XMLListCollection(XMLList(value));
            }
            else if (value)
            {
                value = new ArrayCollection([value]);
            }
            else
            {
                value = new ArrayCollection();
            }

            if (_dataProvider)
            {
                _dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
                                                  dataProviderChangeHandler);
            }
            _dataProvider = ICollectionView(value);
            if (_dataProvider)
            {
                _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                               dataProviderChangeHandler);
            }

            invalidateData();
        }

        //----------------------------------
        //  xField
        //----------------------------------

        /**
         * Storage for the xField property.
         */
        private var _xField:String;

        [Inspectable(category="General")]

        /**
         * Specifies the field of the data provider
         * that determines the x-axis location of each data point.
         * If <code>null</code>, the data points are rendered
         * in the order they appear in the data provider.
         *
         * @default null
         */
        public function get xField():String
        {
            return _xField;
        }
        /**
         * @private
         */
        public function set xField(value:String):void
        {
            _xField = value;
            invalidateData();
        }

        //----------------------------------
        //  yField
        //----------------------------------

        /**
         * Storage for the yField property.
         */
        private var _yField:String;

        [Inspectable(category="General")]

        /**
         * Specifies the field of the data provider
         * that determines the y-axis location of each data point.
         * If <code>null</code>, the Sparkline assumes the data provider
         * consists of the set of values and attempts to convert them
         * to numbers.
         *
         * @default null
         */
        public function get yField():String
        {
            return _yField;
        }
        /**
         * @private
         */
        public function set yField(value:String):void
        {
            _yField = value;
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
        override protected function measure():void
        {
            measuredWidth = 100;
            measuredHeight = 25;
        }

        /**
         * @private
         */
        override protected function updateDisplayList(unscaledWidth:Number,
                                                      unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            // ensure the bounds are up to date
            updateBounds(unscaledWidth, unscaledHeight);
            // ensure the data is up to date
            validateData();

            graphics.clear();
            drawBackground(unscaledWidth, unscaledHeight);
        }


        //------------------------------------
        //
        //           Functions
        //
        //------------------------------------

        /**
         *  @private
         */
        private function initStyles():Boolean
        {
            var sd:CSSStyleDeclaration =
                    styleManager.getStyleDeclaration("com.scottlogic.sparkline.sparklineClasses.SparklineBase");
            if (!sd)
            {
                sd = new CSSStyleDeclaration();
                styleManager.setStyleDeclaration("com.scottlogic.sparkline.sparklineClasses.SparklineBase", sd, false);
            }

            sd.defaultFactory = function():void
            {
                this.fill = new SolidColor(0x000000, 0);
                this.paddingBottom = 2;
                this.paddingLeft = 2;
                this.paddingRight = 2;
                this.paddingTop = 2;
            }

            return true;
        }

        /**
         * Draws the background for the sparkline.
         */
        protected function drawBackground(width:Number, height:Number):void
        {
            var fill:IFill = getStyle("fill");
            if (!fill)
                fill = new SolidColor(0x000000, 0);

            fill.begin(graphics, new Rectangle(0, 0, width, height), null);
            graphics.lineStyle(0,0,0);
            graphics.drawRect(0, 0, width, height);
            fill.end(graphics);
        }

        /**
         * Ensures the bounds are up to date.
         */
        protected function updateBounds(width:Number, height:Number):void
        {
            var left:Number = getStyle("paddingLeft");
            var right:Number = getStyle("paddingRight");
            var top:Number = getStyle("paddingTop");
            var bottom:Number = getStyle("paddingBottom");

            bounds = new Rectangle(left,
                                   top,
                                   width - (left + right),
                                   height - (top + bottom));
        }

        /**
         * Marks the current render data cache as dirty.
         */
        protected function invalidateData():void
        {
            dataDirty = true;
            invalidateDisplayList();
        }

        /**
         * If the current render data cache is considered dirty then
         * it updates the cache.
         */
        protected function validateData():void
        {
            if (dataDirty)
            {
                dataDirty = false;
                updateData();
            }
        }

        /**
         * Updates the render data cache to reflect the current data
         * provider values.  Maps the data provider values to screen
         * coordinates.  Should be implemented by sub-class.
         */
        protected function updateData():void
        {

        }


        //------------------------------------
        //
        //         Event Handlers
        //
        //------------------------------------

        /**
         * When the data provider changes, the render data cache needs to
         * be updated.
         */
        private function dataProviderChangeHandler(e:CollectionEvent):void
        {
            invalidateData();
        }
    }
}