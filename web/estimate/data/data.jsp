<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.estimate.SessionUser"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.datasource.Data"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	String usercode = sessionuser.getId();
	String year = request.getParameter("year");
	String month = StringUtils.defaultString(request.getParameter("month"));
	String type = request.getParameter("type");
	
	ServiceMessage message = new ServiceMessage();
	
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		Data rows = null;
		if(type.equals("1"))
		{
			rows = datasource.find("select * from T_SALES where YEAR = ? and CREATE_USER_ID = ? order by SORT", year, usercode);
		}
		else if(type.equals("2"))
		{
			rows = datasource.find("select * from T_CURRITEMS where YEAR = ? and CREATE_USER_ID = ? order by SORT", year, usercode);
		}
		else if(type.equals("3"))
		{
			rows = datasource.find("select * from T_CONFIG where YEAR = ? and MONTH = ? and CREATE_USER_ID = ?", year, month, usercode);
		}
		message.data.put("rows", rows);
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