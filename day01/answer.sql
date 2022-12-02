-- Create a dedicated schema
DROP SCHEMA IF EXISTS day01 CASCADE;
CREATE SCHEMA day01;


CREATE TABLE day01.inputs
    (
        id serial,
        value integer
    );


-- Load local file as text
\COPY day01.inputs (value) FROM 'day01/input.txt' WITH (FORMAT CSV, FORCE_NULL (value));

-- Part one
SELECT SUM(value) AS top_calories
  FROM (SELECT value, COUNT(*) FILTER (WHERE value IS NULL) OVER (ORDER BY id) AS grp FROM day01.inputs) AS g
 GROUP BY grp
 ORDER BY top_calories DESC FETCH FIRST ROW ONLY;

-- Part two
  WITH top_three_elves AS (SELECT SUM(value) AS elf_calories
                             FROM (SELECT value, COUNT(*) FILTER (WHERE value IS NULL) OVER (ORDER BY id) AS grp
                                     FROM day01.inputs) AS g
                            GROUP BY grp
                            ORDER BY elf_calories DESC FETCH FIRST 3 ROWS ONLY)
SELECT SUM(elf_calories)
  FROM top_three_elves;
