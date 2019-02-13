/* 用户表 */
CREATE TABLE T_USER
(
 ID                  VARCHAR(32),
 NAME                VARCHAR(32),  --姓名
 CODE                VARCHAR(32),  --编码
 LOGIN_NAME          VARCHAR(32),  --登录名
 PASSWORD            VARCHAR(32),  --密码
 CREATE_DATE         VARCHAR(32),  --创建时间
 CONSTRAINT T_USER_PK PRIMARY KEY(ID)
);

/* 往年销量表 */
CREATE TABLE T_SALES
(
 ID                  VARCHAR(32),
 YEAR                VARCHAR(32),  --年份
 MONTH               VARCHAR(32),  --月份
 AREA                VARCHAR(32),  --地区
 BRAND               VARCHAR(32),  --品牌
 MODEL               VARCHAR(32),  --规格
 VOLUME              INT,          --销量
 AMOUNT              DOUBLE,       --销售金额
 COST                DOUBLE,       --调拨价
 PRICE               DOUBLE,       --批发价
 PROFITRATE          VARCHAR(32),  --毛利
 CODE                VARCHAR(32),  --编码
 ISINSIDE            INT,          --是否省内烟
 SORT                INT,          --排序
 CREATE_USER_ID      VARCHAR(32),  --创建人
 CREATE_DATE         VARCHAR(32),  --创建时间
 CONSTRAINT T_SALES_PK PRIMARY KEY(ID)
);

/* 未用 */
CREATE TABLE T_PARAMETERS
(
 ID                  VARCHAR(32),
 P01                 VARCHAR(32),
 P02                 VARCHAR(32),
 P03                 VARCHAR(32),
 P04                 VARCHAR(32),
 P05                 VARCHAR(32),
 YEAR                VARCHAR(32),
 CREATE_USER_ID      VARCHAR(32),  --创建人
 CREATE_DATE         VARCHAR(32),  --创建时间
 CONSTRAINT T_SALES_PK PRIMARY KEY(ID)
);

/* 预测已选方案 */
CREATE TABLE T_SELECTED_PLAN
(
 ID                  VARCHAR(32),
 YEAR                VARCHAR(32),  --年份          
 GROUPNAME           VARCHAR(32),  --价格区间名称          
 GROUPVOLUME         DOUBLE,	   --价格区间销量          
 BRAND               VARCHAR(32),  --品牌          
 MODEL               VARCHAR(32),  --规格          
 MAX                 DOUBLE,	   --最大销量          
 MIN                 DOUBLE,	   --最小销量      
 REMAX               DOUBLE,	   --最大销量     
 REMIN               DOUBLE,	   --最小销量     
 PRICE               DOUBLE,	   --批发价           
 COST                DOUBLE,	   --调拨价          
 RETAILPRICE         DOUBLE,	   --（预测使用）    
 PROFITRATE          VARCHAR(32),  --（预测使用）         
 X                   DOUBLE,	   --销量        
 ISINSIDE            INT,	   --是否省内烟      
 PRODUCER            VARCHAR(256), --卷烟公司
 CREATE_USER_ID      VARCHAR(32),  --创建人
 CREATE_DATE         VARCHAR(32),  --创建时间
 CONSTRAINT T_SELECTED_PLAN_PK PRIMARY KEY(ID)
);

/* 固定费用 */
CREATE TABLE T_CONFIG
(
 ID                  VARCHAR(32),
 YEAR                VARCHAR(32),  --年份          
 MONTH               VARCHAR(32),  --月份    
 CONTENT             VARCHAR(5000),--内容
 CREATE_USER_ID      VARCHAR(32),  --创建人
 CREATE_DATE         VARCHAR(32),  --创建时间
 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

/* 预测年规格 */
CREATE TABLE T_CURRITEMS
(
 ID                  VARCHAR(32),
 YEAR                VARCHAR(32),  --年份
 BRAND               VARCHAR(32),  --品牌
 MODEL               VARCHAR(32),  --规格
 COST                DOUBLE,       --调拨价
 PRICE               DOUBLE,       --批发价
 RETAILPRICE         DOUBLE,       --（预测使用）
 PROFITRATE          VARCHAR(32),  --（预测使用）
 CODE                VARCHAR(32),  --编码
 ISINSIDE            INT,          --是否省内烟
 PRODUCER            VARCHAR(256), --卷烟公司
 SORT                INT,          --排序
 CREATE_USER_ID      VARCHAR(32),  --创建人
 CREATE_DATE         VARCHAR(32),  --创建时间
 CONSTRAINT T_CURRITEMS_PK PRIMARY KEY(ID)
);

--预测的采购计划
CREATE TABLE T_PURCHASE
(
 ID                  VARCHAR(32),  
 YEAR                VARCHAR(32),  --年份
 MONTH               VARCHAR(32),  --月份
 CONTENT             TEXT,         --内容
 CREATE_USER_ID      VARCHAR(32),  --创建人
 CREATE_DATE         VARCHAR(32),  --创建时间
 CONSTRAINT T_PURCHASE_PK PRIMARY KEY(ID)
);


INSERT INTO T_USER(ID, NAME, CODE, LOGIN_NAME, PASSWORD, CREATE_DATE) VALUES('U0', '系统管理员', '001', 'admin', '1', '2000-01-01');


CREATE VIEW T_TOTAL_SALES AS
select ID, YEAR, BRAND, MODEL, ISINSIDE, sum(VOLUME) as 'VOLUME', sum(AMOUNT) as 'AMOUNT', COST, PRICE, PROFITRATE, CODE, SORT, CREATE_USER_ID, CREATE_DATE from T_SALES group by MODEL, YEAR


CREATE VIEW T_SALES_RATIO AS
select a.YEAR, a.PRICE, a.VOLUME, b.TOTAL, cast(a.VOLUME as double) / cast(b.TOTAL as double) as 'SALESRATIO', 0.0008 + 0.92 * (cast(a.VOLUME as double) / cast(b.TOTAL as double)) as 'GROUPRATIO' from
(select YEAR, PRICE, sum(VOLUME) as 'VOLUME' from T_TOTAL_SALES group by PRICE, YEAR) a
left join
(select YEAR, sum(VOLUME) as 'TOTAL' from T_TOTAL_SALES group by YEAR) b
on a.YEAR = b.YEAR


