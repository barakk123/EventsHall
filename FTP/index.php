<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css\styles.css">
    <script>
        function showInputFields() {
            var query = document.getElementById("query").value;
            var weeksInput = document.getElementById("weeks-input");
            var monthsInput = document.getElementById("months-input");

            // Hide all input fields initially
            weeksInput.style.display = "none";
            monthsInput.style.display = "none";

            // Reset input fields
            document.getElementById("weeks").value = "";
            document.getElementById("months").value = "";

            // Show the relevant input field based on the selected query
            switch(query) {
                case "1":
                    weeksInput.style.display = "block";
                    break;
                case "5":
                    monthsInput.style.display = "block";
                    break;
                default:
                    weeksInput.style.display = "none";
                    monthsInput.style.display = "none";
            }
        }
</script>

</head>
<body onload="showInputFields()">
    <form action="execute_query.php" method="post">
        <label for="query">Choose a query:</label>
        <select id="query" name="query" onchange="showInputFields()">
            <option value="1">Show all events in the last X weeks</option>
            <option value="2">Show active events and the customer who ordered them</option>
            <option value="3">Show events that lack waiters and cooks</option>
            <option value="4">Show customers who have more than one order</option>
            <option value="5">Show income from the last X months</option>
        </select>
        <div id="weeks-input" style="display: none;">
            <label for="weeks">Weeks:</label>
            <input type="number" id="weeks" name="weeks" min="1">
        </div>
        <div id="months-input" style="display: none;">
            <label for="months">Months:</label>
            <input type="number" id="months" name="months" min="1">
        </div>

        <input type="submit" value="Submit" id="submit">
    </form>
</body>
</html>
