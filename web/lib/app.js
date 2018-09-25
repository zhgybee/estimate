var app = {};
(function (app) 
{

	app.pre0 = function(number)
	{
		return number.toFixed(2)
	}

	app.pre1 = function(number)
	{
		return (number / 10000).toFixed(2);
		//return number.toFixed(2)
	}

	app.pre2 = function(number)
	{
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