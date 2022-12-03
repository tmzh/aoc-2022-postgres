-- Create a dedicated schema
DROP SCHEMA IF EXISTS day02 CASCADE;
CREATE SCHEMA day02;

CREATE TABLE day02.inputs
    (
        id serial,
        opp char(1),
        strategy char(1)
    );

CREATE TABLE day02.move_values (move, value)
AS (VALUES ('X', 1),
           ('Y', 2),
           ('Z', 3));

-- Load local file as text
\COPY day02.inputs (opp, strategy) FROM 'day02/input.txt' WITH (DELIMITER ' ');

/* PART ONE */
-- A: Rock, B: Paper, C:Scissors
-- X: Rock, Y: Paper, Z:Scissors
  WITH outcome_values (opp, player, value) AS (VALUES ('A', 'X', 3),
                                                      ('A', 'Y', 6),
                                                      ('B', 'Y', 3),
                                                      ('B', 'Z', 6),
                                                      ('C', 'X', 6),
                                                      ('C', 'Z', 3))
SELECT SUM(s.value) + SUM(o.value) AS part_one
  FROM day02.inputs AS i
           FULL JOIN outcome_values AS o
           ON o.opp = i.opp AND o.player = i.strategy
           FULL JOIN day02.move_values AS s
           ON s.move = i.strategy;

/* PART TWO */
-- A:Rock, B: Paper, C:Scissors
-- X: Lose, Y: Draw, Z: Win

INSERT INTO day02.move_values (VALUES ('A', 1), ('B', 2), ('C', 3));

  WITH target_values (opp, result, player) AS (VALUES ('A', 'X', 'C'),
                                                      ('A', 'Y', 'A'),
                                                      ('A', 'Z', 'B'),
                                                      ('B', 'X', 'A'),
                                                      ('B', 'Y', 'B'),
                                                      ('B', 'Z', 'C'),
                                                      ('C', 'X', 'B'),
                                                      ('C', 'Y', 'C'),
                                                      ('C', 'Z', 'A')),
       outcome_values (opp, player, value) AS (VALUES ('A', 'A', 3),
                                                      ('A', 'B', 6),
                                                      ('B', 'B', 3),
                                                      ('B', 'C', 6),
                                                      ('C', 'A', 6),
                                                      ('C', 'C', 3))
SELECT SUM(s.value) + SUM(o.value) AS part_two
  FROM day02.inputs AS i
           JOIN target_values AS t
           ON i.opp = t.opp AND i.strategy = t.result
           FULL JOIN outcome_values AS o
           ON o.opp = i.opp AND o.player = t.player
           JOIN day02.move_values AS s
           ON s.move = t.player;
