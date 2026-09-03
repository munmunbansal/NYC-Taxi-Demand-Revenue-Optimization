USE Trips_Project;
GO

CREATE TABLE yellow_tripdata_stage (
    VendorID VARCHAR(20),
    tpep_pickup_datetime VARCHAR(50),
    tpep_dropoff_datetime VARCHAR(50),
    passenger_count VARCHAR(20),
    trip_distance VARCHAR(30),
    RatecodeID VARCHAR(20),
    store_and_fwd_flag VARCHAR(10),
    PULocationID VARCHAR(20),
    DOLocationID VARCHAR(20),
    payment_type VARCHAR(20),
    fare_amount VARCHAR(30),
    extra VARCHAR(30),
    mta_tax VARCHAR(30),
    tip_amount VARCHAR(30),
    tolls_amount VARCHAR(30),
    improvement_surcharge VARCHAR(30),
    total_amount VARCHAR(30),
    congestion_surcharge VARCHAR(30),
    Airport_fee VARCHAR(30)
);

BULK INSERT dbo.yellow_tripdata_stage
FROM 'E:\imp_resume_&doc\yellow_tripdata_2025-01.csv'
WITH (
    DATAFILETYPE = 'char',
    CODEPAGE = '65001',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FIRSTROW = 2,
    TABLOCK
);

SELECT TOP 10 *
FROM dbo.yellow_tripdata_stage;

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'yellow_tripdata_stage'
ORDER BY ORDINAL_POSITION;

SELECT
    COUNT(*) AS total_rows,

    SUM(CASE WHEN tpep_pickup_datetime IS NULL OR LTRIM(RTRIM(tpep_pickup_datetime)) = '' THEN 1 ELSE 0 END) AS missing_pickup,

    SUM(CASE WHEN tpep_dropoff_datetime IS NULL OR LTRIM(RTRIM(tpep_dropoff_datetime)) = '' THEN 1 ELSE 0 END) AS missing_dropoff,

    SUM(CASE WHEN passenger_count IS NULL OR LTRIM(RTRIM(passenger_count)) = '' THEN 1 ELSE 0 END) AS missing_passenger_count,

    SUM(CASE WHEN trip_distance IS NULL OR LTRIM(RTRIM(trip_distance)) = '' THEN 1 ELSE 0 END) AS missing_trip_distance,

    SUM(CASE WHEN fare_amount IS NULL OR LTRIM(RTRIM(fare_amount)) = '' THEN 1 ELSE 0 END) AS missing_fare,

    SUM(CASE WHEN total_amount IS NULL OR LTRIM(RTRIM(total_amount)) = '' THEN 1 ELSE 0 END) AS missing_total

FROM dbo.yellow_tripdata_stage;

SELECT TOP 20
    passenger_count,
    VendorID,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    trip_distance,
    fare_amount,
    total_amount
FROM dbo.yellow_tripdata_stage
WHERE passenger_count IS NULL
   OR LTRIM(RTRIM(passenger_count)) = '';

SELECT
    COUNT(*) AS negative_fare_rows
FROM dbo.yellow_tripdata_stage
WHERE TRY_CONVERT(decimal(10,2), fare_amount) < 0;

SELECT TOP 20
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    total_amount,
    payment_type,
    tpep_pickup_datetime,
    tpep_dropoff_datetime
FROM dbo.yellow_tripdata_stage
WHERE TRY_CONVERT(decimal(10,2), fare_amount) < 0;

SELECT
    payment_type,
    COUNT(*) AS negative_fare_count
FROM dbo.yellow_tripdata_stage
WHERE TRY_CONVERT(decimal(10,2), fare_amount) < 0
GROUP BY payment_type
ORDER BY negative_fare_count DESC;


SELECT
    payment_type,
    COUNT(*) AS total_rows
FROM dbo.yellow_tripdata_stage
GROUP BY payment_type
ORDER BY payment_type;

SELECT
    COUNT(*) AS invalid_passenger_count
FROM dbo.yellow_tripdata_stage
WHERE passenger_count IS NOT NULL
  AND TRY_CONVERT(decimal(10,2), passenger_count) IS NULL;


  SELECT
    COUNT(*) AS invalid_trip_distance
FROM dbo.yellow_tripdata_stage
WHERE trip_distance IS NOT NULL
  AND TRY_CONVERT(decimal(10,2), trip_distance) IS NULL;

  SELECT
    COUNT(*) AS invalid_fare_amount
