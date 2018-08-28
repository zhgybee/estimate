package com.estimate.utils;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.UUID;
import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class SystemUtils
{
	public static Calendar toCalendar(String date, String format)
	{
		Calendar calendar = Calendar.getInstance();
		try
		{
			SimpleDateFormat dateformat = new SimpleDateFormat(format);
			calendar.setTime( dateformat.parse(date) );
			return calendar;
		}
		catch (ParseException | NullPointerException e)
		{
			
		}
		return null;
	}
	
	
	public static String toString(Calendar calendar, String format)
	{
        if (calendar != null)
        {
    		SimpleDateFormat dateformat = new SimpleDateFormat(format);
            return dateformat.format(calendar.getTime());
        }
        return null;
	}
	public static String toString(Calendar calendar)
	{
        return toString(calendar, "yyyy-MM-dd");
	}
	
	public static int difference(Calendar c1, Calendar c2, int filed)
	{
		int result = 0;
		if(c1 != null && c2 != null)
		{
			if(filed == Calendar.MONTH)
			{
				int year = c2.get(Calendar.YEAR) - c1.get(Calendar.YEAR);
				int month = c2.get(Calendar.MONTH) - c1.get(Calendar.MONTH);
				result = Math.abs(year * 12 + month);
			}
			else if(filed == Calendar.YEAR)
			{
				int year = c2.get(Calendar.YEAR) - c1.get(Calendar.YEAR);
				result = Math.abs(year);
			}
		}
		return result;
	}
	
	public static Calendar max(Calendar c1, Calendar c2)
	{
		if(c1 != null && c2 != null)
		{
			if(c1.after(c2))
			{
				return c1;
			}
			else
			{
				return c2;
			}
		}
		else
		{
			if(c1 != null)
			{
				return c1;
			}
			else if(c2 != null)
			{
				return c2;
			}
			else
			{
				return Calendar.getInstance();
			}
		}
	}
	public static Calendar min(Calendar c1, Calendar c2)
	{
		if(c1 != null && c2 != null)
		{
			if(c1.before(c2))
			{
				return c1;
			}
			else
			{
				return c2;
			}
		}
		else
		{
			if(c1 != null)
			{
				return c1;
			}
			else if(c2 != null)
			{
				return c2;
			}
			else
			{
				return Calendar.getInstance();
			}
		}
	}
	
	public static Calendar getMinimumDayOfMonth(Calendar calendar)
	{
		if(calendar == null)
		{
			return null;
		}
		else
		{
			Calendar result = (Calendar)calendar.clone();
			result.set(Calendar.DAY_OF_MONTH, 1);
			return result;
		}
	}
	
	public static Calendar getMinimumDayOfNextMonth(Calendar calendar)
	{
		if(calendar == null)
		{
			return null;
		}
		else
		{
			Calendar result = (Calendar)calendar.clone();
			result.add(Calendar.MONTH, 1);
			result.set(Calendar.DAY_OF_MONTH, 1);
			return result;
		}
	}
	
	public static String toString(Exception e)
	{
		String result = "";
		if(e != null)
		{
			StackTraceElement[] elements = e.getStackTrace();
			if(elements.length > 0)
			{
				StackTraceElement element = elements[0];
				result = e.getMessage()+ " : " +e.getClass().getName()+" | "+element.getClassName()+"."+element.getMethodName()+"("+element.getFileName()+":"+element.getLineNumber()+")";
			}
		}
		return result;
	}
	
	public static boolean contains(Calendar calendar, Calendar starttime, Calendar endtime)
	{
		boolean result = false;
		
		if(calendar != null && starttime != null && endtime != null)
		{
			int v1 = calendar.compareTo(starttime);
			int v2 = calendar.compareTo(endtime);
			return (v1 == 0 || v1 == 1) && (v2 == 0 || v2 == -1);
		}
		
		return result;
	}
	
	public static String uuid()
	{
		UUID uuid = UUID.randomUUID();
		return StringUtils.replace(uuid.toString(), "-", "");
	}

	public static JSONObject merge(JSONObject arg1, JSONObject arg2) throws JSONException
	{
		JSONObject result = new JSONObject();

		String[] names = JSONObject.getNames(arg1);
		if(names != null)
		{
			for(String name : names)
			{
				result.put(name, arg1.opt(name));
			}
		}
		
		names = JSONObject.getNames(arg2);
		if(names != null)
		{
			for(String name : names)
			{
				result.put(name, arg2.opt(name));
			}
		}
		
		return result;
	}
	public static boolean contains(JSONArray array, String arg)
	{
		for(int i = 0 ; i < array.length() ; i++)
		{
			if(arg.equals(array.optString(i)))
			{
				return true;
			}
		}
		return false;
	}
	public static double round(int scale, double value)
	{
		return new BigDecimal(value).setScale(scale, BigDecimal.ROUND_HALF_UP).doubleValue();
	}
}
