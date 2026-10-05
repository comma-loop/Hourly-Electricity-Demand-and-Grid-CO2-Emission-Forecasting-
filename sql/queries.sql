
-- Q1: mean va do lech cua target theo tung don vi va theo thang
SELECT ba, month(ts_utc) AS mon, AVG(demand) AS mean_target, STDDEV(demand) AS sd_target, COUNT(*) AS n
FROM clean GROUP BY 1, 2 ORDER BY 1, 2;
-- Q2: ty le buoc "su kien" (target vuot phan vi 90%) theo tung BA
WITH thr AS (SELECT quantile_cont(demand, 0.9) AS q FROM clean)
SELECT ba, AVG((demand > q)::INT) AS event_share FROM clean, thr GROUP BY 1 ORDER BY 2 DESC;
-- Q3: target theo decile cua bien phu (quan he voi CO2)
SELECT decile, AVG(demand) AS mean_target, COUNT(*) AS n
FROM (SELECT NTILE(10) OVER (ORDER BY co2_intensity_generated) AS decile, demand FROM clean WHERE co2_intensity_generated IS NOT NULL)
GROUP BY 1 ORDER BY 1;
-- Q4: tuong quan giua target va gia tri cach SEASON buoc truoc (kiem tra seasonal-naive)
SELECT corr(demand, lagged) AS r_season
FROM (SELECT demand, LAG(demand, 24) OVER (PARTITION BY ba ORDER BY ts_utc) AS lagged FROM clean);
