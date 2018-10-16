package com.estimate;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.Random;

import org.apache.commons.lang3.ArrayUtils;

import com.estimate.datasource.Data;
import com.estimate.datasource.Datum;
import java.util.Comparator;

public class SalesData
{
	/* 总销售数量 */
	public double volumetarget;

	/* 总利润目标 */
	public double profittarget;
	
	/* 销售数据 */
	public Data rows;
	
	public int status = 1;
	
	public double[] limit = new double[]{0,0,0,0};

	public SalesData(Data rows)
	{
		this.rows = rows;
	}
	
	public SalesData(Data rows, double volumetarget, double profittarget)
	{
		this.rows = rows;
		this.volumetarget = volumetarget;
		this.profittarget = profittarget;
	}
	
	public void startup()
	{
		double minvolumes = 0;
		double maxvolumes = 0;
		for(Datum row : this.rows)
		{
			double min = row.getDouble("MIN");
			double max = row.getDouble("MAX");
			minvolumes += min;
			maxvolumes += max;
		}
		limit[0] = minvolumes;
		limit[1] = maxvolumes;

		if( minvolumes < this.volumetarget && this.volumetarget < maxvolumes)
		{
			double minprofits = getMinTotalProfit();
			double maxprofits = getMaxTotalProfit();
			limit[2] = minprofits;
			limit[3] = maxprofits;
			
			if(this.profittarget < 0)
			{
				flushVolumes(0);
			}
			else
			{
				if(minprofits < this.profittarget && this.profittarget < maxprofits)
				{
					flushVolumes(0);
					flushProfits(0);
					solve();
				}
				else
				{
					this.status = -2;
				}
			}
		}
		else
		{
			this.status = -1;
		}
	}
	
	
	/**
	 * 解方程组:
	 * x1 + x2 = zt
	 * x1p1 + x2p2 = zp
	 * 得到x2 = (zp - (p1 * zt)) / (p2 - p1)
	 * 把待计算品牌，和每个品牌带入中上述公式中，得到最终的数量
	 * 最终达到效果：每个品牌的销售数量在最大值和最小值之间；各个品牌的销售数量总和等于总销售目标；每个品牌的总利润总和等于总利润目标。
	 */
	public void solve()
	{
		int index = 0;
		for(Datum row : this.rows)
		{
			double x1 = row.getDouble("X");
			double p1 = row.getDouble("PROFIT");
			double tp1 = row.getDouble("TP");
			double min1 = row.getDouble("MIN");
			double max1 = row.getDouble("MAX");
			if(tp1 != 0)
			{
				for(int i = 0 ; i < this.rows.size() ; i++)
				{
					if(i != index)
					{
						Datum targetrow = this.rows.get(i);
						double x2 = targetrow.getDouble("X");
						double p2 = targetrow.getDouble("PROFIT");
						double min2 = targetrow.getDouble("MIN");
						double max2 = targetrow.getDouble("MAX");
						String pair2= targetrow.getString("PAIR");
	
						if(pair2.equals(""))
						{
							double offsetsalestotal = x1 + x2;
							double offsetsalestarget = tp1 + (x2 * p2);
							double kx2 = (offsetsalestarget - (p1 * offsetsalestotal)) / (p2 - p1);
							double kx1 = offsetsalestotal - kx2;
		
							if(min1 < kx1 && kx1 < max1 && min2 < kx2 && kx2 < max2)
							{
								row.put("TP", "");
								row.put("X", kx1);
								targetrow.put("X", kx2);
								break;
							}
						}
					}
				}
			}
			index++;
		}		
	}
	
