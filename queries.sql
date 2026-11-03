-- =====================================================================
-- LABORATORY WORK 6: SQL JOIN OPERATIONS
-- Solutions to Tasks 1 through 15
-- Subject: Databases
-- Student: Yersultan Abdussattar
-- Group: 12:00-13:00
-- SQL Environment: MySQL 8.0+
-- Year: 2026
-- =====================================================================

USE airline_lab6;

-- ---------------------------------------------------------------------
-- Task 1: Write a query that displays all flights of a specific airline.
-- Strategy: INNER JOIN between flights and airlines, filtered by airline_name.
-- ---------------------------------------------------------------------
SELECT f.flight_number, a.airline_name, f.departure_time, f.arrival_time
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
WHERE a.airline_name = 'Air Astana';


-- ---------------------------------------------------------------------
-- Task 2: Compose a query to obtain a list of all flights with the
--         names of departure airports.
-- Strategy: INNER JOIN between flights and airports on departure_airport_id.
-- ---------------------------------------------------------------------
SELECT f.flight_number, ap.airport_name AS departure_airport, ap.city
FROM flights f
JOIN airports ap ON f.departure_airport_id = ap.airport_id;


-- ---------------------------------------------------------------------
-- Task 3: Create a query that finds all airlines that have no flights
--         scheduled for the next month.
-- Strategy: LEFT JOIN airlines with flights filtered for next month's window,
--           then checking WHERE f.flight_id IS NULL (anti-join).
-- ---------------------------------------------------------------------
SELECT a.airline_name
FROM airlines a
LEFT JOIN flights f ON a.airline_id = f.airline_id
  AND f.departure_time >= '2026-11-01' AND f.departure_time < '2026-12-01'
WHERE f.flight_id IS NULL;


-- ---------------------------------------------------------------------
-- Task 4: Create a query to display a list of passengers on a specific flight.
-- Strategy: Multi-table INNER JOIN: passengers -> tickets -> flights.
-- ---------------------------------------------------------------------
SELECT p.first_name, p.last_name, p.passport_number, f.flight_number
FROM passengers p
JOIN tickets t ON p.passenger_id = t.passenger_id
JOIN flights f ON t.flight_id = f.flight_id
WHERE f.flight_number = 'KC101';


-- ---------------------------------------------------------------------
-- Task 5: Write a query that calculates the average, total, maximum and
--         minimum price of tickets for each flight.
-- Strategy: LEFT JOIN flights with tickets grouped by flight_id so that
--           flights with zero tickets return NULL rather than being excluded.
-- ---------------------------------------------------------------------
SELECT f.flight_number,
       AVG(t.ticket_price) AS average_price,
       SUM(t.ticket_price) AS total_price,
       MAX(t.ticket_price) AS maximum_price,
       MIN(t.ticket_price) AS minimum_price
FROM flights f
LEFT JOIN tickets t ON f.flight_id = t.flight_id
GROUP BY f.flight_id, f.flight_number;


-- ---------------------------------------------------------------------
-- Task 6: Create a query that shows all flights flying to a specific country
--         by combining flights, airports and airline, and using the
--         condition on the country name.
-- Strategy: INNER JOIN flights with airlines, departure airports, arrival
--           airports, and destination country, filtered by c.country_name.
-- ---------------------------------------------------------------------
SELECT f.flight_number, a.airline_name,
       dep.airport_name AS departure_airport,
       arr.airport_name AS arrival_airport,
       c.country_name AS destination_country
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
JOIN countries c ON arr.country_id = c.country_id
WHERE c.country_name = 'Turkey';


-- ---------------------------------------------------------------------
-- Task 7: Display a list of minor passengers and their arrival destination.
-- Strategy: JOIN passengers with tickets, flights, arrival airport, and country,
--           filtering minors where age < 18 using TIMESTAMPDIFF.
-- ---------------------------------------------------------------------
SELECT p.first_name, p.last_name, p.date_of_birth, f.flight_number,
       arr.airport_name AS arrival_airport, c.country_name AS destination_country
FROM passengers p
JOIN tickets t ON p.passenger_id = t.passenger_id
JOIN flights f ON t.flight_id = f.flight_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
JOIN countries c ON arr.country_id = c.country_id
WHERE TIMESTAMPDIFF(YEAR, p.date_of_birth, '2026-11-03') < 18;


-- ---------------------------------------------------------------------
-- Task 8: Display the passenger's full name, passport number, and the
--         passenger's current time of arrival at the destination.
-- Strategy: CONCAT passenger first and last name, joined via tickets to flights.
-- ---------------------------------------------------------------------
SELECT CONCAT(p.first_name, ' ', p.last_name) AS full_name,
       p.passport_number, f.flight_number, f.arrival_time
