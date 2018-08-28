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

	DecimalFormat format = new DecimalFormat("#.##");
	ServiceMessage message = new ServiceMessage();
	if(mode.equals("1"))
	{
		int year = NumberUtils.toInt(request.getParameter("year"), 2018);
		double growth = NumberUtils.toDouble(request.getParameter("growth"), 0);

		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);	
			DataSource datasource = new DataSource(connection);	

			double total = 0;

			Datum row = datasource.get("select sum(VOLUME) as VOLUME from T_TOTAL_SALES where CREATE_USER_ID = ? and year = ?", usercode, String.valueOf(year - 1));
			if(!row.getString("VOLUME").equals(""))
			{
				double sum = NumberUtils.toDouble(new BigDecimal( row.getString("VOLUME") ).toString());
				total += sum * (NumberUtils.toDouble(request.getParameter("weight3"), 0) / 100);
			}
			row = datasource.get("select sum(VOLUME) as VOLUME from T_TOTAL_SALES where CREATE_USER_ID = ? and year = ?", usercode, String.valueOf(year - 2));
			if(!row.getString("VOLUME").equals(""))
			{
				double sum = NumberUtils.toDouble(new BigDecimal( row.getString("VOLUME") ).toString());
				total += sum * (NumberUtils.toDouble(request.getParameter("weight2"), 0) / 100);
			}

			row = datasource.get("select sum(VOLUME) as VOLUME from T_TOTAL_SALES where CREATE_USER_ID = ? and year = ?", usercode, String.valueOf(year - 3));
			if(!row.getString("VOLUME").equals(""))
			{
				double sum = NumberUtils.toDouble(new BigDecimal( row.getString("VOLUME") ).toString());
				total += sum * (NumberUtils.toDouble(request.getParameter("weight1"), 0) / 100);
			}
			double result = total * (1 + growth / 100);

			message.data.put("volume", new BigDecimal(format.format(result)).toString());
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
	}
	else if(mode.equals("2"))
	{
		String type = StringUtils.defaultString(request.getParameter("type"), "1");
		int year = NumberUtils.toInt(request.getParameter("year"), 2018);
		Data rows = null;
		Data insidemodeltatios = null;
		Map<String, Map<String, String>> monthratios = new HashMap<String, Map<String, String>>();
		Map<String, Map<String, String>> arearatios = new HashMap<String, Map<String, String>>();
		Map<String, String> monthtotalratios = new HashMap<String, String>();
		Map<String, String> areatotalratios = new HashMap<String, String>();
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);
			DataSource datasource = new DataSource(connection);	
			
			if(type.equals("1") || type.equals("2"))
			{
				rows = datasource.find("select T_CURRITEMS.ID, T_CURRITEMS.COST, T_CURRITEMS.BRAND, T_CURRITEMS.ISINSIDE, T_CURRITEMS.MODEL, T_CURRITEMS.PRICE, T_CURRITEMS.PROFIT, TS.MAX, TS.MIN from T_CURRITEMS left join (select MODEL, max(VOLUME) as MAX, min(VOLUME) as MIN from T_TOTAL_SALES where CREATE_USER_ID = ? and (year = ? or year = ? or year = ?) group by MODEL) TS on T_CURRITEMS.MODEL = TS.MODEL where T_CURRITEMS.CREATE_USER_ID = ? and T_CURRITEMS.YEAR = ? order by T_CURRITEMS.PRICE, SORT", 
						usercode, String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), usercode, String.valueOf(year));
			}
			else if(type.equals("3"))
			{
				rows = datasource.find("select * from T_SELECTED_PLAN where CREATE_USER_ID = ? and YEAR = ? order by GROUPNAME, PRICE", usercode, String.valueOf(year));
				message.data.put("ROWS", rows);	
			}
			
			//上一年条均价
			Datum averageprices = datasource.get("select sum(PRICE * VOLUME) / sum(VOLUME) as 'AVERAGEPRICE' from T_TOTAL_SALES where year = ?", String.valueOf(year - 1));
			message.data.put("LASTYEARAVERAGEPRICE", averageprices.getDouble("AVERAGEPRICE"));

			
			//以往三年每个规格区域销量在全年销量中的占比
			Data areaitems = datasource.find("select a.MODEL, a.AREA, cast(MODELTOTAL as double) / cast(TOTAL as double) as RATIO from (select MODEL, AREA, sum(VOLUME) as 'MODELTOTAL' from T_SALES where year = ? or year = ? or year = ? group by MODEL, AREA order by AREA, MODEL) a left join (select MODEL, sum(VOLUME) as 'TOTAL' from T_SALES where year = ? or year = ? or year = ? group by MODEL order by MODEL) b on a.MODEL = b.MODEL", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3));
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

			//以往3年区域销售量在全年销售量中的占比
			Data areatotalitems = datasource.find("select AREA, sum(VOLUME * AMOUNT) as 'AREATOTAL', (select sum(VOLUME * AMOUNT) from T_SALES where year = ? or year = ? or year = ?) as 'TOTAL' from T_SALES where year = ? or year = ? or year = ? group by AREA order by AREA", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3));
			for(Datum areatotalitem : areatotalitems)
			{
				String area = areatotalitem.getString("AREA");
				areatotalratios.put(area, String.valueOf(areatotalitem.getDouble("AREATOTAL") / areatotalitem.getDouble("TOTAL")));
			}				
			message.data.put("AREATOTALRATIOS", areatotalratios);
			
			
			insidemodeltatios = datasource.find("select a.MODEL, a.YEAR, a.VOLUME, b.TOTAL, cast(a.VOLUME as double) / cast(b.TOTAL as double) as 'RATIO' from T_TOTAL_SALES a left join (select YEAR, sum(VOLUME) as 'TOTAL' from T_TOTAL_SALES where ISINSIDE = '1' group by YEAR) b on a.YEAR = b.YEAR where a.ISINSIDE = '1' and a.YEAR = ?", String.valueOf(year - 1));
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
		
		if(type.equals("1") || type.equals("2"))
		{
			boolean isrun = true;
			int index = 0;
			while(isrun)
			{
				Data clone = new Data();
				for(Datum row : rows)
				{
					clone.add((Datum)row.clone());
				}
				int status = startor(message, request, clone, insidemodeltatios).status;
				if( status == 1 )
				{
					isrun = false;
				}
				if(index == 100)
				{
					isrun = false;
				}
				index++;
			}
		}
		
	}
	out.println(message);
