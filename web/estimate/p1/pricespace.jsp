<%@page import="com.estimate.utils.SystemUtils"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.estimate.datasource.Datum"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.estimate.SessionUser"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.datasource.Data"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	String usercode = sessionuser.getId();

	int year = NumberUtils.toInt(request.getParameter("year"));
	double volumetarget = NumberUtils.toDouble(request.getParameter("volumetarget"));
	
	
	JSONArray array = new JSONArray();
	
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		Data rows = datasource.find("select * from T_SALES_RATIO where YEAR = ? order by PRICE", String.valueOf(year - 1));
		
		Datum lastyeartotal = datasource.get("select sum(VOLUME) as 'TOTAL' from T_TOTAL_SALES where year = ?", String.valueOf(year - 1));	
		double lastyearvolumetotal = lastyeartotal.getDouble("TOTAL");
		double ratio = 0;
		if(lastyearvolumetotal != 0)
		{
			ratio = volumetarget / lastyearvolumetotal;	
		}
		
		Data limits = datasource.find("select MODEL, PRICE, (VOLUME * 1.2 * "+ratio+") * 1.04 as MAX, (VOLUME * 0.8 * "+ratio+") as MIN from T_TOTAL_SALES where CREATE_USER_ID = ? and year = ? group by MODEL", usercode, String.valueOf(year - 1));

		Data items = new Data();
		
		for(Datum row : rows)
		{
			double groupratio = SystemUtils.round(2, row.getDouble("GROUPRATIO") * 100);
			if(groupratio > 4)
			{
				items.add(row);
			}
		}

		for(int i = 0 ; i < items.size() ; i++)
		{
			
			Datum item = items.get(i);

			double groupratio = SystemUtils.round(2, item.getDouble("GROUPRATIO") * 100);
			int index = rows.indexOf(item);
			
			if(i == 0)
			{
				item.put("MIN", 0);
			}
			else
			{
				Datum previous = items.get(i - 1);
				double previousgroupratio = SystemUtils.round(2, previous.getDouble("GROUPRATIO") * 100);
				
				int previousindex = rows.indexOf(previous);				
				int space = index - previousindex - 1;
				
				int number = new Long(Math.round(space * (groupratio / (previousgroupratio + groupratio)))).intValue();
				
				item.put("MIN", rows.get(index - number).getDouble("PRICE"));
				previous.put("MAX", rows.get(index - number - 1).getDouble("PRICE"));
				
				if(i == items.size() - 1)
				{
					item.put("MAX", rows.get(rows.size() - 1).getDouble("PRICE"));
				}
				
			}
			
		}
		
		double totalmax = 0;
		double totalmin = 0;
		for(Datum item : items)
		{
			double min = item.getDouble("MIN");
			double max = item.getDouble("MAX");
			double number = 0;
			for(Datum row : rows)
			{
				double price = row.getDouble("PRICE");
				if(min <= price && price <= max)
				{
					number += row.getDouble("SALESRATIO");
				}
			}
			item.put("NUM", number);
			

			double groupmax = 0;
			double groumin = 0;
			for(Datum limit : limits)
			{
				double price = limit.getDouble("PRICE");
				if(min <= price && price <= max)
				{
					groupmax += limit.getDouble("MAX");
					groumin += limit.getDouble("MIN");
				}
			}
			item.put("GROUPMAX", groupmax);
			item.put("GROUPMIN", groumin);
			totalmax += groupmax;
			totalmin += groumin;
			
			
		}

		for(Datum item : items)
		{
			JSONObject element = new JSONObject();
			element.put("pricelower", item.getDouble("MIN"));
			element.put("priceupper", item.getDouble("MAX"));
			if(volumetarget != 0)
			{
				element.put("volumelower", Math.floor(item.getDouble("GROUPMIN") / volumetarget * 100 ));
				element.put("volumeupper", Math.ceil(item.getDouble("GROUPMAX") / volumetarget * 100 ));
			}
			array.put(element);
		}
		
		
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
		Throwable throwable = ThrowableUtils.getThrowable(e);
		JSONObject element = new JSONObject();
		element.put("pricelower", "获取数据失败（"+throwable.getMessage()+"）");
		element.put("priceupper", "");
		element.put("volumelower", "");
		element.put("volumeupper", "");
		array.put(element);
	}
	finally
	{
		if(connection != null)
		{
			connection.close();
		}
	}
	
	out.println(array.toString(3));
%>