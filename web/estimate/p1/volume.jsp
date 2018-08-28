<%@page import="com.estimate.utils.ThrowableUtils"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.estimate.office.XLSUtils"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.estimate.SystemProperty"%>
<%@page import="com.estimate.utils.ServiceMessage"%>
<%@page contentType="text/html; charset=utf-8"%>
	
<%
	ServiceMessage message = new ServiceMessage();
	String name = request.getParameter("name");
	
	try
	{
		File excel = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "temp" + SystemProperty.FILESEPARATOR + URLDecoder.decode(name, "UTF-8"));
		List<String[]> rows = XLSUtils.toList(excel, 0);		
		JSONObject map = new JSONObject();
		for(int i = 2 ; i < rows.size() ; i++)
		{
			String[] row = rows.get(i);
			map.put(row[0], row[1]);
		}
		message.data.put("MAP", map);
	}
	catch(Exception e)
	{
		Throwable throwable = ThrowableUtils.getThrowable(e);
		message.message(ServiceMessage.FAILURE, throwable.getMessage());
	}
	
	out.println(message);
%>
