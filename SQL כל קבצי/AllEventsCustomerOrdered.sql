-- הצגת האירועים הפעילים (שהאירוע שלהם עוד לא התקיים) והלקוח הזמין --

-- SELECT * FROM dbCourseSt23.team_21_Order AS o
-- JOIN dbCourseSt23.team_21_Event AS e ON o.EventID = e.id
-- JOIN dbCourseSt23.team_21_Customer AS c ON o.CustomerID = c.id
-- WHERE e.EventDate > CURDATE();


-- PHP --
-- $sql = "SELECT * FROM dbCourseSt23.team_21_Order AS o
-- JOIN dbCourseSt23.team_21_Event AS e ON o.EventID = e.id
-- JOIN dbCourseSt23.team_21_Customer AS c ON o.CustomerID = c.id
-- WHERE e.EventDate > CURDATE()";


SELECT 
    o.id, 
    c.name AS CustomerName, 
    (SELECT name FROM dbCourseSt23.team_21_Employee WHERE id = o.salespersonId) AS SalespersonName, 
    e.eventType, 
    o.eventPrice, 
    e.eventDate, 
    e.numberOfGuests, 
    e.minimumPrice 
FROM 
    dbCourseSt23.team_21_Order AS o 
JOIN 
    dbCourseSt23.team_21_Event AS e ON o.EventID = e.id 
JOIN 
    dbCourseSt23.team_21_Customer AS c ON o.CustomerID = c.id 
WHERE 
    e.EventDate > CURDATE();
    
    
-- PHP --
$sql = "SELECT 
    o.id, 
    c.name AS CustomerName, 
    (SELECT name FROM dbCourseSt23.team_21_Employee WHERE id = o.salespersonId) AS SalespersonName, 
    e.eventType, 
    o.eventPrice, 
    e.eventDate, 
    e.numberOfGuests, 
    e.minimumPrice 
FROM 
    dbCourseSt23.team_21_Order AS o 
JOIN 
    dbCourseSt23.team_21_Event AS e ON o.EventID = e.id 
JOIN 
    dbCourseSt23.team_21_Customer AS c ON o.CustomerID = c.id 
WHERE 
    e.EventDate > CURDATE()";

