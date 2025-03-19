WITH CarAverages AS (SELECT cars.name             AS car,
                            cars.class,
                            AVG(results.position) AS avg_position,
                            COUNT(results.race)   AS race_count
                     FROM racing.Results results
                              JOIN
                          racing.Cars cars ON results.car = cars.name
                     GROUP BY cars.name, cars.class),
     ClassAverages AS (SELECT car_avg.class,
                              AVG(car_avg.avg_position) AS class_avg_position,
                              SUM(car_avg.race_count)   AS total_races
                       FROM CarAverages car_avg
                       GROUP BY car_avg.class),
     MinClassAverage AS (SELECT MIN(class_avg_position) AS min_class_avg_position
                         FROM ClassAverages),
     BestClasses AS (SELECT class_avg.class,
                            class_avg.class_avg_position,
                            class_avg.total_races
                     FROM ClassAverages class_avg
                              CROSS JOIN MinClassAverage min_class_avg
                     WHERE class_avg.class_avg_position = min_class_avg.min_class_avg_position)
SELECT car_avg.car          as car_name,
       car_avg.class        as car_class,
       car_avg.avg_position as average_position,
       car_avg.race_count,
       classes.country      as car_country,
       best_classes.total_races
FROM CarAverages car_avg
         JOIN BestClasses best_classes ON car_avg.class = best_classes.class
         JOIN racing.Classes classes ON car_avg.class = classes.class
ORDER BY car_avg.class, car_avg.car;