$(function()
{
	var cookiename = $.cookie('nest-name');
	if(cookiename != null)
	{
		$("#name").val(cookiename);
	}

	var cookiepassword = $.cookie('nest-password');
	if(cookiepassword != null)
	{
		$("#password").val(cookiepassword);
	}

	$.getJSON
	(
		"theme.json",
		function(themes)
		{
			var $theme = $("#theme");
			for(var i = 0 ; i < themes.length ; i++)
			{
				var theme = themes[i]
				$theme.append('<option value="'+theme.code+'">'+theme.title+'</option>');

				var cookietheme = $.cookie('nest-theme');
				if(cookietheme != null)
				{
					$("#theme").val(cookietheme);
				}
			}
		}
	);

	$('#login-form').ajaxForm();

	$(".textedit").keydown
	(
		function(event)
		{
			if(event.which == 13)
			{
				$("#login-button").click();
			}
		}
	);
	
	$("#name").focus();

	var cookiememorization = $.cookie('nest-memorization');
	if(cookiememorization != null)
	{
		$("#memorization i").attr("isselect", "1");
		$("#memorization i").attr("class", "fa fa-check-square-o");
	}
});

function login(theme)
{
	$('#login-form').ajaxSubmit
	(
		function(response)
		{
			response = $.parseJSON(response);
			if(response.STATUS == "-1")
			{
				$("#error-text").append(response.MESSAGES.join("")+"<br/>");
				$("#error-text").slideDown("fast");
			}
			else if(response.STATUS == "1")
			{
				var status = $("#memorization i").attr("isselect");
				if(status == "1")
				{
					$.cookie('nest-name', $("#name").val(), { expires: 365 });
					$.cookie('nest-password', $("#password").val(), { expires: 365 });
					$.cookie('nest-theme', $("#theme").val(), { expires: 365 });
					$.cookie('nest-memorization', "1", { expires: 365 });
				}
				else
				{
					$.cookie('nest-name', null);
					$.cookie('nest-password', null);
					$.cookie('nest-theme', null);
					$.cookie('nest-memorization', null);
				}
				if(theme == null)
				{
					theme = $("#theme").val();
				}
				window.location.href = '../app.html'; 
			}
		}
	);
}

function memorization()
{
	var icon = $("#memorization i");
	var status = icon.attr("isselect");
	if(status == "0")
	{
		icon.attr("isselect", "1");
		icon.attr("class", "fa fa-check-square-o");
	}
	else
	{
		icon.attr("isselect", "0");
		icon.attr("class", "fa fa-square");
	}
}