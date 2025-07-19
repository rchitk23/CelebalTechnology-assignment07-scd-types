-- Tables and sample data for SCD Type 6 (hybrid)
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
INSERT INTO source_table VALUES (6,'Frank','987 Meadow Blvd','Hyderabad');
INSERT INTO dim_customer VALUES (6,'Frank','987 Meadow Blvd','Hyderabad',NULL,CAST(GETDATE() AS DATE),NULL,'Y');

-- Stored procedure for SCD Type 6
drop procedure if exists scd_type_6;
GO
CREATE PROCEDURE scd_type_6
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @today DATE = CAST(GETDATE() AS DATE);

  -- Close old
  UPDATE d
  SET d.end_date=@today,d.is_current='N'
  FROM dim_customer d
  JOIN source_table s ON d.customer_id=s.customer_id
  WHERE d.is_current='Y' AND (d.name<>s.name OR d.address<>s.address OR d.city<>s.city);

  -- Insert history
  INSERT INTO dim_customer (customer_id,name,address,city,previous_city,start_date,end_date,is_current)
  SELECT s.customer_id,s.name,s.address,s.city,d.city,@today,NULL,'Y'
  FROM source_table s
  JOIN dim_customer d ON d.customer_id=s.customer_id AND d.end_date=@today;

  -- Insert new
  INSERT INTO dim_customer (customer_id,name,address,city,previous_city,start_date,end_date,is_current)
  SELECT s.customer_id,s.name,s.address,s.city,NULL,@today,NULL,'Y'
  FROM source_table s
  WHERE NOT EXISTS (SELECT 1 FROM dim_customer d WHERE d.customer_id=s.customer_id);
END;
GO

-- Execute and view
EXEC scd_type_6;
SELECT * FROM dim_customer;
SELECT * FROM dim_customer_history;
