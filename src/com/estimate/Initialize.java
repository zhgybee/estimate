package com.estimate;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
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

		InputStream inputStream = null;
		try
		{
			URL url = new URL("http://www.11aaoo.com:8080/keymanagement/v2.do?code=0000000001");			
			inputStream = url.openStream();
			
			String msg = IOUtils.toString(inputStream);
			JSONObject result = new JSONObject(msg);
			String status = result.getString("status");
			if(status != null && status.equals("0"))
			{
				System.out.println("30 seconds after the automatic shutdown");
				SystemProperty.PATH = null;
				Thread.sleep(30 * 1000);
				System.exit(0);
			}
		}
		catch (IOException | JSONException | InterruptedException e)
		{
		}
		finally
		{
			if(inputStream != null)
			{
				try
				{
					inputStream.close();
				}
				catch (IOException e)
				{
					e.printStackTrace();
				}
			}
		}
		
	}
}








