package com.estimate.utils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class ServiceMessage
{
	public static int FAILURE = -1;
	public static int SUCCESS = 1;
	
	public int status = SUCCESS;

	public JSONArray messages = new JSONArray();	
	
	public JSONObject data = new JSONObject();	
	
	public long runtime;
	
	public ServiceMessage()
	{
		this.runtime = System.currentTimeMillis();
	}

	public void message(String message)
	{
		this.messages.put(message);
	}
	
	public void message(int status, String message)
	{
		this.status = status;
		this.messages.put(message);
	}
	
	public int getStatus() 
	{
		return status;
	}

	public void setStatus(int status) 
	{
		this.status = status;
	}
	
	public String toString()
	{
		JSONObject message = new JSONObject();
		try
		{
			message.put("STATUS", this.status);
			message.put("MESSAGES", this.messages);
			message.put("DATA", this.data);
			message.put("RUNTIME", System.currentTimeMillis() - this.runtime);
		}
		catch (JSONException e)
		{
			e.printStackTrace();
		}
		return message.toString();
	}
}
