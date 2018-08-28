package com.estimate.office;

import java.awt.Point;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class XLSData
{
	private String title;
	
	private List<Map<String, String>> list = new ArrayList<>();
	
	private Map<String, String> data = new HashMap<>();
	
	private Map<String, Point> positions = new HashMap<>();
	
	private Map<String, Map<String, Object>> styles = new HashMap<>();
	
	public Map<String, Map<String, Object>> getStyles() 
	{
		return styles;
	}

	public void setStyles(Map<String, Map<String, Object>> styles) 
	{
		this.styles = styles;
	}

	public List<Map<String, String>> getList()
	{
		return list;
	}

	public void setList(List<Map<String, String>> list)
	{
		this.list = list;
	}

	public Map<String, String> getData()
	{
		return data;
	}

	public void setData(Map<String, String> data)
	{
		this.data = data;
	}

	public Map<String, Point> getPositions()
	{
		return positions;
	}

	public void setPositions(Map<String, Point> positions)
	{
		this.positions = positions;
	}

	public String getTitle()
	{
		return title;
	}

	public void setTitle(String title)
	{
		this.title = title;
	}
}
