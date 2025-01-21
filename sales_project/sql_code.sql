-- Create cars table

CREATE TABLE Cars (
   car_id INT PRIMARY KEY,
   car_name VARCHAR2(50),
   car_model VARCHAR2(50),
   year_of_release INT,
   car_type VARCHAR2(50)
);

-- Create sales table

CREATE TABLE Sales (
   sales_id INT PRIMARY KEY,
   car_id INT,
   sale_date DATE,
   city VARCHAR2(50),
   units_sold INT,
   FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

--  Create Monthly_Sales_Summary Table

CREATE TABLE Monthly_Sales_Summary (
   sales_summary_id INT PRIMARY KEY,
   car_id INT,
   year INT,
   month INT,
   units_sold INT,
   FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);


--Data Insertion - Insert into Cars Table (with 10 brands and models)

BEGIN
   FOR i IN 1..10 LOOP
      INSERT INTO Cars (car_id, car_name, car_model, year_of_release, car_type)
      VALUES (
         i,
         CASE i 
            WHEN 1 THEN 'Maruti Suzuki Swift'
            WHEN 2 THEN 'Hyundai Creta'
            WHEN 3 THEN 'Toyota Corolla'
            WHEN 4 THEN 'Honda Civic'
            WHEN 5 THEN 'Ford Ecosport'
            WHEN 6 THEN 'Mahindra XUV700'
            WHEN 7 THEN 'Tata Nexon'
            WHEN 8 THEN 'BMW X5'
            WHEN 9 THEN 'Mercedes-Benz A-Class'
            WHEN 10 THEN 'Audi Q7'
         END,
         CASE i 
            WHEN 1 THEN 'VXI'
            WHEN 2 THEN 'SX'
            WHEN 3 THEN 'GLI'
            WHEN 4 THEN 'ZX'
            WHEN 5 THEN 'Titanium'
            WHEN 6 THEN 'AX7'
            WHEN 7 THEN 'XZ+'
            WHEN 8 THEN 'xDrive30d'
            WHEN 9 THEN 'A200'
            WHEN 10 THEN 'Technology'
         END,
         2020 + MOD(i, 5),  -- Random year from 2020 to 2024
         CASE MOD(i, 3)
            WHEN 0 THEN 'SUV'
            WHEN 1 THEN 'Hatchback'
            ELSE 'Sedan'
         END
      );
   END LOOP;
END;
/


-- Insert into Sales Table (with random city and sales numbers)

BEGIN
   FOR i IN 1..700 LOOP
      INSERT INTO Sales (sales_id, car_id, sale_date, city, units_sold)
      VALUES (
         i,
         MOD(i, 10) + 1, -- Random car_id between 1 and 10
         TO_DATE(
            '2024-' || 
            LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 12)), 2, '0') || '-' || 
            LPAD(
               TRUNC(DBMS_RANDOM.VALUE(1, 28)), 2, '0'  -- Random day from 1 to 28 (valid for all months)
            ), 
            'YYYY-MM-DD'
         ),
         CASE 
            WHEN MOD(i, 3) = 0 THEN 'Delhi' 
            WHEN MOD(i, 3) = 1 THEN 'Mumbai' 
            ELSE 'Bangalore' 
         END,
         TRUNC(DBMS_RANDOM.VALUE(1, 100))  -- Random number of units sold between 1 and 100
      );
   END LOOP;
END;
/


select * from Monthly_Sales_Summary;

--Insert into Monthly_Sales_Summary Table


BEGIN
   FOR car_id IN 1..10 LOOP  -- For each of the 10 cars
      FOR month IN 1..12 LOOP  -- For each month
         INSERT INTO Monthly_Sales_Summary (sales_summary_id, car_id, year, month, units_sold)
         VALUES (
            (car_id * 100 + month),  -- Unique ID for each row
            car_id,
            2024,
            month,
            TRUNC(DBMS_RANDOM.VALUE(100, 1000))  -- Random sales between 100 and 1000
         );
      END LOOP;
   END LOOP;
END;
/



SELECT car_name, SUM(units_sold) AS total_sales
FROM Sales s
JOIN Cars c ON s.car_id = c.car_id
WHERE EXTRACT(YEAR FROM sale_date) = 2024
GROUP BY car_name;

SELECT car_name, MAX(units_sold) AS highest_sales
FROM Sales s
JOIN Cars c ON s.car_id = c.car_id
WHERE EXTRACT(YEAR FROM sale_date) = 2024
GROUP BY car_name;


SELECT car_name, MIN(units_sold) AS lowest_sales
FROM Sales s
JOIN Cars c ON s.car_id = c.car_id
WHERE EXTRACT(YEAR FROM sale_date) = 2024
GROUP BY car_name;


--Montly Sales Report

SELECT car_name, EXTRACT(MONTH FROM sale_date) AS month, SUM(units_sold) AS total_month_sales
FROM Sales s
JOIN Cars c ON s.car_id = c.car_id
WHERE EXTRACT(YEAR FROM sale_date) = 2024
GROUP BY car_name, EXTRACT(MONTH FROM sale_date)
ORDER BY month;
