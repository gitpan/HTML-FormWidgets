// @(#)$Id: 02ourtools.js 398 2008-05-17 23:37:49Z pjf $

// LiveGridMetaData -----------------------------------------------------

LiveGridMetaData = new Class({
   initialize: function( options ) {
      this.bufferSize   = options.bufferSize   || 7;
      this.onscroll     = options.onscroll     || null;
      this.onscrollidle = options.onscrollidle || null;
      this.pageSize     = options.pageSize     || 10;
      this.totalRows    = options.totalRows    || 0;
   },

   getBufferSize: function()    { return this.bufferSize },

   getPageSize:   function()    { return this.pageSize },

   getTotalRows:  function()    { return this.totalRows },

   setTotalRows:  function( n ) { this.totalRows = n }
});

// LiveGridScroller -----------------------------------------------------

LiveGridScroller = new Class({
   initialize: function( liveGrid ) {
      this.isIE = navigator.userAgent.toLowerCase().indexOf('msie') >= 0;
      this.liveGrid = liveGrid;
      this.metaData = liveGrid.metaData;
      this.scrollTimeout = null;
      this.lastScrollPos = 0;
      this.createScrollBar();
   },

   isUnPlugged: function() { return this.scrollerDiv.onscroll == null },

   plugin: function() {
      this.scrollerDiv.onscroll = this.handleScroll.bindAsEventListener(this);
   },

   unplug: function() { this.scrollerDiv.onscroll = null },

   createScrollBar: function() {
      var table              = this.liveGrid.table;
      var visibleHeight      = table.offsetHeight;
      this.lineHeight        =  visibleHeight/this.metaData.getPageSize();
      this.scrollerDiv       = document.createElement( 'div' );
      var scrollerStyle      = this.scrollerDiv.style;
      scrollerStyle.position = 'relative';
      scrollerStyle.left     = this.isIE ? '-6px' : '-4px';
      scrollerStyle.width    = '19px';
      scrollerStyle.height   = visibleHeight + 'px';
      scrollerStyle.overflow = 'auto';

      if (this.isIE) {
         table.onmousewheel =
            function( evt ) {
               if (event.wheelDelta>=0) {//wheel-up
                  this.scrollerDiv.scrollTop -= this.lineHeight;
               }
               else { this.scrollerDiv.scrollTop += this.lineHeight }

               this.handleScroll( true );
            }.bind( this );
      } else {
        table.addEventListener( 'DOMMouseScroll',
            function( evt ) {
                if (evt.detail < 0) { //wheel-up
                   this.scrollerDiv.scrollTop -= this.lineHeight;
                }
                else { this.scrollerDiv.scrollTop += this.lineHeight }

                this.handleScroll( true );
            }.bind( this ), true );
      }

      // create the inner div...
      this.heightDiv = document.createElement( 'div' );
      this.heightDiv.style.width  = '1px';
      this.heightDiv.style.height = parseInt(visibleHeight *
            this.metaData.getTotalRows()/this.metaData.getPageSize()) + 'px' ;

      this.scrollerDiv.appendChild(this.heightDiv);
      this.scrollerDiv.onscroll = this.handleScroll.bindAsEventListener(this);
      table.parentNode.parentNode.insertBefore( this.scrollerDiv,
                                                table.parentNode.nextSibling );
   },

   updateSize: function() {
      var table = this.liveGrid.table;
      var visibleHeight = table.offsetHeight;
      this.heightDiv.style.height = parseInt(visibleHeight *
            this.metaData.getTotalRows()/this.metaData.getPageSize()) + 'px';
   },

   adjustScrollTop: function() {
      this.unplug();
      var rem = this.scrollerDiv.scrollTop % this.lineHeight;

      if (rem != 0) {
         if (this.lastScrollPos < this.scrollerDiv.scrollTop) {
            this.scrollerDiv.scrollTop = this.scrollerDiv.scrollTop
               + this.lineHeight - rem;
         }
         else {
            this.scrollerDiv.scrollTop = this.scrollerDiv.scrollTop - rem;
         }
      }

      this.lastScrollPos = this.scrollerDiv.scrollTop;
      this.plugin();
   },

   moveScroll: function( rowOffset ) {
	   var pixelOffset = (rowOffset / this.metaData.getTotalRows())
                           * this.heightDiv.offsetHeight;
      this.scrollerDiv.scrollTop = pixelOffset;
   },

   handleScroll: function( skiptimeout ) {
      if ( this.scrollTimeout ) clearTimeout( this.scrollTimeout );

	   var contentOffset = parseInt( this.scrollerDiv.scrollTop *
                 this.metaData.getTotalRows() / this.heightDiv.offsetHeight );

      if ( this.metaData.onscroll )
         this.metaData.onscroll( contentOffset, this.metaData );

      if (skiptimeout == true) { this.scrollIdle() }
      else {
        this.scrollTimeout = setTimeout( this.scrollIdle.bind( this ), 100 );
      }
   },

   scrollIdle: function() {
      if ( this.scrollTimeout ) clearTimeout( this.scrollTimeout );

      // this.adjustScrollTop();
	   var contentOffset = parseInt( this.scrollerDiv.scrollTop *
                 this.metaData.getTotalRows() / this.heightDiv.offsetHeight );
      this.liveGrid.requestContentRefresh( contentOffset );

      if ( this.metaData.onscrollidle ) this.metaData.onscrollidle();
   }
});