FROM dbo.yellow_tripdata_stage
WHERE fare_amount IS NOT NULL
  AND TRY_CONVERT(decimal(10,2), fare_amount) IS NULL;


SELECT
    COUNT(*) AS invalid_pickup_datetime
FROM dbo.yellow_tripdata_stage
WHERE tpep_pickup_datetime IS NOT NULL
  AND TRY_CONVERT(datetime2, tpep_pickup_datetime) IS NULL;

SELECT
    COUNT(*) AS invalid_dropoff_datetime
FROM dbo.yellow_tripdata_stage
WHERE tpep_dropoff_datetime IS NOT NULL
  AND TRY_CONVERT(datetime2, tpep_dropoff_datetime) IS NULL;

USE Trips_Project;
GO

SELECT
    TRY_CONVERT(int, VendorID) AS VendorID,

    TRY_CONVERT(datetime2, tpep_pickup_datetime) AS tpep_pickup_datetime,

    TRY_CONVERT(datetime2, tpep_dropoff_datetime) AS tpep_dropoff_datetime,

    TRY_CONVERT(decimal(10,2), passenger_count) AS passenger_count,

    TRY_CONVERT(decimal(10,2), trip_distance) AS trip_distance,

    TRY_CONVERT(int, RatecodeID) AS RatecodeID,

    store_and_fwd_flag,

    TRY_CONVERT(int, PULocationID) AS PULocationID,

    TRY_CONVERT(int, DOLocationID) AS DOLocationID,

    TRY_CONVERT(int, payment_type) AS payment_type,

    TRY_CONVERT(decimal(10,2), fare_amount) AS fare_amount,

    TRY_CONVERT(decimal(10,2), extra) AS extra,

    TRY_CONVERT(decimal(10,2), mta_tax) AS mta_tax,

    TRY_CONVERT(decimal(10,2), tip_amount) AS tip_amount,

    TRY_CONVERT(decimal(10,2), tolls_amount) AS tolls_amount,

    TRY_CONVERT(decimal(10,2), improvement_surcharge) AS improvement_surcharge,

    TRY_CONVERT(decimal(10,2), total_amount) AS total_amount,

    TRY_CONVERT(decimal(10,2), congestion_surcharge) AS congestion_surcharge,

    TRY_CONVERT(decimal(10,2), Airport_fee) AS Airport_fee

INTO dbo.yellow_tripdata_clean

FROM dbo.yellow_tripdata_stage;


SELECT TOP 20
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    DATEDIFF(
        MINUTE,
        tpep_pickup_datetime,
        tpep_dropoff_datetime
    ) AS Trip_Duration_Min
FROM dbo.yellow_tripdata_clean;

SELECT COUNT(*) AS negative_duration_trips
FROM dbo.yellow_tripdata_clean
WHERE DATEDIFF(
    MINUTE,
    tpep_pickup_datetime,
    tpep_dropoff_datetime
) < 0;

SELECT
    VendorID,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    fare_amount,
    total_amount,
    payment_type
FROM dbo.yellow_tripdata_clean
WHERE DATEDIFF(
    MINUTE,
    tpep_pickup_datetime,
    tpep_dropoff_datetime
) < 0;

SELECT
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    DATEDIFF(
        SECOND,
        tpep_pickup_datetime,
        tpep_dropoff_datetime
    ) AS duration_seconds,
    trip_distance,
    fare_amount,
    total_amount
FROM dbo.yellow_tripdata_clean
WHERE tpep_dropoff_datetime < tpep_pickup_datetime;

SELECT COUNT(*) AS zero_duration_trips
FROM dbo.yellow_tripdata_clean
WHERE DATEDIFF(
    SECOND,
    tpep_pickup_datetime,
    tpep_dropoff_datetime
) = 0;


SELECT TOP 10
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    DATEDIFF(
        MINUTE,
        tpep_pickup_datetime,
        tpep_dropoff_datetime
    ) AS trip_duration_min,
    trip_distance,
    fare_amount,
    total_amount
FROM dbo.yellow_tripdata_clean
WHERE tpep_dropoff_datetime >= tpep_pickup_datetime
ORDER BY trip_duration_min DESC;

SELECT
    COUNT(*) AS zero_distance_trips
FROM dbo.yellow_tripdata_clean
WHERE trip_distance = 0;

SELECT TOP 10
    trip_distance,
    DATEDIFF(
        MINUTE,
        tpep_pickup_datetime,
        tpep_dropoff_datetime
    ) AS trip_duration_min,
    fare_amount,
    total_amount
