
function summary(rows, parameter, fixedcost, monthmap)
{

	let content = ''
	let width = 420;
	content += '<table>';
	content += '<thead>';
	content += '<tr>';
	content += '<td style="width:380px">项目</td>';
	content += '<td style="width:40px">行次</td>';
	content += '</tr>';
	content += '</thead>';

	content += '<tbody>';
	content += '<tr class="v1" ><td style="text-align:left; font-weight:bold"	>一、营业总收入</td>															<td>1 </td></tr>';
	content += '<tr class="v2" ><td style="text-align:left;"					>　　其中：营业收入</td>														<td>2 </td></tr>';
	content += '<tr class="v3" ><td style="text-align:left;"					>　　　　　主营业务收入</td>													<td>3 </td></tr>';
	content += '<tr class="v4" ><td style="text-align:left;"					>　　　　　其他业务收入</td>													<td>4 </td></tr>';
	content += '<tr class="v5" ><td style="text-align:left;"					>　　　△利息收入</td>															<td>5 </td></tr>';
	content += '<tr class="v6" ><td style="text-align:left;"					>　　　△已赚保费</td>															<td>6 </td></tr>';
	content += '<tr class="v7" ><td style="text-align:left;"					>　　　△手续费及佣金收入</td>													<td>7 </td></tr>';
	content += '<tr class="v8" ><td style="text-align:left; font-weight:bold"	>二、营业总成本</td>															<td>8 </td></tr>';
	content += '<tr class="v9" ><td style="text-align:left;"					>　　其中：营业成本</td>														<td>9 </td></tr>';
	content += '<tr class="v10"><td style="text-align:left;"					>　　　　　主营业务成本</td>													<td>10</td></tr>';
	content += '<tr class="v11"><td style="text-align:left;"					>　　　　　其他业务成本</td>													<td>11</td></tr>';
	content += '<tr class="v12"><td style="text-align:left;"					>　　　△利息支出</td>															<td>12</td></tr>';
	content += '<tr class="v13"><td style="text-align:left;"					>　　　△手续费及佣金支出</td>													<td>13</td></tr>';
	content += '<tr class="v14"><td style="text-align:left;"					>　　　△退保金</td>															<td>14</td></tr>';
	content += '<tr class="v15"><td style="text-align:left;"					>　　　△赔付支出净额</td>														<td>15</td></tr>';
	content += '<tr class="v16"><td style="text-align:left;"					>　　　△提取保险合同准备金净额</td>											<td>16</td></tr>';
	content += '<tr class="v17"><td style="text-align:left;"					>　　　△保单红利支出</td>														<td>17</td></tr>';
	content += '<tr class="v18"><td style="text-align:left;"					>　　　△分保费用</td>															<td>18</td></tr>';
	content += '<tr class="v19"><td style="text-align:left;"					>　　　　营业税金及附加（消费税、城建税、附加、土地增值税、4小）</td>			<td>19</td></tr>';
	content += '<tr class="v20"><td style="text-align:left;"					>　　　　销售费用</td>															<td>20</td></tr>';
	content += '<tr class="v21"><td style="text-align:left;"					>　　　　管理费用</td>															<td>21</td></tr>';
	content += '<tr class="v22"><td style="text-align:left;"					>　　　　　其中：研究与开发费</td>												<td>22</td></tr>';
	content += '<tr class="v23"><td style="text-align:left;"					>　　　　　　　　党建工作经费</td>												<td>23</td></tr>';
	content += '<tr class="v24"><td style="text-align:left;"					>　　　　财务费用</td>															<td>24</td></tr>';
	content += '<tr class="v25"><td style="text-align:left;"					>　　　　　其中：利息支出</td>													<td>25</td></tr>';
	content += '<tr class="v26"><td style="text-align:left;"					>　　　　　　　　利息收入</td>													<td>26</td></tr>';
	content += '<tr class="v27"><td style="text-align:left;"					>　　　　　　　　汇兑净损失（净收益以“-”号填列）</td>							<td>27</td></tr>';
	content += '<tr class="v28"><td style="text-align:left;"					>　　　　资产减值损失</td>														<td>28</td></tr>';
	content += '<tr class="v29"><td style="text-align:left;"					>　　　　其他</td>																<td>29</td></tr>';
	content += '<tr class="v30"><td style="text-align:left;"					>　　加：公允价值变动收益（损失以“-”号填列）</td>								<td>30</td></tr>';
	content += '<tr class="v31"><td style="text-align:left;"					>　　　　投资收益（损失以“-”号填列）</td>										<td>31</td></tr>';
	content += '<tr class="v32"><td style="text-align:left;"					>　　　　　其中：对联营企业和合营企业的投资收益</td>							<td>32</td></tr>';
	content += '<tr class="v33"><td style="text-align:left;"					>　　　△汇兑收益（损失以“-”号填列）</td>										<td>33</td></tr>';
	content += '<tr class="v34"><td style="text-align:left; font-weight:bold"	>三、营业利润（亏损以“－”号填列）</td>										<td>34</td></tr>';
	content += '<tr class="v35"><td style="text-align:left;"					>　　加：营业外收入</td>														<td>35</td></tr>';
	content += '<tr class="v36"><td style="text-align:left;"					>　　　　其中：非流动性资产处置利得</td>										<td>36</td></tr>';
	content += '<tr class="v37"><td style="text-align:left;"					>　　　　　　　非货币性资产交换利得（非货币性交易收益）</td>					<td>37</td></tr>';
	content += '<tr class="v38"><td style="text-align:left;"					>　　　　　　　政府补助（补贴收入）</td>										<td>38</td></tr>';
	content += '<tr class="v39"><td style="text-align:left;"					>　　　　　　　债务重组利得</td>												<td>39</td></tr>';
	content += '<tr class="v40"><td style="text-align:left;"					>　　减：营业外支出</td>														<td>40</td></tr>';
	content += '<tr class="v41"><td style="text-align:left;"					>　　　　其中：非流动资产处置损失</td>											<td>41</td></tr>';
	content += '<tr class="v42"><td style="text-align:left;"					>　　　　　　　非货币性资产交换损失（非货币性交易损失）</td>					<td>42</td></tr>';
	content += '<tr class="v43"><td style="text-align:left;"					>　　　　　　　债务重组损失</td>												<td>43</td></tr>';
	content += '<tr class="v44"><td style="text-align:left; font-weight:bold"	>四、利润总额（亏损总额以“－”号填列）</td>									<td>44</td></tr>';
	content += '<tr class="v45"><td style="text-align:left;"					>　　减：所得税费用</td>														<td>45</td></tr>';
	content += '<tr class="v46"><td style="text-align:left;"					>　　加：#未确认的投资损失</td>													<td>46</td></tr>';
	content += '<tr class="v47"><td style="text-align:left; font-weight:bold"	>五、净利润（净亏损以“－”号填列）</td>										<td>47</td></tr>';
	content += '<tr class="v48"><td style="text-align:left;"					>　　减：*少数股东损益</td>														<td>48</td></tr>';
	content += '<tr class="v49"><td style="text-align:left; font-weight:bold"	>六、利税合计</td>																<td>49</td></tr>';
	content += '<tr class="v50"><td style="text-align:left; font-weight:bold"	>七、应交税费合计</td>															<td>50</td></tr>';
	content += '<tr class="v51"><td style="text-align:left;"					>　　所得税</td>																<td>51</td></tr>';
	content += '<tr class="v52"><td style="text-align:left;"					>　　消费税</td>																<td>52</td></tr>';
	content += '<tr class="v53"><td style="text-align:left;"					>　　增值税</td>																<td>53</td></tr>';
	content += '<tr class="v54"><td style="text-align:left;"					>　　城建税</td>																<td>54</td></tr>';
	content += '<tr class="v55"><td style="text-align:left;"					>　　营业税</td>																<td>55</td></tr>';
	content += '<tr class="v56"><td style="text-align:left;"					>　　中央教育费附加</td>														<td>56</td></tr>';
	content += '<tr class="v57"><td style="text-align:left;"					>　　地方教育费附加</td>														<td>57</td></tr>';
	content += '<tr class="v58"><td style="text-align:left;"					>　　土地增值税</td>															<td>58</td></tr>';
	content += '<tr class="v59"><td style="text-align:left;"					>　　印花税</td>																<td>59</td></tr>';
	content += '<tr class="v60"><td style="text-align:left;"					>　　房产税</td>																<td>60</td></tr>';
	content += '<tr class="v61"><td style="text-align:left;"					>　　城镇土地使用税</td>														<td>61</td></tr>';
	content += '<tr class="v62"><td style="text-align:left;"					>　　车船税</td>																<td>62</td></tr>';
	content += '<tr class="v63"><td style="text-align:left;"					>　　个人所得税</td>															<td>63</td></tr>';
	content += '<tr class="v64"><td style="text-align:left;"					>　　残疾人保障金</td>															<td>64</td></tr>';
	content += '<tr class="v65"><td style="text-align:left;"					>　　水利基金</td>																<td>65</td></tr>';
	content += '<tr class="v66"><td style="text-align:left;"					>　　河道维护费</td>															<td>66</td></tr>';
	content += '<tr class="v67"><td style="text-align:left;"					>　　管理费用中税金部分</td>													<td>67</td></tr>';
	content += '</tbody>';
	content += '</table>';

	let $table = $(content);

	var totalcolumn = null;

	if(monthmap != null)
	{
		var monthnames = monthmap.months;
		for(var i = 0 ; i < monthnames.length ; i++)
		{
			$table.find("thead tr").append('<td style="width:100px">'+monthnames[i]+'月</td>');
			width += 100;

			var monthcontent = monthmap.monthfixedcost[monthnames[i]];
			if(monthcontent == null)
			{
				monthcontent = "{}";
			}
			var monthfixedcost = FixedCost.create(parameter.year, monthnames[i], monthcontent);

			var monthcolumn = handle(rows, parameter, monthnames[i], monthmap.area, monthfixedcost);
			setValue($table, monthcolumn);
			totalcolumn = push(totalcolumn, monthcolumn);
		}
	}
	else
	{
		var areanames = fixedcost.areas;
		for(var i = 0 ; i < areanames.length ; i++)
		{
			$table.find("thead tr").append('<td style="width:140px">'+areanames[i]+'</td>');
			width += 140;

			var areacolumn = handle(rows, parameter, areanames[i], areanames[i], fixedcost);
			setValue($table, areacolumn);
			totalcolumn = push(totalcolumn, areacolumn);
		}
	}

	$table.find("thead tr").append('<td style="width:140px">合计</td>');
	width += 140;
	setValue($table, totalcolumn);

	$table.css("width", width);

	return {content:$table, netprofit:totalcolumn.jlr};

}

