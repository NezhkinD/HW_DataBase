SELECT vehicles.vehicle.maker, vehicles.motorcycle.model
FROM vehicles.motorcycle,
     vehicles.vehicle
WHERE horsepower > 150
  AND price < 20000
  AND motorcycle.type = 'Sport'
  AND motorcycle.model = vehicle.model
ORDER BY motorcycle.horsepower DESC;