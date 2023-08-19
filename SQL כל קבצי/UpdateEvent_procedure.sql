-- פרוצדורה לעדכון אירוע --

USE dbCourseSt23;
DELIMITER //
CREATE PROCEDURE UpdateEvent(IN eventId INT, IN newEventType VARCHAR(255), IN newEventDate TIMESTAMP, IN newNumberOfWaitersRequired INT, IN newNumberOfCooksRequired INT, IN newNumberOfGuests INT, IN newMinimumPrice DECIMAL(10,2), IN newPricePerDish DECIMAL(10,2))
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Event WHERE id = eventId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Event does not exist.';
    END IF;

    IF EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Event WHERE eventDate = newEventDate AND id != eventId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Another event is already scheduled for this date.';
    END IF;

    IF newEventDate <= CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot reschedule event to a past date.';
    END IF;

    IF newNumberOfWaitersRequired < 1 OR newNumberOfCooksRequired < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least one waiter and one cook are required for an event.';
    END IF;

    IF newMinimumPrice < newNumberOfGuests * newPricePerDish THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Minimum price cannot be less than the cost per dish multiplied by the number of guests.';
    END IF;

    UPDATE dbCourseSt23.team_21_Event
    SET eventType = newEventType, eventDate = newEventDate, numberOfWaitersRequired = newNumberOfWaitersRequired, numberOfCooksRequired = newNumberOfCooksRequired, numberOfGuests = newNumberOfGuests, minimumPrice = newMinimumPrice, pricePerDish = newPricePerDish
    WHERE id = eventId;
END //
DELIMITER ;



-- DROP PROCEDURE IF EXISTS UpdateEvent;
CALL UpdateEvent(9999, 'New Event Name', '2024-01-01 00:00:00', 5, 4, 100, 5000.00, 50.00);
CALL UpdateEvent(1, 'Updated Test', '2023-07-29 00:00:00', 5, 4, 100, 5000.00, 50.00);
CALL UpdateEvent(2, 'Updated Test', '2023-07-29 00:00:00', 5, 4, 100, 5000.00, 50.00);
CALL UpdateEvent(2, 'Updated Test', '2022-07-29 00:00:00', 5, 4, 100, 5000.00, 50.00);