-- פרוצדורה הוספת עובד חדש --

USE dbCourseSt23;
DELIMITER //
CREATE PROCEDURE AddNewEmployee(IN newId INT, IN newRole ENUM('Waiter', 'Cook', 'Sales'), IN newName VARCHAR(255), IN newAddress VARCHAR(255), IN newPhone VARCHAR(255))
BEGIN
    IF EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Employee WHERE id = newId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee with this ID already exists.';
    END IF;

    IF newRole NOT IN ('Waiter', 'Cook', 'Sales') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid role. Role must be Waiter, Cook, or Sales.';
    END IF;

    INSERT INTO dbCourseSt23.team_21_Employee (id, role, name, address, phone) VALUES (newId, newRole, newName, newAddress, newPhone);
END //
DELIMITER ;


-- 1. הוספת עובד חדש עם פרטים תקניים
CALL AddNewEmployee(1010, 'Waiter', 'New Waiter', '123 New St', '0501234587');

-- 2. ניסיון להוסיף עובד שכבר קיים במערכת (לפי מזהה)
CALL AddNewEmployee(1000, 'Waiter', 'Existing Waiter', '123 Existing St', '0501234577');

-- 3. ניסיון להוסיף עובד עם תפקיד שאינו תקני
CALL AddNewEmployee(1011, 'Manager', 'Invalid Role', '456 Invalid St', '0501234588');
