

-- 1. DATABASE
CREATE DATABASE IF NOT EXISTS hotel_management;
USE hotel_management;
SELECT DATABASE();

-- 2. TABLES
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(200)
);

CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) NOT NULL,
    room_type VARCHAR(50) NOT NULL,
    price_per_day DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Booked',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

SHOW TABLES;
DESCRIBE customers;
DESCRIBE rooms;
DESCRIBE bookings;
DESCRIBE payments;

-- 3. SAMPLE DATA
INSERT INTO customers (customer_name, phone, email, address) VALUES
('Rahul Kumar', '9876543210', 'rahul@example.com', 'Vizianagaram'),
('Priya Sharma', '9876543211', 'priya@example.com', 'Visakhapatnam'),
('Arjun Reddy', '9876543212', 'arjun@example.com', 'Hyderabad'),
('Sneha Rao', '9876543213', 'sneha@example.com', 'Vijayawada'),
('Kiran Kumar', '9876543214', 'kiran@example.com', 'Rajahmundry'),
('Anjali Devi', '9876543215', 'anjali@example.com', 'Vizag'),
('Ravi Teja', '9876543216', 'ravi@example.com', 'Srikakulam'),
('Neha Singh', '9876543217', 'neha@example.com', 'Chennai');

INSERT INTO rooms (room_number, room_type, price_per_day, status) VALUES
('101', 'Single', 1500.00, 'Available'),
('102', 'Single', 1500.00, 'Available'),
('103', 'Double', 2500.00, 'Available'),
('104', 'Double', 2500.00, 'Available'),
('201', 'Deluxe', 3000.00, 'Available'),
('202', 'Deluxe', 3000.00, 'Available'),
('203', 'Suite', 5000.00, 'Available'),
('204', 'Suite', 5000.00, 'Available'),
('301', 'Double', 2500.00, 'Available'),
('302', 'Deluxe', 3000.00, 'Available');

INSERT INTO bookings (customer_id, room_id, check_in_date, check_out_date, status) VALUES
(1, 1, '2026-10-10', '2026-10-12', 'Completed'),
(2, 5, '2026-10-11', '2026-10-14', 'Checked-in'),
(3, 3, '2026-10-12', '2026-10-15', 'Booked'),
(4, 7, '2026-10-15', '2026-10-18', 'Booked'),
(5, 4, '2026-10-16', '2026-10-17', 'Booked');

INSERT INTO payments (booking_id, payment_date, amount, payment_method, payment_status) VALUES
(1, '2026-10-10', 3000.00, 'UPI', 'Paid'),
(2, '2026-10-11', 4500.00, 'Card', 'Paid'),
(2, '2026-10-12', 3000.00, 'UPI', 'Pending'),
(3, '2026-10-12', 5000.00, 'Cash', 'Paid'),
(4, '2026-10-15', 10000.00, 'Online', 'Pending');

SELECT * FROM customers;
SELECT * FROM rooms;
SELECT * FROM bookings;
SELECT * FROM payments;

-- 4. BASIC SELECT / WHERE / ORDER BY
SELECT * FROM rooms WHERE status = 'Available';
SELECT * FROM rooms WHERE room_type = 'Deluxe';
SELECT * FROM rooms WHERE price_per_day > 2000;
SELECT * FROM rooms ORDER BY price_per_day ASC;
SELECT * FROM rooms ORDER BY price_per_day DESC;
SELECT * FROM customers ORDER BY customer_name ASC;
SELECT * FROM bookings ORDER BY check_in_date;
SELECT * FROM bookings WHERE status IN ('Booked', 'Checked-in');
SELECT * FROM rooms WHERE price_per_day BETWEEN 1500 AND 3000;

-- 5. AGGREGATES / GROUP BY / HAVING
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_rooms FROM rooms;
SELECT COUNT(*) AS total_bookings FROM bookings;
SELECT COUNT(*) AS total_payments FROM payments;
SELECT MIN(price_per_day) AS lowest_price,
       MAX(price_per_day) AS highest_price,
       AVG(price_per_day) AS average_price