function handle(rows, parameter, key, area, fixedcost)
{
	let args = {};
	par = $.extend(args, parameter);

	args.totalprice = 0;
	args.totalcost = 0;
	args.maintotalcost = 0;
	args.xfs = 0;
	args.zzs = 0;

	args.K01 = fixedcost.value("K01", area);
	args.K02 = fixedcost.value("K02", area);
	args.K03 = fixedcost.value("K03", area);
	args.K04 = fixedcost.value("K04", area);
	args.K05 = fixedcost.value("K05", area);
	args.K06 = fixedcost.value("K06", area);
	args.K07 = fixedcost.value("K07", area);
	args.K08 = fixedcost.value("K08", area);
	args.K09 = fixedcost.value("K09", area);
	args.K10 = fixedcost.value("K10", area);
	args.K11 = fixedcost.value("K11", area);
	args.K12 = fixedcost.value("K12", area);
	args.K13 = fixedcost.value("K13", area);
	args.K14 = fixedcost.value("K14", area);
	args.K15 = fixedcost.value("K15", area);
	args.K16 = fixedcost.value("K16", area);
	args.K17 = fixedcost.value("K17", area);
	args.K18 = fixedcost.value("K18", area);
	args.K19 = fixedcost.value("K19", area);
	args.K20 = fixedcost.value("K20", area);
	args.K21 = fixedcost.value("K21", area);
	args.K22 = fixedcost.value("K22", area);
	args.K23 = fixedcost.value("K23", area);


	$.each(rows, function(j, row)
	{
		//营业收入
		args.totalprice += row.PRICE / 1.16 * row[key];
		//营业成本
		args.maintotalcost += row.COST / 1.16 * row[key];
		//增值税
		args.zzs += (row.PRICE / 1.16 - row.COST / 1.16) * row[key] * args.taxrate1;
		//消费税
		args.xfs += row[key] + row.PRICE / 1.16 * row[key] * 0.11;
	});	

	args.totalprice = args.totalprice + args.K20;

	args.maintotalcost = args.maintotalcost + args.K21;

	args.zzs = args.zzs - args.K18 - args.K19 - args.K23;

	//教育税
	args.jys = 0.05 * (args.xfs + args.zzs);
	
	//城建税
	var rate = 0.05;
	if(area.indexOf("芜湖市区") != -1 || area.indexOf("江北区") != -1)
	{
		//芜湖市、江北 0.07
		rate = 0.07;
	}
	args.cjs = args.xfs * 0.07 + args.zzs * rate;
	//印花税
	args.yhs = args.totalprice * args.taxrate2 * args.K22;

	//营业税金及附加（消费税、城建税、附加、土地增值税、4小）
	args.yysjfj = args.xfs + args.jys + args.K04 + args.cjs + args.yhs + args.K01 + args.K02 + args.K03;

	//营业总成本
	args.totalcost = args.maintotalcost + args.yysjfj + args.K08 + args.K09 + args.K10 + args.K05 + args.K06 + args.K07 + args.K11;
	//营业利润
	args.yylr = args.totalprice - args.totalcost + args.K13;
	//利润总额
	args.lrze = args.yylr + args.K15 - args.K16;

	//所得税
	args.sds = args.lrze * 0.25;
	//净利润
	args.jlr = args.lrze - args.sds;
	//利税合计
	args.lshj = args.jlr + args.sds + args.zzs + args.yysjfj + args.K17;

	return args;
}

