-- Step 3: Install and load the Postgres extension (only needs to be done once per install)
INSTALL postgres;
LOAD postgres;

ATTACH 'dbname=dbjackson user=jackson password=jackson123 host=ls-2a7d4e4d9224e72ff5b761a4e80c658e526788a3.c4fmk2omyh2a.us-east-1.rds.amazonaws.com' AS pg_db (TYPE postgres, SCHEMA 'public');

CREATE TABLE IF NOT EXISTS pg_db.my_duck_table (
        id INTEGER,
        name TEXT,
        age INTEGER
    );

TRUNCATE TABLE pg_db.my_duck_table;
-- Insert data from DuckDB into the Postgres table
INSERT INTO pg_db.my_duck_table
SELECT * FROM my_duck_table;

-- Test
SELECT * FROM pg_db.my_duck_table;