FROM rooms;
SELECT SUM(amount) AS total_payment_amount FROM payments;
SELECT payment_status, COUNT(*) AS transaction_count, SUM(amount) AS total_amount
FROM payments GROUP BY payment_status;
SELECT payment_method, SUM(amount) AS paid_total
FROM payments WHERE payment_status = 'Paid' GROUP BY payment_method;
SELECT room_type, COUNT(*) AS number_of_rooms, AVG(price_per_day) AS average_price
FROM rooms GROUP BY room_type;
SELECT customer_id, COUNT(*) AS booking_count
FROM bookings GROUP BY customer_id HAVING COUNT(*) >= 1;

-- 6. JOINS / CUSTOMER REPORTS
SELECT b.booking_id, c.customer_name, r.room_number, r.room_type,
       b.check_in_date, b.check_out_date, b.status
FROM bookings b
INNER JOIN customers c ON c.customer_id = b.customer_id
INNER JOIN rooms r ON r.room_id = b.room_id
ORDER BY b.booking_id;

SELECT c.customer_id, c.customer_name, b.booking_id,
       b.check_in_date, b.check_out_date, b.status
FROM customers c LEFT JOIN bookings b ON b.customer_id = c.customer_id
ORDER BY c.customer_id;

SELECT c.customer_id, c.customer_name
FROM customers c LEFT JOIN bookings b ON b.customer_id = c.customer_id
WHERE b.booking_id IS NULL;

SELECT b.booking_id, c.customer_name, r.room_number,
       p.payment_date, p.amount, p.payment_method, p.payment_status
FROM bookings b
JOIN customers c ON c.customer_id = b.customer_id
JOIN rooms r ON r.room_id = b.room_id
LEFT JOIN payments p ON p.booking_id = b.booking_id
ORDER BY b.booking_id, p.payment_date;

-- 7. DATE FUNCTIONS / ROOM CHARGES
SELECT booking_id, check_in_date, check_out_date,
       DATEDIFF(check_out_date, check_in_date) AS total_nights
FROM bookings;

SELECT b.booking_id, c.customer_name, r.room_number,
       b.check_in_date, b.check_out_date,
       DATEDIFF(b.check_out_date, b.check_in_date) AS total_nights,
       r.price_per_day,
       DATEDIFF(b.check_out_date, b.check_in_date) * r.price_per_day AS estimated_room_charge
FROM bookings b
JOIN customers c ON c.customer_id = b.customer_id
JOIN rooms r ON r.room_id = b.room_id
ORDER BY b.booking_id;

SELECT b.booking_id, c.customer_name, r.room_number,
       b.check_in_date, b.check_out_date, b.status
FROM bookings b
JOIN customers c ON c.customer_id = b.customer_id
JOIN rooms r ON r.room_id = b.room_id
WHERE b.status = 'Checked-in' AND b.check_out_date < CURDATE();

-- 8. PAYMENT / OUTSTANDING BALANCE REPORTS
SELECT payment_status, COUNT(*) AS transaction_count, SUM(amount) AS total_amount
FROM payments GROUP BY payment_status;

SELECT payment_method, SUM(amount) AS paid_total
FROM payments WHERE payment_status = 'Paid' GROUP BY payment_method;

SELECT b.booking_id, c.customer_name, r.room_number,
       r.price_per_day * DATEDIFF(b.check_out_date, b.check_in_date) AS room_charge,
       COALESCE(SUM(CASE WHEN p.payment_status = 'Paid' THEN p.amount ELSE 0 END), 0) AS amount_paid,
       r.price_per_day * DATEDIFF(b.check_out_date, b.check_in_date)
       - COALESCE(SUM(CASE WHEN p.payment_status = 'Paid' THEN p.amount ELSE 0 END), 0) AS outstanding_balance
