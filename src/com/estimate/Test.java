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
		
		Data rows = new Data();
		
		Datum row = new Datum();
		row.put("NAME", "雄狮(红)硬盒");
		row.put("MAX", 109486.0);
		row.put("MIN", 72990.0);
		row.put("PROFIT", 3.7799999999999976);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "红三环(软黄)");
		row.put("MAX", 118944.0);
		row.put("MIN", 97765);
		row.put("PROFIT", 3.7799999999999976);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "盛唐吉祥软盒");
		row.put("MAX", 0.0);
		row.put("MIN", 0.0);
		row.put("PROFIT", 4.720000000000002);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "红三环渡江软盒");
		row.put("MAX", 9340.0);
		row.put("MIN", 7677);
		row.put("PROFIT", 4.720000000000002);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "红梅顺软盒");
		row.put("MAX", 177795.0);
		row.put("MIN", 118529.0);
		row.put("PROFIT", 5.890000000000001);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "雄狮硬盒");
		row.put("MAX", 13528.0);
		row.put("MIN", 9018.0);
		row.put("PROFIT", 7.02);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "红三环(幸福篇)");
		row.put("MAX", 38306.0);
		row.put("MIN", 31485);
		row.put("PROFIT", 7.02);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "大前门软盒");
		row.put("MAX", 166289.0);
		row.put("MIN", 110859.0);
		row.put("PROFIT", 7.419999999999998);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "大前门(硬)");
		row.put("MAX", 332.0);
		row.put("MIN", 221.0);
		row.put("PROFIT", 7.68);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "盛唐金牌硬盒");
		row.put("MAX", 103628.0);
		row.put("MIN", 85176);
		row.put("PROFIT", 9.359999999999996);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "哈德门精品硬盒");
		row.put("MAX", 87298.0);
		row.put("MIN", 58198.0);
		row.put("PROFIT", 9.359999999999996);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "白沙软盒");
		row.put("MAX", 65611.0);
		row.put("MIN", 43740.0);
		row.put("PROFIT", 9.359999999999996);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "红梅软盒");
		row.put("MAX", 52564.0);
		row.put("MIN", 35042.0);
		row.put("PROFIT", 9.359999999999996);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "王冠(原味9号塑嘴)110S硬盒");
		row.put("MAX", 956.0);
		row.put("MIN", 785);
		row.put("PROFIT", 10.0);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "王冠(原味1号)");
		row.put("MAX", 1925.0);
		row.put("MIN", 1583);
		row.put("PROFIT", 10.0);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "黄山(红光明)硬盒");
		row.put("MAX", 206341.0);
		row.put("MIN", 169599);
		row.put("PROFIT", 10.920000000000002);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "黄山(新一品)硬盒");
		row.put("MAX", 737100.0);
		row.put("MIN", 605850);
		row.put("PROFIT", 10.920000000000002);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "哈德门(金典)硬盒");
		row.put("MAX", 0.0);
		row.put("MIN", 0.0);
		row.put("PROFIT", 10.920000000000002);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "红旗渠(新版银河)硬盒");
		row.put("MAX", 0.0);
		row.put("MIN", 0.0);
		row.put("PROFIT", 10.920000000000002);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "雄狮新硬盒");
		row.put("MAX", 0.0);
		row.put("MIN", 0.0);
		row.put("PROFIT", 13.050000000000004);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "黄山一品(新)硬盒");
		row.put("MAX", 168034.0);
		row.put("MIN", 138114);
		row.put("PROFIT", 13.050000000000004);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "都宝(纯正9号)硬盒");
		row.put("MAX", 40405.0);
		row.put("MIN", 33211);
		row.put("PROFIT", 13.050000000000004);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "红旗渠银河之光硬盒");
		row.put("MAX", 8816.0);
		row.put("MIN", 5876.0);
		row.put("PROFIT", 13.050000000000004);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "黄果树(长征)");
		row.put("MAX", 17005.0);
		row.put("MIN", 11336.0);
		row.put("PROFIT", 13.050000000000004);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "黄山(嘉宾迎客松)硬盒");
		row.put("MAX", 1568199.0);
		row.put("MIN", 1288962);
		row.put("PROFIT", 15.660000000000004);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "双喜软国际软盒");
		row.put("MAX", 43774.0);
		row.put("MIN", 29182.0);
		row.put("PROFIT", 15.660000000000004);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "黄山(金光明)");
		row.put("MAX", 151533.0);
		row.put("MIN", 124551);
		row.put("PROFIT", 16.83);
		rows.add(row);

		row = new Datum();
		row.put("NAME", "黄山(印象一品)硬盒");
		row.put("MAX", 144724.0);
		row.put("MIN", 118954);
		row.put("PROFIT", 16.83);
		rows.add(row);

		SalesData groupdata = new SalesData(rows, 3540307.33, -1);
		int minTotalProfit = new Double(groupdata.getMinTotalProfit()).intValue();
		int maxTotalProfit = new Double(groupdata.getMaxTotalProfit()).intValue();
		
		//double v = test.d1(rows, 3540307.33);
		//System.out.println(minTotalProfit);
		//System.out.println(maxTotalProfit);
		
		

		BigDecimal decimal = new BigDecimal( "1.3211" );
		System.out.println(decimal.setScale(3, BigDecimal.ROUND_UP).doubleValue());
		
		System.out.println(decimal.setScale(3, BigDecimal.ROUND_DOWN).doubleValue());
		
	}
	
	public void tttt()
	{
		Data rows = new Data();
		Datum row = new Datum();
		row.put("NAME", "南京(红)");
		row.put("MAX", 744836.0);
		row.put("MIN", 496556.0);
		row.put("PROFIT", 28.129999999999995);	
		row.put("X", 500000);	
		rows.add(row);
		
		row = new Datum();
		row.put("NAME", "人民大会堂(硬红)硬盒");
		row.put("MAX", 12855.0);
		row.put("MIN", 8569.0);
		row.put("PROFIT", 31.320000000000007);	
		row.put("X", 10000);	
		rows.add(row);
		
		row = new Datum();
		row.put("NAME", "长白山(777)97S硬盒");
		row.put("MAX", 38006.0);
		row.put("MIN", 25336.0);
		row.put("PROFIT", 33.35000000000001);
		row.put("X", 30000);	
		rows.add(row);
		
		row = new Datum();
		row.put("NAME", "红双喜(硬晶喜)硬盒");
		row.put("MAX", 1664.0);
		row.put("MIN", 1109.0);
		row.put("PROFIT", 33.35000000000001);	
		row.put("X", 1200);
		rows.add(row);	

		SalesData groupdata = new SalesData(rows, 541200, -1);
		int minTotalProfit = new Double(groupdata.getMinTotalProfit()).intValue();
		int maxTotalProfit = new Double(groupdata.getMaxTotalProfit()).intValue();
		System.out.println(minTotalProfit);
		System.out.println(maxTotalProfit);
	}
	
	public double d1(Data rows, double totalvolumn)
	{
		double v = 0;
		
		sort(rows,-1);
		
		dd1(rows, totalvolumn);

		for(Datum row : rows)
		{
			v += row.getDouble("X") * row.getDouble("PROFIT");
			System.out.println(row.getDouble("MIN")+"		"+row.getDouble("MAX")+"		"+row.getDouble("X"));
		}
		return v;
	}
	
	
	public void dd1(Data rows, double totalvolumn)
	{
		if(totalvolumn > 0)
		{
			for(Datum row : rows)
			{
				double min = row.getDouble("MIN");
				double max = row.getDouble("MAX");
				if(!row.containsKey("X"))
				{
					row.put("X", min);
					totalvolumn = totalvolumn - min;
				}
				else
				{
					double x = row.getDouble("X");
					double changer = max - x;
					if(changer > 0)
					{
						double value = changer;
						if(value > totalvolumn)
						{
							value = totalvolumn;
						}
						
						row.put("X", x + value);
						totalvolumn = totalvolumn - value;
					}
				}
			}
		}
		
		if(totalvolumn > 0)
		{
			dd1(rows, totalvolumn);
		}
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
