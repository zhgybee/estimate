package com.estimate.office;

import java.awt.Point;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.apache.commons.io.FileUtils;
import org.apache.poi.hssf.converter.ExcelToHtmlConverter;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.w3c.dom.Document;

public class XLSUtils
{
	public static void toHtml(File source, File target) throws ParserConfigurationException, TransformerException, IOException
	{
		String html = XLSUtils.toHtml(source);
		
		try
		{
			FileUtils.write(target, html, "UTF-8");
		}
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}
	
	public static String toHtml(File file) throws ParserConfigurationException, TransformerException, IOException
	{
		String html = null;
		HSSFWorkbook workbook = null;
		FileInputStream fis = null;
		ByteArrayOutputStream bos = null;
		try
		{		
			ExcelToHtmlConverter excelToHtmlConverter = new ExcelToHtmlConverter( DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument() ); 
			excelToHtmlConverter.setOutputColumnHeaders(false); 
			excelToHtmlConverter.setOutputRowNumbers(false); 

			fis = new FileInputStream(file);
			POIFSFileSystem fs = new POIFSFileSystem( fis );
			workbook = new HSSFWorkbook(fs);
			
			excelToHtmlConverter.processWorkbook(workbook); 
			Document document = excelToHtmlConverter.getDocument();
		
			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer t = tf.newTransformer();  
	        t.setOutputProperty(OutputKeys.ENCODING, "UTF-8");    
	        t.setOutputProperty(OutputKeys.INDENT, "yes");    
	        t.setOutputProperty(OutputKeys.METHOD, "html");    
	        
	        bos = new ByteArrayOutputStream();
			t.transform(new DOMSource(document), new StreamResult(bos));
			html = bos.toString("UTF-8");
		}
		finally
		{
			try
			{
				if(workbook != null)
				{
					workbook.close();
				}
				if(fis != null)
				{
					fis.close();
				}
				if(bos != null)
				{
					bos.close();
				}
			}
			catch (IOException e)
			{
				e.printStackTrace();
			}
		}
		return html;
	}

