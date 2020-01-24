-- Database that creates tables to store data for an online store
-- Drops all tables before creating new ones to avoid compiling errors
DROP TABLE OrderDetails
DROP TABLE Orders
DROP TABLE Admin
DROP TABLE Customer
DROP TABLE Products
DROP TABLE Category

--cateogry table to store the different types of categories a product can have 
CREATE TABLE Category (
CategoryID INT IDENTITY(1,1) PRIMARY KEY, -- the identity tag creates an ID starting from 1, and then going up by one for each new creation 
Name VARCHAR(30) NOT NULL,
Description TEXT
)

-- Products table to store products that will be available on the site
CREATE TABLE Products (
ProductID INT PRIMARY KEY IDENTITY(1,1),
CategoryID INT, -- category fk to show what category the product belongs to 
Name VARCHAR(30) NOT NULL,
Type VARCHAR(20) NOT NULL,
Platform VARCHAR(40) NOT NULL,
AmountAvailable INT NOT NULL DEFAULT 0,
Price INT NOT NULL DEFAULT 0, -- setting default amounts of price and amount available to 0
Description TEXT,
ImageFile VARCHAR(300),
FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID) ON UPDATE CASCADE ON DELETE NO ACTION,
)

CREATE TABLE Customer (
UserID INT PRIMARY KEY IDENTITY(1,1),
FirstName VARCHAR(30) NOT NULL,
MiddleName VARCHAR(30),
LastName VARCHAR(35),
StreetNo VARCHAR(8),
Street VARCHAR(30),
Suburb VARCHAR(40),
Postcode VARCHAR(10),
State VARCHAR(5),
Country VARCHAR(30),
Status VARCHAR(20) NOT NULL DEFAULT 'Active',
Email VARCHAR(255) NOT NULL UNIQUE,
Phone VARCHAR(30),
DateJoined DATE NOT NULL DEFAULT GETDATE(),
CHECK (Status IN ('Active', 'Suspended')) -- checking to make sure the status is either active or suspended 
)

CREATE TABLE Admin ( --stores details of who the admins are on the site
UserID INT IDENTITY(1,1) PRIMARY KEY,
AdminNo CHAR(5) Unique NOT NULL, -- a number given to an admin before registration so they are able to validate their admin status
FirstName VARCHAR(30),
MiddleName VARCHAR(30),
LastName VARCHAR(35),
Email VARCHAR(30),
Phone VARCHAR(30),	
)

CREATE TABLE Orders ( --stores orders made by users in the database
OrderID INT IDENTITY(1,1) PRIMARY KEY, 
UserID INT,
OrderStatus VARCHAR(15) NOT NULL DEFAULT 'Not Shipped',
PayStatus VARCHAR(10) NOT NULL DEFAULT 'Unpaid',
Total INT NOT NULL,
FOREIGN KEY (userID) REFERENCES Customer(UserID) ON UPDATE CASCADE ON DELETE NO ACTION, --originally had payment ID as a FK, but decided to put it on user so admin can just refer to user to get payment details
CHECK (OrderStatus IN ('Not Shipped', 'Shipped')),
CHECK (PayStatus IN ('Unpaid', 'Paid')), --checks to validate input
)

--stores the order id and what products were purchased in that order, has orderID and ProductID as FK to be able to store an order with multiple products
-- middle man to break up the many-to-many relationship of the orders to products
CREATE TABLE OrderDetails (
OrderID INT,
ProductID INT,
Quantity INT DEFAULT 0,
DateOrdered DATE NOT NULL,
OrderTotal INT DEFAULT 0 NOT NULL,
ShippingAdress VARCHAR(200) NOT NULL,
PRIMARY KEY (OrderID, ProductID),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON UPDATE CASCADE ON DELETE NO ACTION
)
