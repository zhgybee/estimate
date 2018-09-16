var app = {};
(function (app) 
{

	app.pre1 = function(number)
	{
		return number.toFixed(2)
	}

	app.pre2 = function(number)
	{
		//return number.toFixed(2)
		return Math.round(number)
	}

	app.pre3 = function(number)
	{
		return number.toFixed(2)
	}

	app.isNumber = function(number)
	{
		if(parseFloat(number).toString() == "NaN" ) 
		{
			return false;
		} 
		else
		{
			return true;
		}
	}

	app.isNumberValue = function($fileds)
	{
		var result = null;
		$.each($fileds, function(i, filed)
		{
			if( !app.isNumber($(filed).val()) )
			{
				result = $(filed);
				return false;
			}
		});
		return result;
	}

})(app);