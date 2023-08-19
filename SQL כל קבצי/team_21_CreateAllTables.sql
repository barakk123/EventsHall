CREATE TABLE dbCourseSt23.team_21_Event (
  id INT PRIMARY KEY AUTO_INCREMENT,
  eventType VARCHAR(255),
  eventDate DATE,
  numberOfGuests INT,
  minimumPrice DECIMAL(10, 2),
  pricePerDish DECIMAL(10, 2),
  numberOfWaitersRequired INT,
  numberOfCooksRequired INT
);

CREATE TABLE dbCourseSt23.team_21_Customer (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  phone VARCHAR(255),
  address VARCHAR(255)
);

CREATE TABLE dbCourseSt23.team_21_Employee (
  id INT PRIMARY KEY,
  role ENUM('Waiter', 'Cook', 'Sales'),
  name VARCHAR(255),
  address VARCHAR(255),
  phone VARCHAR(255)
);

CREATE TABLE dbCourseSt23.team_21_Order (
  id INT PRIMARY KEY AUTO_INCREMENT,
  customerId INT,
  salespersonId INT,
  eventId INT UNIQUE,
  eventPrice DECIMAL(10, 2),
  FOREIGN KEY (customerId) REFERENCES dbCourseSt23.team_21_Customer(id),
  FOREIGN KEY (salespersonId) REFERENCES dbCourseSt23.team_21_Employee(id),
  FOREIGN KEY (eventId) REFERENCES dbCourseSt23.team_21_Event(id)
);

CREATE TABLE dbCourseSt23.team_21_EventEmployee (
  eventId INT,
  employeeId INT,
  PRIMARY KEY (eventId, employeeId),
  FOREIGN KEY (eventId) REFERENCES dbCourseSt23.team_21_Event(id),
  FOREIGN KEY (employeeId) REFERENCES dbCourseSt23.team_21_Employee(id)
);

