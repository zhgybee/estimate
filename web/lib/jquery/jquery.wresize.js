/* 
=============================================================================== 
WResize is the jQuery plugin for fixing the IE window resize bug 
............................................................................... 
Copyright 2007 / Andrea Ercolino 
------------------------------------------------------------------------------- 
LICENSE: http://www.opensource.org/licenses/mit-license.php 
WEBSITE: http://noteslog.com/ 
=============================================================================== 
*/ 
(
	function($) 
	{ 
		$.fn.wresize = function(f) 
		{ 
			function resizeOnce() 
			{ 
				var ie = /msie/.test(navigator.userAgent.toLowerCase());
				if(ie) 
				{ 
					if ('undefined' == typeof(document.body.style.maxHeight)) 
					{ 
						return false; 
					} 
				} 
				return true; 
			} 


			function handleWResize(e) 
			{ 
				if(resizeOnce()) 
				{ 
					return f.apply(this, [e]); 
				} 
			} 

			this.each
			( 
				function() 
				{ 
					if (this == window) 
					{ 
						$(this).resize(handleWResize); 
					} 
					else 
					{ 
						$(this).resize(f); 
					} 
				} 
			); 

			return this; 
		}; 
	} 
)(jQuery); 
