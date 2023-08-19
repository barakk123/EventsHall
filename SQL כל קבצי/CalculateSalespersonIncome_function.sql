-- לכל איש מכירות את כמות הההכנסות לחודש מסויים (שם איש המכירות, חודש ושנה יהיו הקלט) --

USE dbCourseSt23;
DELIMITER //
CREATE FUNCTION CalculateSalespersonIncome(salespersonName VARCHAR(255), month INT, year INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE totalIncome DECIMAL(10,2);

    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Employee WHERE name = salespersonName AND role = 'Sales') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salesperson does not exist.';
    END IF;

    IF month < 1 OR month > 12 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid month.';
    END IF;

    IF year < 1900 OR year > YEAR(CURDATE()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid year.';
    END IF;

    SELECT SUM(o.eventPrice)
    INTO totalIncome
    FROM dbCourseSt23.team_21_Order o
    JOIN dbCourseSt23.team_21_Employee e ON o.salespersonId = e.id
    JOIN dbCourseSt23.team_21_Event ev ON o.eventId = ev.id
    WHERE e.name = salespersonName AND MONTH(ev.eventDate) = month AND YEAR(ev.eventDate) = year;

    IF totalIncome IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salesperson has no sales in the given month and year.';
    END IF;

    RETURN totalIncome;
END //
DELIMITER ;

-- DROP FUNCTION IF EXISTS CalculateSalespersonIncome;

SELECT CalculateSalespersonIncome('Moshe Pearl', 7, 2023); -- Should succeed if 'John Doe' made sales in July 2023
SELECT CalculateSalespersonIncome('Moshe Pearl', 13, 2023); -- Should fail with 'Invalid month.'
SELECT CalculateSalespersonIncome('Moshe Pearl', 7, 1899); -- Should fail with 'Invalid year.'
SELECT CalculateSalespersonIncome('Nonexistent Salesperson', 7, 2023); -- Should fail with 'Salesperson does not exist.'


