CREATE DATABASE SampleTooysGroup;
USE SampleTooysGroup;

#creo le tabelle dimensionali secondo le entità di riferimento
CREATE TABLE Categories(
	CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR (20)
);

CREATE TABLE Products(
	ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR (40) NOT NULL,
    CategoryID INT,
    Price DECIMAL (7,2),
    
CONSTRAINT FK_Products_Category
	FOREIGN KEY (CategoryID)
    REFERENCES Categories(CategoryID)
);


CREATE TABLE SalesRegion(
	RegionID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR (30)
);
    
CREATE TABLE Countries(
	CountryID INT AUTO_INCREMENT PRIMARY KEY,
    Country VARCHAR (30),
    RegionID INT,
    
CONSTRAINT FK_Countries_SalesRegion
	FOREIGN KEY (RegionID)
    REFERENCES SalesRegion(RegionID)
);

#creo la tabella delle vendite
CREATE TABLE Sales(
	SalesID INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE NOT NULL,
    ProductID INT,
    CountryID INT,
    Quantity INT NOT NULL,
    
CONSTRAINT FK_Sales_Product
	FOREIGN KEY (ProductID)
    REFERENCES Products(ProductID),
    
CONSTRAINT FK_Sales_Countries
	FOREIGN KEY (CountryID)
    REFERENCES Countries(CountryID)
);