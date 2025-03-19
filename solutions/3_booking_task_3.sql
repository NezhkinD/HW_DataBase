WITH HotelCategories AS (SELECT hotel.ID_hotel,
                                hotel.name      AS hotel_name,
                                AVG(room.price) AS avg_price,
                                CASE
                                    WHEN AVG(room.price) < 175 THEN 'Дешевый'
                                    WHEN AVG(room.price) >= 175 AND AVG(room.price) <= 300 THEN 'Средний'
                                    ELSE 'Дорогой'
                                    END         AS hotel_category
                         FROM hb.Hotel hotel
                                  JOIN hb.Room room ON hotel.ID_hotel = room.ID_hotel
                         GROUP BY hotel.ID_hotel, hotel.name),
     CustomerPreferences AS (SELECT c.ID_customer,
                                    c.name,
                                    STRING_AGG(DISTINCT hotel_categories.hotel_name, ', ') AS visited_hotels,
                                    CASE
                                        WHEN
                                            MAX(CASE WHEN hotel_categories.hotel_category = 'Дорогой' THEN 1 ELSE 0 END) =
                                            1 THEN 'Дорогой'
                                        WHEN
                                            MAX(CASE WHEN hotel_categories.hotel_category = 'Средний' THEN 1 ELSE 0 END) =
                                            1 THEN 'Средний'
                                        ELSE 'Дешевый'
                                        END                                                AS preferred_hotel_type
                             FROM hb.Customer c
                                      JOIN hb.Booking booking ON c.ID_customer = booking.ID_customer
                                      JOIN hb.Room room ON booking.ID_room = room.ID_room
                                      JOIN HotelCategories hotel_categories ON room.ID_hotel = hotel_categories.ID_hotel
                             GROUP BY c.ID_customer, c.name)
SELECT ID_customer,
       name,
       preferred_hotel_type,
       visited_hotels
FROM CustomerPreferences
ORDER BY CASE
             WHEN preferred_hotel_type = 'Дешевый' THEN 1
             WHEN preferred_hotel_type = 'Средний' THEN 2
             WHEN preferred_hotel_type = 'Дорогой' THEN 3
             END ASC, ID_customer ASC;