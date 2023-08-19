select * from dbCourseSt23.team_21_Order;

-- Inserting into Order table
INSERT INTO dbCourseSt23.team_21_Order (customerId, salespersonId, eventId, eventPrice)
VALUES 
(1100, 1006, 1, 5000.00),
(1101, 1007, 2, 2750.00),
(1102, 1008, 3, 4500.00),
(1103, 1006, 4, 10000.00),
(1104, 1007, 5, 6000.00),
(1105, 1008, 6, 3000.00),
(1106, 1006, 7, 4000.00),
(1107, 1007, 8, 11000.00),
(1108, 1008, 9, 6500.00),
(1109, 1006, 10, 3500.00);


INSERT INTO dbCourseSt23.team_21_Order (id, customerId, salespersonId, eventId, eventPrice)
VALUES 
(11, 1100, 1006, 11, 15000.00);
