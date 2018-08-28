<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.datasource.Data"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

	
<%
	ServiceMessage message = new ServiceMessage();

	String mode = request.getParameter("mode");

	if(mode.equals("1"))
	{
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);	
			DataSource datasource = new DataSource(connection);	
			Data rows = datasource.find("select * from T_USER order by CREATE_DATE");
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
	}
	else if(mode.equals("2"))
	{
		String id = request.getParameter("id");
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);	
			DataSource datasource = new DataSource(connection);	
			Data rows = datasource.find("select * from T_USER where ID = ?", id);
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
	}
	
	out.println(message);
%>