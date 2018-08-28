<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.estimate.SessionUser"%>
<%@page import="com.estimate.datasource.Datum"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	String name = request.getParameter("name");
	String password = request.getParameter("password");

	ServiceMessage message = new ServiceMessage();
	if(name != null && password != null)
	{
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);
			
			DataSource dataSource = new DataSource(connection);
	
			Datum user = dataSource.get("select * from T_USER where LOGIN_NAME = ? and PASSWORD = ?", name, password);
			
			if(user != null)
			{
				SessionUser sessionUser = new SessionUser();
				sessionUser.setId( user.getString("ID") );
				sessionUser.setName( user.getString("NAME") );
				sessionUser.setLoginName( user.getString("LOGIN_NAME") );
				sessionUser.setCode( user.getString("CODE") );
				
				session.setAttribute("user", sessionUser); 
			}
			else
			{
				message.message(ServiceMessage.FAILURE, "输入的用户名或密码错误！");
			}
		}
		catch (Exception e)
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
	else
	{
		message.message(ServiceMessage.FAILURE, "用户名或密码没有输入！");
	}

	out.println(message.toString());
%>