	/**
		根据总利润目标剩余值（正数或负数）重新规划每个品牌的销售数量
		1：找到可调整的最优品牌（利润最大）
		2：根据剩余总利润目标除以最优品牌的利润，得到对于该品牌，需调整多少销售数量。
		3、最优品牌中调整销售数量，并记录调整的值。
		4、根据最优品牌调整的销售数量，在其他品牌（利润低于最优品牌）中抵消，如果一个品牌抵消不了，则迭代用后面的品牌抵消，如果所有平台都抵消不了变化的值，则改组数据无解。
		5：当剩余总利润目标除以调整品牌的利润，得到的值小于1时，则说明无调整空间，则把剩余的总利润目标全部增加到该品牌的总利润中，并记录该品牌为待计算品牌
		6：递归上述步骤，直到总利润目标为0
		最终达到效果：每个品牌的销售数量在最大值和最小值之间；各个品牌的销售数量总和等于总销售目标；每个品牌的总利润总和应该大致等于总利润目标。其中一个品牌为待计算品牌，该品牌的总利润不同于销售量*利润。
	 */
	public void flushProfits(int index)
	{
		Datum changer = null;
		if(this.profittarget != 0)
		{
			//得到一个可调整的品牌（取利润最大）
			for(Datum row : this.rows)
			{
				double min = row.getDouble("MIN");
				double max = row.getDouble("MAX");
				double x = row.getDouble("X");
				double p = row.getDouble("PROFIT");

				//如果总利润目标为正数，则判断该品牌是否可增加数量
				//如果总利润目标为负数，则判断该品牌是否可减少数量
				boolean ischanger = false;
				if(this.profittarget > 0)
				{
					if(x < max)
					{
						ischanger = true;
					}
				}
				else if(this.profittarget < 0)
				{
					if(min < x)
					{
						ischanger = true;
					}
				}
				
				if(ischanger)
				{
					if(changer == null)
					{
						changer = row;
					}
					else
					{
						if(changer.getDouble("PROFIT") < p)
						{
							changer = row;
						}
					}
				}
			}
			
			if(changer != null)
			{
				double min = changer.getDouble("MIN");
				double max = changer.getDouble("MAX");
				double x = changer.getDouble("X");
				double p = changer.getDouble("PROFIT");
				
				//待变化销售数量
				double rx = this.profittarget / p;
				//实际变化销售数量
				double dx = 0;
				
				//如果待变化销售数量绝对值大于1，说明有调整空间
				if(Math.abs(rx) > 1)
				{
					if(x + rx > max)
					{
						//如果 现有数量 + 调整数量 > 上限 则按最大值增加
						dx = max - x;
					}
					else if(x + rx < min)
					{
						//如果 现有数量 + 调整数量 < 下限 则按最小值增加
						dx = min - x;
					}
					else
					{
						dx = rx;
					}
				}
				else
				{
					//如果需增加销售数量小于1，则直接增加利润，并使用TP标记记录该品牌为待计算品牌（品牌总利润 = 销售数量*利润 + 结余的利润目标）。
					changer.put("TP", (x * p) + this.profittarget);
					this.profittarget -= this.profittarget;
				}
				changer.put("X", x + dx);
				
				//总利润目标减去调整后的利润目标
				this.profittarget = this.profittarget - dx * p;
				
				if(dx != 0)
				{
					for(Datum correr : this.rows)
					{
						double correrp = correr.getDouble("PROFIT");
						double corrermin = correr.getDouble("MIN");
						double corrermax = correr.getDouble("MAX");
						double correrx = correr.getDouble("X");

						if(correrp < p)
						{
							//实际减少数量
							double dex = dx;
							if(correrx - dex < corrermin)
							{
								//如果 当前数量 - 调整数量 小于 最小值，则按最小值增加
								dex = correrx - corrermin;
							}
							else if(correrx - dex > corrermax)
							{
								//如果 当前数量 - 调整数量 大于 最大值，则按最大值增加
								dex = correrx - corrermax;
							}
							correr.put("X", correrx - dex);
							this.profittarget = this.profittarget + dex * correrp;

							
							dx = dx - dex;
							if(dx == 0)
							{
								break;
							}
						}
					}
					
					if(dx != 0)
					{
						this.status = -3;
					}
				}
				
			}
		}
		//print();
		if(this.profittarget != 0)
		{
			flushProfits(index);
		}
	}
	
	
	/**
		根据总销售目标设置每个品牌的销售数量
		1：默认每个品牌的销售量初始值为最小值
		2：递归增加每个品牌的销售数量，每次增加的值为其当前值和最大值之间。
		3、每次增加中，总销售目标减去每次增加的量，总利润目标减去每次增加数量的利润
		4：当总销售目标为0时，则停止增加。
		最终达到效果：每个品牌的销售数量在最大值和最小值之间；各个品牌的销售数量总和等于总销售目标；总利润目标已减去每次增加的销售数量利润。
	*/
	public void flushVolumes(int index)
	{
		//如果总销售数量大于0（还有结余）
		if(this.volumetarget > 0)
		{
			for(Datum row : this.rows)
			{
				double min = row.getDouble("MIN");
				double max = row.getDouble("MAX");
				double p = row.getDouble("PROFIT");
	
				if(!row.containsKey("X"))
				{
					//如果没有设置销售数量，则默认为最小值（第一次设置）
					row.put("X", min);
					//总销售目标减去每次增加的数量
					this.volumetarget = this.volumetarget - min;
					//总利润目标减去每次增加数量的利润
					this.profittarget = this.profittarget - (min * p);
				}
				else
				{
					double x = row.getDouble("X");
					//销售品牌可增销售数量
					double changer = max - x;
					if(changer > 0)
					{
						//如果销售品牌可增销售数量不为0，则在可增销售数量中随机取值
						
						double value = random(0, new Double(changer).intValue()) / 6;
						if(value > this.volumetarget)
						{
							//如果可增销售数量大于剩余的总销售目标，则把剩余的总销售目标直接全部增加
							value = this.volumetarget;
						}
						
						row.put("X", x + value);
						this.volumetarget = this.volumetarget - value;
						this.profittarget = this.profittarget - value * p;
					}
				}
			}
		}
		if(this.volumetarget > 0)
		{
			//如果总销售目标不为0，则递归调用
			index++;
			flushVolumes(index);
		}
	}
	public void print()
	{
		System.out.println("=====================================================================S当前状态S=================================================================================");
		double f = 0;
		double k = 0;
		for(int i = 0 ; i < this.rows.size() ; i++)
		{
			Datum row = rows.get(i);
			System.out.println(row.getString("MODEL")+":");
			System.out.print("X="+row.getString("X")+"");
			System.out.print("	MIN="+row.getString("MIN")+"");
			System.out.print("	MAX="+row.getString("MAX")+"");
			System.out.print("	PROFIT="+row.getString("PROFIT")+"");
			System.out.print("	TP="+row.getString("TP")+"");
			System.out.print("	IS="+ ((row.getDouble("MIN") <= row.getDouble("X") && row.getDouble("X") <= row.getDouble("MAX"))) );
			f += row.getDouble("X");
			k += row.getDouble("X") * row.getDouble("PROFIT");
			System.out.println();
		}
		System.out.println("目前total="+new BigDecimal(f).toString());
		System.out.println("目前target="+new BigDecimal(k).toString());
		System.out.println("=====================================================================E当前状态E=================================================================================");
	}
	
