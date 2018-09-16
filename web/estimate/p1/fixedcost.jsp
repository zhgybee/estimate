

<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.estimate.datasource.Data"%>
<%@page import="java.util.Set"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.estimate.datasource.Datum"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page import="com.estimate.SessionUser"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

	
<%
	int year = NumberUtils.toInt(request.getParameter("year"), 2018);
	
	ServiceMessage message = new ServiceMessage();
	
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		Datum row = datasource.get("select * from T_CONFIG where YEAR = ? and MONTH = ''", String.valueOf(year));

		if(row != null)
		{
			//以往3年区域销售量在全年销售量中的占比
			Data areatotalitems = datasource.find("select AREA, sum(VOLUME * AMOUNT) as 'AREATOTAL', (select sum(VOLUME * AMOUNT) from T_SALES where year = ? or year = ? or year = ?) as 'TOTAL' from T_SALES where year = ? or year = ? or year = ? group by AREA order by AREA", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3));
	
			
			String content = row.getString("CONTENT");	
			
			JSONObject configs = new JSONObject(content);
			
			Set<?> keys = configs.keySet();
			for(Object key : keys)
			{
				JSONObject item = configs.getJSONObject(key.toString());
				double total = item.optDouble("按销量分配数");
				if(total != 0)
				{
					for(Datum areatotalitem : areatotalitems)
					{
						String area = areatotalitem.getString("AREA");
						item.put(area, total * (areatotalitem.getDouble("AREATOTAL") / areatotalitem.getDouble("TOTAL")));
					}	
				}
				item.remove("按销量分配数");
			}
			
			row.put("CONTENT", configs.toString());
		
			message.data.put("row", row);
		}
		else
		{
			message.data.put("row", new JSONObject());
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
		Throwable throwable = ThrowableUtils.getThrowable(e);
		message.message(ServiceMessage.FAILURE, throwable.getMessage());
	}
	finally
	{
		if(connection != null)
		{
			connection.close();
		}
	}
	
	out.println(message);
%>