// LiveGridBuffer -----------------------------------------------------

LiveGridBuffer = new Class({
   initialize: function( metaData ) {
      this.start    = 0;
      this.size     = 0;
      this.metaData = metaData;
      this.rows     = new Array();
   },

   update: function(text, xml) {
      this.start = parseInt( xml.documentElement.getAttribute( 'offset' ) );
      this.size  = parseInt( xml.documentElement.getAttribute( 'rowcount' ) );
      var rows   = xml.documentElement.getElementsByTagName( 'row' );

      for (var i = 0; i < this.size; i++) {
         this.rows[this.start + i]
            = rows[ i ].childNodes[ 0 ].nodeValue.unescapeHTML();
      }
   },

	isClose: function( start ) {
      return this.rows[start]
             || this.rows[start + this.metaData.getPageSize()];
	},

   isFullyInRange: function( start ) {
      return this.rows[start]
             && this.rows[start + this.metaData.getPageSize()];
   },

   needsPrevPage: function( start ) {
      return !this.rows[start - this.metaData.getPageSize()];
   },

   needsNextPage: function( start ) {
      return !this.rows[start + 2 * this.metaData.getPageSize()];
   },

   needsMorePages: function( start ) {
      return this.needsPrevPage( start ) || this.needsNextPage( start );
   },

   getRows: function( start ) {
      return this.rows.slice( start, start + this.metaData.getPageSize() );
   }
});

// LiveGridRequest ----------------------------------------------

LiveGridRequest = new Class({
   initialize: function( requestOffset, options ) {
		this.requestOffset = requestOffset;
   }
});

// LiveGrid -----------------------------------------------------

