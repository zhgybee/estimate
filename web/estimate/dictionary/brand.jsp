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

	JSONArray items = new JSONArray();
	int year = NumberUtils.toInt(request.getParameter("year"), 2018);
	
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		Data groups = datasource.find("select T_CURRITEMS.ID, T_CURRITEMS.MODEL, TS.MAX, TS.MIN from T_CURRITEMS left join (select MODEL, max(VOLUME) as MAX, min(VOLUME) as MIN from T_TOTAL_SALES where CREATE_USER_ID = ? and (year = ? or year = ? or year = ?) group by MODEL) TS on T_CURRITEMS.MODEL = TS.MODEL where T_CURRITEMS.CREATE_USER_ID = ? and T_CURRITEMS.YEAR = ? order by sort", 
				usercode, String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), usercode, String.valueOf(year));

		for(Datum group : groups)
		{
			JSONObject item = new JSONObject();
			item.put("key", group.getString("ID"));
			item.put("value", group.getString("MODEL"));
			item.put("max", group.getString("MAX"));
			item.put("min", group.getString("MIN"));
			items.put(item);
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
		Throwable throwable = ThrowableUtils.getThrowable(e);
		JSONObject item = new JSONObject();
		item.put("key", "");
		item.put("value", "获取数据失败（"+throwable.getMessage()+"）");
		items.put(item);
	}
	finally
	{
		if(connection != null)
		{
			connection.close();
		}
	}
	
	out.println(items);
%>