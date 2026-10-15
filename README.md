HOTEL ROOM MANAGEMENT SYSTEM
MySQL Database Project Documentation
Database: hotel_management
ER diagram • Implementation steps • SQL concepts • Testing • Viva questions

 1. Project Overview
The Hotel Room Management System is a relational database project built in MySQL. It organizes customer details, room information, reservations and payment transactions. SQL queries and database objects support reporting, room availability checks, charge calculations and validation of business rules.
1.1 Abstract
The project stores hotel information in four related tables. Primary and foreign keys define relationships. Check constraints validate dates and positive monetary values. Views provide reusable reports, stored procedures simplify common operations, and triggers validate payment status and check booking overlaps.
1.2 Problem Statement
Maintaining customer, room, reservation and payment details in separate registers or spreadsheets can lead to duplicate data, inconsistent records, overlapping reservations and difficult payment tracking. This project centralizes the information and applies validation rules.
1.3 Objectives
•	Store and retrieve customer details.
•	Maintain room numbers, room types, prices and current statuses.
•	Record reservations with check-in and check-out dates.
•	Track payment amounts, methods and statuses.
•	Prevent overlapping bookings through insert and update triggers.
•	Check availability for a requested date range.
•	Calculate estimated room charges and outstanding balances.
•	Generate reports using joins, aggregate functions, subqueries and date functions.
1.4 Scope and Limitations
This is a SQL database prototype, not a complete hotel application with a graphical interface. It does not yet include authentication, an online payment gateway, taxes, discounts or invoices. Stored room status is not a substitute for date-based availability. Production systems also need concurrency-safe booking logic.
2. Technology and SQL Concepts
Concept	Use in the project
MySQL	Relational database engine.
DDL	CREATE DATABASE, CREATE TABLE, ALTER TABLE, CREATE VIEW, CREATE PROCEDURE and CREATE TRIGGER.
DML / DQL	INSERT and UPDATE modify data; SELECT retrieves data.
Primary key	Uniquely identifies each customer, room, booking and payment.
Foreign key	Links bookings to customers and rooms, and payments to bookings.
Constraints	NOT NULL, UNIQUE and CHECK rules protect data quality.
JOIN	Combines customer, room, booking and payment information.
Aggregates	COUNT, SUM, AVG, MIN and MAX summarize data.
GROUP BY / HAVING	Groups records and filters aggregated results.
Subquery / NOT EXISTS	Find maximum-priced rooms and rooms without conflicting reservations.
Views	Reusable reports: hotel_booking_report and available_rooms.
Index / UNIQUE	Unique room-number constraint enforces uniqueness.
Stored procedures	Reusable room search and customer booking lookup.
Triggers	Validate booking overlaps and payment statuses.
DATEDIFF / CASE / COALESCE	Calculate nights, count only Paid amounts and handle missing payments.

3. Database Schema
Database name: hotel_management. Four core tables are used.
customers
Column	Type	Rule / meaning
customer_id	INT	PK, AUTO_INCREMENT
customer_name	VARCHAR(100)	NOT NULL
phone	VARCHAR(15)	Optional
email	VARCHAR(100)	Optional
address	VARCHAR(200)	Optional

rooms
Column	Type	Rule / meaning
room_id	INT	PK, AUTO_INCREMENT
room_number	VARCHAR(10)	UNIQUE, NOT NULL
room_type	VARCHAR(50)	NOT NULL
price_per_day	DECIMAL(10,2)	CHECK > 0
status	VARCHAR(20)	DEFAULT Available

bookings
Column	Type	Rule / meaning
booking_id	INT	PK, AUTO_INCREMENT
customer_id	INT	FK → customers.customer_id
room_id	INT	FK → rooms.room_id
check_in_date	DATE	NOT NULL
check_out_date	DATE	CHECK > check-in
status	VARCHAR(20)	DEFAULT Booked

