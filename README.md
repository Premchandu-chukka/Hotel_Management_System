# 🏨 Hotel Room Management System

A MySQL database project designed to manage hotel customers, room information, reservations, and payment transactions efficiently. This project demonstrates practical SQL concepts, relational database design, data validation, and report generation.

## 📌 Project Overview

The Hotel Room Management System is developed using **MySQL** to maintain hotel-related information in a structured relational database. It helps manage customer details, room availability, booking schedules, and payment records while preventing overlapping reservations.

### 🎯 Objectives

- Store and manage customer information.
- Maintain room details, room types, prices, and statuses.
- Record hotel reservations with check-in and check-out dates.
- Track payment amounts, methods, and statuses.
- Prevent overlapping room reservations using triggers.
- Check room availability for a specified date range.
- Calculate estimated room charges and outstanding balances.
- Generate reports using SQL queries and database objects.

## 🛠️ Technologies Used

- **Database:** MySQL
- **Language:** SQL
- **Tools:** MySQL Workbench / MySQL Command Line Client
- **Concepts:** Relational Database Design, Joins, Views, Stored Procedures, Triggers, Constraints, and Aggregate Functions

## 🗄️ Database Structure

**Database Name:** `hotel_management`

The database contains four main tables:

| Table | Description |
|---|---|
| `customers` | Stores customer details, phone numbers, email addresses, and addresses. |
| `rooms` | Stores room numbers, room types, daily prices, and room statuses. |
| `bookings` | Stores customer reservations, room assignments, and booking dates. |
| `payments` | Stores payment dates, amounts, payment methods, and payment statuses. |

### 🔗 Entity Relationships

- One customer can have multiple bookings.
- One room can have multiple bookings over time.
- One booking can have multiple payment transactions.

**ER Diagram:** Add your project's ER diagram to the repository and link it here when uploaded.

<img width="1536" height="1024" alt="Hotel Room Management ER Diagram" src="https://github.com/user-attachments/assets/fc41f11b-20c2-409c-8aeb-6bf91b55237e" />


## ⚙️ SQL Concepts Implemented

### 1. Database and Table Creation
- `CREATE DATABASE`
- `CREATE TABLE`
- Primary keys and foreign keys
- `NOT NULL`, `UNIQUE`, and `CHECK` constraints

### 2. Data Manipulation and Retrieval
- `INSERT`, `UPDATE`, and `SELECT`
- Filtering with `WHERE`
- Sorting with `ORDER BY`
- Aggregate functions such as `COUNT()`, `SUM()`, `AVG()`, `MIN()`, and `MAX()`
- `GROUP BY` and `HAVING`

### 3. Advanced SQL Concepts
- INNER JOIN and LEFT JOIN
- Subqueries and `NOT EXISTS`
- Date functions such as `DATEDIFF()`
- Conditional expressions using `CASE`
- NULL handling using `COALESCE()`
- Indexes and unique constraints

### 4. Views

| View | Purpose |
|---|---|
| `hotel_booking_report` | Combines booking, customer, and room information for reporting. |
| `available_rooms` | Lists rooms marked as Available in the stored room status. |

### 5. Stored Procedures

| Procedure | Purpose |
|---|---|
| `get_available_rooms` | Retrieves rooms marked as Available. |
| `get_customer_bookings` | Retrieves bookings for a specified customer. |
| `get_rooms_available_for_dates` | Checks room availability for a requested date range. |

### 6. Triggers

| Trigger | Purpose |
|---|---|
| `before_booking_insert` | Prevents overlapping active reservations when inserting a booking. |
| `before_booking_update` | Prevents conflicting booking date or room updates. |
| `before_payment_insert` | Validates payment status during insertion. |

## 🚀 How to Run the Project

### Prerequisites

1. Install MySQL Server.
2. Install MySQL Workbench or use the MySQL command-line client.
3. Download or clone this repository.

### Step 1: Clone the Repository

```bash
git clone <https://github.com/Premchandu-chukka/Hotel_Management_System>
```

Navigate to the downloaded project folder.

### Step 2: Open MySQL Workbench

Connect to your MySQL server and open the SQL script containing the database and table creation statements.

### Step 3: Create the Database

