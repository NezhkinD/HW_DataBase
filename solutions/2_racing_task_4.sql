WITH CarAverages AS (SELECT cars.name             AS car,
                            cars.class,
                            AVG(results.position) AS avg_position,
                            COUNT(results.race)   AS race_count
                     FROM racing.Results results
                              JOIN racing.Cars cars ON results.car = cars.name
                     GROUP BY cars.name, cars.class),
     ClassAverages AS (SELECT car_avg.class,
                              AVG(car_avg.avg_position) AS class_avg_position,
                              COUNT(car_avg.car)        AS car_count
                       FROM CarAverages car_avg
                       GROUP BY car_avg.class)

SELECT car_avg.car          as car_name,
       car_avg.class        as car_class,
       car_avg.avg_position as average_position,
       car_avg.race_count   as race_count,
       classes.country      as car_country
FROM CarAverages car_avg
         JOIN ClassAverages class_avg ON car_avg.class = class_avg.class
         JOIN racing.Classes classes ON car_avg.class = classes.class
WHERE class_avg.car_count >= 2
  AND car_avg.avg_position < class_avg.class_avg_position
ORDER BY car_avg.class, car_avg.avg_position;