payments
Column	Type	Rule / meaning
payment_id	INT	PK, AUTO_INCREMENT
booking_id	INT	FK → bookings.booking_id
payment_date	DATE	NOT NULL
amount	DECIMAL(10,2)	CHECK > 0
payment_method	VARCHAR(20)	NOT NULL
payment_status	VARCHAR(20)	Paid/Pending validated on insert

3.1 Relationships
Relationship	Cardinality	Explanation
customers → bookings	1 to many	One customer can make multiple bookings; each booking references one customer.
rooms → bookings	1 to many over time	A room can be booked repeatedly on different dates; each booking references one room.
bookings → payments	1 to many	One booking can have multiple payment transactions.

3.2 ER Diagram
PK = Primary Key, FK = Foreign Key, UQ = Unique.
 
4. Step-by-Step Implementation
Steps 1–5: Database and tables
Created hotel_management and four core tables. Defined primary keys, data types, required fields and foreign keys.
Steps 6–9: Sample data
Inserted 8 customers, 10 rooms, 5 bookings and 5 payments to test queries and reports.
Steps 10–15: SQL fundamentals
Practised SELECT, WHERE, ORDER BY, operators, aggregate functions, GROUP BY, HAVING, joins, date functions and room-charge calculations.
Steps 16–17: Views
Created hotel_booking_report and available_rooms. The latter checks stored status, not date-specific availability.
Steps 18–29: Queries and analysis
Worked with indexes, date filters, overdue stays, balances, payment summaries, customer booking counts, customers without bookings, maximum room price and duplicate checks.
Steps 30–36: Constraints
Added UNIQUE on room_number and CHECK constraints for positive room prices, valid booking dates and positive payment amounts.
Steps 37–40: Procedures and payment trigger
Created get_available_rooms and get_customer_bookings; added before_payment_insert and tested rejection of an invalid status.
Steps 41–45: Booking overlap protection
Inspected bookings, queried date-based availability, created the insert trigger, rejected an overlapping booking and tested a back-to-back stay.
Steps 46–50: Date-aware procedure
Created get_rooms_available_for_dates with date validation; tested valid and invalid date ranges.
Steps 51–54: Update trigger
Created before_booking_update, tested a conflicting update and verified the original booking remained unchanged.
Steps 55–59: Room status reports
Reviewed and updated sample room statuses; checked status counts and date-based availability separately.
Steps 60–61: Financial reports
Calculated nights, room charges, paid amounts and estimated outstanding balances.
Step 62: Final verification
Verified tables, records, views, procedures and triggers after the database rebuild.
5. Important SQL Examples
5.1 Date-based room availability
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
NOT EXISTS excludes rooms with a conflicting reservation. Overlap logic: existing check-in < requested checkout AND existing checkout > requested check-in. Checkout is exclusive, so back-to-back stays are allowed.
5.2 Estimated room charge
DATEDIFF(b.check_out_date, b.check_in_date) * r.price_per_day
    AS estimated_room_charge
DATEDIFF calculates the number of nights; multiplying by the daily room price estimates the room-only charge.
5.3 Amount paid and outstanding balance
COALESCE(SUM(CASE
    WHEN p.payment_status = 'Paid' THEN p.amount
    ELSE 0
END), 0) AS amount_paid
CASE counts only payments marked Paid; SUM totals them; COALESCE returns zero when no paid transaction exists. Outstanding balance is estimated room charge minus amount paid.
5.4 Trigger logic
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
The update trigger also excludes OLD.booking_id so the current row is not counted as a conflict with itself.
6. Views, Stored Procedures and Triggers
Type	Name	Purpose
View	hotel_booking_report	Reusable report combining booking, customer and room information.
View	available_rooms	Lists rooms with stored status Available; not date-aware.
Procedure	get_available_rooms	Lists rooms whose stored status is Available.
Procedure	get_customer_bookings	Lists bookings for a supplied customer ID.
Procedure	get_rooms_available_for_dates	Checks availability for a requested date range and validates the dates.
Trigger	before_booking_insert	Rejects overlapping active reservations on insert.
Trigger	before_booking_update	Rejects conflicting reservation updates.
Trigger	before_payment_insert	Rejects payment statuses other than Paid or Pending on insert.

