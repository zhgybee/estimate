package com.estimate;

import java.io.File;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.json.JSONObject;
import com.estimate.datasource.Data;
import com.estimate.datasource.DataSource;
import com.estimate.datasource.Datum;
import com.estimate.utils.SystemUtils;
import com.estimate.utils.ThrowableUtils;
import java.util.Comparator;

public class Test
{

	DecimalFormat format = new DecimalFormat("#.##");

	public static void main(String[] args) 
	{
		Test test = new Test();
		/*
		for(int i = 0 ; i < 100 ; i++)
		{
			System.out.println(test.random(-5, 0));
		}
		*/
		/*
		Data rows = test.create1();	
		SalesData salesdata = new SalesData(rows, 34036442, 1266054540);
		System.out.println(34036442+","+1266054540);
		System.out.println("==============================================================================================");
		salesdata.startup();
		System.out.println(salesdata.status);		
		*/
/*
		Data rows = test.create1();	
		SalesData salesdata = new SalesData(rows, 27500000, 0);
		salesdata.startup();
		System.out.println(rows);
*/
		
		Data rows1 = new Data();

		
		
		Datum row = new Datum();
		row.put("NAME", "0.0-61.5");
		row.put("MIN", "78371833");
		row.put("MAX", "84233291");
		rows1.add(row);

		row = new Datum();
		row.put("NAME", "65.72-76.32");
		row.put("MIN", "35944432");
		row.put("MAX", "36281509");
		rows1.add(row);

		row = new Datum();
		row.put("NAME", "80.0-98.0");
		row.put("MIN", "110626957");
		row.put("MAX", "111551083");
		rows1.add(row);

		row = new Datum();
		row.put("NAME", "102.82-121.9");
		row.put("MIN", "192771876");
		row.put("MAX", "193890187");
		rows1.add(row);

		row = new Datum();
		row.put("NAME", "122.96-158.0");
		row.put("MIN", "177318381");
		row.put("MAX", "180715252");
		rows1.add(row);

		row = new Datum();
		row.put("NAME", "159.0-192.5");
		row.put("MIN", "234600172");
		row.put("MAX", "239888696");
		rows1.add(row);

		row = new Datum();
		row.put("NAME", "200.0-210.0");
		row.put("MIN", "221320331");
		row.put("MAX", "221321580");
		rows1.add(row);

		row = new Datum();
		row.put("NAME", "212.0-243.8");
		row.put("MIN", "125998840");
		row.put("MAX", "126408266");
		rows1.add(row);

		row = new Datum();
		row.put("NAME", "248.04-848.0");
		row.put("MIN", "501453901");
		row.put("MAX", "537669390");
		rows1.add(row);
		
		SalesData groupsdata = new SalesData(rows1, 1708774617.21, -1);
		groupsdata.startup();
		

		for(Datum group : groupsdata.rows)
		{
			System.out.println("===================="+group.getString("GROUPNAME")+"=======================");
			System.out.println("min="+new BigDecimal(group.getDouble("MIN")).toString());
			System.out.println("max="+new BigDecimal(group.getDouble("MAX")).toString());
			System.out.println("x="+new BigDecimal(group.getDouble("X")).toString());
		}

		/*
		Datum row = new Datum();	
		row.put("NAME", "黄山松(迎客松赢客)硬盒");
		row.put("MAX", 9960);
		row.put("MIN", 9960);
		row.put("PROFIT", 70.68965517);
		row.put("X", 9960);
		rows.add(row);
		
		row = new Datum();	
		row.put("NAME", "利群(西湖恋)97S硬盒");
		row.put("MAX", 26781);
		row.put("MIN", 26781);
		row.put("PROFIT", 81.83103448);
		row.put("X", 26781);
		rows.add(row);
		
		row = new Datum();	
		row.put("NAME", "黄山(中国印)软盒");
		row.put("MAX", 47800);
		row.put("MIN", 47800);
		row.put("PROFIT", 81.83103448);
		row.put("X", 47800);
		rows.add(row);
		
		row = new Datum();	
		row.put("NAME", "玉溪软盒");
		row.put("MAX", 2083320);
		row.put("MIN", 1772095);
		row.put("PROFIT", 81.83103448);
		row.put("X", 1772223);
		rows.add(row);
		
		row = new Datum();	
		row.put("NAME", "贵烟(跨越)90S硬盒");
		row.put("MAX", 11692);
		row.put("MIN", 11692);
		row.put("PROFIT", 81.83103448);
		row.put("X", 11692);
		rows.add(row);
		
		row = new Datum();	
		row.put("NAME", "都宝(冰爽世界)硬盒");
		row.put("MAX", 0);
		row.put("MIN", 0);
		row.put("PROFIT", 81.83103448);
		row.put("X", 0);
		rows.add(row);
		
		row = new Datum();	
		row.put("NAME", "云烟(软珍品)");
		row.put("MAX", 1240442);
		row.put("MIN", 815367);
		row.put("PROFIT", 83.98448276);
		row.put("X", 815367);
		rows.add(row);
		
		row = new Datum();	
		row.put("NAME", "将军(3G)100S铁盒");
		row.put("MAX", 888);
		row.put("MIN", 760);
		row.put("PROFIT", 74.22413793);
		row.put("X", 760);
		rows.add(row);

		
		
		

		SalesData d = new SalesData(rows);
		System.out.println(d.getTotalVolumes());
		System.out.println(new BigDecimal(d.getMinTotalProfit()).toString());
		System.out.println(new BigDecimal(d.getMaxTotalProfit()).toString());
		*/
	}
	
