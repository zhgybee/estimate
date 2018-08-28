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
	
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		Data groups = datasource.find("select max(YEAR) as 'YEAR' from T_TOTAL_SALES where CREATE_USER_ID = ? group by YEAR", usercode);
		for(Datum group : groups)
		{
			JSONObject item = new JSONObject();
			item.put("key", group.getString("YEAR"));
			item.put("value", group.getString("YEAR"));
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