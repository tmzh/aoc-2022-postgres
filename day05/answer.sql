-- Create a dedicated schema
DROP SCHEMA IF EXISTS day05 CASCADE;
CREATE SCHEMA day05;
CREATE TABLE day05.inputs (id SERIAL, line TEXT);
CREATE TABLE day05.sample (id SERIAL, line TEXT);
-- load local file as text
\ COPY day05.sample (line)
FROM 'day05/sample.txt'
select regexp_match(line, '^.*(\d)$')
from day05.sample
where line ~ '^\s+\d.*';
select d.id,
    SUBSTRING(
        d.line
        FROM 4 *(g.generate_series - 1) + 2 FOR 1
    )
from day05.sample AS d,
    (
        select *
        from generate_series(1, 3)
    ) as g
WHERE d.line LIKE '%[%';