LiveGrid = new Class({
   initialize: function( tableId, url, options ) {
      if ( options == null ) options = {};

      this.url      = url;
      this.options  = options;
      this.tableId  = tableId;
      this.table    = $( tableId );
      this.metaData = new LiveGridMetaData( options );
      this.buffer   = new LiveGridBuffer( this.metaData );

      this.lastDisplayedStartPos = -1;
      this.timeoutHander         = null;
      this.additionalParms       = options.requestParameters || '';
      this.processingRequest     = null;
      this.unprocessedRequest    = null;

      if ( options.prefetchBuffer || options.prefetchOffset) {
         var offset = 0;

         if (options.prefetchOffset) {
            this.scroller.moveScroll( options.prefetchOffset );
            offset = options.prefetchOffset;
         }

         this.fetchBuffer( offset, false );
      }
      else { this.scroller = new LiveGridScroller( this ) }
   },

   setRequestParams: function( params ) {
      this.additionalParms = params;
   },

   setTotalRows: function( newTotalRows ) {
      this.metaData.setTotalRows( newTotalRows );
      this.scroller.updateSize();
   },

   handleTimedOut: function() {
      //server did not respond in n secs assume that there could have been
      //an error or something, and allow requests to be processed again...
      this.processingRequest = null;
      this.processQueuedRequest();
   },

   fetchBuffer: function( offset, sequence_buffers ) {
      var page, page_size;

      if (this.processingRequest) {
         this.unprocessedRequest = new LiveGridRequest( offset );
         return;
      }

      this.processingRequest = new LiveGridRequest(offset);

      page_size = this.metaData.getBufferSize() * this.metaData.getPageSize();
      page      = Math.floor(offset / page_size);

      if (sequence_buffers) {
         page  += offset - page * page_size > page_size / 2 ? 1 : -1;
      }

      if (page < 0) page = 0;

      var callParms = 'id=' + this.tableId + '&page=' + page
                    + '&page_size=' + page_size;

      if (this.additionalParms.length) {
         callParms = callParms + '&' + this.additionalParms;
      }

      if (!this.ajaxRequest) {
         var options = { data: callParms, method: 'get' };
         Object.extend( options, this.options );
         options.onComplete = this.ajaxUpdate.bind( this );
         this.ajaxRequest = new Ajax( this.url, options )
         this.ajaxRequest.request();
      }
      else {
         Object.extend( this.ajaxRequest.options, { data: callParms } );
         this.ajaxRequest.request();
      }

      this.timeoutHandler = setTimeout(this.handleTimedOut.bind(this), 10000);
   },

   requestContentRefresh: function( offset ) {
      if ( this.buffer.isFullyInRange( offset ) ) {
         this.updateContent( offset );

         if (this.buffer.needsMorePages( offset )) {
            this.fetchBuffer( offset, true );
         }
      }
      else if (this.buffer.isClose( offset )) {
         this.fetchBuffer( offset, true );
      }
      else { this.fetchBuffer( offset, false ) }
   },

   ajaxUpdate: function( text, xml ) {
      clearTimeout( this.timeoutHandler );

      try {
         var totalrows =  xml.documentElement.getAttribute( 'totalrows' );
         if (totalrows) this.setTotalRows( totalrows );
      }
      catch (err) {}

      this.buffer.update( text, xml );

      if (this.unprocessedRequest == null) {
         this.updateContent( this.processingRequest.requestOffset );
      }

      this.processingRequest = null;

      if (!this.scroller) {
         this.scroller = new LiveGridScroller( this );

         if (this.options.onFirstContent) this.options.onFirstContent( this );
      }

      if (this.options.onComplete) this.options.onComplete( this );

      this.processQueuedRequest();
   },

   processQueuedRequest: function() {
   	if (this.unprocessedRequest != null) {
   	   this.requestContentRefresh( this.unprocessedRequest.requestOffset );
   	   this.unprocessedRequest = null
   	}
   },

   updateContent: function( offset ) {
      this.replaceCellContents( this.buffer, offset );
   },

   replaceCellContents: function( buffer, start ) {
      if (start == this.lastDisplayedStartPos) return;

      this.table.setHTML( buffer.getRows( start ).join( '' ) );
      this.lastDisplayedStartPos = start
   }
});

// LinkFader -----------------------------------------------------

