-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE employees CASCADE;
DROP TABLE sales CASCADE;
DROP TABLE customers CASCADE;
DROP TABLE products CASCADE;


CREATE TABLE employees(
  id SERIAL PRIMARY KEY,
  employee_name VARCHAR(255),
  employee_email VARCHAR(255)
);

CREATE TABLE customers(
  id SERIAL PRIMARY KEY,
  customer_name VARCHAR(255),
  customer_account VARCHAR(255)
);

CREATE TABLE products(
  id SERIAL PRIMARY KEY,
  product_name VARCHAR(255)
);

CREATE TABLE sales(
  id SERIAL PRIMARY KEY,
  sale_date VARCHAR(255),
  sale_amount MONEY,
  units_sold INTEGER,
  invoice_no INTEGER,
  invoice_frequency VARCHAR(255),
  product_id INTEGER REFERENCES products(id),
  employee_id INTEGER REFERENCES employees(id),
  customer_id INTEGER REFERENCES customers(id)
);
