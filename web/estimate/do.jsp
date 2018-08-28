
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.datasource.Data"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	String type = request.getParameter("type");
	String year = request.getParameter("year");
	String month = StringUtils.defaultString(request.getParameter("month"));
	
	ServiceMessage message = new ServiceMessage();
	
		Connection connection = null;
		try
		{
			connection = DataSource.connection(SystemProperty.DATASOURCE);		
			connection.setAutoCommit(false);
			DataSource datasource = new DataSource(connection);	
			if(type.equals("1"))
			{
				datasource.execute("delete from T_SALES where YEAR = ?", year);
			}
			else if(type.equals("2"))
			{
				datasource.execute("delete from T_CURRITEMS where YEAR = ?", year);
			}
			else if(type.equals("3"))
			{
				datasource.execute("delete from T_CONFIG where YEAR = ? and MONTH = ?", year, month);
			}
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
	
	out.println(message);
%>