FROM passengers p
JOIN tickets t ON p.passenger_id = t.passenger_id
JOIN flights f ON t.flight_id = f.flight_id;


-- ---------------------------------------------------------------------
-- Task 9: Print a list of flights where the airline's home country and
--         origin country are the same. Group/order them by the airport country.
-- Strategy: Join flights to airlines, departure airport, and country,
--           with condition matching airline home country to airport country.
-- ---------------------------------------------------------------------
SELECT c.country_name AS airport_country, a.airline_name, f.flight_number,
       ap.airport_name AS departure_airport
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN airports ap ON f.departure_airport_id = ap.airport_id
JOIN countries c ON ap.country_id = c.country_id
WHERE a.home_country_id = ap.country_id
ORDER BY c.country_name;


-- ---------------------------------------------------------------------
-- Task 10: Write a query that lists each flight number, airline name,
--          departure airport, and arrival airport by joining the relevant tables.
-- Strategy: Multi-table JOIN linking flights to airlines, departure airport,
--           and arrival airport.
-- ---------------------------------------------------------------------
SELECT f.flight_number, a.airline_name,
       dep.airport_name AS departure_airport,
       arr.airport_name AS arrival_airport
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN airports dep ON f.departure_airport_id = dep.airport_id
JOIN airports arr ON f.arrival_airport_id = arr.airport_id;


-- ---------------------------------------------------------------------
-- Task 11: Display all passengers who have booked tickets for flights operated
--          by a specific airline, including the passenger's full name and
--          flight number.
-- Strategy: Multi-table JOIN (passengers -> tickets -> flights -> airlines),
--           filtered by airline_name = 'Air Astana'.
-- ---------------------------------------------------------------------
SELECT CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
       f.flight_number, a.airline_name
FROM passengers p
JOIN tickets t ON p.passenger_id = t.passenger_id
JOIN flights f ON t.flight_id = f.flight_id
JOIN airlines a ON f.airline_id = a.airline_id
WHERE a.airline_name = 'Air Astana';


-- ---------------------------------------------------------------------
-- Task 12: Create a query that shows each flight's number, destination country,
--          and number of passengers booked on that flight. Include flights
--          with no booked passengers.
-- Strategy: JOIN flights with arrival airport and destination country, then
--           LEFT JOIN tickets and aggregate with COUNT(t.ticket_id).
-- ---------------------------------------------------------------------
SELECT f.flight_number, c.country_name AS destination_country,
       COUNT(t.ticket_id) AS passenger_count
FROM flights f
JOIN airports arr ON f.arrival_airport_id = arr.airport_id
JOIN countries c ON arr.country_id = c.country_id
LEFT JOIN tickets t ON f.flight_id = t.flight_id
GROUP BY f.flight_id, f.flight_number, c.country_name;


-- ---------------------------------------------------------------------
-- Task 13: Find passengers who have not booked any tickets, using an
--          appropriate JOIN operation.
-- Strategy: LEFT JOIN passengers with tickets and filter for NULL ticket_id.
-- ---------------------------------------------------------------------
SELECT p.passenger_id, p.first_name, p.last_name, p.passport_number
FROM passengers p
LEFT JOIN tickets t ON p.passenger_id = t.passenger_id
WHERE t.ticket_id IS NULL;


-- ---------------------------------------------------------------------
-- Task 14: Display each airline and the total number of flights it operates,
--          including airlines that currently have no flights.
-- Strategy: LEFT JOIN airlines with flights and aggregate with COUNT(f.flight_id).
-- ---------------------------------------------------------------------
SELECT a.airline_name, COUNT(f.flight_id) AS total_flights
FROM airlines a
LEFT JOIN flights f ON a.airline_id = f.airline_id
GROUP BY a.airline_id, a.airline_name;


-- ---------------------------------------------------------------------
-- Task 15: List flights departing from airports in a specified country and
--          show the airline name, flight number, and departure airport city.
-- Strategy: INNER JOIN flights with airlines, departure airports, and countries,
--           filtered by country_name = 'Kazakhstan'.
-- ---------------------------------------------------------------------
SELECT a.airline_name, f.flight_number, ap.city AS departure_city,
       ap.airport_name AS departure_airport
FROM flights f
JOIN airlines a ON f.airline_id = a.airline_id
JOIN airports ap ON f.departure_airport_id = ap.airport_id
JOIN countries c ON ap.country_id = c.country_id
WHERE c.country_name = 'Kazakhstan';
