/* Create Database */
CREATE DATABASE IF NOT EXISTS case_8_swiggy;
SHOW DATABASES;
USE case_8_swiggy;

/* Creating Post sale table */
CREATE TABLE `post_diwali_swiggy` (
  `DT` text,
  `ID` int DEFAULT NULL,
  `City` int DEFAULT NULL,
  `NAME` text,
  `ITEM_ID` int DEFAULT NULL,
  `ITEM_NAME` text,
  `Hour of the day` int DEFAULT NULL,
  `ORDERS` int DEFAULT NULL,
  `QTY` int DEFAULT NULL,
  `ITEM_GMV` int DEFAULT NULL,
  `CATEGORY` text
);

/* Creating Pre sale table */
CREATE TABLE `pre_diwali_swiggy` (
  `DT` text,
  `ID` int DEFAULT NULL,
  `City` int DEFAULT NULL,
  `NAME` text,
  `ITEM_ID` int DEFAULT NULL,
  `ITEM_NAME` text,
  `HR of the day` int DEFAULT NULL,
  `ORDERS` int DEFAULT NULL,
  `QTY` int DEFAULT NULL,
  `ITEM_GMV` int DEFAULT NULL,
  `CATEGORY` text,
  `MyUnknownColumn` int DEFAULT NULL
);


truncate table post_diwali_swiggy;
truncate table pre_diwali_swiggy;


/* Dataset is very big in size, so importing the CSV data to MySQL by Command Line for Fast Importing */

/*

$ mysql -u root -p

$ mysql> SET GLOBAL local_infile=1;
Query OK, 0 rows affected (0.00 sec)

$ mysql> quit
Bye
$ mysql --local-infile=1 -u root -p

mysql> LOAD DATA LOCAL INFILE '/home/dinesh/Data-Science/MySQL/Case8-SwiggyCase/PostDiwaliSwiggyCaseDatasetDiwaliSales.csv'
INTO TABLE post_diwali_swiggy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM post_diwali_swiggy LIMIT 20;

LOAD DATA LOCAL INFILE '/home/dinesh/Data-Science/MySQL/Case8-SwiggyCase/PreDiwaliSwiggyCaseDatasetDiwaliSales.csv'
INTO TABLE pre_diwali_swiggy
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM pre_diwali_swiggy LIMIT 20;

*/

SELECT * FROM pre_diwali_swiggy LIMIT 10;
SELECT * FROM post_diwali_swiggy LIMIT 10;

DESCRIBE pre_diwali_swiggy;
DESCRIBE post_diwali_swiggy;

/* structure pre_diwali_swiggy table */

alter table pre_diwali_swiggy
add temp_date date;

/*Updates the temp_date column's data*/
SET SQL_SAFE_UPDATES = 0;
Update pre_diwali_swiggy Set temp_date = Str_to_date(DT,'%m/%d/%Y');

SELECT * FROM pre_diwali_swiggy LIMIT 20;

ALTER TABLE pre_diwali_swiggy
DROP COLUMN DT;

/* change Date sequence after ITEM_NAME */
ALTER TABLE pre_diwali_swiggy 
CHANGE COLUMN temp_date order_date DATE AFTER ITEM_NAME;

ALTER TABLE pre_diwali_swiggy 
DROP COLUMN MyUnknownColumn;


ALTER TABLE pre_diwali_swiggy 
CHANGE COLUMN ID id INT,
CHANGE COLUMN City city_id INT ,
CHANGE COLUMN NAME shop_name VARCHAR(200),
CHANGE COLUMN ITEM_ID item_id INT,
CHANGE COLUMN ITEM_NAME item_name VARCHAR(200),
CHANGE COLUMN `HR of the day` hour_of_day INT,
CHANGE COLUMN ORDERS orders INT,
CHANGE COLUMN QTY qty INT,
CHANGE COLUMN ITEM_GMV item_gmv INT,
CHANGE COLUMN CATEGORY category VARCHAR(100);

ALTER TABLE pre_diwali_swiggy 
ADD PRIMARY KEY (id);


/* structure post_diwali_swiggy table */

alter table post_diwali_swiggy
add temp_date date;

SET SQL_SAFE_UPDATES = 0;
Update post_diwali_swiggy Set temp_date = Str_to_date(DT,'%d-%M-%y');

SELECT * FROM post_diwali_swiggy LIMIT 20;

ALTER TABLE post_diwali_swiggy
DROP COLUMN DT;

ALTER TABLE post_diwali_swiggy 
CHANGE COLUMN temp_date order_date DATE AFTER ITEM_NAME;

ALTER TABLE post_diwali_swiggy 
CHANGE COLUMN ID id INT,
CHANGE COLUMN City city_id INT ,
CHANGE COLUMN NAME shop_name VARCHAR(200),
CHANGE COLUMN ITEM_ID item_id INT,
CHANGE COLUMN ITEM_NAME item_name VARCHAR(200),
CHANGE COLUMN `Hour of the day` hour_of_day INT,
CHANGE COLUMN ORDERS orders INT,
CHANGE COLUMN QTY qty INT,
CHANGE COLUMN ITEM_GMV item_gmv INT,
CHANGE COLUMN CATEGORY category VARCHAR(100);

ALTER TABLE post_diwali_swiggy 
ADD PRIMARY KEY (id,item_id);

SELECT * FROM post_diwali_swiggy LIMIT 20;

/* ---------------------*/

/* id cannot be primary key in both tables as there are lot of duplicate entry */

select * from post_diwali_swiggy where id = 45914;


SELECT * FROM pre_diwali_swiggy LIMIT 10;
SELECT * FROM post_diwali_swiggy LIMIT 10;

