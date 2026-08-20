/*
============================================================
Automotive Sales & Service Analytics
SQL Analysis Script
============================================================
Purpose:
    Build an integrated car analytics dataset, validate data
    quality, create an analytical view, and perform business
    analysis for the Power BI dashboard.

Database:
    car

Main objects:
    dbo.MASTER_CAR_DATA
    dbo.vw_Car_Analytics

Note:
    This script is organized for GitHub readability. The
    original SQL file is kept separately as the backup/history.
============================================================
*/


/* =========================================================
   01. DATA INTEGRATION / ETL
   ========================================================= */

USE car;
GO

-- Preview the existing integrated table
SELECT TOP (1000) *
FROM dbo.MASTER_CAR_DATA;
GO

/*
If MASTER_CAR_DATA has not been created yet, the following
query can be used to create it from the source tables.

Run this section only when the target table does not already
exist.
*/

/*
SELECT
    c.Car_ID,
    c.Brand,
    c.Model,
    c.Year,
    c.Fuel_Type,
    c.Transmission,
    c.Color,
    c.Owner_Type,
    c.Mileage_kmpl,
    c.Price_Lakh,
    i.Provider,
    i.Policy_Number,
    i.Expiry_Date,
    i.Status,
    o.Owner_Name,
    o.Contact,
    o.City,
    o.Purchase_Year,
    s.Sale_Price_Lakh,
    s.Sale_Date,
    s.Buyer_Name,
    sh.Service_Type,
    sh.Service_Date,
    sh.Service_Cost,
    sh.Service_Center
INTO dbo.MASTER_CAR_DATA
FROM dbo.Car AS c
LEFT JOIN dbo.INSURANCE AS i
    ON c.Car_ID = i.Car_ID
LEFT JOIN dbo.OWNERS AS o
    ON c.Car_ID = o.Car_ID
LEFT JOIN dbo.SALES AS s
    ON c.Car_ID = s.Car_ID
LEFT JOIN dbo.SERVICE_HISTORY AS sh
    ON c.Car_ID = sh.Car_ID;
GO
*/


/* =========================================================
   02. DATA STRUCTURE & DATA QUALITY
   ========================================================= */

-- Inspect table structure
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'MASTER_CAR_DATA'
ORDER BY ORDINAL_POSITION;
GO


