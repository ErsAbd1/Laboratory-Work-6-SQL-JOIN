-- =====================================================================
-- LABORATORY WORK 6: SQL JOIN OPERATIONS
-- Database Schema & Sample Dataset
-- Subject: Databases
-- Student: Yersultan Abdussattar
-- Group: 12:00-13:00
-- SQL Environment: MySQL 8.0+
-- Year: 2026
-- =====================================================================

DROP DATABASE IF EXISTS airline_lab6;
CREATE DATABASE airline_lab6 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE airline_lab6;

-- Disable foreign key checks for clean teardown
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS passengers;
DROP TABLE IF EXISTS flights;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS airlines;
DROP TABLE IF EXISTS countries;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------
-- 1. Table: countries
-- ---------------------------------------------------------------------
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. Table: airlines
-- ---------------------------------------------------------------------
CREATE TABLE airlines (
    airline_id INT AUTO_INCREMENT PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL UNIQUE,
    home_country_id INT NOT NULL,
    CONSTRAINT fk_airline_country FOREIGN KEY (home_country_id)
        REFERENCES countries(country_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. Table: airports
-- ---------------------------------------------------------------------
CREATE TABLE airports (
    airport_id INT AUTO_INCREMENT PRIMARY KEY,
    airport_name VARCHAR(120) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country_id INT NOT NULL,
    CONSTRAINT fk_airport_country FOREIGN KEY (country_id)
        REFERENCES countries(country_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. Table: flights
-- ---------------------------------------------------------------------
CREATE TABLE flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL UNIQUE,
    airline_id INT NOT NULL,
    departure_airport_id INT NOT NULL,
    arrival_airport_id INT NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    CONSTRAINT fk_flight_airline FOREIGN KEY (airline_id)
        REFERENCES airlines(airline_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_flight_departure FOREIGN KEY (departure_airport_id)
        REFERENCES airports(airport_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_flight_arrival FOREIGN KEY (arrival_airport_id)
        REFERENCES airports(airport_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. Table: passengers
-- ---------------------------------------------------------------------
CREATE TABLE passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    passport_number VARCHAR(30) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. Table: tickets
-- ---------------------------------------------------------------------
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT NOT NULL,
    flight_id INT NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    booking_date DATE NOT NULL,
    CONSTRAINT fk_ticket_passenger FOREIGN KEY (passenger_id)
        REFERENCES passengers(passenger_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ticket_flight FOREIGN KEY (flight_id)
        REFERENCES flights(flight_id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- POPULATE SAMPLE DATA
-- =====================================================================

-- Countries
INSERT INTO countries (country_id, country_name) VALUES
(1, 'Kazakhstan'),
(2, 'Turkey'),
(3, 'Qatar'),
(4, 'Japan');

-- Airlines (Japan Air has 0 flights, used for demonstrating LEFT JOIN in Task 3 & 14)
INSERT INTO airlines (airline_id, airline_name, home_country_id) VALUES
(1, 'Air Astana', 1),
(2, 'Turkish Airlines', 2),
(3, 'Qatar Airways', 3),
(4, 'Japan Air', 4);

-- Airports
INSERT INTO airports (airport_id, airport_name, city, country_id) VALUES
(1, 'Almaty Airport', 'Almaty', 1),
(2, 'Astana Airport', 'Astana', 1),
(3, 'Istanbul Airport', 'Istanbul', 2),
(4, 'Doha Airport', 'Doha', 3);

-- Flights (KC102 has 0 tickets booked, demonstrating LEFT JOIN in Task 5 & 12)
INSERT INTO flights (flight_id, flight_number, airline_id, departure_airport_id, arrival_airport_id, departure_time, arrival_time) VALUES
(1, 'KC101', 1, 1, 2, '2026-11-05 08:00:00', '2026-11-05 09:30:00'),
(2, 'KC102', 1, 2, 1, '2026-11-15 14:00:00', '2026-11-15 15:00:00'),
(3, 'TK201', 2, 3, 1, '2026-11-10 10:00:00', '2026-11-10 16:00:00'),
(4, 'QR301', 3, 4, 3, '2026-12-05 10:00:00', '2026-12-05 15:00:00');

-- Passengers (Aliya is minor < 18, Murat has 0 tickets booked for Task 13)
INSERT INTO passengers (passenger_id, first_name, last_name, passport_number, date_of_birth) VALUES
(1, 'Aliya', 'Sadykova', 'N123456', '2010-04-12'),
(2, 'Dias', 'Kim', 'N234567', '2000-01-01'),
(3, 'Anna', 'Lee', 'N345678', '1995-05-15'),
(4, 'Murat', 'Omarov', 'N456789', '1992-08-20');

-- Tickets
INSERT INTO tickets (ticket_id, passenger_id, flight_id, ticket_price, booking_date) VALUES
(1, 1, 1, 200.00, '2026-10-01'),
(2, 2, 1, 150.00, '2026-10-02'),
(3, 3, 3, 300.00, '2026-10-03'),
(4, 1, 4, 250.00, '2026-10-04');
