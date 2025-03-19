WITH CarStats AS (SELECT cars.name             AS car_name,
                         cars.class,
                         AVG(results.position) AS average_position,
                         COUNT(results.race)   AS race_count
                  FROM racing.Cars cars
                           LEFT JOIN racing.Results results ON cars.name = results.car
                  GROUP BY cars.name, cars.class),

     ClassLowPositionCount AS (SELECT car_stats.class,
                                      COUNT(*) FILTER (WHERE car_stats.average_position > 3) AS low_position_cars
                               FROM CarStats car_stats
                               GROUP BY car_stats.class
                               HAVING COUNT(*) FILTER (WHERE car_stats.average_position > 3) > 0),

    ClassRaceCount AS (SELECT cars.class,
    COUNT(DISTINCT results.race) AS total_races
FROM racing.Cars cars
    LEFT JOIN racing.Results results ON cars.name = results.car
GROUP BY cars.class),

    LowestPosition AS (SELECT MAX(low_position_cars) AS max_low_position_cars
FROM ClassLowPositionCount)

SELECT car_stat.car_name,
       car_stat.class                      AS car_class,
       ROUND(car_stat.average_position, 4) AS average_position,
       car_stat.race_count,
       classes.country                    AS car_country,
       car_race_count.total_races,
       class_low_position_count.low_position_cars        AS low_position_count
FROM CarStats car_stat
         JOIN racing.Classes classes ON car_stat.class = classes.class
         JOIN ClassLowPositionCount class_low_position_count ON car_stat.class = class_low_position_count.class
         JOIN ClassRaceCount car_race_count ON car_stat.class = car_race_count.class
         JOIN LowestPosition lowest_position ON class_low_position_count.low_position_cars = lowest_position.max_low_position_cars
WHERE car_stat.average_position > 3
ORDER BY class_low_position_count.low_position_cars DESC, total_races DESC;