FROM dbo.yellow_tripdata_clean
ORDER BY trip_distance DESC;


ALTER TABLE dbo.yellow_tripdata_clean
ADD trip_duration_min AS
    DATEDIFF(
        SECOND,
        tpep_pickup_datetime,
        tpep_dropoff_datetime
    ) / 60.0;


SELECT TOP 10
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    trip_duration_min,
    trip_distance,
    fare_amount,
    total_amount
FROM dbo.yellow_tripdata_clean;


SELECT
    COUNT(*) AS total_trips,
    ROUND(AVG(trip_distance), 2) AS avg_distance,
    ROUND(AVG(trip_duration_min), 2) AS avg_duration_min,
    ROUND(AVG(fare_amount), 2) AS avg_fare,
    ROUND(AVG(total_amount), 2) AS avg_total_amount,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM dbo.yellow_tripdata_clean
WHERE trip_duration_min >= 0;


SELECT
    DATEPART(HOUR, tpep_pickup_datetime) AS pickup_hour,
    COUNT(*) AS trip_count
FROM dbo.yellow_tripdata_clean
WHERE trip_duration_min >= 0
GROUP BY DATEPART(HOUR, tpep_pickup_datetime)
ORDER BY trip_count DESC;




SELECT
    CASE
        WHEN DATEPART(WEEKDAY, tpep_pickup_datetime) IN (1, 7)
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS trip_count
FROM dbo.yellow_tripdata_clean
WHERE trip_duration_min >= 0
GROUP BY
    CASE
        WHEN DATEPART(WEEKDAY, tpep_pickup_datetime) IN (1, 7)
            THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY trip_count DESC;




SELECT
    CASE
        WHEN DATEPART(WEEKDAY, tpep_pickup_datetime) IN (1, 7)
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,

    COUNT(*) AS trip_count,

    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS trip_percentage

FROM dbo.yellow_tripdata_clean

WHERE trip_duration_min >= 0

GROUP BY
    CASE
        WHEN DATEPART(WEEKDAY, tpep_pickup_datetime) IN (1, 7)
            THEN 'Weekend'
        ELSE 'Weekday'
    END;




SELECT
    DATENAME(WEEKDAY, tpep_pickup_datetime) AS pickup_day,
    COUNT(*) AS trip_count
FROM dbo.yellow_tripdata_clean
WHERE trip_duration_min >= 0
GROUP BY DATENAME(WEEKDAY, tpep_pickup_datetime)
ORDER BY trip_count DESC;


SELECT TOP 10
    DATENAME(WEEKDAY, tpep_pickup_datetime) AS pickup_day,
    DATEPART(HOUR, tpep_pickup_datetime) AS pickup_hour,
    COUNT(*) AS trip_count
FROM dbo.yellow_tripdata_clean
WHERE trip_duration_min >= 0
GROUP BY
    DATENAME(WEEKDAY, tpep_pickup_datetime),
    DATEPART(HOUR, tpep_pickup_datetime)
ORDER BY trip_count DESC;


SELECT
    payment_type,
    COUNT(*) AS trip_count,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_transaction_amount
FROM dbo.yellow_tripdata_clean
WHERE trip_duration_min >= 0
GROUP BY payment_type
ORDER BY total_revenue DESC;


SELECT
    DATENAME(WEEKDAY, tpep_pickup_datetime) AS weekday,
    COUNT(*) AS trip_count,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_transaction_amount
FROM dbo.yellow_tripdata_clean
WHERE trip_duration_min >= 0
GROUP BY DATENAME(WEEKDAY, tpep_pickup_datetime)
ORDER BY total_revenue DESC;


SELECT
    DATEPART(HOUR, tpep_pickup_datetime) AS pickup_hour,
    COUNT(*) AS trip_count,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_transaction
FROM dbo.yellow_tripdata_clean
WHERE trip_duration_min >= 0
GROUP BY DATEPART(HOUR, tpep_pickup_datetime)
ORDER BY total_revenue DESC;



SELECT
    CASE
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 1
            THEN 'Very Short'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 3
            THEN 'Short'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 7
            THEN 'Medium'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 15
            THEN 'Long'
        ELSE 'Very Long'
    END AS distance_category,

    COUNT(*) AS trip_count,

    ROUND(SUM(TRY_CONVERT(decimal(10,2), total_amount)), 2)
        AS total_revenue,

    ROUND(AVG(TRY_CONVERT(decimal(10,2), total_amount)), 2)
        AS avg_trip_amount

