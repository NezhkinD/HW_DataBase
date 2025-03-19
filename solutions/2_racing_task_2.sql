WITH CarAverages AS (SELECT cars.name             AS car,
                            cars.class,
                            AVG(results.position) AS avg_position,
                            COUNT(results.race)   AS race_count
                     FROM racing.Results results
                              JOIN
                          racing.Cars cars ON results.car = cars.name
                     GROUP BY cars.name, cars.class),
     MinAveragePosition AS (SELECT MIN(avg_position) AS min_avg_position
                            FROM CarAverages),
     BestCar AS (SELECT car_avg.car,
                        car_avg.class,
                        car_avg.avg_position,
                        car_avg.race_count
                 FROM CarAverages as car_avg
                          CROSS JOIN
                      MinAveragePosition map
                 WHERE car_avg.avg_position = map.min_avg_position
                 ORDER BY car_avg.car
                 LIMIT 1)
SELECT BestCar.car          as car_name,
       BestCar.class        as car_class,
       BestCar.avg_position as average_position,
       BestCar.race_count,
       classes.country      as car_country
FROM BestCar
         JOIN racing.Classes classes ON BestCar.class = classes.class;