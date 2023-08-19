-- עדכון הזמנה --

USE dbCourseSt23;
DELIMITER //
CREATE PROCEDURE UpdateOrder(IN orderId INT, IN newCustomerId INT, IN newSalespersonId INT, IN newEventId INT, IN newEventPrice DECIMAL(10, 2))
BEGIN
    DECLARE salespersonRole ENUM('Waiter', 'Cook', 'Sales');

    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Order WHERE id = orderId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order does not exist.';
    END IF;

    IF EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Order WHERE eventId = newEventId AND id != orderId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Another order is already associated with this event.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Customer WHERE id = newCustomerId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Customer does not exist.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Employee WHERE id = newSalespersonId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salesperson does not exist.';
    END IF;

    SELECT role INTO salespersonRole
    FROM dbCourseSt23.team_21_Employee
    WHERE id = newSalespersonId;

    IF salespersonRole != 'Sales' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee is not a salesperson.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Event WHERE id = newEventId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Event does not exist.';
    END IF;

    IF (SELECT minimumPrice FROM dbCourseSt23.team_21_Event WHERE id = newEventId) > newEventPrice THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Event price cannot be less than the minimum price.';
    END IF;

    UPDATE dbCourseSt23.team_21_Order
    SET customerId = newCustomerId, salespersonId = newSalespersonId, eventId = newEventId, eventPrice = newEventPrice
    WHERE id = orderId;
END //
DELIMITER ;

-- DROP PROCEDURE IF EXISTS UpdateOrder;

CALL UpdateOrder(1, 1101, 1007, 2, 6000.00);
CALL UpdateOrder(9999, 1101, 1007, 2, 6000.00);
CALL UpdateOrder(1, 9999, 1007, 2, 6000.00);
CALL UpdateOrder(1, 1101, 9999, 2, 6000.00);
CALL UpdateOrder(1, 1101, 1007, 9999, 6000.00);
CALL UpdateOrder(1, 1101, 1007, 2, 100.00);
