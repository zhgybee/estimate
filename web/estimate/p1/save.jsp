<%@page import="java.util.Calendar"%>
<%@page import="com.estimate.utils.SystemUtils"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.estimate.SalesData"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.estimate.datasource.Data"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="com.estimate.datasource.Datum"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page import="com.estimate.SessionUser"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

	
<%
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	String usercode = sessionuser.getId();

	ServiceMessage message = new ServiceMessage();
	int year = NumberUtils.toInt(request.getParameter("year"), 2018);
	

	Set<String> sqls = new HashSet<String>();
	JSONArray rows = new JSONArray(request.getParameter("rows"));

	for(int j = 0 ; j < rows.length() ; j++)
	{
		JSONObject row = rows.getJSONObject(j);	
		sqls.add("insert into T_SELECTED_PLAN(ID, YEAR, GROUPNAME, GROUPVOLUME, BRAND, MODEL, MAX, MIN, REMAX, REMIN, PRICE, COST, X, ISINSIDE, PRODUCER, CREATE_USER_ID, CREATE_DATE) values('"+
		SystemUtils.uuid()+"', '"+year+"', '"+row.optString("GROUPNAME")+"', '"+row.optString("GROUPVOLUME")+"', '"+row.optString("BRAND")+"', '"+row.optString("MODEL")+"', '"+row.optString("MAX")+"', '"+row.optString("MIN")+"', '"+row.optString("REMAX")+"', '"+row.optString("REMIN")+"', '"+row.optString("PRICE")+"', '"+row.optString("COST")+"', '"+row.optString("X")+"', '"+row.optString("ISINSIDE")+"', '"+row.optString("PRODUCER")+"', '"+usercode+"', '"+SystemUtils.toString(Calendar.getInstance())+"')");
	}

	if(sqls.size() > 0)
	{
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);		
			connection.setAutoCommit(false);
			DataSource dataSource = new DataSource(connection);

			dataSource.execute("delete from T_SELECTED_PLAN where YEAR = '"+year+"' and CREATE_USER_ID = '"+usercode+"'");
			for(String sql : sqls)
			{
				dataSource.execute(sql);
			}		
			connection.commit();		
		}
		catch (Exception e)
		{
			e.printStackTrace();
			if(connection != null)
			{
				connection.rollback();
			}
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
	}
	out.println(message);
%>
