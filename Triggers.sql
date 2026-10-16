-- SQL dialect: MySQL 8.0+
-- Prerequisite: run Creating Tables.sql and Inserting Values in a table.sql
-- in a dedicated practice database first. Those scripts insert employee IDs
-- through 108, so this exercise uses IDs 109-111.
--
-- This script demonstrates three alternative versions of the same trigger.
-- Each version replaces the previous trigger. Run it once after setup;
-- the fixed employee IDs mean it is not intended to be rerun unchanged.

CREATE TABLE IF NOT EXISTS trigger_test (
    message VARCHAR(100)
);

-- Reset this demo's log so repeated practice runs are easier to compare.
TRUNCATE TABLE trigger_test;

-- Remove the previous version and any demo employee rows from an earlier run.
DROP TRIGGER IF EXISTS my_trigger;
DELETE FROM employee WHERE emp_id BETWEEN 109 AND 111;

-- Version 1: log a generic message for each inserted employee.
DELIMITER $$
CREATE TRIGGER my_trigger
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    INSERT INTO trigger_test (message)
    VALUES ('Added new employee');
END$$
DELIMITER ;

INSERT INTO employee
VALUES (109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

-- Version 2: log the new employee's first name.
DROP TRIGGER IF EXISTS my_trigger;
DELIMITER $$
CREATE TRIGGER my_trigger
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    INSERT INTO trigger_test (message)
    VALUES (NEW.first_name);
END$$
DELIMITER ;

INSERT INTO employee
VALUES (110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

-- Version 3: log a message based on the employee's sex value.
DROP TRIGGER IF EXISTS my_trigger;
DELIMITER $$
CREATE TRIGGER my_trigger
BEFORE INSERT ON employee
FOR EACH ROW
BEGIN
    IF NEW.sex = 'M' THEN
        INSERT INTO trigger_test (message) VALUES ('Added male employee');
    ELSEIF NEW.sex = 'F' THEN
        INSERT INTO trigger_test (message) VALUES ('Added female employee');
    ELSE
        INSERT INTO trigger_test (message)
        VALUES ('Added employee with other/unspecified value');
    END IF;
END$$
DELIMITER ;

INSERT INTO employee
VALUES (111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

SELECT * FROM trigger_test;
SELECT * FROM employee WHERE emp_id BETWEEN 109 AND 111;

-- Optional cleanup: remove the final trigger while keeping the log table.
DROP TRIGGER IF EXISTS my_trigger;
