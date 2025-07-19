Slowly Changing Dimensions (SCD) Procedures - SQL Server

This project contains SQL scripts to demonstrate all six types of Slowly Changing Dimensions (SCD) using SQL Server. Each script defines the required tables, populates sample data, creates a stored procedure for the respective SCD type, and executes it with a sample SELECT to observe the results.


Contents

scd_type_0.sql: Implements SCD Type 0 (No Changes Allowed)

scd_type_1.sql: Implements SCD Type 1 (Overwrite Changes)

scd_type_2.sql: Implements SCD Type 2 (Full History Tracking)

scd_type_3.sql: Implements SCD Type 3 (Limited History Tracking)

scd_type_4.sql: Implements SCD Type 4 (History Table)

scd_type_6.sql: Implements SCD Type 6 (Hybrid of Types 1, 2, and 3)


Sample Output Screenshots

SCD Type 0


<img width="888" height="198" alt="image" src="https://github.com/user-attachments/assets/625553d7-2eb9-483b-a081-09282201497f" />


SCD Type 1


<img width="900" height="189" alt="image" src="https://github.com/user-attachments/assets/0ad5fbd7-2df6-4d14-b4bd-36e445621b7b" />


SCD Type 2


<img width="886" height="173" alt="image" src="https://github.com/user-attachments/assets/032c90f4-b31e-46b2-94ef-f2e0164afd9c" />


SCD Type 3


<img width="899" height="300" alt="image" src="https://github.com/user-attachments/assets/a1f209f0-8ebc-41f2-927e-ef749e710693" />


SCD Type 4


<img width="903" height="683" alt="Screenshot 2025-07-16 120152" src="https://github.com/user-attachments/assets/533bc107-1eea-4900-b4e6-a804d5941169" />


SCD Type 6

<img width="893" height="681" alt="image" src="https://github.com/user-attachments/assets/11efbe1a-dfba-4587-9f93-8d94d059f4f7" />
