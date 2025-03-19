WITH CarAverages AS (SELECT cars.class,
                            results.car,
                            AVG(results.position) AS avg_position,
                            COUNT(results.race)   AS race_count
                     FROM racing.Results results
                              JOIN racing.Cars cars ON results.car = cars.name
                     GROUP BY cars.class, results.car),
     ClassMinAverages AS (SELECT class,
                                 MIN(avg_position) AS min_avg_position
                          FROM CarAverages
                          GROUP BY class)
SELECT car_avg.car          as car_name,
       car_avg.class        as car_class,
       car_avg.avg_position as average_position,
       car_avg.race_count   as race_count
FROM CarAverages car_avg
         JOIN
     ClassMinAverages car_min_avg
     ON car_avg.class = car_min_avg.class AND car_avg.avg_position = car_min_avg.min_avg_position
ORDER BY car_avg.avg_position;