	public void ff(Data rows)
	{
		rows = sort(rows, -1);
		Datum changer = null;
		for(Datum row : rows)
		{
			double max = row.getDouble("MAX");
			double x = row.getDouble("XK");
			String flag = row.getString("FLAG");
			if(!flag.equals("1") && max > x)
			{
				changer = row;
				break;
			}
		}
		if(changer != null)
		{
			double changnumber = changer.getDouble("MAX") - changer.getDouble("X");
			
			double number = changnumber;
			for(int i = 0 ; i < rows.size() ; i++)
			{
				System.out.println("==min("+i+")==");
				number = ff1(rows, number, changer.getDouble("PROFIT"));
				if(number == 0)
				{
					break;
				}
			}
			changer.put("XK", changer.getDouble("XK") + changnumber - number);
			changer.put("FLAG", "1");
		}
		
	}
	public double ff1(Data rows, double changnumber, double changeprofit)
	{
		rows = sort(rows, 1);
		Datum changer = null;
		for(Datum row : rows)
		{
			double min = row.getDouble("MIN");
			double x = row.getDouble("XK");
			double profit = row.getDouble("PROFIT");
			if(profit < changeprofit && x > min)
			{
				changer = row;
				break;
			}
		}

		if(changer != null)
		{
			double min = changer.getDouble("MIN");
			double x = changer.getDouble("XK");
			
			double number = 0;
			if(x - min >  changnumber)
			{
				number = changnumber;
				changnumber = 0;
			}
			else if(x - min < changnumber)
			{
				number = x - min;
				changnumber = changnumber - number;
			}
			else
			{
				number = changnumber;
				changnumber = 0;
			}
			changer.put("XK", x - number);
			System.out.println(changer);
		}
		return changnumber;
	}

	
	public Data sort(Data rows, int type)
	{
		Collections.sort(rows, new Comparator<Datum>() 
		{
			public int compare(Datum h1, Datum h2) 
			{
				if(h1.getDouble("PROFIT") > h2.getDouble("PROFIT"))
				{
					return 1 * type;
				}
				else if(h1.getDouble("PROFIT") < h2.getDouble("PROFIT"))
				{
					return -1 * type;
				}
				else
				{
					return 0;
				}
			}
		});
		return rows;
	}
	
	public void clone1()
	{
		Connection connection = null;
		try
		{
			connection = DataSource.connection(new File("E:\\code\\java\\estimate\\workspace\\estimate\\web\\db\\db"));		
			DataSource datasource = new DataSource(connection);	
			Data rows = datasource.find("select NAME, MIN, MAX, P from TEST where MAX = '4042'");

			System.out.println(rows);
			
			
			Data clone = new Data();
			for(Datum row : rows)
			{
				clone.add((Datum)row.clone());
			}
			
			clone.get(0).put("NAME", 111);

			System.out.println(clone);
			System.out.println(rows);
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if(connection != null)
			{
				try
				{
					connection.close();
				}
				catch (SQLException e)
				{
					e.printStackTrace();
				}
			}
		}
	}
	
	
	
	
	
