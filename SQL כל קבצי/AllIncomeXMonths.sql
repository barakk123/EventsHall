-- חודשים אחורה X הצגת הכנסות
SELECT SUM(o.eventPrice) AS TotalIncome FROM dbCourseSt23.team_21_Order AS o
JOIN dbCourseSt23.team_21_Event AS e ON o.eventId = e.id
WHERE e.eventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE();

-- PHP --
$stmt = $mysqli->prepare("SELECT SUM(o.eventPrice) AS TotalIncome FROM dbCourseSt23.team_21_Order AS o
JOIN dbCourseSt23.team_21_Event AS e ON o.eventId = e.id
WHERE e.eventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL ? MONTH) AND CURDATE()");
$stmt->bind_param("i", $months);
$stmt->execute();
