<?php
$dbhost = "148.66.138.145";
$dbuser = "dbCourseSt23a";
$dbpass = "dbcourseShUsr23!";
$dbname = "dbCourseSt23";

// Create connection
$conn = new mysqli($dbhost, $dbuser, $dbpass, $dbname);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
?>
