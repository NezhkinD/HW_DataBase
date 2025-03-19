WITH ClientsWithMultipleBooking AS (SELECT booking.ID_customer,
                                           COUNT(booking.ID_booking)     AS total_bookings,
                                           COUNT(DISTINCT room.ID_hotel) AS unique_hotels
                                    FROM hb.Booking booking
                                             JOIN
                                         hb.Room room ON booking.ID_room = room.ID_room
                                    GROUP BY booking.ID_customer
                                    HAVING COUNT(booking.ID_booking) > 2
                                       AND COUNT(DISTINCT room.ID_hotel) > 1),
     ClientsWithHighSpending AS (SELECT booking.ID_customer,
                                        SUM(room.price * (booking.check_out_date - booking.check_in_date)) AS total_spent,
                                        COUNT(booking.ID_booking)                                          AS total_bookings
                                 FROM hb.Booking booking
                                          JOIN
                                      hb.Room room ON booking.ID_room = room.ID_room
                                 GROUP BY booking.ID_customer
                                 HAVING SUM(room.price * (booking.check_out_date - booking.check_in_date)) > 500)
SELECT customer.ID_customer,
       customer.name,
       clients_multi_booking.total_bookings,
       clients_high_spending.total_spent,
       clients_multi_booking.unique_hotels
FROM hb.Customer customer
         JOIN
     ClientsWithMultipleBooking clients_multi_booking ON customer.ID_customer = clients_multi_booking.ID_customer
         JOIN
     ClientsWithHighSpending clients_high_spending ON customer.ID_customer = clients_high_spending.ID_customer
ORDER BY clients_high_spending.total_spent ASC;