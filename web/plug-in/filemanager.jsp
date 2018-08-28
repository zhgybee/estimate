<%@page import="com.estimate.SystemProperty"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html; charset=utf-8"%>

<%
	String action = request.getParameter("action");
	if(action == null)
	{
		action = "up";
	}

	String path = SystemProperty.PATH + SystemProperty.FILESEPARATOR + "temp";
	
	if(action.equals("up"))
	{
		String name = request.getParameter("name");
		File file = new File(path);
		if (!file.exists())
		{
			file.mkdirs();
		}
        DiskFileItemFactory factory = new DiskFileItemFactory();  
        factory.setSizeThreshold(1 * 1024 * 1024);
		
		ServletFileUpload sfu = new ServletFileUpload(factory);
		try
		{
			List<?> fileList = sfu.parseRequest(request);
			for (int i = 0; i < fileList.size(); i++)
			{
				FileItem fileItem = (FileItem) fileList.get(i);
				if (!fileItem.isFormField())
				{
					String fileName = fileItem.getName();
					if(name != null)
					{
						fileName = name;
					}
					File f = new File(path, fileName);
					fileItem.write(f);
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
	}
	else if(action.equals("del"))
	{
		String name = request.getParameter("name");
		if (name == null || name.equals(""))
		{
			out.println("file name is null");
			return;
		}
		File file = new File(path, name);
		if(file != null)
		{
			if(file.exists())
			{
				file.delete();
			}
		}
	}
%>