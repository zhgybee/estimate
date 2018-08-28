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

	DecimalFormat format = new DecimalFormat("#.##");
	ServiceMessage message = new ServiceMessage();
	
	String type = StringUtils.defaultString(request.getParameter("type"), "1");
	int year = NumberUtils.toInt(request.getParameter("year"), 2018);
	
	Data rows = null;
	Map<String, Map<String, String>> monthratios = new HashMap<String, Map<String, String>>();
	Map<String, String> monthtotalratios = new HashMap<String, String>();
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);
		DataSource datasource = new DataSource(connection);	
		
		rows = datasource.find("select * from T_SELECTED_PLAN where CREATE_USER_ID = ? and YEAR = ? order by GROUPNAME, PRICE", usercode, String.valueOf(year));
		message.data.put("ROWS", rows);	
			

		Data monthitems = datasource.find("select a.MODEL, a.MONTH, cast(MODELTOTAL as double) / cast(TOTAL as double) as RATIO from (select MODEL, MONTH, sum(VOLUME) as 'MODELTOTAL' from T_SALES where (year = ? or year = ? or year = ?) group by MODEL, MONTH order by MONTH, MODEL) a left join (select MODEL, sum(VOLUME) as 'TOTAL' from T_SALES where (year = ? or year = ? or year = ?) group by MODEL order by MODEL) b on a.MODEL = b.MODEL", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3));
		for(Datum monthitem : monthitems)
		{
			String model = monthitem.getString("MODEL");
			String month = monthitem.getString("MONTH");
			Map<String, String> monthratio = monthratios.get(model);
			if(monthratio == null)
			{
				monthratio = new HashMap<String, String>();
				monthratios.put(model, monthratio);
			}
			monthratio.put(month, monthitem.getString("RATIO"));
		}
		message.data.put("MONTHRATIOS", monthratios);
		
		
		Data monthtotalitems = datasource.find("select MONTH, sum(VOLUME * AMOUNT) as 'MONTHTOTAL', (select sum(VOLUME * AMOUNT) from T_SALES where (year = ? or year = ? or year = ?)) as 'TOTAL' from T_SALES where (year = ? or year = ? or year = ?) group by MONTH order by MONTH", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3));
		for(Datum monthtotalitem : monthtotalitems)
		{
			String month = monthtotalitem.getString("MONTH");
			monthtotalratios.put(month, String.valueOf(monthtotalitem.getDouble("MONTHTOTAL") / monthtotalitem.getDouble("TOTAL")));
		}		
		message.data.put("MONTHTOTALRATIOS", monthtotalratios);		
		
	}
	catch(Exception e)
	{
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
