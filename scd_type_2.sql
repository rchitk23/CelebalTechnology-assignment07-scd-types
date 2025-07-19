-- Tables and sample data for SCD Type 2 (full history)
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
INSERT INTO source_table VALUES (3, 'Carol', '789 Hill Rd', 'Kolkata');
INSERT INTO dim_customer VALUES (3,'Carol','789 Hill Rd','Kolkata',NULL,CAST(DATEADD(day,-10,GETDATE()) AS DATE),NULL,'Y');

-- Stored procedure for SCD Type 2
drop procedure if exists scd_type_2;
GO
CREATE PROCEDURE scd_type_2
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @today DATE = CAST(GETDATE() AS DATE);

  -- Close old
  UPDATE d
  SET d.end_date   = @today,
      d.is_current = 'N'
  FROM dim_customer d
  JOIN source_table s ON d.customer_id = s.customer_id
  WHERE d.is_current = 'Y'
    AND (d.name <> s.name OR d.address <> s.address OR d.city <> s.city);

  -- Insert changed
  INSERT INTO dim_customer (customer_id,name,address,city,start_date,end_date,is_current)
  SELECT s.customer_id,s.name,s.address,s.city,@today,NULL,'Y'
  FROM source_table s
  JOIN dim_customer d2 ON d2.customer_id=s.customer_id AND d2.end_date=@today;

  -- Insert new
  INSERT INTO dim_customer (customer_id,name,address,city,start_date,end_date,is_current)
  SELECT s.customer_id,s.name,s.address,s.city,@today,NULL,'Y'
  FROM source_table s
  WHERE NOT EXISTS (SELECT 1 FROM dim_customer d WHERE d.customer_id = s.customer_id);
END;
GO

-- Execute and view\EXEC scd_type_2;
SELECT * FROM dim_customer;
