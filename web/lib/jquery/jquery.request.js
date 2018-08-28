(
	function($) 
	{
		$.extend
		(
			{
				getParameter: function (m)
				{
					var sValue = location.search.match(new RegExp("[\?\&]" + m + "=([^\&]*)(\&?)", "i"));
					return sValue ? sValue[1] : sValue;
				},
				getContextPath: function (m)
				{
					var pathname = document.location.pathname;
					var index = pathname.substr(1).indexOf("/");
					var result = pathname.substr(0,index+1);
					return result;
				},
				setParameter: function (url, name, value) 
				{
					var r = url;
					if (r != null && r != 'undefined' && r != "") 
					{
						value = encodeURIComponent(value);
						var reg = new RegExp("(^|)" + name + "=([^&]*)(|$)");
						var tmp = name + "=" + value;
						if (url.match(reg) != null) 
						{
							r = url.replace(eval(reg), tmp);
						}
						else 
						{
							if (url.match("[\?]")) 
							{
								r = url + "&" + tmp;
							} 
							else 
							{
								r = url + "?" + tmp;
							}
						}
					}
					return r;
				}
			}
		);
	}
)
(jQuery);