LinkFader = new Class({
   options: {
      cn    : 'Fade',             // Class name matching links to fade
      inBy  : 6,                  // Fade in colour inc/dec by
      outBy : 6,                  // Fade out colour inc/dec by
      speed : 20,                 // Millisecs between colour changes
      fc    : 'ff0000'            // Fade to colour
   },

   initialize: function( options ) {
      var i, ignoreIt, link;

      this.setOptions( options );
      this.colour = null;         // Store links original colour
      this.linkNo = 0,            // Index of currently fading link
      this.timer  = null;         // Interval object

      for (i = 0; i < document.links.length; i++) {
         link     = document.links[i];
         ignoreIt = link.className.indexOf( this.options.cn ) < 0;

         if (!ignoreIt) {
            if (!link.id) link.id = 'link' + i;

            if (!link.onmouseover && !link.onmouseout) {
               link.onmouseover = this.StartFade.bind( this, link.id );
               link.onmouseout  = this.ClearFade.bind( this, link.id );
            }
         }
      }
   },

   ClearFade: function( id ) {
      if (this.timer) { clearInterval( this.timer ); this.timer = null }

      this.timer = setInterval( this.Fade.bind( this ), this.options.speed, 0);
   },

   CurrentColour: function( index ) {
      var cc, i, style, temp = '', view = document.defaultView;

      style = view.getComputedStyle( document.links[index], '' );
      cc    = style.getPropertyValue( 'color' );

      if (cc.length == 4 && cc.substring( 0, 1 ) == '#') {
         for (i = 0; i < 3; i++) {
            temp += cc.substring( i + 1, i + 2 ) + cc.substring( i + 1, i + 2);
         }

         cc = temp;
      }
      else if (cc.indexOf('rgb') != -1) { cc = cc.rgbToHex().substring(1, 7) }
      else if (cc.length == 7)          { cc = cc.substring( 1, 7 ) }
      else                              { cc = this.options.fc }

      return cc;
   },

   Fade: function( d ) {
      var cc = new Array(), tc = new Array();

      if (d == 1) tc = this.options.fc.hexToRgb( true );
      else tc = this.colour.hexToRgb( true );

      cc = this.CurrentColour( this.linkNo ).hexToRgb( true );

      if (tc[0] == cc[0] && tc[1] == cc[1] && tc[2] == cc[2]) {
         clearInterval( this.timer ); this.timer = null;
         return;
      }

      document.links[this.linkNo].style.color = this.NextColour( tc, cc, d );
   },

   NextColour: function( tc, cc, d ) {
      var change, colour, diff, i, nc;

      for (i = 0; i < 3; i++) {
         if (d == 1) { change = this.options.inBy }
         else { change = this.options.outBy }

         if (!colour) colour = 'rgb(';
         else colour += ',';

         nc = cc[i];

         if (tc[i]-cc[i] > 0) { diff   = tc[i]-cc[i] }
         else                 { diff   = cc[i]-tc[i] }
         if (diff  < change)  { change = diff }
         if (cc[i] > tc[i])   { nc     = cc[i]-change }
         if (cc[i] < tc[i])   { nc     = cc[i]+change }
         if (nc    < 0)       { nc     = 0 }
         if (nc    > 255)     { nc     = 255 }
         colour +=  nc;
      }

      colour += ')';
      return colour;
   },

   StartFade: function( id ) {
      if (this.timer) {
         clearInterval( this.timer ); this.timer = null;
         document.links[this.linkNo].style.color = this.colour.hexToRgb();
      }

      for (var i = 0; i < document.links.length; i++) {
         if (id == document.links[i].id) {
            this.linkNo = i;
            this.colour = this.CurrentColour( i );
            this.timer  = setInterval( this.Fade.bind( this ),
                                       this.options.speed, 1);
            return;
         }
      }
   }
});

LinkFader.implement(new Options);

Element.extend({
/*
	Property: setHTML
		Sets the innerHTML of the Element.

	Arguments:
		html - string; the new innerHTML for the element.

	Example:
		>$('myElement').setHTML(newHTML) //the innerHTML of myElement
                                         is now = newHTML
*/

	setHTML: function( html ){
      while (this.firstChild) this.removeChild( this.firstChild );

      return HTMLtoDOM( html, this );
	}
});

/*
Script: String.js
	Contains String prototypes.

License:
	MIT-style license.
*/

/*
Class: String
	A collection of The String Object prototype methods.
*/

