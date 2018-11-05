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


	String mode = request.getParameter("mode");

	SessionUser sessionuser = SessionUser.getSessionUser(session);
	String usercode = sessionuser.getId();

	ServiceMessage message = new ServiceMessage();

	int year = NumberUtils.toInt(request.getParameter("year"), 2018);
	String area = StringUtils.defaultString(request.getParameter("area"), "");
	String issurplus = StringUtils.defaultString(request.getParameter("issurplus"), "0");
	
	Map<String, Map<String, String>> monthratios = new HashMap<String, Map<String, String>>();
	Map<String, String> monthtotalratios = new HashMap<String, String>();
	Map<String, String> monthfixedcost = new HashMap<String, String>();
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);
		DataSource datasource = new DataSource(connection);	
		
		
		//以往三年每个规格月销量在全年销量中的占比
		Data monthitems = null;
		if(area.equals(""))
		{
			monthitems = datasource.find("select a.MODEL, a.MONTH, cast(MODELTOTAL as double) / cast(TOTAL as double) as RATIO from (select MODEL, MONTH, sum(VOLUME) as 'MODELTOTAL' from T_SALES where (year = ? or year = ? or year = ?) group by MODEL, MONTH order by MONTH, MODEL) a left join (select MODEL, sum(VOLUME) as 'TOTAL' from T_SALES where (year = ? or year = ? or year = ?) group by MODEL order by MODEL) b on a.MODEL = b.MODEL", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3));
		}
		else
		{
			monthitems = datasource.find("select a.MODEL, a.MONTH, cast(MODELTOTAL as double) / cast(TOTAL as double) as RATIO from (select MODEL, MONTH, sum(VOLUME) as 'MODELTOTAL' from T_SALES where (year = ? or year = ? or year = ?) and AREA = ? group by MODEL, MONTH order by MONTH, MODEL) a left join (select MODEL, sum(VOLUME) as 'TOTAL' from T_SALES where (year = ? or year = ? or year = ?) and AREA = ? group by MODEL order by MODEL) b on a.MODEL = b.MODEL", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), area, String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), area);
		}
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

		
		//以往3年月销售量在全年销售量中的占比
		Data monthtotalitems = null;
		if(area.equals(""))
		{
			monthtotalitems = datasource.find("select MONTH, sum(VOLUME * AMOUNT) as 'MONTHTOTAL', (select sum(VOLUME * AMOUNT) from T_SALES where (year = ? or year = ? or year = ?)) as 'TOTAL' from T_SALES where (year = ? or year = ? or year = ?) group by MONTH order by MONTH", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3));
		}
		else
		{
			monthtotalitems = datasource.find("select MONTH, sum(VOLUME * AMOUNT) as 'MONTHTOTAL', (select sum(VOLUME * AMOUNT) from T_SALES where (year = ? or year = ? or year = ?) and AREA = ?) as 'TOTAL' from T_SALES where (year = ? or year = ? or year = ?) and AREA = ? group by MONTH order by MONTH", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), area, String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), area);
		}
		for(Datum monthtotalitem : monthtotalitems)
		{
			String month = monthtotalitem.getString("MONTH");
			monthtotalratios.put(month, String.valueOf(monthtotalitem.getDouble("MONTHTOTAL") / monthtotalitem.getDouble("TOTAL")));
		}				
		message.data.put("MONTHTOTALRATIOS", monthtotalratios);
		
		Data fixedcosts = datasource.find("select * from T_CONFIG where YEAR = ?", String.valueOf(year));
		for(Datum fixedcost : fixedcosts)
		{
			String month = fixedcost.getString("MONTH");
			monthfixedcost.put(month, fixedcost.getString("CONTENT"));
		}		

		message.data.put("FIXEDCOST", monthfixedcost);
		
		if(issurplus.equals("1"))
		{
			//如果是取剩余月份，那么表格中的去年比较量，也是从去年的相应月份中取值
			String monthnames = StringUtils.defaultString(request.getParameter("monthnames"), "");
			
			Data monthtotalvolumns = null;
			
			if(area.equals(""))
			{
				monthtotalvolumns = datasource.find("select MODEL, sum(VOLUME) as 'VOLUME' from T_SALES where month in ("+monthnames+") and year = ? group by MODEL", String.valueOf(year - 1));
			}
			else
			{
				monthtotalvolumns = datasource.find("select MODEL, sum(VOLUME) as 'VOLUME' from T_SALES where month in ("+monthnames+") and year = ? and AREA = ? group by MODEL", String.valueOf(year - 1), area);
			}
			
			Map<String, Integer> monthtotalvolumnmap = new HashMap<String, Integer>();
			for(Datum monthtotalvolumn : monthtotalvolumns)
			{
				monthtotalvolumnmap.put(monthtotalvolumn.getString("MODEL"), monthtotalvolumn.getInt("VOLUME"));
			}
			
			message.data.put("MONTHTOTALVOLUMN", monthtotalvolumnmap);
		}
		
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