	public double getTotalProfit()
	{
		double totalprofit = 0;
		for(Datum row : this.rows)
		{
			totalprofit += row.getDouble("X") * row.getDouble("PROFIT");
		}
		return totalprofit;
	}
	
	public double getTotalVolumes()
	{
		double totalVolume = 0;
		for(Datum row : this.rows)
		{
			totalVolume += row.getDouble("X");
		}
		return totalVolume;
	}
	
	public void clearVolumes()
	{
		for(Datum row : this.rows)
		{
			row.remove("X");
		}
	}
	public void clearKeys(String name)
	{
		for(Datum row : this.rows)
		{
			row.remove(name);
		}
	}
	
    public int random(int min, int max) 
    {
        Random random = new Random();
        int number = random.nextInt(max) % (max - min + 1) + min;
        return number;
    }
    
    public void sort(int type)
    {
		Collections.sort(this.rows, new Comparator<Datum>() 
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
				return 0;
			}
		});
    }
    
	public double getMaxTotalProfit()
	{
		clearKeys("MAXPROFITX");
		double profit = 0;
		sort(-1);	
		int i = 0;
		maxProfit(this.volumetarget, i);

		for(Datum row : this.rows)
		{
			profit += row.getDouble("MAXPROFITX") * row.getDouble("PROFIT");
		}
		return profit;
	}

	public void maxProfit(double totalvolumn, int index)
	{
		if(totalvolumn > 0)
		{
			for(Datum row : this.rows)
			{
				double min = row.getDouble("MIN");
				double max = row.getDouble("MAX");
				if(!row.containsKey("MAXPROFITX"))
				{
					row.put("MAXPROFITX", min);
					totalvolumn = totalvolumn - min;
				}
				else
				{
					double x = row.getDouble("MAXPROFITX");
					double changer = max - x;
					if(changer > 0)
					{
						double value = changer;
						if(value > totalvolumn)
						{
							value = totalvolumn;
						}
						
						row.put("MAXPROFITX", x + value);
						totalvolumn = totalvolumn - value;
					}
				}
			}
		}
		
		if(totalvolumn > 0 && index < 5)
		{
			index++;
			maxProfit(totalvolumn, index);
		}
	}
	
	public double getMinTotalProfit()
	{
		clearKeys("MINPROFITX");
		double profit = 0;
		sort(1);		
		minProfit(this.volumetarget);

		for(Datum row : this.rows)
		{
			profit += row.getDouble("MINPROFITX") * row.getDouble("PROFIT");
		}
		return profit;
	}

	public void minProfit(double totalvolumn)
	{
		if(totalvolumn > 0)
		{
			for(Datum row : this.rows)
			{
				double min = row.getDouble("MIN");
				double max = row.getDouble("MAX");
				if(!row.containsKey("MINPROFITX"))
				{
					row.put("MINPROFITX", min);
					totalvolumn = totalvolumn - min;
				}
				else
				{
					double x = row.getDouble("MINPROFITX");
					double changer = max - x;
					if(changer > 0)
					{
						double value = changer;
						if(value > totalvolumn)
						{
							value = totalvolumn;
						}
						
						row.put("MINPROFITX", x + value);
						totalvolumn = totalvolumn - value;
					}
				}
			}
		}
		
		if(totalvolumn > 0)
		{
			minProfit(totalvolumn);
		}
	}
