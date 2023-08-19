-- מתן הנחה באחוזים --

USE dbCourseSt23;
DELIMITER //
CREATE PROCEDURE GiveDiscount(IN inputEventId INT, IN discountPercentage DECIMAL(5, 2))
BEGIN
    DECLARE currentPrice DECIMAL(10, 2);
    DECLARE newPrice DECIMAL(10, 2);
    DECLARE minimumPrice DECIMAL(10, 2);

    IF NOT EXISTS (SELECT 1 FROM dbCourseSt23.team_21_Event WHERE id = inputEventId) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Event does not exist.';
    END IF;

    IF discountPercentage <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Discount percentage must be greater than 0.';
    END IF;

    SELECT o.eventPrice, e.minimumPrice INTO currentPrice, minimumPrice
    FROM dbCourseSt23.team_21_Order o
    JOIN dbCourseSt23.team_21_Event e ON o.eventId = e.id
    WHERE o.eventId = inputEventId;

    SET newPrice = currentPrice - (currentPrice * discountPercentage / 100);

    IF newPrice < minimumPrice THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Discounted price cannot be less than the minimum price.';
    END IF;

    UPDATE dbCourseSt23.team_21_Order
    SET eventPrice = newPrice
    WHERE eventId = inputEventId;
END //
DELIMITER ;

-- DROP PROCEDURE IF EXISTS GiveDiscount;

CALL GiveDiscount(1, 10.00); -- Should succeed
CALL GiveDiscount(1, 0.00); -- Should fail with 'Discount percentage must be greater than 0.'
CALL GiveDiscount(9999, 10.00); -- Should fail with 'Event does not exist.'
CALL GiveDiscount(1, 90.00); -- Should fail with 'Discounted price cannot be less than the minimum price.'
