CREATE TABLE T_USER
(
 ID                  VARCHAR(32),
 NAME                VARCHAR(32),
 CODE                VARCHAR(32),
 LOGIN_NAME          VARCHAR(32),
 PASSWORD            VARCHAR(32),
 CREATE_DATE         VARCHAR(32),
 CONSTRAINT T_USER_PK PRIMARY KEY(ID)
);


CREATE TABLE T_SALES
(
 ID                  VARCHAR(32),
 YEAR                VARCHAR(32),
 MONTH               VARCHAR(32),
 AREA                VARCHAR(32),
 BRAND               VARCHAR(32),
 MODEL               VARCHAR(32),
 VOLUME              INT,
 AMOUNT              DOUBLE,
 COST                DOUBLE,
 PRICE               DOUBLE,
 PROFITRATE          VARCHAR(32),
 CODE                VARCHAR(32),
 ISINSIDE            INT,
 SORT                INT,
 CREATE_USER_ID      VARCHAR(32),
 CREATE_DATE         VARCHAR(32),
 CONSTRAINT T_SALES_PK PRIMARY KEY(ID)
);

CREATE TABLE T_PARAMETERS
(
 ID                  VARCHAR(32),
 P01                 VARCHAR(32),
 P02                 VARCHAR(32),
 P03                 VARCHAR(32),
 P04                 VARCHAR(32),
 P05                 VARCHAR(32),
 YEAR                VARCHAR(32),
 CREATE_USER_ID      VARCHAR(32),
 CREATE_DATE         VARCHAR(32),
 CONSTRAINT T_SALES_PK PRIMARY KEY(ID)
);

CREATE TABLE T_SELECTED_PLAN
(
 ID                  VARCHAR(32),
 YEAR                VARCHAR(32),
 GROUPNAME           VARCHAR(32),
 GROUPVOLUME         DOUBLE,
 BRAND               VARCHAR(32),
 MODEL               VARCHAR(32),
 MAX                 DOUBLE,
 MIN                 DOUBLE,
 REMAX               DOUBLE,
 REMIN               DOUBLE,
 PRICE               DOUBLE,
 COST                DOUBLE,
 X                   DOUBLE,
 ISINSIDE            INT,
 PRODUCER            VARCHAR(256),
 CREATE_USER_ID      VARCHAR(32),
 CREATE_DATE         VARCHAR(32),
 CONSTRAINT T_SELECTED_PLAN_PK PRIMARY KEY(ID)
);


CREATE TABLE T_CONFIG
(
 ID                  VARCHAR(32),
 YEAR                VARCHAR(32),
 MONTH               VARCHAR(32),
 CONTENT             VARCHAR(5000),
 CREATE_USER_ID      VARCHAR(32),
 CREATE_DATE         VARCHAR(32),
 CONSTRAINT T_CONFIG_PK PRIMARY KEY(ID)
);

CREATE TABLE T_CURRITEMS
(
 ID                  VARCHAR(32),
 YEAR                VARCHAR(32),
 BRAND               VARCHAR(32),
 MODEL               VARCHAR(32),
 COST                DOUBLE,
 PRICE               DOUBLE,
 CODE                VARCHAR(32),
 ISINSIDE            INT,
 PRODUCER            VARCHAR(256),
 SORT                INT,
 CREATE_USER_ID      VARCHAR(32),
 CREATE_DATE         VARCHAR(32),
 CONSTRAINT T_CURRITEMS_PK PRIMARY KEY(ID)
);

CREATE TABLE T_PURCHASE
(
 ID                  VARCHAR(32),
 YEAR                VARCHAR(32),
 MONTH               VARCHAR(32),
 CONTENT             TEXT,
 CREATE_USER_ID      VARCHAR(32),
 CREATE_DATE         VARCHAR(32),
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


