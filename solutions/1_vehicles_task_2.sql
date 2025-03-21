SELECT maker,
       car.model,
       horsepower,
       engine_capacity,
       vehicle.type AS "vehicle_type"
FROM vehicles.car, vehicles.vehicle
WHERE horsepower > 150
  AND engine_capacity < 3.0
  AND price < 35000
  AND car.model = vehicle.model

UNION ALL

SELECT maker,
       motorcycle.model,
       horsepower,
       engine_capacity,
       vehicle.type AS "vehicle_type"
FROM vehicles.motorcycle, vehicles.vehicle
WHERE horsepower > 150
  AND engine_capacity < 1.5
  AND price < 20000
  AND motorcycle.model = vehicle.model

UNION ALL

SELECT maker,
       vehicles.bicycle.model,
       NULL AS horsepower,
       NULL AS engine_capacity,
       vehicle.type AS "vehicle_type"
FROM vehicles.bicycle, vehicles.vehicle
WHERE gear_count > 18
  AND price < 4000
  AND bicycle.model = vehicle.model

ORDER BY horsepower DESC NULLS LAST;