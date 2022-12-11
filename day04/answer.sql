-- Create a dedicated schema
DROP SCHEMA IF EXISTS day04 CASCADE;
CREATE SCHEMA day04;

CREATE TABLE day04.inputs (
    id       SERIAL,
    section1 TEXT NOT NULL,
    section2 TEXT NOT NULL
);

CREATE TABLE day04.sample (
    id       SERIAL,
    section1 TEXT NOT NULL,
    section2 TEXT NOT NULL
);

-- load local file as text
\COPY day04.sample (section1, section2) FROM 'day04/sample.txt' WITH (FORMAT CSV);
\COPY day04.inputs (section1, section2) FROM 'day04/input.txt' WITH (FORMAT CSV);

/* PART ONE */
\echo 'Part One'

WITH assignment_pairs AS (
    SELECT SPLIT_PART(section1, '-', 1)::int AS a1start,
        SPLIT_PART(section1, '-', 2)::int AS a1end,
        SPLIT_PART(section2, '-', 1)::int AS a2start,
        SPLIT_PART(section2, '-', 2)::int AS a2end
    FROM day04.:table
)
SELECT COUNT(*)
FROM assignment_pairs
WHERE (a1start <= a2start AND a1end >= a2end) -- a1 in a2
   OR (a2start <= a1start AND a2end >= a1end) -- a2 in a1
;

/* PART TWO */
\echo 'Part Two';
WITH assignment_pairs AS (
    SELECT SPLIT_PART(section1, '-', 1)::int AS a1start,
        SPLIT_PART(section1, '-', 2)::int AS a1end,
        SPLIT_PART(section2, '-', 1)::int AS a2start,
        SPLIT_PART(section2, '-', 2)::int AS a2end
    FROM day04.:table
)
SELECT COUNT(*)
FROM assignment_pairs
WHERE (a1start <= a2start AND a2start <= a1end) -- a2 starts within a1
   OR (a2start <= a1start AND a1start <= a2end) -- a1 starts within a2
;
