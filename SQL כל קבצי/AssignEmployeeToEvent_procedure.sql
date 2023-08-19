-- שיבוץ צוות לאירוע – מוסיפה איש צוות לאירוע --
-- פרוצדורה --
USE dbCourseSt23;
DELIMITER //
CREATE PROCEDURE AssignEmployeeToEvent(IN orderId INT, IN inputEmployeeId INT)
BEGIN
    DECLARE eventDate TIMESTAMP;
    DECLARE requiredWaiters INT;
    DECLARE requiredCooks INT;
    DECLARE assignedWaiters INT;
    DECLARE assignedCooks INT;
    DECLARE employeeRole ENUM('Waiter', 'Cook', 'Sales');
    DECLARE isEmployeeAssigned INT;

    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Order WHERE id = orderId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order does not exist.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Employee WHERE id = inputEmployeeId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee does not exist.';
    END IF;

    SELECT COUNT(*) INTO isEmployeeAssigned
    FROM dbCourseSt23.team_21_EventEmployee
    WHERE eventId = orderId AND employeeId = inputEmployeeId;

    IF isEmployeeAssigned > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee is already assigned to this event.';
    END IF;

    SELECT e.eventDate, e.numberOfWaitersRequired, e.numberOfCooksRequired INTO eventDate, requiredWaiters, requiredCooks
    FROM dbCourseSt23.team_21_Order AS o
    JOIN dbCourseSt23.team_21_Event AS e ON o.eventId = e.id
    WHERE o.id = orderId;

    IF eventDate <= CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot assign employee to past event.';
    END IF;

    SELECT COUNT(*) INTO assignedWaiters
    FROM dbCourseSt23.team_21_EventEmployee AS ee
    JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
    WHERE ee.eventId = orderId AND emp.role = 'Waiter';

    SELECT COUNT(*) INTO assignedCooks
    FROM dbCourseSt23.team_21_EventEmployee AS ee
    JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
    WHERE ee.eventId = orderId AND emp.role = 'Cook';

    SELECT role INTO employeeRole
    FROM dbCourseSt23.team_21_Employee
    WHERE id = inputEmployeeId;

    IF employeeRole = 'Sales' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No need to assign a salesperson to the event.';
    ELSEIF employeeRole = 'Waiter' AND assignedWaiters >= requiredWaiters THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No more waiters required for this event.';
    ELSEIF employeeRole = 'Cook' AND assignedCooks >= requiredCooks THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No more cooks required for this event.';
    ELSE
        INSERT INTO dbCourseSt23.team_21_EventEmployee (eventId, employeeId) VALUES (orderId, inputEmployeeId);

        SELECT COUNT(*) INTO assignedWaiters
        FROM dbCourseSt23.team_21_EventEmployee AS ee
        JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
        WHERE ee.eventId = orderId AND emp.role = 'Waiter';

        SELECT COUNT(*) INTO assignedCooks
        FROM dbCourseSt23.team_21_EventEmployee AS ee
        JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
        WHERE ee.eventId = orderId AND emp.role = 'Cook';

        SELECT requiredWaiters - assignedWaiters AS WaitersNeeded, requiredCooks - assignedCooks AS CooksNeeded;
    END IF;
END //
DELIMITER ;



CALL AssignEmployeeToEvent(10, 8);
-- DROP PROCEDURE IF EXISTS AssignEmployeeToEvent