7. Results and Test Cases
Metric	Verified result
Customers	8
Rooms	10
Bookings	5
Payments	5
Views	2
Procedures	3
Triggers	3
Estimated room charges	₹37,000
Payments marked Paid	₹12,500
Estimated outstanding room balance	₹24,500

Financial totals are based on sample data. Pending transactions are excluded from money received. Taxes, discounts and extra services are not included.
Test	Expected / observed behavior
Overlapping insert for room 103, Oct 14–16	Rejected by booking trigger.
Back-to-back room 103 stay beginning Oct 15	Accepted in test transaction; transaction was rolled back afterward.
Checkout date equals check-in date	Rejected by date-aware procedure.
Conflicting update of booking 5	Rejected; original booking stayed unchanged.
Payment status Failed	Rejected by payment trigger.
Date-based availability Oct 12–15	Returned 8 rooms in the sample test.

8. Limitations and Future Improvements
•	The project is a database prototype without a graphical user interface or authentication.
•	Room status is simplified; date-based availability must be checked with get_rooms_available_for_dates.
•	The sample room-status UPDATE assumes at most one booking row per room in the sample data; production logic must handle multiple bookings and maintenance status.
•	Triggers alone are not a complete concurrency-safe reservation solution; production code should use appropriate transactions and locking.
•	The payment-status trigger validates inserts; additional validation is needed for status updates.
•	Future improvements: cancellations, maintenance management, taxes, discounts, receipts, user roles, audit logs and a front-end application.
9. Interview / Viva Questions
What is the purpose of the project?
To organize hotel customers, rooms, bookings and payments in MySQL and generate useful reports.
Why four separate tables?
Each table represents a distinct entity, reduces repeated data and lets foreign keys represent relationships.
What is a primary key?
A column or set of columns that uniquely identifies each row.
What is a foreign key?
A column that references a key in another table, such as bookings.customer_id.
Why use LEFT JOIN for payments?
It keeps bookings even when no payment row exists, allowing the report to show zero paid.
What does DATEDIFF do?
Returns the difference in days between two dates; checkout minus check-in gives nights.
Why use COALESCE?
Replaces NULL with a fallback value such as zero.
What is a view?
A named reusable SELECT query used to simplify reporting.
What is a stored procedure?
A named SQL routine called with CALL, optionally accepting parameters.
What is a trigger?
A database routine that runs automatically before or after a specified table event.
How are overlapping bookings detected?
Existing check-in < requested checkout AND existing checkout > requested check-in.
Why is checkout exclusive?
A checkout on October 15 can be followed by another check-in on October 15.
View vs procedure?
A view represents a reusable query; a procedure is callable logic that can accept parameters and execute statements.
What does GROUP BY do?
Groups rows so aggregate functions can summarize each group.
What would you improve for production?
Add UI, authentication, cancellation and maintenance workflows, audit logs, payment update validation and concurrency-safe booking handling.
10. Short Presentation Script
Good morning. My project is a Hotel Room Management System developed using MySQL. It manages customer details, room information, bookings and payments through four related tables. I used primary and foreign keys, constraints, joins, aggregate functions, views, stored procedures and triggers. The triggers validate payment status and prevent overlapping reservations. I also created reports for room availability, room charges and outstanding balances. This project helped me practise relational database design and practical SQL.
Appendix: Verification Commands
USE hotel_management;
SHOW TABLES;
DESCRIBE customers;
DESCRIBE rooms;
DESCRIBE bookings;
DESCRIBE payments;
SHOW TRIGGERS;
SHOW PROCEDURE STATUS WHERE Db = 'hotel_management';
SELECT * FROM hotel_booking_report;
SELECT * FROM available_rooms;
CALL get_available_rooms();
CALL get_customer_bookings(2);
CALL get_rooms_available_for_dates('2026-10-12', '2026-10-15');
