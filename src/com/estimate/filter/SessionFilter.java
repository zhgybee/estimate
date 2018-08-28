package com.estimate.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.estimate.SessionUser;
import com.estimate.SystemProperty;


public class SessionFilter implements Filter
{
	protected String[] exclusions = null;
	
	protected FilterConfig filterConfig = null;

	public SessionFilter()
	{
		super();
	}

	public void init(FilterConfig filterConfig) throws ServletException
	{
		this.filterConfig = filterConfig;
		this.exclusions = filterConfig.getInitParameter("exclusions").split(",");
	}

	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException
	{
		HttpServletRequest request = (HttpServletRequest)servletRequest;
		HttpServletResponse response = (HttpServletResponse)servletResponse;

		String uri = request.getRequestURI();
		boolean result = true;
		if(!contains(this.exclusions, uri))
		{
			HttpSession session = request.getSession();
			if(session == null || SessionUser.getSessionUser(session) == null)
			{
				result = false;
			}
		}
		
		if(result)
		{
			chain.doFilter(request, response);
		}
		else
		{ 
			response.sendRedirect(SystemProperty.CONTEXTPATH+"/index.html");
		}
		
	}

	public boolean contains(String[] array, String arg)
	{
		for(int i = 0 ; i < array.length ; i++)
		{
			if( arg.indexOf(array[i]) != -1 )
			{
				return true;
			}
		}
		return false;
	}

	public void destroy()
	{
	}
}
