package com.estimate.datasource;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang3.math.NumberUtils;

public class DataSource
{
	private Connection connection;
	
	public DataSource(Connection connection)
	{
		this.setConnection(connection);
	}

	public Data find(String sql, String... args) throws SQLException
	{
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		try
		{
			statement = this.connection.prepareStatement(sql);
			
			int index = 1;
			for(String arg : args)
			{
				statement.setString(index, arg);
				index++;
			}
			
			resultSet = statement.executeQuery();
			Data data = full(resultSet);
			return data;
		}
		finally
		{
	    	if(resultSet != null)
	    	{
	    		resultSet.close();
	    	}
	    	if(statement != null)
	    	{
	    		statement.close();
	    	}
		}
	}
	
	public Data find(String sql, int number, int size, String... args)
	{
		return null;
	}
	
	public Datum get(String sql, String... args) throws SQLException
	{
		Data data = find(sql, args);
		if(data != null && data.size() > 0)
		{
			Datum datum = data.get(0);
			return datum;
		}
		return null;
	}
	
	public int count(String sql) throws SQLException
	{
		Datum datum = get(sql);
		if(datum != null)
		{
			return NumberUtils.toInt(datum.getString("COUNT"), 0);
		}
		else
		{
			return 0;
		}
		
	}

	public List<String> getColumnNames(String sql, String... args) throws SQLException
	{
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		try
		{
			statement = this.connection.prepareStatement(sql);
			resultSet = statement.executeQuery();
			ResultSetMetaData metadata = resultSet.getMetaData();
			List<String> columnnames = new ArrayList<String>();
			for(int i = 1 ; i <= metadata.getColumnCount() ; i++)
			{
				columnnames.add(metadata.getColumnName(i));
			}
			return columnnames;
		}
		finally
		{
	    	if(resultSet != null)
	    	{
	    		resultSet.close();
	    	}
	    	if(statement != null)
	    	{
	    		statement.close();
	    	}
		}
	}
	
	public void execute(String sql, String... args) throws SQLException
	{
		PreparedStatement statement = null;		
		try
		{
			statement = this.connection.prepareStatement(sql);
			int index = 1;
			for(String arg : args)
			{
				statement.setString(index, arg);
				index++;
			}
			
			statement.executeUpdate();
			statement.close();
		}
		finally
		{
	    	if(statement != null)
	    	{
	    		statement.close();
	    	}
		}
		
	}

    private Data full(ResultSet rs) throws SQLException
	{
    	Data data = new Data();
	    ResultSetMetaData rsmd = rs.getMetaData();
	    Datum datum = null;
	    while(rs.next())
	    {
	    	datum = new Datum();
	        for(int i = 0; i < rsmd.getColumnCount(); i++)
	        {
	        	String column = rsmd.getColumnName(i + 1);
	        	Object o = rs.getObject(i + 1);
	        	datum.put(column, o);
	        }
	        data.add(datum);
	    }
	    return data;
	} 	
	
	public Connection getConnection()
	{
		return connection;
	}

	public void setConnection(Connection connection)
	{
		this.connection = connection;
	}
	
	public static Connection connection(File file) throws ClassNotFoundException, SQLException
	{
		Class.forName("org.sqlite.JDBC");
		Connection connection = null;
		if(file != null && file.exists())
		{
			connection = DriverManager.getConnection("jdbc:sqlite:"+file.getAbsolutePath());
		}
		return connection;
	}
}
