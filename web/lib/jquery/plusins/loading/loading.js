function showLoading() 
{
	var $loading = $("#loading-panel");
	if($loading.length == 0)
	{
		var content = '<div id="loading-panel" style="display:none">';
		content += '<div class="loading-mask"></div>';

		content += '<div class="loading-toast"><img src="'+$.getContextPath()+'/images/loading2.gif"/></div>';
		content += '</div>';
		$("body").append(content);
		$loading = $("#loading-panel");
	}

	var loadimage = $loading.find(".loading-toast");
	if($(document).scrollTop() > 0)
	{
		loadimage.css("left", $(window).outerWidth(true) / 2 - loadimage.width() / 2);
		loadimage.css("top", $(document).scrollTop() + $(window).outerHeight(true) / 2 - loadimage.height() / 2 - 30);
	}
	else
	{
		loadimage.css("left", $(window).outerWidth(true) / 2 - loadimage.width() / 2);
		loadimage.css("top", $(window).outerHeight(true) / 2 - loadimage.height() / 2 - 30);
	}

	$loading.show();
}
function hideLoading() 
{
	var $loading = $("#loading-panel");
	$loading.hide();
}