-- פרוצדורה הוספת הזמנה --

USE dbCourseSt23;
DELIMITER //
CREATE PROCEDURE AddNewOrder(IN newCustomerId INT, IN newSalespersonId INT, IN newEventId INT, IN newEventPrice DECIMAL(10, 2))
BEGIN
    DECLARE salespersonRole ENUM('Waiter', 'Cook', 'Sales');

    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Customer WHERE id = newCustomerId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer does not exist.';
    ELSEIF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Employee WHERE id = newSalespersonId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salesperson does not exist.';
    ELSE
        SELECT role INTO salespersonRole
        FROM dbCourseSt23.team_21_Employee
        WHERE id = newSalespersonId;

        IF salespersonRole != 'Sales' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee is not a salesperson.';
        ELSEIF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Event WHERE id = newEventId) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Event does not exist.';
        ELSEIF (SELECT minimumPrice FROM dbCourseSt23.team_21_Event WHERE id = newEventId) > newEventPrice THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Event price cannot be less than the minimum price.';
        ELSEIF EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Order WHERE eventId = newEventId) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'An order for this event already exists.';
        ELSE
            INSERT INTO dbCourseSt23.team_21_Order (customerId, salespersonId, eventId, eventPrice) 
            VALUES (newCustomerId, newSalespersonId, newEventId, newEventPrice);
        END IF;
    END IF;
END //
DELIMITER ;

-- DROP PROCEDURE IF EXISTS AddNewOrder

-- הוספת הזמנה קיימת:
CALL AddNewOrder(1100, 1006, 1, 6000.00);

-- הוספת הזמנה עם לקוח שאינו קיים:
CALL AddNewOrder(9999, 1006, 1, 6000.00);

-- הוספת הזמנה עם איש מכירות שאינו קיים:
CALL AddNewOrder(1100, 9999, 1, 6000.00);

-- הוספת הזמנה עם איש מכירות שאינו בתפקיד מכירות:
CALL AddNewOrder(1100, 1000, 1, 6000.00);

-- הוספת הזמנה עם אירוע שאינו קיים:
CALL AddNewOrder(1100, 1006, 9999, 6000.00);

-- הוספת הזמנה עם מחיר אירוע שהוא פחות מהמחיר המינימלי:
CALL AddNewOrder(1100, 1006, 1, 4000.00);
