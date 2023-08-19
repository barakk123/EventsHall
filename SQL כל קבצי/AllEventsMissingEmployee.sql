-- הצגת אירועים שחסרים ל ה ם מלצרים וטבחים --

SELECT e.id, e.eventType, e.eventDate, e.numberOfWaitersRequired, e.numberOfCooksRequired, 
        (SELECT COUNT(*) FROM dbCourseSt23.team_21_EventEmployee AS ee
         JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
         WHERE ee.eventId = e.id AND emp.role = 'Waiter') AS AssignedWaiters,
        (SELECT COUNT(*) FROM dbCourseSt23.team_21_EventEmployee AS ee
         JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
         WHERE ee.eventId = e.id AND emp.role = 'Cook') AS AssignedCooks
 FROM dbCourseSt23.team_21_Event AS e
 HAVING e.numberOfWaitersRequired > AssignedWaiters OR e.numberOfCooksRequired > AssignedCooks;

$sql = "SELECT e.id, e.eventType, e.eventDate, e.numberOfWaitersRequired, e.numberOfCooksRequired, 
        (SELECT COUNT(*) FROM dbCourseSt23.team_21_EventEmployee AS ee
         JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
         WHERE ee.eventId = e.id AND emp.role = 'Waiter') AS AssignedWaiters,
        (SELECT COUNT(*) FROM dbCourseSt23.team_21_EventEmployee AS ee
         JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
         WHERE ee.eventId = e.id AND emp.role = 'Cook') AS AssignedCooks
 FROM dbCourseSt23.team_21_Event AS e
 HAVING e.numberOfWaitersRequired > AssignedWaiters OR e.numberOfCooksRequired > AssignedCooks";


-- בסוף בחרנו להציג זאת כך:
SELECT 
    e.id, 
    e.eventType, 
    e.eventDate, 
    e.numberOfWaitersRequired, 
    e.numberOfCooksRequired, 
    (SELECT COUNT(*) FROM dbCourseSt23.team_21_EventEmployee AS ee
     JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
     WHERE ee.eventId = e.id AND emp.role = 'Waiter') AS AssignedWaiters,
    (SELECT COUNT(*) FROM dbCourseSt23.team_21_EventEmployee AS ee
     JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
     WHERE ee.eventId = e.id AND emp.role = 'Cook') AS AssignedCooks,
    e.numberOfWaitersRequired - (SELECT COUNT(*) FROM dbCourseSt23.team_21_EventEmployee AS ee
     JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
     WHERE ee.eventId = e.id AND emp.role = 'Waiter') AS WaitersMissing,
    e.numberOfCooksRequired - (SELECT COUNT(*) FROM dbCourseSt23.team_21_EventEmployee AS ee
     JOIN dbCourseSt23.team_21_Employee AS emp ON ee.employeeId = emp.id
     WHERE ee.eventId = e.id AND emp.role = 'Cook') AS CooksMissing
FROM 
    dbCourseSt23.team_21_Event AS e
HAVING 
    WaitersMissing > 0 OR CooksMissing > 0
