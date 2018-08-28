package com.estimate.datasource;

import java.util.HashMap;
import java.util.Objects;

import org.apache.commons.lang3.math.NumberUtils;

public class Datum extends HashMap<String, Object>
{
	private static final long serialVersionUID = 6170230575956396503L;
	
	public String getString(String columnName)
	{
		return Objects.toString(get(columnName), "");
	}
	
	public int getInt(String columnName)
	{
		return NumberUtils.toInt(getString(columnName), 0);
	}

	public double getDouble(String columnName)
	{
		return NumberUtils.toDouble(getString(columnName), 0);
	}

	public Data getData(String columnName)
	{
		return (Data)get(columnName);
	}
}







