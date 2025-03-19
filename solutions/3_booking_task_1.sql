WITH CustomerBooking AS (SELECT customer.ID_customer,
                                customer.name,
                                customer.email,
                                customer.phone,
                                COUNT(DISTINCT booking.ID_booking)                  as total_bookings,
                                COUNT(DISTINCT hotel.ID_hotel)                      as distinct_hotels,
                                STRING_AGG(DISTINCT hotel.name, ', ')               as hotel_list,
                                AVG(booking.check_out_date - booking.check_in_date) as avg_stay_duration
                         FROM hb.Customer customer
                                  JOIN hb.Booking booking ON customer.ID_customer = booking.ID_customer
                                  JOIN hb.Room room ON booking.ID_room = room.ID_room
                                  JOIN hb.Hotel hotel ON room.ID_hotel = hotel.ID_hotel
                         GROUP BY customer.ID_customer, customer.name, customer.email, customer.phone
                         HAVING COUNT(DISTINCT booking.ID_booking) > 2
                            AND COUNT(DISTINCT hotel.ID_hotel) > 1)
SELECT name,
       email,
       phone,
       total_bookings,
       hotel_list,
       ROUND(avg_stay_duration, 2) as avg_stay_duration_days
FROM CustomerBooking
ORDER BY total_bookings DESC;