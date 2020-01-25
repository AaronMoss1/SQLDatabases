-- Aaron Moss
-- Assignment 3: Physical Database Design
if not exists(select * from sys.databases where name = 'OrdersDB')
    create database ResourceDB
GO
USE ResourceDB
GO
DROP TABLE privilegeDecides
DROP TABLE enrolsIn
DROP TABLE courseOffering
DROP TABLE privilege
DROP TABLE reservation
DROP TABLE loanedResource
DROP TABLE moveableResource
DROP TABLE immovableResource
DROP TABLE Resource
DROP TABLE Category
DROP TABLE Location
DROP TABLE Acquisition
DROP TABLE Phone 
DROP TABLE Staff
DROP TABLE Student
DROP TABLE Member

CREATE TABLE Member (
memberID CHAR(10) PRIMARY KEY,
firstName VARCHAR(15) NOT NULL,
middleName VARCHAR (20),
lastName VARCHAR (20) NOT NULL,
streetNumber INT,
streetName VARCHAR(40),
city VARCHAR(20),
postcode INT,
state VARCHAR(5),
country VARCHAR(15),
email VARCHAR(50),
memberStatus VARCHAR(15) DEFAULT 'Active',
comments VARCHAR(150)
)

CREATE TABLE Student (
memberID CHAR(10) PRIMARY KEY,
penaltyPoints INT DEFAULT 12,
FOREIGN KEY (memberID) REFERENCES Member(memberID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE Staff (
memberID CHAR(10) PRIMARY KEY,
FOREIGN KEY (memberID) REFERENCES Member(memberID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE Phone (
memberID CHAR(10),
phoneNo CHAR(15) UNIQUE,
PRIMARY KEY(memberID, phoneNo),
FOREIGN KEY (memberID) REFERENCES Member(memberID) ON UPDATE CASCADE ON DELETE NO ACTION,
)

CREATE TABLE Acquisition (
acquisitionID CHAR(10) PRIMARY KEY,
memberID CHAR(10),
itemName VARCHAR(50) NOT NULL,
make VARCHAR(100),
manufacturer VARCHAR(100),
model VARCHAR(50),
year int,
description VARCHAR(200),
urgency VARCHAR(25) DEFAULT 'Not Urgent',
status VARCHAR(30) DEFAULT 'Pending',
fundCode CHAR(10) NOT NULL,
vendorCode CHAR(10) NOT NULL,
price INT,
notes VARCHAR(150),
FOREIGN KEY (memberID) REFERENCES Member(memberID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE Location (
locationID CHAR(10) PRIMARY KEY,
room VARCHAR(50) NOT NULL,
building VARCHAR(50) NOT NULL,
campus VARCHAR(50) NOT NULL,
)

CREATE TABLE Category (
categoryID CHAR(10) PRIMARY KEY,
name VARCHAR(50) NOT NULL,
description VARCHAR(150),
maxBorrowTimeDays INT NOT NULL DEFAULT '1'
)

CREATE TABLE Resource (
resourceID CHAR(10) PRIMARY KEY,
categoryID CHAR(10),
locationID CHAR(10),
description VARCHAR(150),
status VARCHAR(50) DEFAULT 'Available',
FOREIGN KEY (categoryID) REFERENCES Category(categoryID)  ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (locationID) REFERENCES location(locationID)  ON UPDATE CASCADE ON DELETE NO ACTION,
)

CREATE TABLE immovableResource (
resourceID CHAR(10) PRIMARY KEY,
capacity INT,
FOREIGN KEY (resourceID) REFERENCES Resource(resourceID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE moveableResource (
resourceID CHAR(10) PRIMARY KEY,
name CHAR(25),
make VARCHAR(50),
manufacturer VARCHAR(50),
model VARCHAR(50),
year INT,
assetValue INT DEFAULT 0,
FOREIGN KEY (resourceID) REFERENCES Resource(resourceID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE loanedResource (
loanID CHAR(10) PRIMARY KEY,
memberID CHAR(10),
resourceID CHAR(10),
dateLoaned DATE,
dueDate DATE,
dateReturned DATE,
FOREIGN KEY (resourceID) REFERENCES Resource(resourceID) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (memberID) REFERENCES Member(memberID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE reservation (
reservationID CHAR(10) PRIMARY KEY,
memberID CHAR(10),
resourceID CHAR(10),
dateRequired DATE NOT NULL,
dateDue DATE,
FOREIGN KEY (memberID) REFERENCES Member(memberID) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (resourceID) REFERENCES Resource(resourceID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE privilege (
privilegeID CHAR(10) PRIMARY KEY,
categoryID CHAR(10),
name VARCHAR(50),
description VARCHAR(150),
maxResourceBorrow INT NOT NULL DEFAULT 0,
FOREIGN KEY (categoryID) REFERENCES Category(categoryID)  ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE courseOffering (
courseID CHAR(10) PRIMARY KEY,
courseName VARCHAR(50) NOT NULL,
semester INT NOT NULL CHECK(semester BETWEEN 1 AND 4),
year INT,
dateStart DATE,
dateEnd DATE
)

CREATE TABLE enrolsIn (
memberID CHAR(10),
courseID CHAR(10),
dateEnrolled DATE,
PRIMARY KEY (memberID, courseID),
FOREIGN KEY (memberID) REFERENCES Student(memberID) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (courseID) REFERENCES courseOffering(courseID) ON UPDATE CASCADE ON DELETE NO ACTION
)

CREATE TABLE privilegeDecides (
courseID CHAR(10),
privilegeID CHAR(10),
PRIMARY KEY(courseID, privilegeID),
FOREIGN KEY (courseID) REFERENCES courseOffering(courseID) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (privilegeID) REFERENCES privilege(privilegeID) ON UPDATE CASCADE ON DELETE NO ACTION
)

--Inserting For The Members Table, A few Nulls and defaults have been placed, defaults are where columns are defined
INSERT INTO Member VALUES ('stu1', 'John', 'Stephen', 'Benson', 3, 'Hill Street', 'Shortland', 2307, 'NSW', 'Australia', NULL, 'Active', 'Frequent User');
INSERT INTO Member (memberID, firstName, middleName, lastName, streetNumber, streetName, city, postcode, state, country, email, comments) VALUES ('stu2', 'Ben', 'Chase', 'Nelson', 7, 'Joan Street', 'Adamstown', 2289, 'NSW', 'Australia', 'itsBen@gmail.com', 'Frequent User');
INSERT INTO Member VALUES ('stu3', 'Steve', NULL, 'Paul', 8, 'Bird Avenue', 'Hamilton', 2303, 'NSW', 'Australia', 'steveP@gmail.com', 'Active', 'Frequent User, Missed a few return dates');
INSERT INTO Member VALUES ('stu4', 'Jack', 'Nathan', 'West', 39, 'Guam Street', 'Jesmond', 2299, 'NSW', 'Australia', 'JNW@outlook.com', 'Active', 'Frequent User, collects resources from one category only');
INSERT INTO Member (memberID, firstName, middleName, lastName, streetNumber, streetName, city, postcode, state, country, email, comments) VALUES ('stu5', 'Sam', 'Simon', 'Johnson', 32, 'Peters Street', 'Adamstown', 2289, 'NSW', 'Australia', 'SamSimon@gmail.com', 'Frequent User');
INSERT INTO Member VALUES ('stu6', 'Rachel', 'Kristy', 'Logan', 96, 'Estonton Street', 'Hamilton', 2303, 'NSW', 'Australia', NULL, 'Active', 'Frequent User, has filed many complaints');
INSERT INTO Member VALUES ('stu7', 'Aaron', NULL, 'Jackson', 25, 'Eastwood Street', 'Shortland', 2307, 'NSW', 'Australia', 'AaronJ45@gmail.com', 'Active', 'Frequent User');
INSERT INTO Member VALUES ('stu8', 'Jayden', 'Ian', 'Stapleton', 30, 'Jackaranda Street', 'Jesmond', 2299, 'NSW', 'Australia', 'jayStapleman56@gmail.com', 'Active', 'Not So Frequent User');
INSERT INTO Member VALUES ('stu9', 'Christopher', 'Tyrell', 'Yielder', 47, 'Outlook Circuit', 'Maryland', 2287, 'NSW', 'Australia', 'Yielder4@gmail.com', 'Active', 'Frequent User, Always returns on time');
INSERT INTO Member VALUES ('stu10', 'Kate', 'Holly', 'North', 90, 'Trast Street', 'Waratah', 2298, 'NSW', 'Australia', NULL, 'Active', 'Frequent User');
INSERT INTO Member (memberID, firstName, middleName, lastName, streetNumber, streetName, city, postcode, state, country, email, comments) VALUES ('stu11', 'Jason', NULL, 'Samson', 43, 'Bell Street', 'Jesmond', 2299, 'NSW', 'Australia', 'Jason34@gmail.com', 'Frequent User');
INSERT INTO Member VALUES ('stu12', 'Paul', 'Ethan', 'Kingston', 12, 'Pomton Street', 'Hamilton', 2303, 'NSW', 'Australia', NULL, 'Active', 'Frequent User, Has damaged a resource before');
INSERT INTO Member VALUES ('stu13', 'Mark', 'Rae', 'Saviton', 58, 'West Road', 'Maryland', 2287, 'NSW', 'Australia', 'marktheman@gmail.com', 'Active', 'Not So Frequent User');
INSERT INTO Member VALUES ('stu14', 'Samantha', 'Jade', 'Rose', 86, 'Newcastle Street', 'Jesmond', 2289, 'NSW', 'Australia', 'sJade123@gmail.com', 'Active', 'Frequent User');
INSERT INTO Member VALUES ('stf1', 'Simon', 'Ramskey', 'Nuller', 3, 'Ralph Street', 'Shortland', 2307, 'NSW', 'Australia', NULL, 'Active', 'Frequent User');
INSERT INTO Member VALUES ('stf2', 'Jeffery', NULL, 'Long', 3, 'Saint Patrick Street', 'Shortland', 2307, 'NSW', 'Australia', 'jeffL@gmail.com', 'Active', 'Frequent User');
INSERT INTO Member (memberID, firstName, middleName, lastName, streetNumber, streetName, city, postcode, state, country, email, comments) VALUES ('stf3', 'Roger', 'Willow', 'Nile', 7, 'Lean Avenue', 'Adamstown', 2289, 'NSW', 'Australia', 'itsRoger@gmail.com', 'Frequent User');
INSERT INTO Member VALUES ('stf4', 'Stephen', NULL, 'Jackman', 85, 'Boworra Avenue', 'Hamilton', 2303, 'NSW', 'Australia', 'TheJackman@gmail.com', 'Active', 'Frequent User, Missed a few return dates');
INSERT INTO Member VALUES ('stf5', 'Jade', NULL, 'East', 71, 'Soldaw Street', 'Jesmond', 2299, 'NSW', 'Australia', 'JadeEast569@outlook.com', 'Active', 'Frequent User, collects resources from one category only');
INSERT INTO Member (memberID, firstName, middleName, lastName, streetNumber, streetName, city, postcode, state, country, email, comments) VALUES ('stf6', 'Ethan', 'Dennis', 'Jalk', 42, 'Polo Street', 'Adamstown', 2289, 'NSW', 'Australia', 'theDennis@gmail.com', 'Frequent User');
INSERT INTO Member VALUES ('stf7', 'Ethel', 'Mandy', 'Ulton', 82, 'Werrabe Street', 'Hamilton', 2303, 'NSW', 'Australia', NULL, 'Active', 'Frequent User, has filed many complaints');
INSERT INTO Member VALUES ('stf8', 'Aaron', 'James', 'Matthews', 11, 'Short Street', 'Shortland', 2307, 'NSW', 'Australia', 'AJM3454@gmail.com', 'Active', 'Frequent User');
INSERT INTO Member VALUES ('stf9', 'Hank', NULL, 'Walter', 45, 'North Street', 'Jesmond', 2299, 'NSW', 'Australia', 'walter6@gmail.com', 'Active', 'Not So Frequent User');
INSERT INTO Member VALUES ('stf10', 'Fred', 'Richard', 'Yonder', 1, 'Hilton Circuit', 'Maryland', 2287, 'NSW', 'Australia', 'YonderF3424@gmail.com', 'Active', 'Frequent User, Always returns on time');

-- Inserting for the students table
INSERT INTO Student (memberID) VALUES ('stu1');
INSERT INTO Student VALUES ('stu2', 9);
INSERT INTO Student VALUES ('stu3', 12);
INSERT INTO Student VALUES ('stu4', 12);
INSERT INTO Student VALUES ('stu5', 12);
INSERT INTO Student VALUES ('stu6', 12);
INSERT INTO Student VALUES ('stu7', 9);
INSERT INTO Student VALUES ('stu8', 12);
INSERT INTO Student (memberID) VALUES ('stu9');
INSERT INTO Student VALUES ('stu10', 12);
INSERT INTO Student (memberID) VALUES ('stu11');
INSERT INTO Student VALUES ('stu12', 3);
INSERT INTO Student VALUES ('stu13', 9);
INSERT INTO Student VALUES ('stu14', 6);

--Inserting for the staff table
INSERT INTO Staff VALUES ('stf1');
INSERT INTO Staff VALUES ('stf2');
INSERT INTO Staff VALUES ('stf3');
INSERT INTO Staff VALUES ('stf4');
INSERT INTO Staff VALUES ('stf5');
INSERT INTO Staff VALUES ('stf6');
INSERT INTO Staff VALUES ('stf7');
INSERT INTO Staff VALUES ('stf8');
INSERT INTO Staff VALUES ('stf9');
INSERT INTO Staff VALUES ('stf10');

--Inserting for the Phone number table for members
INSERT INTO Phone VALUES ('stu1', '+61 432567985');
INSERT INTO Phone VALUES ('stu2', '+61 465121234')
INSERT INTO Phone VALUES ('stu3', '+61 423455568');
INSERT INTO Phone VALUES ('stu4', '+61 467779930');
INSERT INTO Phone VALUES ('stu5', '+61 450601234');
INSERT INTO Phone VALUES ('stu6', '+61 445698539');
INSERT INTO Phone VALUES ('stu7', '+61 406079943');
INSERT INTO Phone VALUES ('stu8', '+61 444231245');
INSERT INTO Phone VALUES ('stu9', '+61 455669813');
INSERT INTO Phone VALUES ('stu10', '+61 432678899');
INSERT INTO Phone VALUES ('stu11', '+61 459342136');
INSERT INTO Phone VALUES ('stu12', '+61 436221321');
INSERT INTO Phone VALUES ('stu13', '+61 488997731');
INSERT INTO Phone VALUES ('stu14', '+6 1444337869');
INSERT INTO Phone VALUES ('stf1', '+61 437263721');
INSERT INTO Phone VALUES ('stf2', '+61 414256723');
INSERT INTO Phone VALUES ('stf3', '+61 456743221');
INSERT INTO Phone VALUES ('stf4', '+61 456776541');
INSERT INTO Phone VALUES ('stf5', '+61 434216675');
INSERT INTO Phone VALUES ('stf6', '+61 478654404');
INSERT INTO Phone VALUES ('stf7', '+61 499876531');
INSERT INTO Phone VALUES ('stf8', '+61 409098761');
INSERT INTO Phone VALUES ('stf9', '+61 476121904');
INSERT INTO Phone VALUES ('stf10', '+61 433298776');

--Insert Data to acquisition 
INSERT INTO Acquisition (acquisitionID, memberID, itemName, make, manufacturer, model, year, description, fundCode,vendorCode, price, notes) VALUES ('acq1', 'stu1', 'Drone', 'DroneZone', 'Drone Crew', 'DVZ100', 2018,'Drone With Camera Attatched', 'f1', 'v1', 195, 'need it for project');
INSERT INTO Acquisition (acquisitionID, memberID, itemName, make, manufacturer, model, year, description, fundCode,vendorCode, price, notes) VALUES ('acq2', 'stf10', 'IT Book', NULL, 'Book Company', '3rd Edition', 2017, 'New IT book as the old is slightly out of date', 'f3', 'v3', 220, 'needed for classroom');
INSERT INTO Acquisition VALUES ('acq3', 'stu12', 'Networks DVD', NULL, 'Educational movies', NULL, 2018, 'New video explaining fundamental topics about networks', 'Very Urgent', 'Pending', 'f5', 'v5', 15, NULL);

--Insert Data to Location
INSERT INTO Location VALUES ('l1', 'r.378', 'East Building', 'Callaghan');
INSERT INTO Location VALUES ('l2', 'r.195', 'North Building', 'Callaghan');
INSERT INTO Location VALUES ('l3', 'r.231', 'East Building', 'Callaghan');
INSERT INTO Location VALUES ('l4', 'r.113', 'West Building', 'Callaghan');
INSERT INTO Location VALUES ('l5', 'r.567', 'South Building', 'Callaghan');
INSERT INTO Location VALUES ('l6', 'r.79', 'North Building', 'Callaghan');

--Insert Data to category table
INSERT INTO Category VALUES ('cat1', 'Microphones', 'Microphones that can be borrowed for use in the system, very good sound quality', 3);
INSERT INTO Category VALUES ('cat2', 'Speakers', 'Speakers that can be borrowed in the system, good sound output', 5);
INSERT INTO Category VALUES ('cat3', 'Books', 'Variety of books that can be borrowed by members', 2);
INSERT INTO Category VALUES ('cat4', 'Camera', 'Cameras that can be used for various projects, good quality images can be imported straight to pc', 8);
INSERT INTO Category VALUES ('cat5', 'Rooms', 'Rooms that can be hired out by a member', 4);

--Insert Data to resource table
INSERT INTO Resource (resourceID, categoryID, locationID, description) VALUES ('res1', 'cat4', 'l3', 'camera to be borrowed by members');
INSERT INTO Resource VALUES ('res2', 'cat4', 'l3', 'camera to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res3', 'cat4', 'l3', 'camera to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res4', 'cat4', 'l3', 'camera to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res5', 'cat4', 'l3', 'camera to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res6', 'cat4', 'l3', 'camera to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res7', 'cat4', 'l3', 'camera to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res8', 'cat4', 'l3', 'camera to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res9', 'cat2', 'l1', 'speakers to be borrowed by members', 'In Use');
INSERT INTO Resource VALUES ('res10', 'cat2', 'l1', 'speakers to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res11', 'cat2', 'l1', 'speakers to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res12', 'cat3', 'l2', 'Books to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res13', 'cat3', 'l2', 'Books to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res14', 'cat1', 'l4', 'Microphone to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res15', 'cat1', 'l4', 'Microphone to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res16', 'cat1', 'l4', 'Microphone to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res17', 'cat1', 'l4', 'Microphone to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res18', 'cat5', 'l6', 'Room to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res19', 'cat5', 'l3', 'Room to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res20', 'cat5', 'l6', 'Room to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res21', 'cat5', 'l2', 'Room to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res22', 'cat5', 'l1', 'Room to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res23', 'cat5', 'l5', 'Room to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res24', 'cat5', 'l4', 'Room to be borrowed by members', 'Available');
INSERT INTO Resource VALUES ('res25', 'cat5', 'l2', 'Room to be borrowed by members', 'Available');

--Insert Data for immovable
INSERT INTO immovableResource VALUES ('res18', 30);
INSERT INTO immovableResource VALUES ('res19', 10);
INSERT INTO immovableResource VALUES ('res20', 15);
INSERT INTO immovableResource VALUES ('res21', 20);
INSERT INTO immovableResource VALUES ('res22', 40);
INSERT INTO immovableResource VALUES ('res23', 30);
INSERT INTO immovableResource VALUES ('res24', 30);
INSERT INTO immovableResource VALUES ('res25', 30);

--Insert Data for moveable
INSERT INTO moveableResource VALUES ('res1', 'camera1', 'camMake1', 'camMakers', 'camModel1', 2018, 40);
INSERT INTO moveableResource VALUES ('res2', 'camera2', 'camMake2', 'camMakers', 'camModel2', 2018, 70);
INSERT INTO moveableResource VALUES ('res3', 'camera3', 'camMake3', 'camMakers', 'camModel3', 2018, 90);
INSERT INTO moveableResource VALUES ('res4', 'camera4', 'camMake4', 'camMakers', 'camModel4', 2018, 23);
INSERT INTO moveableResource VALUES ('res5', 'camera5', 'camMake5', 'camMakers', 'camModel5', 2018, 34);
INSERT INTO moveableResource VALUES ('res6', 'camera6', 'camMake6', 'camMakers', 'camModel6', 2018, 56);
INSERT INTO moveableResource VALUES ('res7', 'camera7', 'camMake7', 'camMakers', 'camModel7', 2018, 46);
INSERT INTO moveableResource VALUES ('res8', 'camera8', 'camMake8', 'camMakers', 'camModel8', 2018, 30);
INSERT INTO moveableResource VALUES ('res9', 'speaker1', 'speakerMake1', 'speakerMakers', 'speakerModel1', 2018, 130);
INSERT INTO moveableResource VALUES ('res10', 'speaker2', 'speakerMake2', 'speakerMakers', 'speakerModel2', 2018, 350);
INSERT INTO moveableResource VALUES ('res11', 'speaker3', 'speakerMake3', 'speakerMakers', 'speakerModel3', 2018, 190);
INSERT INTO moveableResource VALUES ('res12', 'book1', 'bookMake1', 'bookMakers', 'bookModel1', 2018, 10);
INSERT INTO moveableResource VALUES ('res13', 'book2', 'bookMake2', 'bookMakers', 'bookModel2', 2018, 15);
INSERT INTO moveableResource VALUES ('res14', 'mic1', 'micMake1', 'micMakers', 'micModel1', 2018, 40);
INSERT INTO moveableResource VALUES ('res15', 'mic2', 'micMake2', 'micMakers', 'micModel2', 2018, 30);
INSERT INTO moveableResource VALUES ('res16', 'mic3', 'micMake3', 'micMakers', 'micModel3', 2018, 60);
INSERT INTO moveableResource VALUES ('res17', 'mic4', 'micMake4', 'micMakers', 'micModel4', 2018, 90);

--Insert Data For Loaned Resource
INSERT INTO loanedResource VALUES ('loan1', 'stu2', 'res2', '2018-10-19', '2018-10-30', '2018-10-31');
INSERT INTO loanedResource VALUES ('loan2', 'stu3', 'res9', '2018-10-30', '2018-11-2', NULL);
INSERT INTO loanedResource VALUES ('loan3', 'stu8', 'res5', '2018-10-9', '2018-10-14', '2018-10-14');
INSERT INTO loanedResource VALUES ('loan4', 'stu7', 'res16', '2018-10-9', '2018-10-29', '2018-10-30');
INSERT INTO loanedResource VALUES ('loan5', 'stu5', 'res5', '2018-10-15', '2018-10-30', '2018-10-30');

--Insert Data for Reservations table
--INSERT INTO reservation (reservationID, memberID, resourceID, dateRequired, dateDue)
INSERT INTO reservation VALUES ('rsv1', 'stu4', 'res12', '2018-11-10', '2018-11-11');
INSERT INTO reservation VALUES ('rsv2', 'stu10', 'res9', '2018-11-4', '2018-11-8');
INSERT INTO reservation VALUES ('rsv3', 'stu5', 'res19', '2018-5-1', '2018-11-11');
INSERT INTO reservation VALUES ('rsv4', 'stu9', 'res19', '2018-5-1', '2018-11-11');
INSERT INTO reservation VALUES ('rsv5', 'stu11', 'res19', '2018-5-1', '2018-11-11');
INSERT INTO reservation VALUES ('rsv6', 'stu12', 'res19', '2018-6-5', '2018-11-11');
INSERT INTO reservation VALUES ('rsv7', 'stu7', 'res19', '2018-6-5', '2018-11-11');
INSERT INTO reservation VALUES ('rsv8', 'stf4', 'res19', '2018-6-5', '2018-11-11');
INSERT INTO reservation VALUES ('rsv9', 'stf2', 'res19', '2018-6-5', '2018-11-11');
INSERT INTO reservation VALUES ('rsv10', 'stu1', 'res19', '2018-8-19', '2018-11-11');
INSERT INTO reservation VALUES ('rsv11', 'stf8', 'res19', '2018-8-19', '2018-11-11');
INSERT INTO reservation VALUES ('rsv12', 'stu13', 'res19', '2018-8-19', '2018-11-11');

--Insert Data for Privilege table
INSERT INTO privilege VALUES ('priv1', 'cat1', 'microphone privileges', 'privileges granted for the microphone category', 5);
INSERT INTO privilege VALUES ('priv2', 'cat2', 'speaker privileges', 'privileges granted for the speaker category', 1);
INSERT INTO privilege VALUES ('priv3', 'cat3', 'books privileges', 'privileges granted for the book category', 10);
INSERT INTO privilege VALUES ('priv4', 'cat4', 'camera privileges', 'privileges granted for the microphone category', 2);
INSERT INTO privilege VALUES ('priv5', 'cat5', 'room privileges', 'privileges granted for the room category', 1);

--Insert Data for courses
INSERT INTO courseOffering VALUES ('c1', 'intro to programming', 1, 2018, '2018-2-1', '2018-11-29');
INSERT INTO courseOffering VALUES ('c2', 'data structures', 1, 2018, '2018-2-1', '2018-11-29');
INSERT INTO courseOffering VALUES ('c3', 'databases', 1, 2018, '2018-2-1', '2018-11-29');
INSERT INTO courseOffering VALUES ('c4', 'web design', 2, 2018, '2018-6-2', '2018-11-29');
INSERT INTO courseOffering VALUES ('c5', 'web engineering', 1, 2018, '2018-2-1', '2018-11-29');

--Insert Data for students enrolling in courses
INSERT INTO enrolsIn VALUES ('stu1', 'c1', '2018-1-30');
INSERT INTO enrolsIn VALUES ('stu2', 'c3', '2018-1-28');
INSERT INTO enrolsIn VALUES ('stu3', 'c3', '2018-1-2');
INSERT INTO enrolsIn VALUES ('stu4', 'c2', '2018-1-26');
INSERT INTO enrolsIn VALUES ('stu5', 'c4', '2018-5-21');
INSERT INTO enrolsIn VALUES ('stu6', 'c2', '2018-1-28');
INSERT INTO enrolsIn VALUES ('stu7', 'c5', '2018-1-19');
INSERT INTO enrolsIn VALUES ('stu8', 'c5', '2018-1-16');
INSERT INTO enrolsIn VALUES ('stu9', 'c4', '2018-5-24');
INSERT INTO enrolsIn VALUES ('stu10', 'c1', '2018-1-21');
INSERT INTO enrolsIn VALUES ('stu11', 'c4', '2018-5-22');
INSERT INTO enrolsIn VALUES ('stu12', 'c5', '2018-1-29');
INSERT INTO enrolsIn VALUES ('stu13', 'c2', '2018-1-30');
INSERT INTO enrolsIn VALUES ('stu14', 'c1', '2018-1-30');

--Insert Data for privilege decides
INSERT INTO privilegeDecides VALUES ('c1', 'priv1');
INSERT INTO privilegeDecides VALUES ('c2', 'priv2');
INSERT INTO privilegeDecides VALUES ('c3', 'priv3');
INSERT INTO privilegeDecides VALUES ('c4', 'priv4');
INSERT INTO privilegeDecides VALUES ('c5', 'priv5');


--Q1: For a staff member with id number xxx, print his/her name and phone number.
SELECT memberID, phoneNo
FROM Phone
WHERE memberID = 'stf5'

--Q2: Print the name of student(s) who has/have enrolled in the course with course id xxx.
SELECT m.firstName, m.lastName
FROM enrolsIn e, Member m
WHERE m.memberID = e.memberID AND e.courseID = 'c1'

--Q3: Print the name(s) of the student member(s) who has/have borrowed the category with the name of camera, of which the
--model is xxx, in this year. Note: camera is a category, and model attribute must be in movable table.
SELECT m.firstName, m.lastName
FROM Member m, loanedResource l, Resource r, moveableResource mov, Student s
WHERE m.memberID = s.memberID AND l.memberID = m.memberID AND l.resourceID = r.resourceID AND l.resourceID = mov.resourceID
AND r.categoryID = 'cat4' AND mov.model = 'camModel2' AND mov.year = 2018

--Q4: Find the moveable resource that is the mostly loaned in current month. Print the resource id and resource name.
SELECT m.resourceID, m.name
FROM moveableResource m, loanedResource l
WHERE l.resourceID = m.resourceID AND l.dateLoaned BETWEEN '2018-10-1' AND '2018-10-31'
GROUP BY m.resourceID, m.name 
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM loanedResource l, moveableResource m WHERE l.resourceID = m.resourceID GROUP BY l.resourceID)


--Q5: For each of the three days, including May 1, 2018, June 5, 2018 and August 19, 2018, print the date, the name of the room 
--with name xxx, and the total number of reservations made for the room on each day.
SELECT DISTINCT r.dateRequired, l.room, COUNT(*) AS reservationCount
FROM reservation r, Location l, Resource re
WHERE r.resourceID = re.resourceID AND re.locationID = l.locationID AND l.room = 'r.231' AND r.dateRequired = '2018-8-19'
GROUP BY r.dateRequired, l.room
UNION ALL
SELECT DISTINCT r.dateRequired, l.room, COUNT(*) AS reservationCount
FROM reservation r, Location l, Resource re
WHERE r.resourceID = re.resourceID AND re.locationID = l.locationID AND l.room = 'r.231' AND r.dateRequired = '2018-5-1'
GROUP BY r.dateRequired, l.room
UNION ALL 
SELECT DISTINCT r.dateRequired, l.room, COUNT(*) AS reservationCount
FROM reservation r, Location l, Resource re
WHERE r.resourceID = re.resourceID AND re.locationID = l.locationID AND l.room = 'r.231' AND r.dateRequired = '2018-6-5'
GROUP BY r.dateRequired, l.room
