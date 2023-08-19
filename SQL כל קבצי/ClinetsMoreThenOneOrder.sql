SELECT c.id, c.name, COUNT(o.id) AS NumberOfOrders
FROM dbCourseSt23.team_21_Customer AS c
JOIN dbCourseSt23.team_21_Order AS o ON c.id = o.customerId
GROUP BY c.id, c.name
HAVING COUNT(o.id) > 1;

-- PHP --
$sql = "SELECT c.id, c.name, COUNT(o.id) AS NumberOfOrders
FROM dbCourseSt23.team_21_Customer AS c
JOIN dbCourseSt23.team_21_Order AS o ON c.id = o.customerId
GROUP BY c.id, c.name
HAVING COUNT(o.id) > 1";