/*
	public double getMaxTotalProfit()
	{
		//得到总量一定的情况下，最高利润组合
		double totalprofit = 0;
		for(Datum row : this.rows)
		{
			row.put("MPX", row.getDouble("X"));
			row.put("FLAG", "");
		}
		
		for(int i = 0 ; i < rows.size() ; i++)
		{
			maxProfit();
		}

		for(Datum row : this.rows)
		{
			totalprofit += row.getDouble("MPX") * row.getDouble("PROFIT");
		}
		
		return totalprofit;
	}
	
	public void maxProfit()
	{
		sort(-1);
		Datum changer = null;
		for(Datum row : this.rows)
		{
			double max = row.getDouble("MAX");
			double x = row.getDouble("MPX");
			String flag = row.getString("FLAG");
			if(!flag.equals("1") && max > x)
			{
				changer = row;
				break;
			}
		}
		if(changer != null)
		{
			double changnumber = changer.getDouble("MAX") - changer.getDouble("MPX");
			
			double number = changnumber;
			for(int i = 0 ; i < this.rows.size() ; i++)
			{
				number = changeMaxProfit(number, changer.getDouble("PROFIT"));
				if(number == 0)
				{
					break;
				}
			}
			changer.put("MPX", changer.getDouble("MPX") + changnumber - number);
			changer.put("FLAG", "1");
		}
	}
	
	private double changeMaxProfit(double changnumber, double changeprofit)
	{
		sort(1);
		Datum changer = null;
		for(Datum row : this.rows)
		{
			double min = row.getDouble("MIN");
			double x = row.getDouble("MPX");
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
			double x = changer.getDouble("MPX");
			
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
			changer.put("MPX", x - number);
		}
		return changnumber;
	}

	
	public double getMinTotalProfit()
	{
		//得到总量一定的情况下，最低利润组合
		double totalprofit = 0;
		for(Datum row : this.rows)
		{
			row.put("MPX", row.getDouble("X"));
			row.put("FLAG", "");
		}
		for(int i = 0 ; i < rows.size() ; i++)
		{
			minProfit();
		}

		for(Datum row : this.rows)
		{
			totalprofit += row.getDouble("MPX") * row.getDouble("PROFIT");
		}
		
		return totalprofit;
	}
	
	public void minProfit()
	{
		sort(1);
		Datum changer = null;
		for(Datum row : this.rows)
		{
			double max = row.getDouble("MAX");
			double x = row.getDouble("MPX");
			String flag = row.getString("FLAG");
			if(!flag.equals("1") && max > x)
			{
				changer = row;
				break;
			}
		}
		if(changer != null)
		{
			double changnumber = changer.getDouble("MAX") - changer.getDouble("MPX");
			
			double number = changnumber;
			for(int i = 0 ; i < this.rows.size() ; i++)
			{
				number = changeMinProfit(number, changer.getDouble("PROFIT"));
				if(number == 0)
				{
					break;
				}
			}
			changer.put("MPX", changer.getDouble("MPX") + changnumber - number);
			changer.put("FLAG", "1");
		}
	}
	
	private double changeMinProfit(double changnumber, double changeprofit)
	{
		sort(-1);
		Datum changer = null;
		for(Datum row : this.rows)
		{
			double min = row.getDouble("MIN");
			double x = row.getDouble("MPX");
			double profit = row.getDouble("PROFIT");
			if(profit > changeprofit && x > min)
			{
				changer = row;
				break;
			}
		}

		if(changer != null)
		{
			double min = changer.getDouble("MIN");
			double x = changer.getDouble("MPX");
			
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
			changer.put("MPX", x - number);
		}
		return changnumber;
	}
	*/
}
