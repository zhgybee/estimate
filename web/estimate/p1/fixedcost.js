
function FixedCost()
{  
	this.year;
	this.month;
	this.cost = {};

	this.items = [
					{key:"K01", value:"房产税"},
					{key:"K02", value:"土地使用税"},
					{key:"K03", value:"车船税"},
					{key:"K04", value:"土地增值税"},
					{key:"K05", value:"管理可控费用"},
					{key:"K06", value:"管理固定费用"},
					{key:"K07", value:"管理人工费用"},
					{key:"K08", value:"销售可控费用"},
					{key:"K09", value:"销售固定费用"},
					{key:"K10", value:"销售人工费用"},
					{key:"K11", value:"财务费用"},
					{key:"K12", value:"公允价值变动损益"},
					{key:"K13", value:"投资收益"},
					{key:"K14", value:"汇兑收益"},
					{key:"K15", value:"营业外收入"},
					{key:"K16", value:"营业外支出"},
					{key:"K17", value:"其他项目税金"},
					{key:"K18", value:"上年留底进项"},
					{key:"K19", value:"费用化进项"},
					{key:"K20", value:"其他业务收入"},
					{key:"K21", value:"其他业务成本"},
					{key:"K22", value:"印花税交税比例"},
					{key:"K23", value:"进项调整金额"}
	
				]

	this.areas = ["芜湖市区卷烟营销部", "芜湖县卷烟营销部", "繁昌县卷烟营销部", "南陵县卷烟营销部", "无为县卷烟营销部", "江北区卷烟营销部", "机关", "物流"]


	this.getTarget = function(target)
	{
		return target + (this.value("K05") + this.value("K06") + this.value("K07")) + (this.value("K08") + this.value("K09") + this.value("K10")) + this.value("K11") - this.value("K12") - this.value("K13") - this.value("K14") - this.value("K15") + this.value("K16") - this.value("K17") + this.value("K18") + this.value("K19") + this.value("K23") - this.value("K20") + this.value("K21");
	}


	this.getProfit = function(profit)
	{
		return profit - (this.value("K05") + this.value("K06") + this.value("K07")) - (this.value("K08") + this.value("K09") + this.value("K10")) - this.value("K11") + this.value("K12") + this.value("K13") + this.value("K14") + this.value("K15") - this.value("K16") + this.value("K17") - this.value("K18") - this.value("K19") - this.value("K23") + this.value("K20") - this.value("K21");
	}

	this.value = function(itemkey, area)
	{
		var number = 0;
		if(area == null || area == "")
		{
			var values = this.cost[itemkey];
			if(values != null)
			{
				for(var key in values)
				{
					number += this.cost[itemkey][key] || 0;
				}
			}
		}
		else
		{
			if(this.cost[itemkey] != null)
			{
				number = this.cost[itemkey][area] || 0;
			}
		}
		return number;
	}
} 

FixedCost.create = function(year, month, cost)
{
	var fixedcost = new FixedCost();
	fixedcost.year = year;
	fixedcost.month = month;
	if(cost != null && cost != "")
	{
		fixedcost.cost = $.parseJSON(cost);
	}
	return fixedcost;
};


function toNumber(value)
{
	if(value == null || value == "")
	{
		return 0;
	}
	else
	{
		return parseFloat(value);
	}
}


