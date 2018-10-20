<%@page import="org.apache.commons.lang3.math.NumberUtils"%>
<%@page import="com.estimate.SessionUser"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page import="java.util.Calendar"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.apache.commons.lang3.ArrayUtils"%>
<%@page import="com.estimate.utils.SystemUtils"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.io.File"%>
<%@page import="java.util.List"%>
<%@page import="com.estimate.office.XLSUtils"%>
<%@page contentType="text/html; charset=utf-8"%>

<%	
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	String usercode = sessionuser.getId();

	ServiceMessage message = new ServiceMessage();
	
	String filename = StringUtils.defaultString(request.getParameter("filename"), "");
	String type = StringUtils.defaultString(request.getParameter("type"), "1");
	
	File excel = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "temp" + SystemProperty.FILESEPARATOR + URLDecoder.decode(filename, "UTF-8"));
	List<String[]> rows = XLSUtils.toList(excel, 0);
	
	Set<String> sqls = new HashSet<String>();
	
	
	if(type.equals("1"))
	{
		String pyear = "";
		String pmonth = "";
		String parea = "";
		String pbrand = "";
		for(int i = 2 ; i < rows.size() ; i++)
		{
			String[] row = rows.get(i);
			
			if(row.length == 11)
			{
				String year = row[0];
				year = StringUtils.replace(year, "年", "");
				if(year.equals(""))
				{
					year = pyear;
				}
	
				String month = row[1];
				month = StringUtils.replace(month, "月", "");
				if(month.equals(""))
				{
					month = pmonth;
				}
	
				String area = row[2];
				if(area.equals(""))
				{
					area = parea;
				}
	
				String brand = row[3];
				if(brand.equals(""))
				{
					brand = pbrand;
				}
	
				String model = row[4];
				
				String isinside = row[5];
				if(isinside.equals("省外烟"))
				{
					isinside = "0";
				}
				else
				{
					isinside = "1";
				}
				
				String volume = row[6];
	
				String amount = row[7];
	
				String cost = row[8];
	
				String price = row[9];
	
				
				
				amount = StringUtils.replace(amount, "￥", "");
				cost = StringUtils.replace(cost, "￥", "");
				price = StringUtils.replace(price, "￥", "");
	
				amount = StringUtils.replace(amount, ",", "");
				cost = StringUtils.replace(cost, ",", "");
				price = StringUtils.replace(price, ",", "");

				double profitrate = 0;
				try
				{
					profitrate = (NumberUtils.toDouble(price, 0) - NumberUtils.toDouble(cost, 0)) / NumberUtils.toDouble(price, 0);
				}
				catch(Exception e)
				{
					profitrate = -1;
				}
				
				String sql = "INSERT INTO T_SALES(ID, YEAR, MONTH, AREA, BRAND, MODEL, VOLUME, AMOUNT, COST, PRICE, PROFITRATE, CODE, ISINSIDE, SORT, CREATE_USER_ID, CREATE_DATE) VALUES('"+SystemUtils.uuid()+"', '"+year+"', '"+month+"', '"+area+"', '"+brand+"', '"+model+"', '"+volume+"', '"+amount+"', '"+cost+"', '"+price+"', '"+profitrate+"', '', '"+isinside+"', '"+i+"', '"+usercode+"', '"+SystemUtils.toString(Calendar.getInstance())+"')";
	
	
				pyear = year;
				pmonth = month;
				parea = area;
				pbrand = brand;
				sqls.add(sql);
			}
			else
			{
				message.message(ServiceMessage.FAILURE, "[往年销售数据]模板中列数（"+row.length+"/11）错误。");
				break;
			}
		}
	}
	else if(type.equals("2"))
	{
		String pyear = "";
		String pbrand = "";
		String pproducer = "";
		for(int i = 2 ; i < rows.size() ; i++)
		{
			String[] row = rows.get(i);
			
			if(row.length == 8)
			{
				String year = row[0];
				year = StringUtils.replace(year, "年", "");
				if(year.equals(""))
				{
					year = pyear;
				}
	
				String brand = row[1];
				if(brand.equals(""))
				{
					brand = pbrand;
				}
				
				String producer = row[2];
				if(producer.equals(""))
				{
					producer = pproducer;
				}
	
				String model = row[3];
				
				String isinside = row[4];
				if(isinside.equals("省外烟"))
				{
					isinside = "0";
				}
				else
				{
					isinside = "1";
				}
	
				String cost = row[5];
	
				String price = row[6];
				
				String retailprice = row[7];
				
				cost = StringUtils.replace(cost, "￥", "");
				price = StringUtils.replace(price, "￥", "");
				retailprice = StringUtils.replace(retailprice, "￥", "");
	
				cost = StringUtils.replace(cost, ",", "");
				price = StringUtils.replace(price, ",", "");
				retailprice = StringUtils.replace(retailprice, ",", "");
				
				double profitrate = 0;
				try
				{
					profitrate = (NumberUtils.toDouble(price, 0) - NumberUtils.toDouble(cost, 0)) / NumberUtils.toDouble(price, 0);
				}
				catch(Exception e)
				{
					profitrate = -1;
				}
				
				String sql = "INSERT INTO T_CURRITEMS(ID, YEAR, BRAND, MODEL, COST, PRICE, RETAILPRICE, PROFITRATE, ISINSIDE, PRODUCER, SORT, CREATE_USER_ID, CREATE_DATE) VALUES('"+
					SystemUtils.uuid()+"', '"+year+"', '"+brand+"', '"+model+"', '"+cost+"', '"+price+"', '"+retailprice+"', '"+profitrate+"', '"+isinside+"', '"+producer+"', '"+i+"', '"+usercode+"', '"+SystemUtils.toString(Calendar.getInstance())+"')";
	
				pyear = year;
				pbrand = brand;
				pproducer = producer;
				sqls.add(sql);
			}
			else
			{
				message.message(ServiceMessage.FAILURE, "[预测年规格]模板中列数（"+row.length+"/8）错误。");
				break;
			}
		}
	}
	else if(type.equals("3"))
	{
		String year = "";
		String month = "";
		JSONObject map = new JSONObject();
		
		if(rows.size() > 2)
		{
			String[] names = rows.get(1);
			if(names.length == 13)
			{
				for(int i = 2 ; i < rows.size() ; i++)
				{
					String[] row = rows.get(i);
					
						if(!row[0].equals(""))
						{
							year = row[0];
							year = StringUtils.replace(year, ".0", "");
							year = StringUtils.replace(year, "年", "");
						}
						if(!row[1].equals(""))
						{
							month = row[1];
							month = StringUtils.replace(month, ".0", "");
							month = StringUtils.replace(month, "月", "");
						}
						
						JSONObject item = new JSONObject();	
						for(int j = 4 ; j < names.length ; j++)
						{
							item.put(names[j], NumberUtils.toDouble(row[j], 0));
						}
						String key = row[2];				
						map.put(key, item);
				}
				String sql = "INSERT INTO T_CONFIG(ID, YEAR, MONTH, CONTENT, CREATE_USER_ID, CREATE_DATE) VALUES('"+
						SystemUtils.uuid()+"', '"+year+"', '"+month+"', '"+map.toString()+"', '"+usercode+"', '"+SystemUtils.toString(Calendar.getInstance())+"')";
				sqls.add(sql);
			}
			else
			{
				message.message(ServiceMessage.FAILURE, "[预测年年度费用]模板中列数（"+names.length+"/13）错误。");
			}
			
		}
		else
		{
			message.message(ServiceMessage.FAILURE, "[预测年年度费用]模板中没有数据。");
		}

	}
	
	
	

	if(sqls.size() > 0)
	{
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);		
			connection.setAutoCommit(false);
			DataSource dataSource = new DataSource(connection);
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
	
	out.println(message.toString());
%>