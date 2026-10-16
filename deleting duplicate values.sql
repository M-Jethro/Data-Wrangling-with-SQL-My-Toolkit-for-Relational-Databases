-- SQL dialect: MySQL 8.0+
-- Self-contained exercise to identify and remove duplicate artist names.
-- Run only in a disposable practice database: this script recreates its table.

DROP TABLE IF EXISTS artists;
CREATE TABLE artists (
    id INT PRIMARY KEY,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL
);

INSERT INTO artists (id, first_name, last_name)
VALUES
    (1, 'Thomas', 'Black'),
    (2, 'Kate', 'Smith'),
    (3, 'Natali', 'Wein'),
    (4, 'Francesco', 'Benelli'),
    (5, 'Nicholas', 'Smith'),
    (6, 'Perl', 'Hoon'),
    (7, 'Kate', 'Smith'),
    (8, 'Natali', 'Wein'),
    (9, 'Kate', 'Smith'),
    (10, 'Natali', 'Wein');

-- 1. Identify duplicate name combinations.
SELECT
    first_name,
    last_name,
    COUNT(*) AS record_count
FROM artists
GROUP BY first_name, last_name
HAVING COUNT(*) > 1
ORDER BY record_count DESC, last_name, first_name;

-- 2. Inspect individual rows and their duplicate number.
SELECT
    id,
    first_name,
    last_name,
    ROW_NUMBER() OVER (
        PARTITION BY first_name, last_name
        ORDER BY id
    ) AS duplicate_number
FROM artists
ORDER BY last_name, first_name, id;

-- 3. Alternative method: create a deduplicated copy before changing the original.
-- This uses the same duplicate-containing input as the DELETE example below.
DROP TABLE IF EXISTS artists_deduplicated;
CREATE TABLE artists_deduplicated AS
SELECT
    MIN(id) AS id,
    first_name,
    last_name
FROM artists
GROUP BY first_name, last_name;

SELECT * FROM artists_deduplicated ORDER BY id;

-- 4. Keep the lowest ID for each name and delete all subsequent duplicates.
-- The derived-table layer avoids MySQL's target-table subquery restriction.
DELETE FROM artists
WHERE id IN (
    SELECT id
    FROM (
        SELECT
            id,
            ROW_NUMBER() OVER (
                PARTITION BY first_name, last_name
                ORDER BY id
            ) AS duplicate_number
        FROM artists
    ) AS ranked_artists
    WHERE duplicate_number > 1
);

SELECT * FROM artists ORDER BY id;

-- Review the deduplicated copy before using it to replace any other table.
