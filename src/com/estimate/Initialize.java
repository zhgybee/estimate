package com.estimate;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.json.JSONException;
import org.json.JSONObject;

public class Initialize extends HttpServlet
{
	private static final long serialVersionUID = -8122098481008457707L;

	public void init(ServletConfig config) throws ServletException
	{
		initialize(config);
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	}
	
	public void initialize(ServletConfig servletConfig)
	{
		SystemProperty.PATH = servletConfig.getServletContext().getRealPath("");
		SystemProperty.CONTEXTPATH = servletConfig.getServletContext().getContextPath();
		SystemProperty.FILESEPARATOR = System.getProperty("file.separator");
		

		try
		{
			JSONObject config = new JSONObject(FileUtils.readFileToString(new File(SystemProperty.PATH + SystemProperty.FILESEPARATOR + "config" + SystemProperty.FILESEPARATOR + "config.json"), "UTF-8"));
			SystemProperty.DATASOURCE = new File( SystemProperty.PATH + SystemProperty.FILESEPARATOR + "db" + SystemProperty.FILESEPARATOR + config.optString("datasource") ) ;
		}
		catch (JSONException | IOException e)
		{
			e.printStackTrace();
		}
		
	}
}








