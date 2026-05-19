CREATE DATABASE Electric_Vehicle_Population
USE Electric_Vehicle_Population

drop table if exists ev_pop

CREATE TABLE ev_pop
(VIN VARCHAR (10),
County VARCHAR (50),
City VARCHAR (50),
State CHAR (5),
Postal_Code VARCHAR (10),
Model_year	INT,
Make VARCHAR (30),
Model VARCHAR (30),
Electric_vehicle_type VARCHAR (40),
Clean_Alternative_Fuel_Vehicle_Eligibility	VARCHAR (60),
Electric_Range INT,
Legislative_district INT,
DOL_vehicle_ID BIGINT PRIMARY KEY NOT NULL,
Vehicle_Location VARCHAR (100),
Electric_utility VARCHAR (120),
Census_tract_2020 VARCHAR (20))


BULK INSERT ev_pop
FROM 'C:\Users\Ato\Downloads\Electric_Vehicle_Population_Data.csv'
WITH ( FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	CODEPAGE = 65001,
	TABLOCK);

	SELECT c.column_id, c.name, t.name AS data_type, c.max_length
FROM sys.columns c
JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.ev_pop')
ORDER BY c.column_id;
--checking the various columns in the table and their datatypes

--BULK INSERT dbo.ev_pop
--FROM 'C:\Users\Ato\Downloads\Electric_Vehicle_Population_Data.csv'
--WITH (
 --   FIRSTROW = 2,
 --   FIELDTERMINATOR = ',',
 --   ROWTERMINATOR = '0x0d0a',
 --   CODEPAGE = '65001',
 --   ERRORFILE = 'C:\Users\Ato\Downloads\ev_pop_errors_2.log',
 --   MAXERRORS = 1000
--);

ALTER TABLE ev_pop
ALTER COLUMN Electric_Utility VARCHAR (120);
ALTER TABLE ev_pop
ALTER COLUMN Make VARCHAR (50);
--alter table, alter column

BULK INSERT dbo.ev_pop
FROM 'C:\Users\Ato\Downloads\Electric_Vehicle_Population_Data.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    CODEPAGE = '65001',
    ROWTERMINATOR = '0x0d0a',
    MAXERRORS = 1000,
    ERRORFILE = 'C:\Users\Ato\Downloads\ev_pop_err_run3');
--new bulk insert SYNTAX

SELECT
  kc.name AS pk_name,
  c.name  AS pk_column
FROM sys.key_constraints kc
JOIN sys.index_columns ic 
  ON kc.parent_object_id = ic.object_id 
 AND kc.unique_index_id  = ic.index_id
JOIN sys.columns c
  ON ic.object_id = c.object_id 
 AND ic.column_id = c.column_id
WHERE kc.type = 'PK'
  AND kc.parent_object_id = OBJECT_ID('dbo.ev_pop');
  --checking which column had the PK.

  TRUNCATE TABLE ev_pop
--deleting all all records in the table

  SELECT * FROM ev_pop

--DATA CLEANING & MODELLING
SELECT
    DOL_vehicle_ID,
    COUNT(*) AS dol_count
  FROM ev_pop
  GROUP BY dol_vehicle_id
  HAVING COUNT (*) >1;
--checking for duplicate in PK column

--NULL VALUES
SELECT * 
FROM ev_pop
WHERE county IS NULL OR
      city IS NULL OR
      state IS NULL OR
      model_year IS NULL OR
      make IS NULL OR
      model IS NULL OR
      electric_utility IS NULL OR
      census_tract_2020 IS NULL OR
      postal_code IS NULL OR
      vehicle_location IS NULL OR
      legislative_district IS NULL OR
      electric_range IS NULL;
--checking for NULL values (data cleaning)

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN model_year IS NULL THEN 1 ELSE 0 END) AS model_year_nulls,
    SUM(CASE WHEN make IS NULL THEN 1 ELSE 0 END) AS make_nulls,
    SUM(CASE WHEN electric_range IS NULL THEN 1 ELSE 0 END) AS erange_nulls,
    SUM(CASE WHEN model IS NULL THEN 1 ELSE 0 END) AS model_nulls
FROM ev_pop;
-- Understanding the NUMBER OF NULLS in the KEY columns to know how to handle them because not all nulls are handled the same)
--Only electric_range has nulls (5) of the 4 core columns 

SELECT
  COUNT(*) AS total_rows,
  100.0 * SUM(CASE WHEN electric_range IS NULL THEN 1 ELSE 0 END) / COUNT(*) AS erange_null_pct
FROM ev_pop;
--checking the % of nulls vs the entire records

--WHITESPACE
SELECT
    column_name,
    COUNT(*) AS whitespace_rows
FROM (
    SELECT 'county' AS column_name, county AS value FROM ev_pop
UNION ALL
    SELECT 'city', city from ev_pop
UNION ALL
    SELECT 'state', state from ev_pop
UNION ALL
    SELECT 'make', make from ev_pop
UNION ALL
    SELECT 'model', model from ev_pop
UNION ALL 
    SELECT 'electric_utility', electric_utility from ev_pop
    ) t
    WHERE VALUE IS NOT NULL
    AND value <>LTRIM(RTRIM(value))
GROUP BY column_name;

