-- פרוצדורה עדכון עובד --

USE dbCourseSt23;
DELIMITER //
CREATE PROCEDURE UpdateEmployee(IN newId INT, IN newRole ENUM('Waiter', 'Cook', 'Sales'), IN newName VARCHAR(255), IN newAddress VARCHAR(255), IN newPhone VARCHAR(255))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Employee WHERE id = newId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee does not exist.';
    END IF;

    IF newRole NOT IN ('Waiter', 'Cook', 'Sales') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid role.';
    END IF;

    UPDATE dbCourseSt23.team_21_Employee 
    SET role = newRole, name = newName, address = newAddress, phone = newPhone
    WHERE id = newId;
END //
DELIMITER ;

-- בדיקה של עדכון עובד קיים
CALL UpdateEmployee(1010, 'Cook', 'Waiter Updated', '123 new St Updated', '0501234587');

-- בדיקה של עדכון עובד שאינו קיים
CALL UpdateEmployee(9999, 'Cook', 'Waiter Updated', '123 new St Updated', '0501234587');

-- בדיקה של עדכון עובד עם תפקיד לא חוקי
CALL UpdateEmployee(1010, 'Invalid Role', 'Waiter Updated', '123 new St Updated', '0501234587');