%>

<%!
	public ServiceMessage startor(ServiceMessage message, HttpServletRequest request, Data rows, Data insidemodeltatios) throws Exception
	{
		int status = ServiceMessage.SUCCESS;
		
		DecimalFormat format = new DecimalFormat("#.##");
		String type = StringUtils.defaultString(request.getParameter("type"), "1");
		
		double volumetarget = NumberUtils.toDouble(request.getParameter("volumetarget"));
		double profittarget = NumberUtils.toDouble(request.getParameter("profittarget"));
		
		if(rows != null)
		{
			String[] brandchangers = StringUtils.split( StringUtils.defaultString(request.getParameter("brandchangers"), ""), ",");
			String[] brandlowers = StringUtils.split( StringUtils.defaultString(request.getParameter("brandlowers"), ""), ",");
			String[] branduppers = StringUtils.split( StringUtils.defaultString(request.getParameter("branduppers"), ""), ",");
			double growth = NumberUtils.toDouble(request.getParameter("growth"), 0);
	
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

			//设置省内烟中每个规格占比
			Map<String, Integer> modelminvolumes = null;
			double insideratio = NumberUtils.toDouble(request.getParameter("insideratio"), 0);
			if(insideratio != 0)
			{
				modelminvolumes = new HashMap<String, Integer>();
				double insidetotalvolume = volumetarget * (insideratio / 100);
				for(Datum insidemodeltatio : insidemodeltatios)
				{
					double ratio = insidemodeltatio.getDouble("RATIO");
					modelminvolumes.put(insidemodeltatio.getString("MODEL"), new Double(Math.ceil(insidetotalvolume * ratio)).intValue());
				}
			}
			
			//根据增长率自动调整上限，如果手工设置了上下限，则参照手工设置
			for(Datum row : rows)
			{
				row.put("MAX", format.format( Math.ceil( row.getDouble("MAX") * (1 + (growth / 100)) ) ));
				
				String model = row.getString("MODEL");
				String[] values = changers.get(model);
				if(values != null)
				{
					row.put("MIN", values[0]);
					row.put("MAX", values[1]);
				}
				else
				{
					if(modelminvolumes != null)
					{
						Integer newmin = modelminvolumes.get(model);
						int min = row.getInt("MIN");
						int max = row.getInt("MAX");
						if(newmin != null)
						{
							if( min < newmin && newmin < max)
							{
								row.put("MIN", newmin);
							}
						}
					}
				}
			}
			
			
			for(Datum row : rows)
			{
				row.put("REMIN", row.getDouble("MIN"));
				row.put("REMAX", row.getDouble("MAX"));
			}
			
			//分组计算
			String[] grouppricelowers = StringUtils.split( StringUtils.defaultString(request.getParameter("grouppricelowers"), ""), ",");
			String[] grouppriceuppers = StringUtils.split( StringUtils.defaultString(request.getParameter("grouppriceuppers"), ""), ",");
			String[] groupvolumelowers = StringUtils.split( StringUtils.defaultString(request.getParameter("groupvolumelowers"), ""), ",");
			String[] groupvolumeuppers = StringUtils.split( StringUtils.defaultString(request.getParameter("groupvolumeuppers"), ""), ",");
	
			//每组数据
			Data groups = new Data();	
			//是否需要分组计算
			if(grouppricelowers.length != 0 && grouppricelowers.length == grouppriceuppers.length && grouppriceuppers.length == groupvolumelowers.length && groupvolumelowers.length == groupvolumeuppers.length)
			{
				for(int i = 0 ; i < grouppricelowers.length ; i++)
				{
					double grouppricelower = NumberUtils.toDouble(grouppricelowers[i], 0);
					double grouppriceupper = NumberUtils.toDouble(grouppriceuppers[i], 0);
					double groupvolumelower = NumberUtils.toDouble(groupvolumelowers[i], 0);
					double groupvolumeupper = NumberUtils.toDouble(groupvolumeuppers[i], 0);
	
					Data grouprows = new Data();
					double groupprofitlower = 1000;
					double groupprofitupper = 0;
					for(Datum row : rows)
					{
						if(grouppricelower <= row.getDouble("PRICE") && row.getDouble("PRICE") <= grouppriceupper)
						{
							grouprows.add(row);
							double profit = row.getDouble("PROFIT");
							
							groupprofitlower = Math.min(groupprofitlower, profit);
							groupprofitupper = Math.max(groupprofitupper, profit);
						}
					}
					
					//设置销量计算组合，根据传递的值，设置销量占比的上下限。销量占比去除小数点
					Datum group = new Datum();
					group.put("GROUPNAME", grouppricelower+"-"+grouppriceupper);
					group.put("PRICELOWER", grouppricelower);
					group.put("PRICEUPPER", grouppriceupper);
					group.put("PROFITLOWER", groupprofitlower);
					group.put("PROFITUPPER", groupprofitupper);
					group.put("MIN", groupvolumelower * 1000);
					group.put("MAX", groupvolumeupper * 1000);
					group.put("ROWS", grouprows);
					groups.add(group);
				}
				
				//设置销量占比总和为100000，根据每组上下限推算每组的数据

				SalesData groupsdata = new SalesData(groups, 100000, -1);
				groupsdata.startup();
				groups = groupsdata.rows;

				//销量分解后的总利润
				for(Datum group : groups)
				{
					
					//得到本组数据的销量
					double volumeratio = group.getDouble("X");;
					double groupvolume = (volumeratio / 1000) / 100 * volumetarget;
					
					Data grouprows = group.getData("ROWS");
					
					SalesData groupdata = new SalesData(grouprows, groupvolume, -1);
					groupdata.startup();
					if(groupdata.status > 0)
					{
					}
					else
					{
						status = groupdata.status;
					}
					message.message(groupdata.status, "");
					
					group.put("GROUPVOLUME", groupvolume);

					group.put("MAX", new Double(groupdata.getMaxTotalProfit()).intValue());
					group.put("MIN", new Double(groupdata.getMinTotalProfit()).intValue());
					
					groupdata.sort(1);
				}

				
				if(type.equals("2"))
				{			
					SalesData groupsdata2 = new SalesData(groups, profittarget, -1);
					groupsdata2.clearVolumes();
					groupsdata2.startup();
					
					for(Datum group : groups)
					{
						double groupvolume = group.getDouble("GROUPVOLUME");	
						double grouptargetprofit = group.getDouble("X");
						
						Data grouprows = group.getData("ROWS");
						SalesData groupdata = new SalesData(grouprows, groupvolume, grouptargetprofit);
						groupdata.clearVolumes();
						groupdata.startup();
						if(groupdata.status > 0)
						{
						}
						else
						{
							status = groupdata.status;
						}
					}
					
				}
			}
			else
			{
				SalesData salesdata = null;
				if(type.equals("1"))
				{
					salesdata = new SalesData(rows, volumetarget, -1);
				}
				else if(type.equals("2"))
				{
					salesdata = new SalesData(rows, volumetarget, profittarget);
				}
				salesdata.startup();
				if(salesdata.status > 0)
				{
					Datum group = new Datum();
					group.put("MODEL", "-");
					group.put("GROUPVOLUME", volumetarget);
					group.put("ROWS", salesdata.rows);
					groups.add(group);
				}
				else
				{
					status = salesdata.status;
				}
			}
			
			
			Data items = new Data();
			
			for(Datum group : groups)
			{
				Data grouprows = group.getData("ROWS");
				for(Datum row : grouprows)
				{
					row.put("GROUPNAME", group.getString("GROUPNAME"));
					row.put("GROUPVOLUME", group.getString("GROUPVOLUME"));
					items.add(row);
				}
			}
			
			message.data.put("ROWS", items);
		}	
		message.message(status, "");
		return message;
	}
	
%>



