--ANALYSIS
--KPIs
SELECT
    COUNT(*) AS total_vehicles,
    COUNT(DISTINCT make) AS disc_make,
    COUNT(DISTINCT model) AS disc_model,
    COUNT(DISTINCT state) AS disc_state,
    MIN(model_year) AS earliest_year,
    MAX(model_year) AS latest_year
FROM ev_pop;

--EV Adoption over Time (How has EV adoption evolved?)
SELECT
    model_year,
    COUNT(*) AS vehicle_count
FROM ev_pop
GROUP BY model_year
ORDER BY model_year DESC;

--Adoption by EV type (Are BEVs or PHEVs driving growth?)
SELECT
    electric_vehicle_type,
    COUNT(*) AS vehicle_count
FROM ev_pop
GROUP BY Electric_vehicle_type
ORDER BY vehicle_count DESC

--Most popular vehicles registered by MAKE (who dominates the EV market)
SELECT
    make,
    COUNT(*) as vehicle_count
FROM ev_pop
GROUP BY make
ORDER BY vehicle_count DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--Most popular models (Which specific models drive adoption?)
SELECT 
    model_year,
    model,
    COUNT(*) as model_count
FROM ev_pop
GROUP BY model_year, model
(
    SELECT
    make,
    model,
    COUNT(*) AS model_count
FROM ev_pop
GROUP BY make, model
ORDER BY model_count DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--Average electric range by year (Is EV technology improving over time?)
SELECT
    model_year,
    AVG(electric_range * 1.0) AS avg_electric_range
FROM ev_pop
    WHERE electric_range IS NOT NULL
        GROUP BY model_year
        ORDER BY avg_electric_range DESC;

--Average Electric range by manufacturer (Who leads in battery performance?)
SELECT
    make,
    AVG(electric_range * 1.0) AS avg_erange
FROM ev_pop
WHERE electric_range IS NOT NULL
  GROUP BY make
    ORDER BY avg_erange DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--Which utilities support the most EVs?
SELECT
  electric_utility,
  COUNT(*) AS vehicle_count
FROM ev_pop
GROUP BY electric_utility
ORDER BY vehicle_count DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--EV adoption overtime
SELECT
    model_year,
    COUNT(*) AS vehicle_count
FROM ev_pop
GROUP BY model_year
ORDER BY model_year DESC;


--year on year change (is ev adoption growing or slowing down)
WITH yearly_counts AS (
  SELECT
    model_year,
    COUNT(*) AS ev_count
  FROM ev_pop
  GROUP BY model_year
)
SELECT
  model_year,
  ev_count,
  ev_count - LAG(ev_count) OVER (ORDER BY model_year) AS yoy_change
FROM yearly_counts
ORDER BY model_year;


--top make per ev type
    WITH ranked_makes AS (
  SELECT
    electric_vehicle_type,
    make,
    COUNT(*) AS vehicle_count,
    ROW_NUMBER() OVER (
      PARTITION BY electric_vehicle_type
      ORDER BY COUNT(*) DESC
    ) AS rn
  FROM ev_pop
  GROUP BY electric_vehicle_type, make
)
SELECT
  electric_vehicle_type,
  make,
  vehicle_count
FROM ranked_makes
WHERE rn <= 5
ORDER BY electric_vehicle_type, vehicle_count DESC;

SELECT
  model_year,
  make,
  model,
  AVG(electric_range * 1.0) AS avg_electric_range
FROM ev_pop
WHERE electric_range IS NOT NULL
GROUP BY model_year, make, model
ORDER BY avg_electric_range DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

--BEV vs PHEV
SELECT
  model_year,
  electric_vehicle_type
FROM ev_pop
GROUP BY model_year, electric_vehicle_type
ORDER BY model_year, electric_vehicle_type;


SELECT
  electric_vehicle_type,
  COUNT(*) AS vehicle_count,
  ROUND(
    100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
    2
  ) AS percentage_of_total
FROM ev_pop
GROUP BY electric_vehicle_type
ORDER BY vehicle_count DESC;

WITH model_volume AS (
  SELECT
    make,
    model,
    COUNT(*) AS total_records
  FROM ev_pop
  WHERE electric_range IS NOT NULL
  GROUP BY make, model
)
SELECT *
FROM model_volume
WHERE total_records >= 300   -- threshold you can tune
ORDER BY total_records DESC;

--Calculating the year-on-year changes in electric range of top models
WITH model_yearly_range AS (
  SELECT
    model_year,
    make,
    model,
    CONCAT(make, ' ', model) AS make_model,
    AVG(electric_range * 1.0) AS avg_range
  FROM ev_pop
  WHERE electric_range IS NOT NULL
  GROUP BY model_year, make, model
),
model_yoy AS (
SELECT
  model_year,
  make,
  make_model,
  model,
  avg_range,
  avg_range
    - LAG(avg_range) OVER (
        PARTITION BY make, model
        ORDER BY model_year
      ) AS yoy_range_change
FROM model_yearly_range
),
model_stats AS (
    SELECT
        make_model,
        COUNT(DISTINCT model_year) AS years_present,
        SUM (
            CASE WHEN yoy_range_change IS NOT NULL
            THEN ROUND(ABS(yoy_range_change),2)
            ELSE 0
        END) AS total_change
    FROM model_yoy
    GROUP BY make_model)
    SELECT
        make_model,
        years_present,
        total_change
    FROM model_stats
   WHERE years_present >=3
   AND total_change > 0
  ORDER BY total_change DESC;


 