	public void ff()
	{
		Connection connection = null;
		try
		{
			connection = DataSource.connection(new File("E:\\code\\java\\estimate\\workspace\\estimate\\web\\db\\db"));		
			DataSource datasource = new DataSource(connection);	
			Data rows = datasource.find("select NAME, MIN, MAX, P from TEST where AREA = '80.0-98.0'");
			SalesData groupdata = new SalesData(rows, 3114100.0, 107706424.631841);
			System.out.println("目标:3114100.0, 107706424.631841");
			groupdata.startup();
			for(Datum s : groupdata.rows)
			{
				System.out.println(s);
			}
			System.out.println(groupdata.status);
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if(connection != null)
			{
				try
				{
					connection.close();
				}
				catch (SQLException e)
				{
					e.printStackTrace();
				}
			}
		}
	}
	
	
	
	
	
	public void temp(Data rows)
	{
		double d1 = 0;
		double d2 = 0;
		double ps = 0;
		for(Datum row : rows)
		{
			double max = row.getDouble("MAX");
			double p = row.getDouble("P");
			
			d1 += max;
			d2 += max * p;
			ps += p;
		}
		
		

		System.out.println(ps / rows.size());
		System.out.println(new BigDecimal(d1).toString());
		System.out.println(new BigDecimal(d2).toString());
	}
	