function push(m1, m2)
{
	if(m1 == null)
	{
		m1 = m2;
	}
	else
	{
		for(var key in m1)
		{
			m1[key] = m1[key] + m2[key];
		}
	}
	return m1;
}

function setValue($table, areacolumn)
{
	$table.find("tbody .v1").append('<td></td>');
	$table.find("tbody .v2").append('<td></td>');
	$table.find("tbody .v3").append('<td>'+app.pre1(areacolumn.totalprice)+'</td>');
	$table.find("tbody .v4").append('<td>'+app.pre1(areacolumn.K20)+'</td>');
	$table.find("tbody .v5").append('<td></td>');
	$table.find("tbody .v6").append('<td></td>');
	$table.find("tbody .v7").append('<td></td>');
	$table.find("tbody .v8").append('<td>'+app.pre1(areacolumn.totalcost)+'</td>');
	$table.find("tbody .v9").append('<td></td>');
	$table.find("tbody .v10").append('<td>'+app.pre1(areacolumn.maintotalcost)+'</td>');
	$table.find("tbody .v11").append('<td>'+app.pre1(areacolumn.K21)+'</td>');
	$table.find("tbody .v12").append('<td></td>');
	$table.find("tbody .v13").append('<td></td>');
	$table.find("tbody .v14").append('<td></td>');
	$table.find("tbody .v15").append('<td></td>');
	$table.find("tbody .v16").append('<td></td>');
	$table.find("tbody .v17").append('<td></td>');
	$table.find("tbody .v18").append('<td></td>');
	$table.find("tbody .v19").append('<td>'+app.pre1(areacolumn.yysjfj)+'</td>');
	$table.find("tbody .v20").append('<td>'+app.pre1(areacolumn.K08 + areacolumn.K09 + areacolumn.K10)+'</td>');
	$table.find("tbody .v21").append('<td>'+app.pre1(areacolumn.K05 + areacolumn.K06 + areacolumn.K07)+'</td>');
	$table.find("tbody .v22").append('<td></td>');
	$table.find("tbody .v23").append('<td></td>');
	$table.find("tbody .v24").append('<td>'+app.pre1(areacolumn.K11)+'</td>');
	$table.find("tbody .v25").append('<td></td>');
	$table.find("tbody .v26").append('<td></td>');
	$table.find("tbody .v27").append('<td></td>');
	$table.find("tbody .v28").append('<td></td>');
	$table.find("tbody .v29").append('<td></td>');
	$table.find("tbody .v30").append('<td></td>');
	$table.find("tbody .v31").append('<td>'+app.pre1(areacolumn.K13)+'</td>');
	$table.find("tbody .v32").append('<td></td>');
	$table.find("tbody .v33").append('<td></td>');
	$table.find("tbody .v34").append('<td>'+app.pre1(areacolumn.yylr)+'</td>');
	$table.find("tbody .v35").append('<td>'+app.pre1(areacolumn.K15)+'</td>');
	$table.find("tbody .v36").append('<td></td>');
	$table.find("tbody .v37").append('<td></td>');
	$table.find("tbody .v38").append('<td></td>');
	$table.find("tbody .v39").append('<td></td>');
	$table.find("tbody .v40").append('<td>'+app.pre1(areacolumn.K16)+'</td>');
	$table.find("tbody .v41").append('<td></td>');
	$table.find("tbody .v42").append('<td></td>');
	$table.find("tbody .v43").append('<td></td>');
	$table.find("tbody .v44").append('<td>'+app.pre1(areacolumn.lrze)+'</td>');
	$table.find("tbody .v45").append('<td>'+app.pre1(areacolumn.sds)+'</td>');
	$table.find("tbody .v46").append('<td></td>');
	$table.find("tbody .v47").append('<td>'+app.pre1(areacolumn.jlr)+'</td>');
	$table.find("tbody .v48").append('<td></td>');
	$table.find("tbody .v49").append('<td>'+app.pre1(areacolumn.lshj)+'</td>');
	$table.find("tbody .v50").append('<td></td>');
	$table.find("tbody .v51").append('<td>'+app.pre1(areacolumn.sds)+'</td>');
	$table.find("tbody .v52").append('<td>'+app.pre1(areacolumn.xfs)+'</td>');
	$table.find("tbody .v53").append('<td>'+app.pre1(areacolumn.zzs)+'</td>');
	$table.find("tbody .v54").append('<td>'+app.pre1(areacolumn.cjs)+'</td>');
	$table.find("tbody .v55").append('<td></td>');
	$table.find("tbody .v56").append('<td>'+app.pre1(areacolumn.jys * 0.6)+'</td>');
	$table.find("tbody .v57").append('<td>'+app.pre1(areacolumn.jys * 0.4)+'</td>');
	$table.find("tbody .v58").append('<td>'+app.pre1(areacolumn.K04)+'</td>');
	$table.find("tbody .v59").append('<td>'+app.pre1(areacolumn.yhs)+'</td>');
	$table.find("tbody .v60").append('<td>'+app.pre1(areacolumn.K01)+'</td>');
	$table.find("tbody .v61").append('<td>'+app.pre1(areacolumn.K02)+'</td>');
	$table.find("tbody .v62").append('<td>'+app.pre1(areacolumn.K03)+'</td>');
	$table.find("tbody .v63").append('<td></td>');
	$table.find("tbody .v64").append('<td></td>');
	$table.find("tbody .v65").append('<td></td>');
	$table.find("tbody .v66").append('<td></td>');
	$table.find("tbody .v67").append('<td>'+app.pre1(areacolumn.K17)+'</td>');
}
