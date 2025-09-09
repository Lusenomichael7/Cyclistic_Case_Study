/* 1. Combining the data was necessary to avoid doing the analysis on each of the datasets from the last year */
CREATE TABLE Cyclistic.Cyclistic_Combined_Table as ( 
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Jan_2024` UNION ALL 
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.FEB_24` UNION ALL 
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Mar_24` UNION ALL 
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Apr_24` UNION ALL
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.May_24` UNION ALL
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Jun_24` UNION ALL
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Jul_24` UNION ALL
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Aug_24` UNION ALL
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Sep_24` UNION ALL
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Oct_24` UNION ALL
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Nov_24` UNION ALL
SELECT * FROM `plated-dryad-448619-k8.Cyclistic.Dec_24` ) ; 


/* 2. Confirm the types of members */
SELECT DISTINCT member_casual
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`
/* Casuals and Members are the two member types */ 


/* 3.Find the rideable types */
SELECT DISTINCT rideable_type
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`
/* There are three rideable_types:classic_bikes, electric_bikes and electric_scooters */


/* 4. ride_id is a primary key we need to check for consistencies in length */
SELECT LENGTH(ride_id), count(*)
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`
GROUP BY LENGTH(ride_id);

SELECT COUNT (DISTINCT ride_id)
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`;
/* Each ride_id string is 16 digits */
/* There are 5,860,568 ride IDs in total, of which 5,860,357 are unique meaning 211 are duplicates */


/* 5. We only want the rows where the length of the ride was longer than one minute,
but shorter than one day */
SELECT *
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table` 
WHERE TIMESTAMP_DIFF(ended_at, started_at, MINUTE) < 1 OR
TIMESTAMP_DIFF(ended_at, started_at, MINUTE) > 1440;
/*There are 139124 rides below a minute and more than a day long these will need to be cleaned later*/


/* 6. We need to find naming inconsistencies  */

SELECT start_station_name, count(*)
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`
GROUP BY start_station_name
ORDER BY start_station_name;
/*There are 1073951 start stations with no names*/

SELECT end_station_name, count(*)
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`
GROUP BY end_station_name
ORDER BY end_station_name;
/*There are 1104653 end stations with no names*/

 
  SELECT COUNT(DISTINCT(start_station_name)) AS Cyl_startname,
   COUNT(DISTINCT(end_station_name)) AS Cyl_endname,
   COUNT(DISTINCT(start_station_id)) AS Cyl_startid,
   COUNT(DISTINCT(end_station_id)) AS Cyl_endid
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`;
/*There 1808 and 1815 start station and end station names respectively,while only 1763 and 1768 start staion and end station IDs. This likely due to duplicate values which will be cleaned later*/

/*We also need to find the number of nulls in the station ids*/
SELECT count(*) as num_of_rides
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`
WHERE start_station_id IS NULL  OR
end_station_id IS NULL;
/*There are 1,652,259 null values for start and end station ids */

SELECT
  COUNTIF(start_station_id IS NULL) AS nulls_in_start_station_id,
  COUNTIF(end_station_id IS NULL) AS nulls_in_end_station_id
FROM
  `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`;
/*There are 1,073,951 null values for start station ids , while there are 1,104,653 null values for end sta*/
/*There are the same number of null ids as there are null names for both start and end stations. Meaning all rows with no names have no IDs*/


/* 7. Next we need to check for nulls in the latitude and longitude columns*/

SELECT count(*) as lat_lng
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`
WHERE start_lat IS NULL OR
 start_lng IS NULL OR
 end_lat IS NULL OR
 end_lng IS NULL;
/*There are 7232 null values for start and end latitudes and longitude*/

SELECT
  COUNTIF(start_lat IS NULL) AS nulls_in_start_lat,
  COUNTIF(start_lng IS NULL) AS nulls_in_start_lng,
  COUNTIF(end_lat IS NULL)   AS nulls_in_end_lat,
  COUNTIF(end_lng IS NULL)   AS nulls_in_end_lng
FROM
  `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`;
/*The query results show that there are no NULL values in start_lat and start_lng. However, end_lat and end_lng contain all the 7232 NULL values*/
 





