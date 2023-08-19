-- שאילתות
-- הצגת כל האירועים ב X השבועות האחרונים (X יועבר כפרמטר)
-- (יועבר כפרמטר X) השבועות האחרונים X הצגת כל האירועים ב --

-- SELECT CURDATE();
-- SELECT DATE_SUB(CURDATE(), INTERVAL 1 WEEK);
-- SELECT * FROM dbCourseSt23.team_21_Event WHERE EventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL X WEEK) AND CURDATE();
-- SELECT * FROM dbCourseSt23.team_21_Event WHERE EventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 WEEK) AND CURDATE();

-- SELECT * FROM dbCourseSt23.team_21_Event WHERE EventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL ? WEEK) AND CURDATE();
SELECT e.*, o.eventPrice 
FROM dbCourseSt23.team_21_Event AS e
JOIN dbCourseSt23.team_21_Order AS o ON e.id = o.EventID
WHERE e.EventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL ? WEEK) AND CURDATE();


-- PHP --
-- $stmt = $mysqli->prepare("SELECT * FROM dbCourseSt23.team_21_Event WHERE EventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL ? WEEK) AND CURDATE()");
-- $stmt->bind_param("i", $weeks);
-- $stmt->execute();


-- PHP --
$stmt = $conn->prepare("SELECT e.*, o.eventPrice 
                                FROM dbCourseSt23.team_21_Event AS e
                                JOIN dbCourseSt23.team_21_Order AS o ON e.id = o.EventID
                                WHERE e.EventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL ? WEEK) AND CURDATE()");
        $stmt->bind_param("i", $weeks);