	public Data create1()
	{
		int year = 2018;
		Data rows = null;
		Connection connection = null;
		try
		{
			connection = DataSource.connection(new File("E:\\code\\java\\estimate\\workspace\\estimate\\web\\db\\db"));	
			DataSource datasource = new DataSource(connection);	

			rows = datasource.find("select T_TOTAL_SALES.ID, T_TOTAL_SALES.MODEL as NAME, T_TOTAL_SALES.PRICE, T_TOTAL_SALES.PROFIT as P, TS.MAX, TS.MIN from "
					+ "T_TOTAL_SALES left join (select MODEL, max(VOLUME) as MAX, min(VOLUME) as MIN from T_TOTAL_SALES where CREATE_USER_ID = ? and (year = ? or year = ? or year = ?) "
					+ "group by MODEL) TS on T_TOTAL_SALES.MODEL = TS.MODEL where CREATE_USER_ID = ? and YEAR = ? order by T_TOTAL_SALES.PRICE, SORT", 
					"U0", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), "U0", String.valueOf(year - 1));
			
			//rows = datasource.find("select T_SALES.ID, T_SALES.C02 as NAME, T_SALES.C04, T_SALES.C08 as P, TS.MAX, TS.MIN from T_SALES left join (select C02, max(C06) as MAX, min(C06) as MIN from T_SALES where CREATE_USER_ID = ? and (year = ? or year = ? or year = ?) group by C02) TS on T_SALES.C02 = TS.C02 where CREATE_USER_ID = ? and YEAR = ? order by T_SALES.C04, SORT", 
			//		"U0", String.valueOf(year - 1), String.valueOf(year - 2), String.valueOf(year - 3), "U0", String.valueOf(year - 1));
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if(connection != null)
			{
				try
				{
					connection.close();
				}
				catch (SQLException e)
				{
					e.printStackTrace();
				}
			}
		}
		return rows;
	}
	
	public Data create2()
	{
		Data rows = new Data();
		
		Datum datum = new Datum();
		datum.put("ID", "n1");
		datum.put("NAME", "n1");
		datum.put("MAX", "18");
		datum.put("MIN", "3");
		datum.put("P", "1.2");
		rows.add(datum);
		
		datum = new Datum();
		datum.put("ID", "n2");
		datum.put("NAME", "n2");
		datum.put("MAX", "15");
		datum.put("MIN", "1");
		datum.put("P", "1.8");
		rows.add(datum);
		
		datum = new Datum();
		datum.put("ID", "n3");
		datum.put("NAME", "n3");
		datum.put("MAX", "21");
		datum.put("MIN", "6");
		datum.put("P", "2.1");
		rows.add(datum);
		
		datum = new Datum();
		datum.put("ID", "n4");
		datum.put("NAME", "n4");
		datum.put("MAX", "12");
		datum.put("MIN", "2");
		datum.put("P", "1.7");
		rows.add(datum);
		
		datum = new Datum();
		datum.put("ID", "n5");
		datum.put("NAME", "n5");
		datum.put("MAX", "35");
		datum.put("MIN", "8");
		datum.put("P", "2.3");
		rows.add(datum);

		datum = new Datum();
		datum.put("ID", "n6");
		datum.put("NAME", "n6");
		datum.put("MAX", "28");
		datum.put("MIN", "6");
		datum.put("P", "1.3");
		rows.add(datum);
		
		return rows;
	}
		
	
	public double handle(Data rows, double FEE1, double FEE2, double FEE3, double FEE4, double FEE5, double FEE6, double FEE7, double GAIN)
	{
		double TAX11 = 0;
		double TAX21 = 0;
		double TAX22 = 0;
		double REV1 = 0;
		double FEE01 = 0;
		for(Datum row : rows)
		{
			double salesvolume = row.getDouble("X");
			double cost = row.getDouble("C03");
			double price = row.getDouble("C04");
			cost = cost / 1.17;
			price = price / 1.17;
			
			TAX11 += salesvolume * (price - cost) *0.17;
	
			TAX21 += salesvolume * price * 0.11;
			TAX22 += salesvolume;
			
			REV1 += salesvolume * price;
			
			FEE01 += salesvolume * cost;
		}
		
		//Xi                                 销售量
		//PRICEi                             批发价/1.17
		//COSTi                              调拨价/1.17
		
		//应纳增值税额                       TAX1=∑(Xi*(PRICEi-COSTi)*17%) + 3240000 
		double TAX1 = TAX11 + 3240000;
	
		//应纳消费税额                       TAX2=∑（Xi*PRICEi*11%）+∑（Xi）
		double TAX2 = TAX21 + TAX22;
		
		//应纳城建税额                       TAX3=TAX1*51%*0.07+TAX1*49%*0.05+TAX2*0.07
		double TAX3 = (TAX1 * 0.51 * 0.07) + (TAX1 * 0.49 * 0.05) + (TAX2 * 0.07);
		
		//应纳教育费附加                     TAX4=（TAX1+TAX2)*(3%+2%)     注：含地方附加费
		double TAX4 = (TAX1 + TAX2) * (0.03 + 0.02) ;
				                    
		//应纳四小税额                       TAX5 填写
		double TAX5 = 3475100;
				                    
		//土地增值税                         TAX6 填写
		double TAX6 = 0;
	
		//税金及附加                         TAXA=TAX2+TAX3+TAX4+TAX5+TAX6
		double TAXA = TAX2 + TAX3 + TAX4 + TAX5 + TAX6;
		
		//营业收入                           REV=∑Xi*PRICEi
		double REV = REV1;
			                             
		//营业成本                           FEE0=∑Xi*COSTi
		double FEE0 = FEE01;
	            
		//所得税费用                         TAX7=（REV-FEE0-TAXA-FEE1-FEE2-FEE3+FEE4+FEE5+FEE6+GAIN-FEE7）*25%	
		double TAX7 = (REV - FEE0 - TAXA - FEE1 - FEE2 - FEE3 + FEE4 + FEE5 + FEE6 + GAIN - FEE7) * 0.25;
		
		//净利润                             NI =（REV-FEE0-TAXA-FEE1-FEE2-FEE3+FEE4+FEE5+FEE6+GAIN-FEE7）*75%
		double NI = (REV - FEE0 - TAXA - FEE1 - FEE2 - FEE3 + FEE4 + FEE5 + FEE6 + GAIN - FEE7) * 0.75;
		
		//目标函数                           NI+(TAX1+AX2+AX3+AX4+AX5+AX6+TAX7)=T  
		double T = NI+(TAX1 + TAX2 + TAX3 + TAX4 + TAX5 + TAX6 + TAX7);
		
		return T;
	}
	
    public int random(int min, int max) 
    {
        Random random = new Random();
        int number = random.nextInt(max) % (max - min + 1) + min;
        return number;
    }
}
