
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.estimate.utils.SystemUtils"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.datasource.Data"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	String mode = request.getParameter("mode");
	
	ServiceMessage message = new ServiceMessage();
	
	if(mode.equals("1"))
	{
		String id = request.getParameter("id");
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);		
			connection.setAutoCommit(false);
			DataSource datasource = new DataSource(connection);	
			datasource.execute("delete from T_USER where id = ?", id);
			connection.commit();
		}
		catch(Exception e)
		{
			if(connection != null)
			{
				connection.rollback();
			}
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
		String name = StringUtils.defaultString(request.getParameter("name"), "");
		String code = StringUtils.defaultString(request.getParameter("code"), "");
		String loginname = StringUtils.defaultString(request.getParameter("loginname"), "");
		String password = StringUtils.defaultString(request.getParameter("password"), "");
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);		
			connection.setAutoCommit(false);
			DataSource datasource = new DataSource(connection);	
			datasource.execute("INSERT INTO T_USER(ID, NAME, CODE, LOGIN_NAME, PASSWORD, CREATE_DATE) VALUES(?, ?, ?, ?, ?, ?)", SystemUtils.uuid(), name, code, loginname, password, SystemUtils.toString(Calendar.getInstance()));
			connection.commit();
		}
		catch(Exception e)
		{
			if(connection != null)
			{
				connection.rollback();
			}
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