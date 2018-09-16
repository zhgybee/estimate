<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.estimate.utils.SystemUtils"%>
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
	String month = StringUtils.defaultString(request.getParameter("month"), "1");
	String content = request.getParameter("content");
	
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);
		DataSource datasource = new DataSource(connection);	

		datasource.execute("delete from T_PURCHASE where YEAR = ? and MONTH = ?", String.valueOf(year), String.valueOf(month));
		datasource.execute("insert into T_PURCHASE(ID, YEAR, MONTH, CONTENT, CREATE_DATE) values(?, ?, ?, ?, '"+SystemUtils.toString(Calendar.getInstance())+"')", 
				SystemUtils.uuid(), String.valueOf(year), month, content);
		
	}
	catch(Exception e)
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

		
	out.println(message);
%>