/* Combine both table pre and post data into a new table by adding a new column type */

CREATE TABLE pre_post_diwali_swiggy (
  id int DEFAULT NULL,
  city_id int DEFAULT NULL,
  shop_name varchar(200) DEFAULT NULL,
  item_id int DEFAULT NULL,
  item_name varchar(200) DEFAULT NULL,
  order_date date DEFAULT NULL,
  hour_of_day int DEFAULT NULL,
  orders int DEFAULT NULL,
  qty int DEFAULT NULL,
  item_gmv int DEFAULT NULL,
  category varchar(100) DEFAULT NULL,
  type varchar(20) DEFAULT NULL
);

ALTER TABLE `case_8_swiggy`.`pre_post_diwali_swiggy` 
CHANGE COLUMN `type` `type` VARCHAR(20) NULL DEFAULT NULL ;


/* Dump data from temp table to main table after changing the DOB format and Remission data types */
INSERT INTO pre_post_diwali_swiggy 
(id,city_id,shop_name,item_id,item_name,order_date,hour_of_day,orders,qty,item_gmv,category,type) 
SELECT id,city_id,shop_name,item_id,item_name,order_date,hour_of_day,orders,qty,item_gmv,category,"pre_diwali" 
FROM pre_diwali_swiggy order by ID;

INSERT INTO pre_post_diwali_swiggy 
(id,city_id,shop_name,item_id,item_name,order_date,hour_of_day,orders,qty,item_gmv,category,type) 
SELECT id,city_id,shop_name,item_id,item_name,order_date,hour_of_day,orders,qty,item_gmv,category,"post_diwali" 
FROM post_diwali_swiggy order by ID;

UPDATE pre_post_diwali_swiggy SET item_name = "Rasogulla" WHERE item_name = "Rasgulla";
UPDATE pre_post_diwali_swiggy SET item_name = "Samosa" WHERE item_name = "Samosa (1 Pc)"; 
UPDATE pre_post_diwali_swiggy SET item_name = "Rasogulla" WHERE item_name = "White Rasgulla (1 Pc)";
UPDATE pre_post_diwali_swiggy SET item_name = "Rasogulla" WHERE item_name = "Rasgulla (1 Pc)";

SELECT DISTINCT item_name FROM pre_post_diwali_swiggy WHERE item_name LIKE "Rasg%";
SELECT DISTINCT item_name FROM pre_post_diwali_swiggy WHERE item_name LIKE "Samosa%";


/* Export the database into CSV file */
mysql -u root -p case_8_swiggy -B -e "select * from pre_post_diwali_swiggy;" | sed "s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g" > "/home/dinesh/Data-Science/MySQL/Case8-SwiggyCase/pre_post_diwali_swiggy.csv"


SELECT * FROM pre_post_diwali_swiggy where type = "pre_diwali" LIMIT 10;
SELECT * FROM pre_post_diwali_swiggy where type = "post_diwali" LIMIT 10;

/*******************************************************************************************/

/*Diwali was on 27th oct 2019*/
/*  post diwali range was from 10th oct to 17th oct*/
/*  post diwali range was from 18th oct to 28th oct*/


/* max, min, ave sales and qty */

SELECT type, count(*) as total_count ,min(item_gmv) AS min_gmv, max(item_gmv) AS max_gmv, avg(item_gmv) AS avg_gmv,
min(qty) AS min_qty, max(qty) AS max_qty, avg(qty) AS avg_qty
from pre_post_diwali_swiggy
GROUP BY type;

SELECT type, count(*) as total_count ,sum(item_gmv)/1000 AS total_gmv, avg(item_gmv) AS avg_gmv,
sum(qty) AS total_qty, avg(qty) AS avg_qty
from pre_post_diwali_swiggy
GROUP BY type;

/* Group by item name*/

SELECT type, item_name, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "pre_diwali"
GROUP BY item_name
ORDER BY total_qty DESC
LIMIT 50;


SELECT type, item_name, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "post_diwali"
GROUP BY item_name
ORDER BY total_qty DESC
LIMIT 5;


/* group by date*/

SELECT type, order_date, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "pre_diwali"
GROUP BY order_date
ORDER BY 2 DESC
LIMIT 30;

SELECT type, order_date, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "post_diwali"
GROUP BY order_date
ORDER BY 2 DESC
LIMIT 30;

/* group by shop */

SELECT type, shop_name, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "pre_diwali"
GROUP BY shop_name
ORDER BY total_qty DESC
LIMIT 5;

SELECT type, shop_name, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "post_diwali"
GROUP BY shop_name
ORDER BY total_qty DESC
LIMIT 5; 

/* group by category */

SELECT type, category, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "pre_diwali"
GROUP BY category
ORDER BY total_qty DESC
LIMIT 10;

SELECT type, category, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "post_diwali"
GROUP BY category
ORDER BY total_qty DESC
LIMIT 10; 

/* group by hour_of_day */

SELECT type, hour_of_day, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "pre_diwali"
GROUP BY hour_of_day
ORDER BY 2 DESC
LIMIT 30;

SELECT type, hour_of_day, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "post_diwali"
GROUP BY hour_of_day
ORDER BY 2 DESC
LIMIT 30; 

/* group by city_id */

SELECT type, city_id, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "pre_diwali"
GROUP BY city_id
ORDER BY 2 DESC
LIMIT 30;

SELECT type, city_id, sum(qty) AS total_qty, sum(item_gmv) AS total_gmv
from pre_post_diwali_swiggy
WHERE type = "post_diwali"
GROUP BY city_id
ORDER BY 2 DESC
LIMIT 30; 







