-- =====================================================================
-- NYC TAXI: SUPPLY-DEMAND GAP & FLEET REBALANCING QUERY
-- =====================================================================

-- 1. Peak Hour Demand vs Revenue Contribution
SELECT 
    EXTRACT(HOUR FROM tpep_pickup_datetime) AS pickup_hour,
    COUNT(VendorID) AS total_trips,
    ROUND(SUM(total_amount), 2) AS total_revenue,
    ROUND(AVG(trip_distance), 2) AS avg_distance,
    ROUND(AVG(total_amount), 2) AS avg_fare
FROM fact_taxi_trips
GROUP BY EXTRACT(HOUR FROM tpep_pickup_datetime)
ORDER BY total_trips DESC;

-- 2. High-Density Corridor Demand (Midtown <-> Upper East Side)
SELECT 
    pz.zone AS pickup_zone,
    dz.zone AS dropoff_zone,
    COUNT(*) AS total_corridor_trips,
    ROUND(SUM(t.total_amount), 2) AS corridor_revenue
FROM fact_taxi_trips t
JOIN dim_taxi_zones pz ON t.pu_location_id = pz.location_id
JOIN dim_taxi_zones dz ON t.do_location_id = dz.location_id
WHERE EXTRACT(HOUR FROM tpep_pickup_datetime) BETWEEN 17 AND 19
GROUP BY pz.zone, dz.zone
ORDER BY total_corridor_trips DESC
LIMIT 10;
