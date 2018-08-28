(
	function($)
	{
		var selectedStatus = function($li)
		{
			$li.attr("isselect", "1");
			$li.css("background-color", "#fff4e3");
		}

		var unSelectStatus = function($li)
		{
			$li.removeAttr("isselect");
			$li.css("background-color", "");
		}

		var clickitem = function(event)
		{
			var $panel = event.data.$panel;
			var item = event.data.item;

			var options = $panel.data("options");
			var $keyfield = $panel.data("$keyfield");
			var $valfield = $panel.data("$valfield");

			if(!options.ismultiple)
			{
				unSelectStatus($panel.find("ul li"));
			}

			var isselect = $(this).attr("isselect");
			if(isselect == "1")
			{
				unSelectStatus($(this));
			}
			else
			{
				selectedStatus($(this));
			}

			var selectedVals = [];
			var selectedkeys = [];
			$panel.find("ul li[isselect=1]").each(function(i)
			{
				selectedVals[i] = $(this).text();
				selectedkeys[i] = $(this).attr("key");
			});
			$keyfield.val(selectedkeys.join(","))
			$valfield.val(selectedVals.join(","))

			if(!options.ismultiple)
			{
				$("#selector-panel").hide();
			}

			if(options.onclick != null)
			{
				options.onclick(item, $keyfield);
			}

			event.stopPropagation();
		}

		var open = function(event)
		{
			var $panel = event.data.$panel;
			var options = $panel.data("options");
			
			var $valfield = $(this);
			var $keyfield = $valfield.data("joint");
			$panel.data("$keyfield", $keyfield);
			$panel.data("$valfield", $valfield);

			var $selectorpanel = $("#selector-panel")
			if($selectorpanel.size() == 0)
			{
				$selectorpanel = $('<div id="selector-panel" style="position:absolute; display:none;"></div>');
				$("body").append($selectorpanel);
				$selectorpanel.on("mousedown", function(event){event.stopPropagation();});
			}
			$selectorpanel.css("border-bottom-color", $valfield.css("border-bottom-color"));
			$selectorpanel.css("border-bottom-style", $valfield.css("border-bottom-style"));
			$selectorpanel.css("border-bottom-width", $valfield.css("border-bottom-width"));
			$selectorpanel.css("border-left-color", $valfield.css("border-left-color"));
			$selectorpanel.css("border-left-style", $valfield.css("border-left-style"));
			$selectorpanel.css("border-left-width", $valfield.css("border-left-width"));
			$selectorpanel.css("border-right-color", $valfield.css("border-right-color"));
			$selectorpanel.css("border-right-style", $valfield.css("border-right-style"));
			$selectorpanel.css("border-right-width", $valfield.css("border-right-width"));

			$selectorpanel.children().detach();
			$selectorpanel.html($panel);
			
			var width = 600;
			var height = 300;

			if(options.mode == "list")
			{
				unSelectStatus($panel.find("ul li"));

				var id = $keyfield.val();
				if(id != "")
				{
					var ids = id.split(",");
					for(var i = 0 ; i < ids.length ; i++)
					{
						var $item = $panel.find("ul li[key='"+ids[i]+"']");
						selectedStatus($item);
					}
				}

				$selectorpanel.css("min-width", $valfield.innerWidth()+"px");

				width = $valfield.innerWidth();
				height = $panel.outerHeight();
			}

			var position = $valfield.offset();


			var pagewidth = $(document).width();
			var pageheight = $(document).height();
			if(position.left + width > pagewidth)
			{				
				$selectorpanel.css("left", position.left - width + $valfield.outerWidth());
			}
			else
			{
				$selectorpanel.css("left", position.left);
			}
			if(position.top + height > pageheight)
			{				
				if(position.top < height)
				{
					$selectorpanel.css("top", position.top + $valfield.outerHeight() - 3);
				}
				else
				{
					$selectorpanel.css("top", position.top - height - 3);
				}
			}
			else
			{
				$selectorpanel.css("top", position.top + $valfield.outerHeight() - 3);
			}


			$selectorpanel.show();
			$(window).resize();
		}


		$.fn.selection = function(p1, p2)
		{     
			if(typeof p1 == "string")
			{
				var fun = methods[p1];
				if(fun != null)
				{
					return fun($(this), p2);
				}
			}
			else
			{
				var defaults = 
				{
					url: "",
					ismultiple: false,
					mode: 'list',
					cache: true
				}
				
				var options = $.extend({}, defaults, p1);
				var $fields = this;

				var $panel = $('<div/>');
				$panel.data("options", options);

				this.each
				(
					function()
					{
						var $field = $(this).data("joint");
						if($field == null)
						{
							//$field = $('<input type="text" readonly="true">');
							$field = $('<input type="text">');
						}

						$field.attr("style", $(this).attr("style"));
						$field.attr("class", $(this).attr("class"));
						$field.attr("placeholder", $(this).attr("placeholder"));
						$field.show();
						$(this).hide();
						$(this).after($field);

						var title = $(this).attr("title");
						if(title != "")
						{
							$field.val(title);
						}

						$field.data("joint", $(this));
						$(this).data("joint", $field);
						$(this).data("$panel", $panel);
						$field.on("click", {"$panel":$panel}, open);
						if(options.search != null && search)
						{
							$field.on("keyup", {"$panel":$panel}, function(event)
							{
								let value = $(this).val();
								var $panel = event.data.$panel;
								var $items = $panel.find(".item-panel li");
								$.each($items, function(i, item)
								{
									if($(item).text().indexOf(value) == 0)
									{
										$(item).show();
									}
									else
									{
										$(item).hide();
									}
								})
							});
						}
					}
				);


				if(options.mode == "list")
				{
					if(options.items == null)
					{
						var url = options.url;

						var dictionaries = $("body").data("dictionary");
						if(dictionaries == null)
						{
							$("body").data("dictionary", {});
							dictionaries = $("body").data("dictionary");
						}

						var items = dictionaries[url];
						if(items == null)
						{
							$.ajax
							({
								async: false,
								dataType: "json",
								url:url,
								cache:options.cache,
								success:function(data) 
								{
									items = data;
									dictionaries[url] = items;
								}
							});
						}
					}
					else
					{
						items = options.items;
					}

					var $items = $('<ul class="item-panel"/>');
					$items.data("items", items);
					$.each(items, function(i, item)
					{
						var $item = $('<li key="'+item.key+'">'+item.value+'</li>');
						$item.on("click", {$panel:$panel, item:item}, clickitem);
						$item.on("mouseout", function()
						{
							if($(this).attr("isselect") == null)
							{
								$(this).css("background-color", "");
							}
						});
						$item.on("mouseover", function()
						{
							if($(this).attr("isselect") == null)
							{
								$(this).css("background-color", "#e4efff");
							}
						});
						$items.append($item);
					});
					$panel.html($items);
				}

				$(document).mousedown
				(
					function(e)
					{
						try
						{
							if($(e.target).closest("#selector-panel").size() == 0)
							{
								$("#selector-panel").hide();
							}
						}
						catch(e)
						{
							
						}
					}
				);
			}
		};  

		var methods =
		{
			setId:function($obj, id)
			{
				var $panel = $obj.data("$panel");
				var options = $panel.data("options");
				if(options.mode == "list")
				{
					var $items = $panel.find("ul");
					var items = $items.data("items");
					var values = [];
					var ids = id.split(",");
					for(var i = 0 ; i < ids.length ; i++)
					{
						$.each(items, function(j, item)
						{
							if(ids[i] == item.key)
							{
								values.push(item.value);
							}
						});
					}
					
					$obj.val(id);
					var $field = $obj.data("joint");
					if($field != null)
					{
						$field.val(values.join(","));
					}
				}
				else if(options.mode == "tree")
				{
				}
			}
		};
	}
)
(jQuery);
