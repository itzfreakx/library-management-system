-- ========================================
-- Library Management System - MySQL Schema
-- Author: Your Name
-- Description: SQL schema for managing books,
-- authors, patrons, and transactions
-- ========================================

-- Drop existing tables (for reset/testing purposes)
DROP TABLE IF EXISTS book_category;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS patrons;
DROP TABLE IF EXISTS authors;

-- ========================================
-- Authors Table
-- ========================================
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique ID for each author
    first_name VARCHAR(50) NOT NULL,                  -- Author's first name
    last_name VARCHAR(50) NOT NULL,                   -- Author's last name
    birth_date DATE,                                  -- Date of birth
    UNIQUE (first_name, last_name)                    -- Prevent duplicate author names
);

-- ========================================
-- Books Table
-- ========================================
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique ID for each book
    title VARCHAR(100) NOT NULL,                      -- Book title
    author_id INT,                                    -- Foreign key to authors
    genre VARCHAR(50),                                -- Genre of the book
    published_date DATE,                              -- Date book was published
    available_copies INT DEFAULT 0,                   -- How many copies are available
    FOREIGN KEY (author_id) REFERENCES authors(author_id) -- Link to authors table
);

-- ========================================
-- Patrons Table
-- ========================================
CREATE TABLE patrons (
    patron_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique ID for each patron
    first_name VARCHAR(50) NOT NULL,                  -- Patron's first name
    last_name VARCHAR(50) NOT NULL,                   -- Patron's last name
    email VARCHAR(100) NOT NULL UNIQUE,               -- Unique email for each patron
    phone_number VARCHAR(20),                         -- Contact number
    address TEXT,                                     -- Home address
    registered_date DATE DEFAULT CURRENT_DATE         -- Auto-filled on insert
);

-- ========================================
-- Transactions Table
-- ========================================
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique transaction ID
    patron_id INT NOT NULL,                           -- Who borrowed the book
    book_id INT NOT NULL,                             -- What book was borrowed
    checkout_date DATE DEFAULT CURRENT_DATE,          -- Date of checkout
    return_date DATE,                                 -- Date of return (nullable)
    FOREIGN KEY (patron_id) REFERENCES patrons(patron_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- ========================================
-- Categories Table
-- ========================================
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,       -- Unique ID for category
    category_name VARCHAR(100) UNIQUE NOT NULL        -- Name of the category
);

-- ========================================
-- Book_Category Table (Many-to-Many)
-- ========================================
CREATE TABLE book_category (
    book_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (book_id, category_id),               -- Composite primary key
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- ========================================
-- Sample Data Insertion
-- ========================================

-- Add Authors
INSERT INTO authors (first_name, last_name, birth_date)
VALUES 
('J.K.', 'Rowling', '1965-07-31'),
('George', 'Orwell', '1903-06-25');

-- Add Books
INSERT INTO books (title, author_id, genre, published_date, available_copies)
VALUES 
('Harry Potter and the Sorcerer\'s Stone', 1, 'Fantasy', '1997-06-26', 5),
('1984', 2, 'Dystopian', '1949-06-08', 3);

-- Add Patrons
INSERT INTO patrons (first_name, last_name, email, phone_number, address)
VALUES 
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Main St'),
('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', '456 Oak Ave');

-- Add Categories
INSERT INTO categories (category_name)
VALUES 
('Fantasy'),
('Dystopian');

-- Link Books to Categories (Many-to-Many)
INSERT INTO book_category (book_id, category_id)
VALUES 
(1, 1),  -- Harry Potter -> Fantasy
(2, 2);  -- 1984 -> Dystopian

-- Add a Transaction (Book Checkout)
INSERT INTO transactions (patron_id, book_id, checkout_date)
VALUES 
(1, 1, '2025-05-10');