FROM bookings b
JOIN customers c ON c.customer_id = b.customer_id
JOIN rooms r ON r.room_id = b.room_id
LEFT JOIN payments p ON p.booking_id = b.booking_id
GROUP BY b.booking_id, c.customer_name, r.room_number,
         r.price_per_day, b.check_in_date, b.check_out_date
ORDER BY b.booking_id;

-- 9. SUBQUERIES / DATA QUALITY CHECKS
SELECT room_number, room_type, price_per_day
FROM rooms WHERE price_per_day = (SELECT MAX(price_per_day) FROM rooms);

SELECT room_number, COUNT(*) AS duplicate_count
FROM rooms GROUP BY room_number HAVING COUNT(*) > 1;
SELECT * FROM rooms WHERE price_per_day <= 0;
SELECT * FROM bookings WHERE check_out_date <= check_in_date;
SELECT * FROM payments WHERE amount <= 0;

-- 10. VIEWS
CREATE VIEW hotel_booking_report AS
SELECT b.booking_id, c.customer_name, r.room_number, r.room_type,
       b.check_in_date, b.check_out_date, b.status
FROM bookings b
INNER JOIN customers c ON c.customer_id = b.customer_id
INNER JOIN rooms r ON r.room_id = b.room_id;

CREATE VIEW available_rooms AS
SELECT room_number, room_type, price_per_day
FROM rooms WHERE status = 'Available';

SELECT * FROM hotel_booking_report;
SELECT * FROM available_rooms;

-- 11. INDEX AND CONSTRAINTS
-- Historical development sequence: index created, then replaced by UNIQUE constraint.
CREATE INDEX idx_room_number ON rooms(room_number);
DROP INDEX idx_room_number ON rooms;
ALTER TABLE rooms ADD CONSTRAINT uq_room_number UNIQUE (room_number);
ALTER TABLE rooms ADD CONSTRAINT chk_room_price CHECK (price_per_day > 0);
ALTER TABLE bookings ADD CONSTRAINT chk_booking_dates CHECK (check_out_date > check_in_date);
ALTER TABLE payments ADD CONSTRAINT chk_payment_amount CHECK (amount > 0);
SHOW INDEX FROM rooms;
SHOW CREATE TABLE rooms;
SHOW CREATE TABLE bookings;
SHOW CREATE TABLE payments;

-- 12. STORED PROCEDURES
DELIMITER //
CREATE PROCEDURE get_available_rooms()
BEGIN
    SELECT room_id, room_number, room_type, price_per_day
    FROM rooms
    WHERE status = 'Available'
    ORDER BY price_per_day, room_number;
END //

CREATE PROCEDURE get_customer_bookings(IN p_customer_id INT)
BEGIN
    SELECT b.booking_id, c.customer_name, r.room_number, r.room_type,
           b.check_in_date, b.check_out_date, b.status
    FROM bookings b
    INNER JOIN customers c ON c.customer_id = b.customer_id
    INNER JOIN rooms r ON r.room_id = b.room_id
    WHERE b.customer_id = p_customer_id
    ORDER BY b.check_in_date DESC;
END //

CREATE PROCEDURE get_rooms_available_for_dates(IN p_check_in DATE, IN p_check_out DATE)
BEGIN
    IF p_check_in IS NULL OR p_check_out IS NULL OR p_check_out <= p_check_in THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid dates: checkout must be after check-in.';
    ELSE
        SELECT r.room_id, r.room_number, r.room_type, r.price_per_day
        FROM rooms r
        WHERE NOT EXISTS (
            SELECT 1 FROM bookings b
            WHERE b.room_id = r.room_id
              AND b.status IN ('Booked', 'Checked-in')
              AND b.check_in_date < p_check_out
              AND b.check_out_date > p_check_in
        )
        ORDER BY r.room_number;
    END IF;
END //
DELIMITER ;

CALL get_available_rooms();
CALL get_customer_bookings(2);
CALL get_rooms_available_for_dates('2026-10-12', '2026-10-15');