FROM dbo.yellow_tripdata_clean

WHERE TRY_CONVERT(decimal(10,2), trip_distance) > 0
  AND trip_duration_min >= 0

GROUP BY
    CASE
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 1
            THEN 'Very Short'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 3
            THEN 'Short'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 7
            THEN 'Medium'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 15
            THEN 'Long'
        ELSE 'Very Long'
    END

ORDER BY total_revenue DESC;







SELECT
    CASE
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 1 THEN 'Very Short'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 3 THEN 'Short'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 7 THEN 'Medium'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 15 THEN 'Long'
        ELSE 'Very Long'
    END AS distance_category,

    ROUND(
        AVG(TRY_CONVERT(decimal(10,2), total_amount)), 2
    ) AS avg_trip_amount

FROM dbo.yellow_tripdata_clean

WHERE TRY_CONVERT(decimal(10,2), trip_distance) > 0
  AND trip_duration_min >= 0

GROUP BY
    CASE
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 1 THEN 'Very Short'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 3 THEN 'Short'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 7 THEN 'Medium'
        WHEN TRY_CONVERT(decimal(10,2), trip_distance) <= 15 THEN 'Long'
        ELSE 'Very Long'
    END

ORDER BY avg_trip_amount DESC;




SELECT TOP 10
    PULocationID AS pickup_location,
    COUNT(*) AS trip_count
FROM dbo.yellow_tripdata_clean
WHERE trip_duration_min >= 0
GROUP BY PULocationID
ORDER BY trip_count DESC;


SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';


USE Trips_Project;
GO

CREATE TABLE dbo.taxi_zone_lookup (
    LocationID INT,
    Borough VARCHAR(50),
    Zone VARCHAR(100),
    service_zone VARCHAR(50)
);


BULK INSERT dbo.taxi_zone_lookup
FROM 'E:\imp_resume_&doc\taxi_zone_lookup.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    TABLOCK
);


SELECT COUNT(*) AS zone_rows
FROM dbo.taxi_zone_lookup;


SELECT TOP 10 *
FROM dbo.taxi_zone_lookup;



SELECT TOP 10
    t.PULocationID,
    z.Borough,
    z.Zone,
    COUNT(*) AS trip_count
FROM dbo.yellow_tripdata_clean AS t
JOIN dbo.taxi_zone_lookup AS z
    ON t.PULocationID = z.LocationID
WHERE t.trip_duration_min >= 0
GROUP BY
    t.PULocationID,
    z.Borough,
    z.Zone
ORDER BY trip_count DESC;



SELECT TOP 10
    z.Borough,
    z.Zone,
    COUNT(*) AS trip_count
FROM dbo.yellow_tripdata_clean AS t
JOIN dbo.taxi_zone_lookup AS z
    ON t.DOLocationID = z.LocationID
WHERE t.trip_duration_min >= 0
GROUP BY
    z.Borough,
    z.Zone
ORDER BY trip_count DESC;


SELECT TOP 10
    z1.Zone AS pickup_zone,
    z2.Zone AS dropoff_zone,
    COUNT(*) AS trip_count
FROM dbo.yellow_tripdata_clean AS t
JOIN dbo.taxi_zone_lookup AS z1
    ON t.PULocationID = z1.LocationID
JOIN dbo.taxi_zone_lookup AS z2
    ON t.DOLocationID = z2.LocationID
WHERE t.trip_duration_min >= 0
GROUP BY
    z1.Zone,
    z2.Zone
ORDER BY trip_count DESC;


SELECT TOP 10
    z1.Zone AS pickup_zone,
    z2.Zone AS dropoff_zone,
    COUNT(*) AS trip_count,
    ROUND(SUM(TRY_CONVERT(decimal(10,2), t.total_amount)), 2) AS total_revenue,
    ROUND(AVG(TRY_CONVERT(decimal(10,2), t.total_amount)), 2) AS avg_trip_amount
FROM dbo.yellow_tripdata_clean AS t
JOIN dbo.taxi_zone_lookup AS z1
    ON t.PULocationID = z1.LocationID
JOIN dbo.taxi_zone_lookup AS z2
    ON t.DOLocationID = z2.LocationID
WHERE t.trip_duration_min >= 0
GROUP BY
    z1.Zone,
    z2.Zone
ORDER BY total_revenue DESC;


SELECT
    t.PULocationID,
    t.DOLocationID,
    t.fare_amount,
    t.tip_amount,
    t.tolls_amount,
    t.total_amount,
    t.tpep_pickup_datetime,
    t.tpep_dropoff_datetime
