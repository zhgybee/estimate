<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page import="com.estimate.SessionUser"%>
<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.datasource.Data"%>
<%@page import="com.estimate.datasource.DataSource"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html; charset=utf-8"%>

	
<%
	SessionUser sessionuser = SessionUser.getSessionUser(session);
	String usercode = sessionuser.getId();
	
	ServiceMessage message = new ServiceMessage();
	
	Connection connection = null;
	try
	{
		connection = DataSource.connection(SystemProperty.DATASOURCE);	
		DataSource datasource = new DataSource(connection);	
		Data rows = datasource.find("select '1' as 'TYPE', max(YEAR) as 'YEAR', '' as 'MONTH', max(CREATE_DATE) as 'CREATE_DATE' from T_SALES where CREATE_USER_ID = ? group by YEAR union all select '2' as 'TYPE', max(YEAR) as 'YEAR', '' as 'MONTH', max(CREATE_DATE) as 'CREATE_DATE' from T_CURRITEMS where CREATE_USER_ID = ? group by YEAR union all select '3' as 'TYPE', YEAR, MONTH, CREATE_DATE from T_CONFIG where CREATE_USER_ID = ?", usercode, usercode, usercode);
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