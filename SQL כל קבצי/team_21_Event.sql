select * from dbCourseSt23.team_21_Event;

-- Inserting into Event table
INSERT INTO dbCourseSt23.team_21_Event (id, eventType, eventDate, numberOfGuests, minimumPrice, pricePerDish, numberOfWaitersRequired, numberOfCooksRequired)
VALUES 
(1, 'Wedding', '2023-12-01', 100, 5000.00, 50.00, 5, 3),
(2, 'Birthday', '2023-12-02', 50, 2500.00, 50.00, 3, 2),
(3, 'Anniversary', '2023-12-03', 75, 3750.00, 50.00, 4, 2),
(4, 'Corporate', '2023-12-04', 200, 10000.00, 50.00, 10, 5),
(5, 'Wedding', '2023-12-05', 120, 6000.00, 50.00, 6, 3),
(6, 'Birthday', '2023-12-06', 60, 3000.00, 50.00, 3, 2),
(7, 'Anniversary', '2023-12-07', 80, 4000.00, 50.00, 4, 2),
(8, 'Corporate', '2023-12-08', 220, 11000.00, 50.00, 11, 5),
(9, 'Wedding', '2023-12-09', 130, 6500.00, 50.00, 7, 3),
(10, 'Birthday', '2023-12-10', 70, 3500.00, 50.00, 4, 2);