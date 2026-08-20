
SELECT TOP (1000) [Car_ID]
      ,[Brand]
      ,[Model]
      ,[Year]
      ,[Fuel_Type]
      ,[Transmission]
      ,[Color]
      ,[Owner_Type]
      ,[Mileage_kmpl]
      ,[Price_Lakh]
      ,[Provider]
      ,[Policy_Number]
      ,[Expiry_Date]
      ,[Status]
      ,[Owner_Name]
      ,[Contact]
      ,[City]
      ,[Purchase_Year]
      ,[Buyer_Name]
      ,[Service_Type]
      ,[Service_Date]
      ,[Service_Cost]
      ,[Service_Center]
  FROM [car].[dbo].[MASTER_CAR_DATA]

  select car.[Car_ID]
      ,[Brand]
      ,[Model]
      ,[Year]
      ,[Fuel_Type]
      ,[Transmission]
      ,[Color]
      ,[Owner_Type]
      ,[Mileage_kmpl]
      ,[Price_Lakh],
      [Provider]
      ,[Policy_Number]
      ,[Expiry_Date]
      ,[Status],[Owner_Name]
      ,[Contact]
      ,[City]
      ,[Purchase_Year],[Sale_Price_Lakh]
      ,[Sale_Date]
      ,[Buyer_Name],[Service_Type]
      ,[Service_Date]
      ,[Service_Cost]
      ,[Service_Center] INTO MASTER_CAR_DATA
      from Car
LEFT JOIN INSURANCE
ON CAR.Car_ID=Insurance.CAR_ID
LEFT JOIN OWNERS
ON OWNERS.CAR_ID = CAR.Car_ID
LEFT JOIN SALES
ON SALES.CAR_ID = CAR.CAR_ID
LEFT JOIN SERVICE_HISTORY
ON SERVICE_HISTORY.CAR_ID = CAR.Car_ID

USE car;

SELECT TOP 10 *
FROM dbo.MASTER_CAR_DATA;

USE car;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'MASTER_CAR_DATA'
ORDER BY ORDINAL_POSITION;

USE car;

DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql = @sql +
'SELECT ''' + COLUMN_NAME + ''' AS Column_Name,
        COUNT(*) AS Null_Count
 FROM dbo.MASTER_CAR_DATA
 WHERE [' + COLUMN_NAME + '] IS NULL
 UNION ALL '
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'MASTER_CAR_DATA';

SET @sql = LEFT(@sql, LEN(@sql) - 10);

EXEC sp_executesql @sql;

USE car;

SELECT
    Car_ID,
    COUNT(*) AS Record_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Car_ID
HAVING COUNT(*) > 1
ORDER BY Record_Count DESC;

USE car;

SELECT COUNT(*) AS Total_Records
FROM dbo.MASTER_CAR_DATA;

USE car;

SELECT
    COUNT(*) AS Duplicate_Car_IDs
FROM (
    SELECT Car_ID
    FROM dbo.MASTER_CAR_DATA
    GROUP BY Car_ID
    HAVING COUNT(*) > 1
) AS Duplicates;

USE car;

SELECT COUNT(*) AS Total_Records
FROM dbo.MASTER_CAR_DATA;

USE car;

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Car_ID) AS Car_ID_Not_Null,
    COUNT(Brand) AS Brand_Not_Null,
    COUNT(Model) AS Model_Not_Null,
    COUNT(Price_Lakh) AS Price_Not_Null,
    COUNT(City) AS City_Not_Null,
    COUNT(Service_Cost) AS Service_Cost_Not_Null
FROM dbo.MASTER_CAR_DATA;

USE car;

SELECT
    COUNT(*) AS Invalid_Price_Rows
FROM dbo.MASTER_CAR_DATA
WHERE Price_Lakh <= 0;

USE car;

SELECT
    COUNT(*) AS Invalid_Mileage_Rows
FROM dbo.MASTER_CAR_DATA
WHERE Mileage_kmpl <= 0;

USE car;

SELECT
    MIN(Year) AS Minimum_Year,
    MAX(Year) AS Maximum_Year
FROM dbo.MASTER_CAR_DATA;

USE car;

SELECT
    MIN(Sale_Price_Lakh) AS Min_Sale_Price,
    MAX(Sale_Price_Lakh) AS Max_Sale_Price,
    MIN(Service_Cost) AS Min_Service_Cost,
    MAX(Service_Cost) AS Max_Service_Cost
FROM dbo.MASTER_CAR_DATA;

USE car;

SELECT
    MIN(Sale_Date) AS Min_Sale_Date,
    MAX(Sale_Date) AS Max_Sale_Date,
    MIN(Service_Date) AS Min_Service_Date,
    MAX(Service_Date) AS Max_Service_Date
FROM dbo.MASTER_CAR_DATA;

USE car;

SELECT COUNT(*) AS Invalid_Service_Dates
FROM dbo.MASTER_CAR_DATA
WHERE Service_Date > Sale_Date;

USE car;

SELECT
    Fuel_Type,
    COUNT(*) AS Car_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Fuel_Type
ORDER BY Car_Count DESC;

USE car;

SELECT
    Transmission,
    COUNT(*) AS Car_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Transmission
ORDER BY Car_Count DESC;

USE car;

SELECT
    Status,
    COUNT(*) AS Record_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Status
ORDER BY Record_Count DESC;

USE car;

SELECT
    Owner_Type,
    COUNT(*) AS Record_Count
FROM dbo.MASTER_CAR_DATA
GROUP BY Owner_Type
ORDER BY Record_Count DESC;

CREATE OR ALTER VIEW dbo.vw_Car_Analytics
AS
SELECT
    *,
    Year - Purchase_Year AS Vehicle_Age
FROM dbo.MASTER_CAR_DATA;

USE car;

SELECT TOP 10 *
FROM dbo.vw_Car_Analytics;

USE car;

SELECT
    Brand,
    COUNT(*) AS Car_Count
FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Car_Count DESC;

USE car;

SELECT
    Fuel_Type,
    COUNT(*) AS Car_Count
FROM dbo.vw_Car_Analytics
GROUP BY Fuel_Type
ORDER BY Car_Count DESC;

USE car;

SELECT
    Transmission,
    COUNT(*) AS Car_Count
FROM dbo.vw_Car_Analytics
GROUP BY Transmission
ORDER BY Car_Count DESC;

USE car;

SELECT
    Status,
    COUNT(*) AS Record_Count
FROM dbo.vw_Car_Analytics
GROUP BY Status
ORDER BY Record_Count DESC;

USE car;

SELECT
    Owner_Type,
    COUNT(*) AS Record_Count
FROM dbo.vw_Car_Analytics
GROUP BY Owner_Type
ORDER BY Record_Count DESC;

USE car;

SELECT
    City,
    COUNT(*) AS Record_Count
FROM dbo.vw_Car_Analytics
GROUP BY City
ORDER BY Record_Count DESC;

USE car;

SELECT
    Fuel_Type,
    COUNT(*) AS Record_Count
FROM dbo.vw_Car_Analytics
GROUP BY Fuel_Type
ORDER BY Record_Count DESC;

USE car;

SELECT
    Transmission,
    COUNT(*) AS Record_Count
FROM dbo.vw_Car_Analytics
GROUP BY Transmission
ORDER BY Record_Count DESC;

USE car;

SELECT
    Status,
    COUNT(*) AS Record_Count
FROM dbo.vw_Car_Analytics
GROUP BY Status
ORDER BY Record_Count DESC;

USE car;

SELECT
    Owner_Type,
    COUNT(*) AS Record_Count
FROM dbo.vw_Car_Analytics
GROUP BY Owner_Type
ORDER BY Record_Count DESC;

USE car;

SELECT
    City,
    COUNT(*) AS Record_Count
FROM dbo.vw_Car_Analytics
GROUP BY City
ORDER BY Record_Count DESC;

USE car;

SELECT
    AVG(Sale_Price_Lakh) AS Avg_Sale_Price,
    MIN(Sale_Price_Lakh) AS Min_Sale_Price,
    MAX(Sale_Price_Lakh) AS Max_Sale_Price,
    AVG(Service_Cost) AS Avg_Service_Cost,
    MIN(Service_Cost) AS Min_Service_Cost,
    MAX(Service_Cost) AS Max_Service_Cost,
    AVG(Mileage_kmpl) AS Avg_Mileage,
    MIN(Mileage_kmpl) AS Min_Mileage,
    MAX(Mileage_kmpl) AS Max_Mileage
FROM dbo.vw_Car_Analytics;

USE car;

SELECT
    Brand,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Avg_Sale_Price DESC;

USE car;

SELECT
    Fuel_Type,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage,
    ROUND(AVG(Service_Cost), 2) AS Avg_Service_Cost
FROM dbo.vw_Car_Analytics
GROUP BY Fuel_Type
ORDER BY Avg_Sale_Price DESC;

SELECT
    Vehicle_Age,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Vehicle_Age
ORDER BY Vehicle_Age;

CREATE OR ALTER VIEW dbo.vw_Car_Analytics
AS
SELECT
    *,
    Purchase_Year - Year AS Vehicle_Age
FROM dbo.MASTER_CAR_DATA;

SELECT
    Vehicle_Age,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Vehicle_Age
ORDER BY Vehicle_Age;

SELECT
    Vehicle_Age,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Vehicle_Age
ORDER BY Vehicle_Age;

SELECT
    Vehicle_Age,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Vehicle_Age
ORDER BY Vehicle_Age;

SELECT TOP 10
    Year,
    Purchase_Year,
    Purchase_Year - Year AS Age_Check
FROM dbo.MASTER_CAR_DATA;

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

SELECT
    Vehicle_Age,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
WHERE Vehicle_Age IS NOT NULL
GROUP BY Vehicle_Age
ORDER BY Vehicle_Age;

SELECT
    Provider,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Service_Cost), 2) AS Avg_Service_Cost
FROM dbo.vw_Car_Analytics
GROUP BY Provider
ORDER BY Car_Count DESC;

SELECT
    Brand,
    Fuel_Type,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Brand, Fuel_Type
ORDER BY Brand, Car_Count DESC;

SELECT TOP 10
    Brand,
    Fuel_Type,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Brand, Fuel_Type
ORDER BY Avg_Sale_Price DESC;

SELECT
    Brand,
    COUNT(*) AS Car_Count,
    AVG(Sale_Price_Lakh) AS Avg_Sale_Price,
    RANK() OVER (
        ORDER BY AVG(Sale_Price_Lakh) DESC
    ) AS Price_Rank
FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Price_Rank;

SELECT
    Fuel_Type,
    Brand,
    COUNT(*) AS Car_Count,
    AVG(Sale_Price_Lakh) AS Avg_Sale_Price,
    RANK() OVER (
        PARTITION BY Fuel_Type
        ORDER BY AVG(Sale_Price_Lakh) DESC
    ) AS Brand_Rank
FROM dbo.vw_Car_Analytics
GROUP BY Fuel_Type, Brand
ORDER BY Fuel_Type, Brand_Rank;

WITH BrandRanking AS
(
    SELECT
        Fuel_Type,
        Brand,
        COUNT(*) AS Car_Count,
        AVG(Sale_Price_Lakh) AS Avg_Sale_Price,
        RANK() OVER (
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
    Avg_Sale_Price
FROM BrandRanking
WHERE Brand_Rank = 1
ORDER BY Fuel_Type;

WITH BrandRanking AS
(
    SELECT
        Fuel_Type,
        Brand,
        COUNT(*) AS Car_Count,
        AVG(Sale_Price_Lakh) AS Avg_Sale_Price,
        RANK() OVER (
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
FROM BrandRanking
WHERE Brand_Rank <= 3
ORDER BY Fuel_Type, Brand_Rank;

WITH BrandRanking AS
(
    SELECT
        Fuel_Type,
        Brand,
        COUNT(*) AS Car_Count,
        AVG(Sale_Price_Lakh) AS Avg_Sale_Price,
        RANK() OVER (
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
FROM BrandRanking
WHERE Brand_Rank <= 3
ORDER BY Fuel_Type, Brand_Rank;

SELECT
    Brand,
    COUNT(*) AS Car_Count,
    AVG(Sale_Price_Lakh) AS Avg_Sale_Price
FROM dbo.vw_Car_Analytics
GROUP BY Brand
HAVING AVG(Sale_Price_Lakh) >
(
    SELECT AVG(Sale_Price_Lakh)
    FROM dbo.vw_Car_Analytics
)
ORDER BY Avg_Sale_Price DESC;

SELECT
    Brand,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(
        (SELECT AVG(Sale_Price_Lakh)
         FROM dbo.vw_Car_Analytics), 2
    ) AS Overall_Avg_Price
FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Avg_Sale_Price DESC;

SELECT
    Brand,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,

    CASE
        WHEN AVG(Sale_Price_Lakh) >
             (SELECT AVG(Sale_Price_Lakh)
              FROM dbo.vw_Car_Analytics)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS Price_Category

FROM dbo.vw_Car_Analytics
GROUP BY Brand
ORDER BY Avg_Sale_Price DESC;

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

SELECT
    Fuel_Type,
    Brand,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,

    RANK() OVER (
        PARTITION BY Fuel_Type
        ORDER BY AVG(Sale_Price_Lakh) DESC
    ) AS Brand_Rank

FROM dbo.vw_Car_Analytics
GROUP BY Fuel_Type, Brand
ORDER BY Fuel_Type, Brand_Rank;

WITH Brand_Ranking AS
(
    SELECT
        Fuel_Type,
        Brand,
        COUNT(*) AS Car_Count,
        ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,

        RANK() OVER (
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

SELECT
    Fuel_Type,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(MIN(Sale_Price_Lakh), 2) AS Min_Sale_Price,
    ROUND(MAX(Sale_Price_Lakh), 2) AS Max_Sale_Price,
    ROUND(AVG(Mileage_Kmpl), 2) AS Avg_Mileage
FROM dbo.vw_Car_Analytics
GROUP BY Fuel_Type
ORDER BY Avg_Sale_Price DESC;

SELECT
    Brand,
    Fuel_Type,
    COUNT(*) AS Car_Count,
    ROUND(AVG(Sale_Price_Lakh), 2) AS Avg_Sale_Price,
    ROUND(AVG(Mileage_Kmpl), 2) AS Avg_Mileage,

    CASE
        WHEN AVG(Sale_Price_Lakh) >= 26
             AND AVG(Mileage_Kmpl) >= 17.5
        THEN 'High Price + High Mileage'

        WHEN AVG(Sale_Price_Lakh) >= 26
        THEN 'High Price'

        WHEN AVG(Mileage_Kmpl) >= 17.5
        THEN 'High Mileage'

        ELSE 'Standard'
    END AS Performance_Category

FROM dbo.vw_Car_Analytics
GROUP BY Brand, Fuel_Type
ORDER BY Avg_Sale_Price DESC;




