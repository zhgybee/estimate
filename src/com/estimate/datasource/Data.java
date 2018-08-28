package com.estimate.datasource;

import java.util.ArrayList;

public class Data extends ArrayList<Datum>
{
	private static final long serialVersionUID = 6170230575956396503L;
	
	public Data()
	{
	}
	
	public Datum last()
	{
		return get(this.size() - 1);
	}
	
	public Datum first()
	{
		return get(0);
	}

}