	public static List<String[]> toList(File file, int index)
	{
		Workbook workbook = null;
		FileInputStream fis = null;
		List<String[]> result = new ArrayList<>();
		try
		{
			fis = new FileInputStream(file);
			POIFSFileSystem fs = new POIFSFileSystem( fis );
			workbook = new HSSFWorkbook(fs);
			Sheet sheet = workbook.getSheetAt(index);
	        int rownumber = sheet.getLastRowNum();
	        
	        Row row = sheet.getRow(0);
	        if(row != null)
		    {
		        int colnumber = row.getLastCellNum() - row.getFirstCellNum();
		        for (int i = 0; i <= rownumber; i++) 
		        {
		        	String[] array = new String[colnumber];
		            row = sheet.getRow(i);
		            if(row != null)
		            {
			            for(int j = 0; j < colnumber; j++)
			            {
			            	Cell cell = row.getCell(j);
			            	if(cell == null)
			            	{
			            		array[j] = "";
			            	}
			            	else
			            	{
			            		array[j] = cell.toString();
			            	}
			            }
		            }
		            result.add(array);
		        }
	        }
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if(workbook != null)
				{
					workbook.close();
				}
				if(fis != null)
				{
					fis.close();
				}
			}
			catch (IOException e)
			{
				e.printStackTrace();
			}
		}
		return result;
	}
	
	public static void deleteRow(File excel, String[] sheetnames, int start, int end)
	{

		Workbook workbook = null;
		FileInputStream fis = null;
		FileOutputStream fos = null;
		try
		{
			fis = new FileInputStream(excel);
			
			POIFSFileSystem fs = new POIFSFileSystem( fis );
			workbook = new HSSFWorkbook(fs);
			
			for(String sheetname : sheetnames)
			{
				Sheet sheet = workbook.getSheet(sheetname);
		        int sheetMergeCount = sheet.getNumMergedRegions();  
		        
		        List<Integer> mergenumber = new ArrayList<Integer>();
		        
				for(int i = start ; i <= end ; i++)
				{
					Row row = sheet.getRow(i - 1);
					if(row != null)
					{
						sheet.removeRow(row);
					}
				}
				for (int j = 0; j < sheetMergeCount; j++) 
				{  
					CellRangeAddress range = sheet.getMergedRegion(j);  
					int firstRow = range.getFirstRow();
					int lastRow = range.getLastRow();
					for(int i = start - 1 ; i <= end ; i++)
					{
						if(i >= firstRow && i <= lastRow)
						{
							if(!mergenumber.contains(j))
								mergenumber.add(j);
						}
					}
				}
		        for(int i = mergenumber.size() - 1 ; i >= 0 ; i--)
		        {
					sheet.removeMergedRegion(mergenumber.get(i));
		        }
			}
			
			fos = new FileOutputStream(excel);
			workbook.write(fos);
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if(workbook != null)
				{
					workbook.close();
				}
				if(fis != null)
				{
					fis.close();
				}
				if(fos != null)
				{
					fos.close();
				}
			}
			catch (IOException e)
			{
				e.printStackTrace();
			}
		}
	}
	
	
    
	public static File createXLS(File template, List<XLSData> xlsdatas, File target)
	{
		return createXLS(template, xlsdatas, target, true);
	}
	
	public static File createXLS(File template, List<XLSData> xlsdatas, File target, boolean isIncreaseSheet)
	{
		Workbook workbook = null;
		FileInputStream fis = null;
		FileOutputStream fos = null;
		try
		{
			FileUtils.copyFile(template, target);

			fis = new FileInputStream(target);
			
			POIFSFileSystem fs = new POIFSFileSystem( fis );
			workbook = new HSSFWorkbook(fs);
	
			int index = 0;
			int flag = 1;
			for(XLSData xlsdata : xlsdatas)
			{
				String title = xlsdata.getTitle();
				Sheet sheet = null;
				if(isIncreaseSheet)
				{
					index++;
					//在新文件中创建一个sheet，由于模板中已经存在一个sheet（sheet索引为0），所以克隆后的sheet索引为index					
				    sheet = workbook.cloneSheet(0);
				    if(workbook.getSheet(title) == null)
				    {
				    	workbook.setSheetName(index, title);
				    }
				    else
				    {
				    	workbook.setSheetName(index, title+"-"+flag);
				    	flag++;
				    }
				}
			    else
			    {
			    	sheet = workbook.getSheet(title);
			    }
				
				if(sheet != null)
				{
					List<Map<String, String>> list = xlsdata.getList();
					Map<String, String> data = xlsdata.getData();
					Map<String, Point> positions = xlsdata.getPositions();
					Map<String, Map<String, Object>> styles = xlsdata.getStyles();
					
					if(data != null)
					{
						//填充普通表格（不需要自动变化变结构）数据。
					    Set<String> keys = data.keySet();
					    for(String key : keys)
					    {
					    	Point point = positions.get(key);
					    	if(point != null)
					    	{
						    	int x = point.x;
						    	int y = point.y;
								Row row = sheet.getRow(y);
								if(row != null)
								{
									Cell cell = row.getCell(x);
									if (cell == null)
									{
										cell = row.createCell(x);
									}    
									CellStyle cellStyle = cell.getCellStyle();    
									
								    Map<String, Object> style = styles.get(key);
								    if(style != null)
								    {
								    	cellStyle = XLSUtils.fillCellStyle(workbook, cellStyle, style);
								    }
								    
								    cellStyle.setWrapText(true); 
								    cell.setCellStyle(cellStyle);    
									cell.setCellValue(data.get(key));
								}
								else
								{
							    	System.out.println("��"+y+"����excel����в����ڡ�");
								}
					    	}
					    }
					}
					if(list != null)
					{
						//填充明细表格（需要变化变结构，随着数据自动增加行）数据。
						
						//行模板。在明细表格中，需默认存在第一条数据的行样式。即行模板
						Map<Integer, Row> referrows = new HashMap<Integer, Row>();

						//行模板中最后一行的行号，用于自动增加行时的移动标识。
				    	int startrownumber = 0;

				    	//行模板中合并单元格的规则
				    	Set<CellRangeAddress> mergecells = new HashSet<CellRangeAddress>();
				    	
					    for(int i = 0 ; i < list.size() ; i++)
					    {
					    	Map<String, String> item  = list.get(i);
							
					    	Map<Integer, Row> rows = new HashMap<Integer, Row>();
					    	if(i > 0)
					    	{
					    		//如果不是第一条数据，说明行模板等参数已设置完毕。
					    		
					    		//根据行模板中最后一行的行号进行移动操作，把从行模板中最后一行到模板结尾，向下移动需要增加的行数
					    		int nextrownumber = startrownumber + ( (i - 1) * referrows.size() ) + 1;
					    		Set<Integer> rownumbers = referrows.keySet();
					    		sheet.shiftRows(nextrownumber, sheet.getLastRowNum(), rownumbers.size(), true, false);
					    		
					    		int rowindex = 0;
					    		for(Integer rownumber : rownumbers)
					    		{
					    			//������
					    			Row row = sheet.createRow(nextrownumber + rowindex);
									Row source = referrows.get(rownumber);
									row.setHeight(source.getHeight());
									rows.put(rownumber, row);
									rowindex++;
					    		}
	
					    		for(CellRangeAddress mergecell : mergecells)
					    		{
					    			//把行模板中合并单元格的规则，作用于新增的行中
					    			CellRangeAddress copy = mergecell.copy();
					    			copy.setFirstRow(mergecell.getFirstRow() + (i * rownumbers.size()));
					    			copy.setLastRow(mergecell.getLastRow() + (i * rownumbers.size()));
								    sheet.addMergedRegion(copy);
					    		}
					    	}
					    	
						    Set<String> keys = item.keySet();
						    for(String key : keys)
						    {
						    	Point point = positions.get(key);
						    	if(point != null)
						    	{
							    	int x = point.x;
							    	int y = point.y;
							    	
								    Row row = null;
								    if(i == 0)
								    {
								    	//如果是第一条数据，直接填充到模板已存在的行中，并且设置为行模板。
								    	row = sheet.getRow(y);
								    	referrows.put(y, row);
								    	startrownumber = Math.max(startrownumber, y);
								    	
							    		int mergednumber = sheet.getNumMergedRegions();
							    		for(int j = 0 ; j < mergednumber ; j++)
							    		{
							    			//检测模板中的合并单位格规则是否作用于行模板中，如果作用于，则记录（mergeCells）。
										    CellRangeAddress cellrange = sheet.getMergedRegion(j);
										    if(cellrange.getFirstRow() == y || cellrange.getLastRow() == y)
										    {
										    	mergecells.add(cellrange);
										    }
							    		}
								    }
								    else
								    {
								    	row = rows.get(y);
								    }
								    
								    if(row != null)
								    {
										Cell cell = row.getCell(x);
										if(cell == null)
										{
											cell = row.createCell(x);
											Row source = referrows.get(y);
											cell.setCellStyle(source.getCell(x).getCellStyle());
											cell.setCellType(source.getCell(x).getCellType());
										}
										cell.setCellValue(item.get(key));
								    }
								    else
								    {
								    	System.out.println("第"+y+"行在excel表格中不存在。");
								    }
						    	}
						    }		
					    }
					}
					
				}
				else
				{
					System.out.println("sheet("+title+")在excel表格中不存在。");
				}
			}

			if(isIncreaseSheet)
			{
				workbook.removeSheetAt(0);
			}
			fos = new FileOutputStream(target);
			workbook.write(fos);
		}
		catch(IOException e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if(workbook != null)
				{
					workbook.close();
				}
				if(fis != null)
				{
					fis.close();
				}
				if(fos != null)
				{
					fos.close();
				}
			}
			catch (IOException e)
			{
				e.printStackTrace();
			}
		}
		
		return target;
	}
	
	public static CellStyle fillCellStyle(Workbook workbook, CellStyle source, Map<String, Object> style)
	{
		CellStyle cellStyle = workbook.createCellStyle();
		cellStyle.cloneStyleFrom(source);
		if(style != null)
		{
			Object color = style.get("color");
			if(color != null)
			{
				Font font = workbook.createFont();
				font.setColor( (short)color );
				cellStyle.setFont(font);
			}
			Object background = style.get("background");
			if(color != null)
			{
				cellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
				cellStyle.setFillForegroundColor((short)background);
			}
		}
		
		return cellStyle;
	}
}











