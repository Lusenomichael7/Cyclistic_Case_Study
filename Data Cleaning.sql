/*There are 211 duplicate rows */
SELECT ride_id,start_station_name,end_station_name, COUNT(*) 
FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`
GROUP BY ride_id,start_station_name,end_station_name
HAVING COUNT(*) > 1;

SELECT *
FROM (
 SELECT
      *,
      ROW_NUMBER()
          OVER (PARTITION BY ride_id)
          row_number
  FROM `plated-dryad-448619-k8.Cyclistic.Cyclistic_Combined_Table`
)
WHERE row_number = 1
/* After removing the duplicate rows, 5,860,357 rows remained out of the original 5,860,568 */




