package com.estimate;

import javax.servlet.http.HttpSession;

public class SessionUser
{
	private String id;
	
	private String loginName;
	
	private String name;
	
	private String code;

	public String getId()
	{
		return id;
	}

	public void setId(String id)
	{
		this.id = id;
	}

	public String getLoginName()
	{
		return loginName;
	}

	public void setLoginName(String loginName)
	{
		this.loginName = loginName;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getCode() 
	{
		return code;
	}

	public void setCode(String code) 
	{
		this.code = code;
	}
	
	public static SessionUser getSessionUser(HttpSession session)
	{
		return (SessionUser)session.getAttribute("user");
	}
}