FROM dbo.yellow_tripdata_clean AS t
JOIN dbo.taxi_zone_lookup AS z1
    ON t.PULocationID = z1.LocationID
JOIN dbo.taxi_zone_lookup AS z2
    ON t.DOLocationID = z2.LocationID
WHERE z1.Zone = 'LaGuardia Airport'
  AND z2.Zone = 'Astoria Park'
ORDER BY TRY_CONVERT(decimal(10,2), t.total_amount) DESC;


SELECT
    COUNT(*) AS extreme_amount_trips
FROM dbo.yellow_tripdata_clean
WHERE TRY_CONVERT(decimal(10,2), total_amount) > 1000;

SELECT
    PULocationID,
    DOLocationID,
    fare_amount,
    tip_amount,
    tolls_amount,
    total_amount,
    tpep_pickup_datetime,
    tpep_dropoff_datetime
FROM dbo.yellow_tripdata_clean
WHERE TRY_CONVERT(decimal(10,2), total_amount) > 1000
ORDER BY TRY_CONVERT(decimal(10,2), total_amount) DESC;



SELECT
    PULocationID,
    DOLocationID,
    trip_distance,
    trip_duration_min,
    fare_amount,
    total_amount
FROM dbo.yellow_tripdata_clean
WHERE TRY_CONVERT(decimal(10,2), total_amount) > 1000
ORDER BY TRY_CONVERT(decimal(10,2), total_amount) DESC;



SELECT COUNT(*) AS rows_before
FROM dbo.yellow_tripdata_clean;

SELECT COUNT(*) AS rows_after
FROM dbo.yellow_tripdata_clean
WHERE TRY_CONVERT(decimal(10,2), total_amount) <= 1000;


SELECT *
INTO dbo.yellow_tripdata_final
FROM dbo.yellow_tripdata_clean
WHERE TRY_CONVERT(decimal(10,2), total_amount) <= 1000;

SELECT COUNT(*) AS final_rows
FROM dbo.yellow_tripdata_final;


SELECT
    COUNT(*) AS total_trips,
    ROUND(SUM(TRY_CONVERT(decimal(10,2), total_amount)), 2) AS total_revenue,
    ROUND(AVG(TRY_CONVERT(decimal(10,2), total_amount)), 2) AS avg_trip_amount,
    ROUND(AVG(TRY_CONVERT(decimal(10,2), trip_distance)), 2) AS avg_trip_distance,
    ROUND(AVG(trip_duration_min), 2) AS avg_trip_duration
FROM dbo.yellow_tripdata_final;


SELECT
    payment_type,
    COUNT(*) AS trip_count,
    ROUND(SUM(TRY_CONVERT(decimal(10,2), total_amount)), 2) AS total_revenue,
    ROUND(AVG(TRY_CONVERT(decimal(10,2), total_amount)), 2) AS avg_trip_amount
FROM dbo.yellow_tripdata_final
GROUP BY payment_type
ORDER BY total_revenue DESC;


SELECT
    DATENAME(WEEKDAY, tpep_pickup_datetime) AS day_of_week,
    COUNT(*) AS trip_count,
    ROUND(SUM(TRY_CONVERT(decimal(10,2), total_amount)), 2) AS total_revenue,
    ROUND(AVG(TRY_CONVERT(decimal(10,2), total_amount)), 2) AS avg_trip_amount
FROM dbo.yellow_tripdata_final
GROUP BY DATENAME(WEEKDAY, tpep_pickup_datetime),
         DATEPART(WEEKDAY, tpep_pickup_datetime)
ORDER BY trip_count DESC


SELECT
    DATEPART(HOUR, tpep_pickup_datetime) AS pickup_hour,
    COUNT(*) AS trip_count
FROM dbo.yellow_tripdata_final
GROUP BY DATEPART(HOUR, tpep_pickup_datetime)
ORDER BY trip_count DESC;;


SELECT
    DATEPART(HOUR, tpep_pickup_datetime) AS pickup_hour,
    COUNT(*) AS trip_count,
    ROUND(SUM(TRY_CONVERT(decimal(10,2), total_amount)), 2) AS total_revenue,
    ROUND(AVG(TRY_CONVERT(decimal(10,2), total_amount)), 2) AS avg_trip_amount
FROM dbo.yellow_tripdata_final
GROUP BY DATEPART(HOUR, tpep_pickup_datetime)
ORDER BY total_revenue DESC;