```sql
CREATE DATABASE hotel_management;
USE hotel_management;
```

If the database and tables are already created by your script, do not recreate them unnecessarily.

### Step 4: Execute the SQL Scripts

Execute the scripts in the following order:

1. Create the database and tables.
2. Insert sample customer, room, booking, and payment records.
3. Create views.
4. Add constraints and indexes.
5. Create stored procedures.
6. Create triggers.
7. Execute testing and reporting queries.

Ensure foreign-key dependencies are respected when creating tables and inserting data.

### Step 5: Verify the Database

```sql
USE hotel_management;

SHOW TABLES;

DESCRIBE customers;
DESCRIBE rooms;
DESCRIBE bookings;
DESCRIBE payments;

SHOW TRIGGERS;

SHOW PROCEDURE STATUS
WHERE Db = 'hotel_management';
```

### Step 6: Test Stored Procedures

```sql
CALL get_available_rooms();

CALL get_customer_bookings(2);

CALL get_rooms_available_for_dates(
    '2026-10-12',
    '2026-10-15'
);
```

The availability procedure should be tested with valid dates and invalid date ranges.

## 🧪 Testing and Results

The project was tested using sample records and SQL queries.

| Test Case | Expected Result |
|---|---|
| Insert an overlapping booking | Rejected by the booking trigger. |
| Create a back-to-back reservation | Accepted when no other conflict exists. |
| Use the same check-in and check-out date | Rejected by date validation. |
| Update a booking to conflicting dates | Rejected by the update trigger. |
| Insert an invalid payment status | Rejected by the payment trigger. |
| Search for available rooms by dates | Returns rooms without conflicting active bookings. |

### Sample Project Results

- Customers: 8
- Rooms: 10
- Bookings: 5
- Payments: 5
- Views: 2
- Stored Procedures: 3
- Triggers: 3
- Estimated Room Charges: ₹37,000
- Payments Marked Paid: ₹12,500
- Estimated Outstanding Balance: ₹24,500

*These figures represent the sample dataset used for project testing, not live hotel transactions.*

## 💰 Financial Reporting

The project calculates estimated room charges using the number of nights multiplied by the room's daily price.

```sql
DATEDIFF(b.check_out_date, b.check_in_date)
    * r.price_per_day AS estimated_room_charge
```

Paid transactions are included in the amount received, while pending transactions are excluded.

The estimated outstanding balance is calculated as:

**Outstanding Balance = Estimated Room Charges − Amount Paid**

These calculations exclude taxes, discounts, and additional hotel services.

## 🔒 Business Rules

- Every room must have a unique room number.
- Room prices must be positive.
- Booking checkout dates must be later than check-in dates.
- Payment amounts must be positive.
- Payment status must be either `Paid` or `Pending` when inserted.
- Active bookings must not overlap for the same room.
- Checkout dates are exclusive, allowing a new reservation to begin on the previous reservation's checkout date.

## ⚠️ Limitations

- This project is a database prototype and does not include a graphical user interface.
- User authentication and authorization are not implemented.
- Online payment gateway integration is not included.
- Room status alone does not determine availability for a particular date range.
- Additional transaction and locking logic would be required for reliable concurrent reservations in a production system.
- Payment status updates require additional validation beyond the insert trigger.

## 🔮 Future Enhancements

- Develop a web application using Python and Django.
- Add customer registration and login.
- Implement booking cancellation and modification.
- Add room maintenance management.
- Generate invoices and payment receipts.
- Include taxes, discounts, and additional service charges.
- Add user roles, audit logs, and enhanced transaction handling.

## 🎓 Learning Outcomes

Through this project, I gained practical experience in:

- Designing relational database schemas.
- Establishing relationships using primary and foreign keys.
- Writing SQL queries for real-world scenarios.
- Using joins, subqueries, and aggregate functions.
- Creating views and stored procedures.
- Implementing triggers to enforce business rules.
- Validating reservation dates and calculating financial reports.
- Testing database operations and handling invalid inputs.

## 👨‍💻 Author

**Project:** Hotel Room Management System  
**Database:** MySQL  
**Project Type:** SQL Database Project

## 📄 License

This project is intended for educational and learning purposes.
