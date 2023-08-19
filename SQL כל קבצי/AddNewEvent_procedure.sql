-- פרוצדורה להוספת אירוע חדש --

USE dbCourseSt23;
DELIMITER //
CREATE PROCEDURE AddNewEvent(IN newEventType VARCHAR(255), IN newEventDate TIMESTAMP, IN newNumberOfWaitersRequired INT, IN newNumberOfCooksRequired INT, IN newNumberOfGuests INT, IN newMinimumPrice DECIMAL(10,2), IN newPricePerDish DECIMAL(10,2))
BEGIN
    IF EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Event WHERE eventDate = newEventDate) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Another event is already scheduled for this date.';
    END IF;

    IF newEventDate <= CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot schedule event in the past.';
    END IF;

    IF newNumberOfWaitersRequired < 1 OR newNumberOfCooksRequired < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least one waiter and one cook are required for an event.';
    END IF;

    IF newMinimumPrice < newNumberOfGuests * newPricePerDish THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Minimum price cannot be less than the cost per dish multiplied by the number of guests.';
    END IF;

    INSERT INTO dbCourseSt23.team_21_Event (eventType, eventDate, numberOfWaitersRequired, numberOfCooksRequired, numberOfGuests, minimumPrice, pricePerDish) VALUES (newEventType, newEventDate, newNumberOfWaitersRequired, newNumberOfCooksRequired, newNumberOfGuests, newMinimumPrice, newPricePerDish);
END //
DELIMITER ;



-- DROP PROCEDURE IF EXISTS AddNewEvent;

CALL AddNewEvent('New Event', '2022-01-01', 5, 5, 100, 5000.00, 50.00);
CALL AddNewEvent('Test Event', '2023-07-30', 5, 4, 100, 5000.00, 50.00);
CALL AddNewEvent('Test Event', '2023-07-30', 5, 4, 100, 5000.00, 50.00);
