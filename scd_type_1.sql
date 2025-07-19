-- Tables and sample data for SCD Type 1 (overwrite)
IF OBJECT_ID('source_table', 'U') IS NOT NULL DROP TABLE source_table;
IF OBJECT_ID('dim_customer', 'U') IS NOT NULL DROP TABLE dim_customer;

CREATE TABLE source_table (
  customer_id INT PRIMARY KEY,
  name        VARCHAR(100),
  address     VARCHAR(200),
  city        VARCHAR(100)
);

CREATE TABLE dim_customer (
  customer_id   INT,
  name          VARCHAR(100),
  address       VARCHAR(200),
  city          VARCHAR(100),
  previous_city VARCHAR(100),
  start_date    DATE,
  end_date      DATE,
  is_current    CHAR(1),
  PRIMARY KEY (customer_id, start_date)
);

-- Sample data
INSERT INTO source_table VALUES (2, 'Bob', '456 Lake Ave', 'Mumbai');
INSERT INTO dim_customer VALUES (2,'Bob','456 Lake Ave','Mumbai',NULL,CAST(GETDATE() AS DATE),NULL,'Y');

-- Stored procedure for SCD Type 1
drop procedure if exists scd_type_1;
GO
CREATE PROCEDURE scd_type_1
AS
BEGIN
  SET NOCOUNT ON;
  -- Update
  UPDATE d
  SET d.name    = s.name,
      d.address = s.address,
      d.city    = s.city
  FROM dim_customer d
  JOIN source_table s ON d.customer_id = s.customer_id
  WHERE d.is_current = 'Y';

  -- Insert new
  INSERT INTO dim_customer (customer_id, name, address, city, start_date, is_current)
  SELECT s.customer_id, s.name, s.address, s.city, CAST(GETDATE() AS DATE), 'Y'
  FROM source_table s
  WHERE NOT EXISTS (
    SELECT 1 FROM dim_customer d WHERE d.customer_id = s.customer_id
  );
END;
GO

-- Execute and view
EXEC scd_type_1;
SELECT * FROM dim_customer;
