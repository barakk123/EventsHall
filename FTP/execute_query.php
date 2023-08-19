<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css\styles.css">
</head>
<body>
<?php
include 'db_connect.php';

$query = $_POST['query'];
$weeks = $_POST['weeks'] ?? null;
$months = $_POST['months'] ?? null;

switch ($query) {
    case 1:
        $stmt = $conn->prepare("SELECT e.*, o.eventPrice 
                                FROM dbCourseSt23.team_21_Event AS e
                                JOIN dbCourseSt23.team_21_Order AS o ON e.id = o.EventID
                                WHERE e.EventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL ? WEEK) AND CURDATE()");
        $stmt->bind_param("i", $weeks);
        break;
    
    case 2:
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
        break;
    case 3:
        $sql = "SELECT 
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
    ";
        break;
    case 4:
        $sql = "SELECT c.id, c.name, COUNT(o.id) AS NumberOfOrders
        FROM dbCourseSt23.team_21_Customer AS c
        JOIN dbCourseSt23.team_21_Order AS o ON c.id = o.customerId
        GROUP BY c.id, c.name
        HAVING COUNT(o.id) > 1";
        break;
    case 5:
        $stmt = $conn->prepare("SELECT SUM(o.eventPrice) AS TotalIncome FROM dbCourseSt23.team_21_Order AS o
        JOIN dbCourseSt23.team_21_Event AS e ON o.eventId = e.id
        WHERE e.eventDate BETWEEN DATE_SUB(CURDATE(), INTERVAL ? MONTH) AND CURDATE()");
        $stmt->bind_param("i", $months);
        break;
}

if (isset($stmt)) {
    $stmt->execute();
    $meta = $stmt->result_metadata(); 
    while ($field = $meta->fetch_field()) { 
        $params[] = &$row[$field->name]; 
    } 
    call_user_func_array(array($stmt, 'bind_result'), $params);
    $result = array();
    while ($stmt->fetch()) {
        foreach($row as $key => $val) {
            $c[$key] = $val;
        }
        $result[] = $c;
    }
    $stmt->close();
} else {
    $result = $conn->query($sql);
}

if (isset($stmt)) {
    // Handle prepared statements
    if (count($result) > 0) {
        echo "<table>";
        $header = false;
        foreach($result as $row) {
            if(!$header) {
                echo "<tr>";
                foreach($row as $key => $value) {
                    echo "<th>{$key}</th>";
                }
                echo "</tr>";
                $header = true;
            }
            echo "<tr>";
            foreach($row as $value) {
                echo "<td>{$value}</td>";
            }
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "0 results";
    }
} else {
    // Handle regular SQL queries
    if ($result->num_rows > 0) {
        echo "<table>";
        $header = false;
        while($row = $result->fetch_assoc()) {
            if(!$header) {
                echo "<tr>";
                foreach($row as $key => $value) {
                    echo "<th>{$key}</th>";
                }
                echo "</tr>";
                $header = true;
            }
            echo "<tr>";
            foreach($row as $value) {
                echo "<td>{$value}</td>";
            }
            echo "</tr>";
        }
        echo "</table>";
    } else {
        echo "0 results";
    }
}
?>
    <a href="index.php" class="back-button">Back to Query Selection</a>
</body>
</html>
