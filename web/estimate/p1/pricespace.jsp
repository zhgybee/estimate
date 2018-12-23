<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
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
	double fudong = NumberUtils.toDouble(request.getParameter("fudong"), 0.2);

	
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
		
		//Data limits = datasource.find("select MODEL, PRICE, (VOLUME * "+(1 + fudong)+" * "+ratio+") as MAX, (VOLUME * "+(1 - fudong)+" * "+ratio+") as MIN from T_TOTAL_SALES where CREATE_USER_ID = ? and year = ? group by MODEL", usercode, String.valueOf(year - 1));
		
		Data limits = datasource.find("select T_CURRITEMS.MODEL, T_CURRITEMS.PRICE, TS.MAX, TS.MIN from T_CURRITEMS left join (select MODEL, VOLUME, (VOLUME * "+(1 + fudong)+" * "+ratio+") as MAX, (VOLUME * "+(1 - fudong)+" * "+ratio+") as MIN from T_TOTAL_SALES where CREATE_USER_ID = ? and year = ? group by MODEL) TS on T_CURRITEMS.MODEL = TS.MODEL where T_CURRITEMS.CREATE_USER_ID = ? and T_CURRITEMS.YEAR = ? order by T_CURRITEMS.PRICE, SORT", 
						usercode, String.valueOf(year - 1), usercode, String.valueOf(year));
		
		
		Data insidemodeltatios = datasource.find("select a.MODEL, a.YEAR, a.VOLUME, b.TOTAL, cast(a.VOLUME as double) / cast(b.TOTAL as double) as 'RATIO' from T_TOTAL_SALES a left join (select YEAR, sum(VOLUME) as 'TOTAL' from T_TOTAL_SALES where ISINSIDE = '1' group by YEAR) b on a.YEAR = b.YEAR where a.ISINSIDE = '1' and a.YEAR = ?", String.valueOf(year - 1));


		String[] brandchangers = StringUtils.split( StringUtils.defaultString(request.getParameter("brandchangers"), ""), ",");
		String[] brandlowers = StringUtils.split( StringUtils.defaultString(request.getParameter("brandlowers"), ""), ",");
		String[] branduppers = StringUtils.split( StringUtils.defaultString(request.getParameter("branduppers"), ""), ",");
		
		Map<String, String[]> changers = new HashMap<String, String[]>();
		//设置某个规格的上下限
		if(brandchangers.length != 0 && brandchangers.length == brandlowers.length && brandlowers.length == branduppers.length)
		{
			for(int i = 0 ; i < brandchangers.length ; i++)
			{
				String brand = brandchangers[i];
				String lower = brandlowers[i];
				String upper = branduppers[i];
				
				changers.put(brand, new String[]{lower, upper});
			}
		}

		Map<String, Integer> modelminvolumes = null;
		
		double insideratio = NumberUtils.toDouble(request.getParameter("insideratio"), 0);
		if(insideratio != 0)
		{
			modelminvolumes = new HashMap<String, Integer>();
			double insidetotalvolume = volumetarget * (insideratio / 100);
			for(Datum insidemodeltatio : insidemodeltatios)
			{
				modelminvolumes.put(insidemodeltatio.getString("MODEL"), new Double(Math.ceil(insidetotalvolume * insidemodeltatio.getDouble("RATIO"))).intValue());
			}
		}
		
		for(Datum limit : limits)
		{
			String model = limit.getString("MODEL");
			String[] values = changers.get(model);
			if(values != null)
			{
				limit.put("MIN", values[0]);
				limit.put("MAX", values[1]);
			}
			else
			{
				if(modelminvolumes != null)
				{
					Integer newmin = modelminvolumes.get(model);
					if(newmin != null)
					{
						double min = limit.getDouble("MIN");
						double max = limit.getDouble("MAX");
						if( min < newmin && newmin < max)
						{
							limit.put("MIN", newmin);
						}
					}
				}
			}
		}
		
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
		
		for(Datum item : items)
		{
			double min = item.getDouble("MIN");
			double max = item.getDouble("MAX");
			
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
		}
		for(Datum item : items)
		{
			JSONObject element = new JSONObject();
			element.put("pricelower", item.getDouble("MIN"));
			element.put("priceupper", item.getDouble("MAX"));
			if(volumetarget != 0)
			{
				BigDecimal decimal = new BigDecimal( item.getDouble("GROUPMIN") / volumetarget * 100 );
				element.put("volumelower", decimal.setScale(3, BigDecimal.ROUND_UP).doubleValue());
				
				decimal = new BigDecimal( item.getDouble("GROUPMAX") / volumetarget * 100 );
				element.put("volumeupper", decimal.setScale(3, BigDecimal.ROUND_DOWN).doubleValue());
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