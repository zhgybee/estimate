<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.estimate.datasource.Data"%>
<%@page import="java.text.DecimalFormat"%>
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
	
	int year = NumberUtils.toInt(request.getParameter("year"), 2018);
	String month = StringUtils.defaultString(request.getParameter("month"), "1");
	
	Data rows = null;
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);
		DataSource datasource = new DataSource(connection);	
		
		rows = datasource.find("select *, (PRICE - COST) as 'PROFIT' from T_SELECTED_PLAN where CREATE_USER_ID = ? and YEAR = ? order by GROUPNAME, PRICE", usercode, String.valueOf(year));
		message.data.put("ROWS", rows);	
		
		
		Map<String, Map<String, String>> arearatios = new HashMap<String, Map<String, String>>();
		//以往三年每个规格区域销量在全年销量中的占比
		Data areaitems = datasource.find("select a.MODEL, a.AREA, cast(MODELTOTAL as double) / cast(TOTAL as double) as RATIO from (select MODEL, AREA, sum(VOLUME * PRICE) as 'MODELTOTAL' from T_SALES where year = ? or year = ? or year = ? group by MODEL, AREA order by AREA, MODEL) a left join (select MODEL, sum(VOLUME * PRICE) as 'TOTAL' from T_SALES where year = ? or year = ? or year = ? group by MODEL order by MODEL) b on a.MODEL = b.MODEL", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3));
		for(Datum areaitem : areaitems)
		{
			String model = areaitem.getString("MODEL");
			String area = areaitem.getString("AREA");
			Map<String, String> arearatio = arearatios.get(model);
			if(arearatio == null)
			{
				arearatio = new HashMap<String, String>();
				arearatios.put(model, arearatio);
			}
			arearatio.put(area, areaitem.getString("RATIO"));
		}				
		message.data.put("AREARATIOS", arearatios);

		Map<String, String> areatotalratios = new HashMap<String, String>();
		
		
		//以往3年区域销售量在全年销售量中的占比
		Data areatotalitems = datasource.find("select AREA, sum(VOLUME * PRICE) as 'AREATOTAL', (select sum(VOLUME * PRICE) from T_SALES where year = ? or year = ? or year = ?) as 'TOTAL' from T_SALES where year = ? or year = ? or year = ? group by AREA order by AREA", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3));
		for(Datum areatotalitem : areatotalitems)
		{
			String area = areatotalitem.getString("AREA");
			areatotalratios.put(area, String.valueOf(areatotalitem.getDouble("AREATOTAL") / areatotalitem.getDouble("TOTAL")));
		}				
		message.data.put("AREATOTALRATIOS", areatotalratios);
		
		
		
		
		
		Data areas = datasource.find("select AREA from T_SALES group by AREA");
		Map<String, Map<String, Map<String, String>>> areamonthratios = new HashMap<String, Map<String, Map<String, String>>>();
		Map<String, Map<String, String>> areamonthtotalratios = new HashMap<String, Map<String, String>>();
		
		for(Datum area : areas)
		{
			String areaname = area.getString("AREA");
		

			Map<String, Map<String, String>> monthratios = new HashMap<String, Map<String, String>>();
			Data monthitems = datasource.find("select a.MODEL, a.MONTH, cast(MODELTOTAL as double) / cast(TOTAL as double) as RATIO from (select MODEL, MONTH, sum(VOLUME * PRICE) as 'MODELTOTAL' from T_SALES where (year = ? or year = ? or year = ?) and AREA = ? group by MODEL, MONTH order by MONTH, MODEL) a left join (select MODEL, sum(VOLUME * PRICE) as 'TOTAL' from T_SALES where (year = ? or year = ? or year = ?) and AREA = ? group by MODEL order by MODEL) b on a.MODEL = b.MODEL", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), areaname, String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), areaname);

			for(Datum monthitem : monthitems)
			{
				String model = monthitem.getString("MODEL");
				String currmonth = monthitem.getString("MONTH");
				Map<String, String> monthratio = monthratios.get(model);
				if(monthratio == null)
				{
					monthratio = new HashMap<String, String>();
					monthratios.put(model, monthratio);
				}
				monthratio.put(currmonth, monthitem.getString("RATIO"));
			}
			
			Map<String, String> monthtotalratios = new HashMap<String, String>();
			Data monthtotalitems = datasource.find("select MONTH, sum(VOLUME * PRICE) as 'MONTHTOTAL', (select sum(VOLUME * PRICE) from T_SALES where (year = ? or year = ? or year = ?) and AREA = ?) as 'TOTAL' from T_SALES where (year = ? or year = ? or year = ?) and AREA = ? group by MONTH order by MONTH ", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), areaname, String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), areaname);
			for(Datum monthtotalitem : monthtotalitems)
			{
				String currmonth = monthtotalitem.getString("MONTH");
				monthtotalratios.put(currmonth, String.valueOf(monthtotalitem.getDouble("MONTHTOTAL") / monthtotalitem.getDouble("TOTAL")));
			}			
			
			areamonthratios.put(areaname, monthratios);
			areamonthtotalratios.put(areaname, monthtotalratios);

		}
		

		message.data.put("AREAMONTHRATIOS", areamonthratios);
		message.data.put("AREAMONTHTOTALRATIOS", areamonthtotalratios);		
		
		
		Datum fixedcost = null;
		
		Data fixedcosts = datasource.find("select * from T_CONFIG where YEAR = ? and MONTH = ?", String.valueOf(year), month);
		if(fixedcosts.size() > 0)
		{
			fixedcost = fixedcosts.get(0);		
		}
		else
		{
			message.message(ServiceMessage.SUCCESS, month+"月固定费用未上传，将影响计算结果。");
			fixedcost = new Datum();
			fixedcost.put("YEAR", year);
			fixedcost.put("MONTH", month);
			fixedcost.put("CONTENT", "{}");
		}
		
		if(fixedcost != null)
		{
			message.data.put("FIXEDCOST", fixedcost);
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