String.extend({
   escapeHTML: function() {
      var text = this;
      text = text.replace( /\</g, '&lt;'   );
      text = text.replace( /\>/g, '&gt;'   );
      text = text.replace( /\"/g, '&quot;' );
      text = text.replace( /\&/g, '&amp;'  );
      return text;
   },

   unescapeHTML: function() {
      var text = this;
      text = text.replace( /\&lt\;/g,   '<' );
      text = text.replace( /\&gt\;/g,   '>' );
      text = text.replace( /\&quot\;/g, '"' );
      text = text.replace( /\&amp\;/g,  '&' );
      return text;
   }
});

/*
Script: Tips.js
	Tooltips, BubbleTips, whatever they are, they will appear on mouseover

License:
	MIT-style license.

Credits:
	The idea behind Tips.js is based on Bubble Tooltips
	(<http://web-graphics.com/mtarchive/001717.php>) by Alessandro
	Fulcitiniti <http://web-graphics.com>
*/

/*
Class: Tips
	Display a tip on any element with a title and/or href.

Note:
	Tips requires an XHTML doctype.

Arguments:
	elements - a collection of elements to apply the tooltips to on mouseover.
	options - an object. See options Below.

Options:
	maxTitleChars - the maximum number of characters to display in the
	                title of the tip. defaults to 30.
	showDelay - the delay the onShow method is called. (defaults to 100 ms)
	hideDelay - the delay the onHide method is called. (defaults to 100 ms)
	className - the prefix for your tooltip classNames. defaults to 'tool'.
		the whole tooltip will have as classname: tool-tip
		the title will have as classname: tool-title
		the text will have as classname: tool-text
	offsets - the distance of your tooltip from the mouse. an Object
	          with x/y properties.
	fixed - if set to true, the toolTip will not follow the mouse.

Events:
	onShow - optionally you can alter the default onShow behaviour with
	         this option (like displaying a fade in effect);
	onHide - optionally you can alter the default onHide behaviour with
	         this option (like displaying a fade out effect);

Example:
	(start code)
	<img src="/images/i.png" title="The body of the tooltip is stored
	                                in the title" class="toolTipImg"/>
	<script>
		var myTips = new Tips($$('.toolTipImg'), {
			maxTitleChars: 50	//I like my captions a little long
		});
	</script>
	(end)

Note:
	The title of the element will always be used as the tooltip
	body. If you put ~ in your title, the text before the ~ will become
	the tooltip title.
*/

var Tips = new Class({
	options: {
		onShow: function( tip ) { tip.setStyle( 'visibility', 'visible' ) },
		onHide: function( tip ) { tip.setStyle( 'visibility', 'hidden'  ) },
		maxTitleChars: 40,
		showDelay: 100,
      hellip: '\u2026',
		hideDelay: 100,
		className: 'tool',
		offsets: { 'x': 20, 'y': 20 },
      separator: '~',
      spacer: '\u00a0\u00a0\u00a0',
      timeout: 30000,
		fixed: false
	},

	initialize: function( elements, options ) {
      var cell, row, table;

		this.setOptions( options );
      this.toolTip = new Element( 'div', {
			'class' : this.options.className + '-tip',
			'styles': { 'position'  : 'absolute',
                     'top'       : '0',
                     'left'      : '0',
                     'visibility': 'hidden' } } ).inject( document.body );
      table = new Element( 'table',
         { 'cellpadding': '0', 'cellspacing': '0' } ).inject( this.toolTip );
      row   = new Element( 'tr' ).inject( table );
      this.titleCell = new Element( 'td',
         { 'class': this.options.className + '-tip-topLeft'} ).inject( row );
      this.title = new Element( 'span' ).inject( this.titleCell );

      cell  = new Element( 'td',
         { 'class': this.options.className + '-tip-topRight'} ).inject( row );
      new Element( 'span' ).appendText( this.options.spacer ).inject( cell );

      row   = new Element( 'tr' ).inject( table );
      this.textCell  = new Element( 'td', { 'class': this.options.className
                                   + '-tip-bottomLeft'} ).inject( row );
      this.text = new Element( 'span' ).inject( this.textCell );

      cell  = new Element( 'td', { 'class': this.options.className
                                   + '-tip-bottomRight' } ).inject( row );
      new Element( 'span' ).appendText( this.options.spacer ).inject( cell );

      $$( elements ).each( this.build, this );

		if (this.options.initialize) this.options.initialize.call( this );
	},

	build: function( el ) {
      if (el.$tmp.myTitle || el.$tmp.myText) return;

		el.$tmp.myTitle = (el.href && el.getTag() == 'a')
                      ? el.href.replace( 'http://', '' )
                      : (el.rel || false);

		if (el.title){
			var dual = el.title.split( this.options.separator );

			if (dual.length > 1){
				el.$tmp.myTitle = dual[0].trim();
				el.$tmp.myText  = dual[1].trim();
			}
         else {
				if (!el.$tmp.myTitle) el.$tmp.myTitle = this.options.hellip;

				el.$tmp.myText = el.title;
			}

			el.removeAttribute( 'title' );
		}
      else { el.$tmp.myText = false }

		if (el.$tmp.myTitle && el.$tmp.myTitle.length >
          this.options.maxTitleChars) {
         el.$tmp.myTitle
            = el.$tmp.myTitle.substr( 0, this.options.maxTitleChars - 1 )
            + this.options.hellip;
      }

		el.addEvent( 'mouseenter', function( event ) {
			this.start( el );

			if (!this.options.fixed) this.locate( event );
			else this.position( el );
		}.bind( this ) );

		if (!this.options.fixed)
         el.addEvent( 'mousemove', this.locate.bindWithEvent( this ) );

		el.addEvent( 'mouseleave', this.end.bind( this ) );
		el.addEvent( 'trash', this.hide.bind( this ) );
	},

	end: function( event ) {
		$clear( this.timer );
		this.timer = this.hide.delay( this.options.hideDelay, this );
	},

	hide: function() {
		this.fireEvent( 'onHide', [this.toolTip] );
	},

	locate: function( event ) {
		var win = { 'x': window.getWidth(), 'y': window.getHeight() };
		var scroll
         = { 'x': window.getScrollLeft(), 'y': window.getScrollTop() };
		var tip
         = { 'x': this.toolTip.offsetWidth, 'y': this.toolTip.offsetHeight };
		var prop = { 'x': 'left', 'y': 'top' };

		for (var z in prop) {
			var pos = event.page[z] + this.options.offsets[z];
			if ((pos + tip[z] - scroll[z]) > win[z])
            pos = event.page[z] - this.options.offsets[z] - tip[z];
			this.toolTip.setStyle( prop[z], pos );
		};
	},

	position: function( element ) {
		var pos = element.getPosition();
		this.toolTip.setStyles({
			'left': pos.x + this.options.offsets.x,
			'top': pos.y + this.options.offsets.y
		});
	},

   show: function() {
      if ( this.options.timeout )
         this.timer = this.hide.delay( this.options.timeout, this );
      this.fireEvent( 'onShow', [this.toolTip] );
   },

   start: function(el) {
      var len, width, w = 100;

		if (el.$tmp.myText) {
         width = window.getWidth();
         len = el.$tmp.myTitle.length > el.$tmp.myText.length
            ? el.$tmp.myTitle.length : el.$tmp.myText.length;
         w = 10 * len;

         if (w < 100) w = 100;

         if (w > width / 4) w = width / 4;
      }

      this.titleCell.setStyle( 'width', parseInt( w ) + 'px' );
      if ($defined( this.title.lastChild ))
         this.title.removeChild( this.title.lastChild );
		this.title.appendText( el.$tmp.myTitle || this.options.spacer );
      this.textCell.setStyle( 'width', parseInt( w ) + 'px' );
      if ($defined( this.text.lastChild ))
         this.text.removeChild( this.text.lastChild );
		this.text.appendText( el.$tmp.myText || this.options.spacer );

		$clear( this.timer );
		this.timer = this.show.delay( this.options.showDelay, this );
	}
});

Tips.implement(new Events, new Options);

/*
Script: Accordion.js
	Contains <Accordion>

License:
	MIT-style license.
*/

/*
Class: Accordion
   The Accordion class creates a group of elements that
	are toggled when their handles are clicked. When one elements
	toggles in, the others toggles back.  Inherits methods, properties,
	options and events from <Fx.Elements>.

Note:
	The Accordion requires an XHTML doctype.

Arguments:
   togglers - required, a collection of elements, the elements handlers
	           that will be clickable.
	elements - required, a collection of elements the transitions will
	           be applied to.
	options  - optional, see options below, and <Fx.Base> options and events.

Options:
	show - integer, the Index of the element to show at start.
	display - integer, the Index of the element to show at start (with
	          a transition). defaults to 0.
	fixedHeight - integer, if you want the elements to have a fixed
	              height. defaults to false.
	fixedWidth - integer, if you want the elements to have a fixed
	             width. defaults to false.
	height - boolean, will add a height transition to the accordion if
	         true. defaults to true.
	opacity - boolean, will add an opacity transition to the accordion
	          if true. defaults to true.
	width - boolean, will add a width transition to the accordion if
	        true. defaults to false, css mastery is required to make this work!
	alwaysHide - boolean, will allow to hide all elements if true,
	             instead of always keeping one element shown. defaults to false.
Events:
	onActive - function to execute when an element starts to show
	onBackground - function to execute when an element starts to hide
*/

var Accordion = Fx.Elements.extend({
	options: {
		onActive: Class.empty,
		onBackground: Class.empty,
		display: 0,
		show: false,
		height: true,
		width: false,
		opacity: true,
		fixedHeight: false,
		fixedWidth: false,
		wait: false,
		alwaysHide: false
	},

	initialize: function(){
		var options, togglers, elements, container;
		$each(arguments, function(argument, i){
			switch($type(argument)){
				case 'object': options = argument; break;
				case 'element': container = $(argument); break;
				default:
					var temp = $$(argument);
					if (!togglers) togglers = temp;
					else elements = temp;
			}
		});
		this.togglers = togglers || [];
		this.elements = elements || [];
		this.container = $(container);
		this.setOptions(options);
		this.previous = -1;
		if (this.options.alwaysHide) this.options.wait = true;
		if ($chk(this.options.show)){
			this.options.display = false;
			this.previous = this.options.show;
		}
		if (this.options.start){
			this.options.display = false;
			this.options.show = false;
		}
		this.effects = {};
		if (this.options.opacity)
         this.effects.opacity = 'fullOpacity';
		if (this.options.width)
         this.effects.width = this.options.fixedWidth
                            ? 'fullWidth' : 'offsetWidth';
		if (this.options.height)
         this.effects.height = this.options.fixedHeight
                             ? 'fullHeight' : 'scrollHeight';
		for (var i = 0, l = this.togglers.length; i < l; i++)
         this.addSection(this.togglers[i], this.elements[i]);
		this.elements.each(function(el, i){
			if (this.options.show === i){
				this.fireEvent('onActive', [this.togglers[i], el]);
			}
         else {
				for (var fx in this.effects) el.setStyle(fx, 0);
			}
		}, this);
		this.parent(this.elements);
		if ($chk(this.options.display)) this.display(this.options.display);
	},

	/*
	Property: addSection
		Dynamically adds a new section into the accordion at the
		specified position.

	Arguments:
		toggler - (dom element) the element that toggles the accordion
		          section open.
		element - (dom element) the element that stretches open when the
		          toggler is clicked.
		pos     - (integer) the index where these objects are to be inserted
		          within the accordion.
	*/

	addSection: function(toggler, element, pos){
		toggler = $(toggler);
		element = $(element);
		var test = this.togglers.contains(toggler);
		var len = this.togglers.length;
		this.togglers.include(toggler);
		this.elements.include(element);
		if (len && (!test || pos)){
			pos = $pick(pos, len - 1);
			toggler.injectBefore(this.togglers[pos]);
			element.injectAfter(toggler);
		}
      else if (this.container && !test){
			toggler.inject(this.container);
			element.inject(this.container);
		}
		var idx = this.togglers.indexOf(toggler);
		toggler.addEvent('click', this.display.bind(this, idx));
		if (this.options.height)
         element.setStyles({ 'padding-top': 0, 'padding-bottom': 0 });
		if (this.options.width)
         element.setStyles({ 'padding-left': 0, 'padding-right': 0 });
		element.fullOpacity = 1;
		if (this.options.fixedWidth)
         element.fullWidth = this.options.fixedWidth;
		if (this.options.fixedHeight)
         element.fullHeight = this.options.fixedHeight;
		element.setStyle('overflow', 'hidden');
		if (!test){
			for (var fx in this.effects) element.setStyle(fx, 0);
		}
		return this;
	},

	/*
	Property: display
		Shows a specific section and hides all others. Useful when
		triggering an accordion from outside.

	Arguments:
		index - integer, the index of the item to show, or the actual
		        element to show.
	*/

	display: function(index){
		index = ($type(index) == 'element')
            ? this.elements.indexOf(index) : index;

		if ((this.timer && this.options.wait)
          || (index === this.previous
              && !this.options.alwaysHide)) return this;

		var obj = {};
		this.previous = index;
		this.elements.each(function(el, i){
			obj[i] = {};
			var hide = (i != index)
            || (this.options.alwaysHide && (el.offsetHeight > 0));
			this.fireEvent(hide ? 'onBackground' : 'onActive',
                        [this.togglers[i], el]);
			for (var fx in this.effects)
            obj[i][fx] = hide ? 0 : el[this.effects[fx]];
		}, this);
		return this.start(obj);
	},

   showThisHideOpen: function( index ) { return this.display( index ) },

   redisplay: function() {
      var index = this.previous;
      this.previous = -1;
      this.display( index );
   },

   reload: function() {
      if (!($defined( this.togglers[ 0 ] )
            && $defined( this.togglers[ 0 ].onclick ))) return;
      this.togglers[ 0 ].onclick();
   },

   resize: function( height, width ) {
      this.elements.each( function( el ) {
         if (height) el.fullHeight = this.options.fixedHeight = height;
         if (width)  el.fullWidth  = this.options.fixedWidth  = width;
      }, this );
      this.redisplay();
   }
});

Fx.Accordion = Accordion;