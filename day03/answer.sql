-- Create a dedicated schema
DROP SCHEMA IF EXISTS day03 CASCADE;
CREATE SCHEMA day03;

CREATE TABLE day03.inputs (
    id   SERIAL,
    line TEXT NOT NULL
);

CREATE TABLE day03.sample (
    id   SERIAL,
    line TEXT
);

-- load local file as text
\COPY day03.sample (line) FROM 'day03/sample.txt';
\COPY day03.inputs (line) FROM 'day03/input.txt';

/* PART ONE */
\echo 'Part One';

-- item counts: calculate size of each compartment
-- items: list of items in each compartment
-- common_items: common item in each compartment
-- priorities: priority of common items in each compartment

WITH item_counts AS (
    SELECT id, line, LENGTH(line) AS no_of_items
    FROM day03.:table
), items AS (
    SELECT SUBSTRING(line FROM 1 FOR no_of_items / 2) AS first,
        SUBSTRING(line FROM no_of_items / 2 + 1 FOR no_of_items / 2) AS second
    FROM item_counts
), common_items AS (
    SELECT (
        SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(first, '')) INTERSECT SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(second, ''))
    ) AS common_item
    FROM items
), priorities AS (

    SELECT POSITION(common_item IN 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') AS priority FROM common_items
)
SELECT SUM(priority)
FROM priorities;

/* PART TWO */
\echo 'Part two';
-- groups: 3 item lists of each group
-- badges: badge of each group
-- common_items: common item in each compartment
-- priorities: priority of common items in each compartment
WITH groups AS (
    SELECT id,
        line AS third,
        LAG(line, 1) OVER ( ORDER BY id RANGE BETWEEN 3 PRECEDING AND CURRENT ROW ) AS second,
        LAG(line, 2) OVER (ORDER BY id RANGE BETWEEN 3 PRECEDING AND CURRENT ROW ) AS first
    FROM day03.:table
), badges AS (
    SELECT (
        SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(third, ''))
        INTERSECT
        SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(second, ''))
        INTERSECT
        SELECT UNNEST(REGEXP_SPLIT_TO_ARRAY(first, ''))
    ) AS badge
    FROM groups
    WHERE id % 3 = 0
), priorities AS (
    SELECT POSITION(badge IN 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ') AS priority FROM badges
)
SELECT SUM(priority)
FROM priorities;