-- Dynamic null-count check for every column
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql = @sql +
    N'SELECT ''' + COLUMN_NAME + N''' AS Column_Name,
             COUNT(*) AS Null_Count
      FROM dbo.MASTER_CAR_DATA
      WHERE [' + COLUMN_NAME + N'] IS NULL
      UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'MASTER_CAR_DATA';

SET @sql = LEFT(@sql, LEN(@sql) - 10);

EXEC sys.sp_executesql @sql;
GO


-- Check duplicate Car IDs
SELECT
    Car_ID,
    COUNT(*) AS Record_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Car_ID
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;
GO


-- Count duplicated Car IDs
SELECT COUNT(*) AS Duplicate_Car_IDs
FROM
(
    SELECT Car_ID
    FROM dbo.MASTER_CAR_DATA
    GROUP BY Car_ID
    HAVING COUNT(*) > 1
) AS Duplicates;
GO


-- Basic completeness check
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Car_ID) AS Car_ID_Not_Null,
    COUNT(Brand) AS Brand_Not_Null,
    COUNT(Model) AS Model_Not_Null,
    COUNT(Price_Lakh) AS Price_Not_Null,
    COUNT(City) AS City_Not_Null,
    COUNT(Service_Cost) AS Service_Cost_Not_Null
FROM dbo.MASTER_CAR_DATA;
GO


-- Invalid price values
SELECT COUNT(*) AS Invalid_Price_Rows
FROM dbo.MASTER_CAR_DATA
WHERE Price_Lakh <= 0;
GO


-- Invalid mileage values
SELECT COUNT(*) AS Invalid_Mileage_Rows
FROM dbo.MASTER_CAR_DATA
WHERE Mileage_kmpl <= 0;
GO


-- Year range validation
SELECT
    MIN(Year) AS Minimum_Year,
    MAX(Year) AS Maximum_Year
FROM dbo.MASTER_CAR_DATA;
GO


-- Purchase-year range validation
SELECT
    MIN(Purchase_Year) AS Minimum_Purchase_Year,
    MAX(Purchase_Year) AS Maximum_Purchase_Year
FROM dbo.MASTER_CAR_DATA;
GO


-- Price and service-cost range
SELECT
    MIN(Sale_Price_Lakh) AS Min_Sale_Price,
    MAX(Sale_Price_Lakh) AS Max_Sale_Price,
    MIN(Service_Cost) AS Min_Service_Cost,
    MAX(Service_Cost) AS Max_Service_Cost
FROM dbo.MASTER_CAR_DATA;
GO


-- Date range validation
SELECT
    MIN(Sale_Date) AS Min_Sale_Date,
    MAX(Sale_Date) AS Max_Sale_Date,
    MIN(Service_Date) AS Min_Service_Date,
    MAX(Service_Date) AS Max_Service_Date
FROM dbo.MASTER_CAR_DATA;
GO


-- Service should normally occur before/on sale date
SELECT COUNT(*) AS Invalid_Service_Dates
FROM dbo.MASTER_CAR_DATA
WHERE Service_Date > Sale_Date;
GO


/* =========================================================
   03. DIMENSIONAL / DISTRIBUTION ANALYSIS
   ========================================================= */

SELECT
    Fuel_Type,
    COUNT(*) AS Car_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Fuel_Type
ORDER BY Car_Count DESC;
GO


SELECT
    Transmission,
    COUNT(*) AS Car_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Transmission
ORDER BY Car_Count DESC;
GO


SELECT
    Status,
    COUNT(*) AS Record_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Status
ORDER BY Record_Count DESC;
GO


SELECT
    Owner_Type,
    COUNT(*) AS Record_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Owner_Type
ORDER BY Record_Count DESC;
GO


SELECT
    City,
    COUNT(*) AS Record_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY City
ORDER BY Record_Count DESC;
GO


/* =========================================================
   04. ANALYTICAL VIEW
   ========================================================= */

CREATE OR ALTER VIEW dbo.vw_Car_Analytics
AS
SELECT
    *,
    CASE
        WHEN Purchase_Year >= Year
        THEN Purchase_Year - Year
        ELSE NULL
    END AS Vehicle_Age
FROM dbo.MASTER_CAR_DATA;
GO


-- Validate the analytical view
SELECT TOP (10) *
FROM dbo.vw_Car_Analytics;
GO


/* =========================================================
   05. OVERALL KPI ANALYSIS
   ========================================================= */

SELECT
    COUNT(*) AS Total_Cars,
    COUNT(DISTINCT Brand) AS Total_Brands,
    COUNT(DISTINCT Fuel_Type) AS Total_Fuel_Types,
    COUNT(DISTINCT Model) AS Total_Models
FROM dbo.vw_Car_Analytics;
GO


SELECT
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(MIN(Sale_Price_Lakh), 2) AS Min_Sale_Price,
    ROUND(MAX(Sale_Price_Lakh), 2) AS Max_Sale_Price,
    ROUND(AVG(Service_Cost), 2) AS Avg_Service_Cost,
    ROUND(MIN(Service_Cost), 2) AS Min_Service_Cost,
    ROUND(MAX(Service_Cost), 2) AS Max_Service_Cost,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage,
    ROUND(MIN(Mileage_kmpl), 2) AS Min_Mileage,
    ROUND(MAX(Mileage_kmpl), 2) AS Max_Mileage
FROM dbo.vw_Car_Analytics;
GO


/* =========================================================
   06. BRAND PERFORMANCE
   ========================================================= */

SELECT
    Brand,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Avg_Sale_Price DESC;
GO


-- Brands above the overall average sale price
SELECT
    Brand,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price
FROM dbo.vw_Car_Analytics
GROUP BY Brand
HAVING AVG(Sale_Price_Lakh) >
(
    SELECT AVG(Sale_Price_Lakh)
    FROM dbo.vw_Car_Analytics
)
ORDER BY Avg_Sale_Price DESC;
GO


-- Difference from overall average
SELECT
    Brand,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(
        AVG(Sale_Price_Lakh) -
        (SELECT AVG(Sale_Price_Lakh)
         FROM dbo.vw_Car_Analytics), 2
    ) AS Difference_From_Overall_Avg
FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Difference_From_Overall_Avg DESC;
GO


-- Rank brands by average sale price
WITH Brand_Performance AS
(
    SELECT
        Brand,
        COUNT(*) AS Car_Count,
        ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price
    FROM dbo.vw_Car_Analytics
    GROUP BY Brand
)
SELECT
    Brand,
    Car_Count,
    Avg_Sale_Price,
    RANK() OVER (ORDER BY Avg_Sale_Price DESC) AS Price_Rank
FROM Brand_Performance
ORDER BY Price_Rank;
GO


/* =========================================================
   07. FUEL TYPE ANALYSIS
   ========================================================= */

SELECT
    Fuel_Type,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(MIN(Sale_Price_Lakh), 2) AS Min_Sale_Price,
    ROUND(MAX(Sale_Price_Lakh), 2) AS Max_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage,
    ROUND(AVG(Service_Cost), 2) AS Avg_Service_Cost
FROM dbo.vw_Car_Analytics
GROUP BY Fuel_Type
ORDER BY Avg_Sale_Price DESC;
GO


/* =========================================================
   08. BRAND + FUEL TYPE ANALYSIS
   ========================================================= */

SELECT
    Brand,
    Fuel_Type,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Brand, Fuel_Type
ORDER BY Brand, Car_Count DESC;
GO


-- Top 3 brands within each fuel type
WITH Brand_Ranking AS
(
    SELECT
        Fuel_Type,
        Brand,
        COUNT(*) AS Car_Count,
        ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
        RANK() OVER
        (
            PARTITION BY Fuel_Type
            ORDER BY AVG(Sale_Price_Lakh) DESC
        ) AS Brand_Rank
    FROM dbo.vw_Car_Analytics
    GROUP BY Fuel_Type, Brand
)
SELECT
    Fuel_Type,
    Brand,
    Car_Count,
    Avg_Sale_Price,
    Brand_Rank
FROM Brand_Ranking
WHERE Brand_Rank <= 3
ORDER BY Fuel_Type, Brand_Rank;
GO


/* =========================================================
   09. VEHICLE AGE ANALYSIS
   ========================================================= */

SELECT
    Vehicle_Age,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
WHERE Vehicle_Age IS NOT NULL
GROUP BY Vehicle_Age
ORDER BY Vehicle_Age;
GO


/* =========================================================
   10. INSURANCE / SERVICE ANALYSIS
   ========================================================= */

SELECT
    Provider,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Service_Cost), 2) AS Avg_Service_Cost
FROM dbo.vw_Car_Analytics
GROUP BY Provider
ORDER BY Car_Count DESC;
GO


SELECT
    Brand,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Service_Cost), 2) AS Avg_Service_Cost
FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Avg_Service_Cost DESC;
GO


/* =========================================================
   11. PERFORMANCE SEGMENTATION
   ========================================================= */

SELECT
    Brand,
    Fuel_Type,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage,
    CASE
        WHEN AVG(Sale_Price_Lakh) >= 26
             AND AVG(Mileage_kmpl) >= 17.5
            THEN 'High Price + High Mileage'
        WHEN AVG(Sale_Price_Lakh) >= 26
            THEN 'High Price'
        WHEN AVG(Mileage_kmpl) >= 17.5
            THEN 'High Mileage'
        ELSE 'Standard'
    END AS Performance_Category
FROM dbo.vw_Car_Analytics
GROUP BY Brand, Fuel_Type
ORDER BY Avg_Sale_Price DESC;
GO


/* =========================================================
   12. DASHBOARD-SUPPORTING QUERIES
   ========================================================= */

-- Sales by year
SELECT
    YEAR(Sale_Date) AS Sale_Year,
    COUNT(*) AS Cars_Sold,
    ROUND(SUM(Sale_Price_Lakh), 2) AS Total_Sales_Value
FROM dbo.vw_Car_Analytics
WHERE Sale_Date IS NOT NULL
GROUP BY YEAR(Sale_Date)
ORDER BY Sale_Year;
GO


-- Top cities by number of cars
SELECT TOP (10)
    City,
    COUNT(*) AS Car_Count
FROM dbo.vw_Car_Analytics
GROUP BY City
ORDER BY Car_Count DESC;
GO


-- Top 10 brands by average sale price
SELECT TOP (10)
    Brand,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Avg_Sale_Price DESC;
GO


-- Price vs mileage by brand
SELECT
    Brand,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Avg_Sale_Price DESC;
GO


/*
============================================================
END OF SCRIPT
============================================================
*/
