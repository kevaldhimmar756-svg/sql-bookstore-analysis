-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM orders;

-- BASIC QUERIES

-- 1. Retrive all the books in the 'Fiction' Genre.

SELECT * FROM Books
WHERE Genre = 'Fiction';

-- 2. Find books published after the year 1950.

SELECT * FROM Books
WHERE published_year > 1950;

-- 3. List all the customers from the canada

SELECT * FROM customers
WHERE country = 'Canada';

-- 4. Show orders placed in november 2023.

SELECT * FROM orders
WHERE order_date BETWEEN  '2023-11-01' AND '2023-11-30';

-- 5. Retrive the total stock of books available.

SELECT SUM(stock) AS total_stock 
FROM Books;

-- 6. Find the details of the most expensive books

SELECT * FROM Books
ORDER BY price DESC LIMIT 1;

-- 7. Show all the customers who ordered more than 1 quantity of a book.

SELECT * FROM orders
WHERE quantity >1;

-- 8. Retrive all the orders where the total amount exeeds $50.

SELECT * FROM orders
WHERE total_amount >50;

-- 9. List all genres available in the books table.

SELECT DISTINCT (Genre)
FROM Books;

-- 10. Find the books with the lowest stock.

SELECT title, Genre, stock
FROM Books 
ORDER BY stock ASC;

-- 11. Calculate the total revenue generated from all orders.

SELECT SUM (total_amount) AS Revenue
FROM orders;



-- ADVANCE QUERIES

-- 1. Retrive the total numbers of books sold for each genre.

SELECT b.Genre, SUM(o.quantity) AS total_books_sold
FROM orders o
JOIN Books b ON b.book_id = o.book_id
GROUP BY b.Genre;

-- 2. Find the average price of books in the 'Fantasy' Genre.

SELECT AVG (b.price), b.Genre
FROM Books b
WHERE Genre = 'Fantasy'
GROUP BY b.Genre;

-- 3. List customers who have placed atleast 2 orders.

SELECT o.customer_id, c.name, COUNT (o.order_id) AS order_count
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id) >= 2;

-- 4. Find the most frequently ordered book

SELECT b.Book_id ,b.title, COUNT(o.order_id) AS order_count
FROM orders o
JOIN Books b ON b.book_id = o.book_id
GROUP BY b.Book_id 
ORDER BY order_count DESC;

-- 5. Show the top 3 most expensive books of 'Fantasy' Genre.

SELECT * FROM Books
WHERE Genre = 'Fantasy'
ORDER BY price DESC LIMIT 3;

-- 6. Retrive the total quantity of books sold by each author.

SELECT b.author,SUM (o.quantity) AS total_books_sold
FROM orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.author;

-- 7. List the cities where customers who spent over $300 are located.

SELECT DISTINCT c.city, o.total_amount
FROM orders o
JOIN customers c ON c.customer_id = o. customer_id
WHERE o.total_amount > 300
GROUP BY c.city, o.total_amount;

-- 8. Find the customers who spent the most on orders.

SELECT c.customer_id , c.name , SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC LIMIT 1;

-- 9. Calculate the stock remaining after fulfilling all orders

SELECT  b.book_id, b.title, 
    GREATEST(b.stock - COALESCE(SUM(o.quantity), 0), 0) AS order_quantity,
	GREATEST(b.stock - COALESCE (SUM(o.quantity),0),0) AS remaining_quantity
FROM Books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id, b.title, b.stock ORDER BY b.book_id;