-- 13. TRIGGERS
DELIMITER //
CREATE TRIGGER before_payment_insert
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    IF NEW.payment_status NOT IN ('Paid', 'Pending') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid payment status. Use Paid or Pending.';
    END IF;
END //

CREATE TRIGGER before_booking_insert
BEFORE INSERT ON bookings
FOR EACH ROW
BEGIN
    DECLARE conflicting_bookings INT DEFAULT 0;
    IF NEW.status IN ('Booked', 'Checked-in') THEN
        SELECT COUNT(*) INTO conflicting_bookings
        FROM bookings b
        WHERE b.room_id = NEW.room_id
          AND b.status IN ('Booked', 'Checked-in')
          AND b.check_in_date < NEW.check_out_date
          AND b.check_out_date > NEW.check_in_date;
        IF conflicting_bookings > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Room is already booked for the selected dates.';
        END IF;
    END IF;
END //

CREATE TRIGGER before_booking_update
BEFORE UPDATE ON bookings
FOR EACH ROW
BEGIN
    DECLARE conflicting_bookings INT DEFAULT 0;
    IF NEW.status IN ('Booked', 'Checked-in') THEN
        SELECT COUNT(*) INTO conflicting_bookings
        FROM bookings b
        WHERE b.room_id = NEW.room_id
          AND b.booking_id <> OLD.booking_id
          AND b.status IN ('Booked', 'Checked-in')
          AND b.check_in_date < NEW.check_out_date
          AND b.check_out_date > NEW.check_in_date;
        IF conflicting_bookings > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Room is already booked for the selected dates.';
        END IF;
    END IF;
END //
DELIMITER ;

-- 14. UPDATE ROOM STATUSES FOR THIS SAMPLE DATA
-- For the current sample data, each room has at most one booking.
UPDATE rooms r
LEFT JOIN bookings b ON r.room_id = b.room_id
SET r.status = CASE
    WHEN b.status = 'Checked-in' THEN 'Occupied'
    WHEN b.status = 'Booked' THEN 'Booked'
    ELSE 'Available'
END;

SELECT room_number, status FROM rooms ORDER BY room_number;
SELECT status AS room_status, COUNT(*) AS total_rooms
FROM rooms GROUP BY status ORDER BY status;

-- 15. DATE-BASED AVAILABILITY / BOOKING INSPECTION
SELECT r.room_id, r.room_number, r.room_type, r.price_per_day
FROM rooms r
WHERE NOT EXISTS (
    SELECT 1 FROM bookings b
    WHERE b.room_id = r.room_id
      AND b.status IN ('Booked', 'Checked-in')
      AND b.check_in_date < '2026-10-15'
      AND b.check_out_date > '2026-10-12'
)
ORDER BY r.room_number;

SELECT b.booking_id, r.room_number, c.customer_name,
       b.check_in_date, b.check_out_date, b.status
FROM bookings b
JOIN rooms r ON r.room_id = b.room_id
JOIN customers c ON c.customer_id = b.customer_id
ORDER BY r.room_number, b.check_in_date;

-- 16. FINAL VERIFICATION
SHOW TABLES;
SELECT 'customers' AS table_name, COUNT(*) AS total_records FROM customers
UNION ALL SELECT 'rooms', COUNT(*) FROM rooms
UNION ALL SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL SELECT 'payments', COUNT(*) FROM payments;
SHOW TRIGGERS;
SHOW PROCEDURE STATUS WHERE Db = 'hotel_management';


USE hotel_management;

SHOW TABLES;


SELECT 'customers' AS table_name, COUNT(*) AS total_records
FROM customers

UNION ALL

SELECT 'rooms', COUNT(*) FROM rooms

UNION ALL

SELECT 'bookings', COUNT(*) FROM bookings

UNION ALL

SELECT 'payments', COUNT(*) FROM payments

SHOW TRIGGERS;
SHOW PROCEDURE STATUS
WHERE Db = 'hotel_management';