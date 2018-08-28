<%@page import="com.estimate.SystemProperty"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.File"%>

<%@page contentType="text/html; charset=utf-8"%>
<%

	String[] directories = new String[]
	{
		"temp",
		"version" +SystemProperty.FILESEPARATOR+ "package"
	};

	for(String directory : directories)
	{
		File file = new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + directory);
		FileUtils.cleanDirectory(file);
	}
%>
<!doctype html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link rel="stylesheet" href="../style/css/main.css" />
	<script type="text/javascript" src="../lib/jquery/jquery.js"></script>
	<script type="text/javascript">

		$(function()
		{
			$.get("../apply/personnel/organization/export.jsp", function(columns){});
		});

	</script>
</head>
<body>

<p style="text-align:center; font-size:20px; margin:80px 30px; padding:10px; border-bottom:1px solid #eeeeee">清理完毕，请<a onclick="window.close()" style="color:#0000ff; cursor:pointer">点击</a>关闭！</p>

</body>
</html>
