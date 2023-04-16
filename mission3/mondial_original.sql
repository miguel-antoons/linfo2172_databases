--
-- File generated with SQLiteStudio v3.4.3 on Wed Apr 12 16:26:41 2023
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Borders
DROP TABLE IF EXISTS Borders;
CREATE TABLE IF NOT EXISTS Borders (
    country1 VARCHAR (4),
    country2 VARCHAR (4),
    length   FLOAT,
    PRIMARY KEY (country1, country2),
    FOREIGN KEY (country1) REFERENCES Country(code),
    FOREIGN KEY (country2) REFERENCES Country(code),
    CONSTRAINT BordersLength CHECK (length >= 0)
);

-- Table: Continent
DROP TABLE IF EXISTS Continent;
CREATE TABLE IF NOT EXISTS Continent (
    name VARCHAR (20),
    area FLOAT (10),
    PRIMARY KEY (name),
    CONSTRAINT ContinentArea CHECK (area >= 0)
);

-- Table: Country
DROP TABLE IF EXISTS Country;
CREATE TABLE IF NOT EXISTS Country (
    code       VARCHAR (4),
    name       VARCHAR (35) NOT NULL UNIQUE,
    capital    VARCHAR (35),
    area       FLOAT,
    population INT,
    PRIMARY KEY (code),
    CONSTRAINT CountryArea CHECK (area >= 0),
    CONSTRAINT CountryPopulation CHECK (population >= 0) 
);

-- Table: Encompasses
DROP TABLE IF EXISTS Encompasses;
CREATE TABLE IF NOT EXISTS Encompasses (
    country    VARCHAR (4),
    continent  VARCHAR (20),
    percentage FLOAT    CHECK ( (percentage > 0) AND 
                                (percentage <= 100) ),
    PRIMARY KEY (country, continent), 
    FOREIGN KEY (country) REFERENCES Country(code),
    FOREIGN KEY (continent) REFERENCES Continent(name)
);

-- Table: EthnicGroup
DROP TABLE IF EXISTS EthnicGroup;
CREATE TABLE IF NOT EXISTS EthnicGroup (
    name       VARCHAR (50),
    country    VARCHAR (4),
    percentage FLOAT,
    PRIMARY KEY (name, country),
    FOREIGN KEY (country) REFERENCES Country(code),
    CONSTRAINT EthnicPercentage CHECK ( (percentage > 0) AND 
                                     (percentage <= 100) ) 
);

-- Table: GeoMountain
DROP TABLE IF EXISTS GeoMountain;
CREATE TABLE IF NOT EXISTS GeoMountain (
    mountain  VARCHAR (35),
    country   VARCHAR (4),
    province  VARCHAR (35),
    PRIMARY KEY (mountain, country, province),
    FOREIGN KEY (mountain) REFERENCES Mountain(name),
    FOREIGN KEY (country) REFERENCES Province(country),
    FOREIGN KEY (province) REFERENCES Province(name)
);

-- Table: Independence
DROP TABLE IF EXISTS Independence;
CREATE TABLE IF NOT EXISTS Independence (
    country         VARCHAR (4),
    Independence    DATE,
    PRIMARY KEY (country),
    FOREIGN KEY (country) REFERENCES Country(code)
);

-- Table: Language
DROP TABLE IF EXISTS Language;
CREATE TABLE IF NOT EXISTS Language (
    name       VARCHAR (50),
    country    VARCHAR (4),
    percentage FLOAT,
    PRIMARY KEY (name, country),
    FOREIGN KEY (country) REFERENCES Country(code),
    CONSTRAINT LanguagePercentage CHECK ( (percentage > 0) AND 
                                       (percentage <= 100) ) 
);

-- Table: Mountain
DROP TABLE IF EXISTS Mountain;
CREATE TABLE IF NOT EXISTS Mountain (
    name      VARCHAR (35),
    mountains VARCHAR (35),
    height    FLOAT,
    PRIMARY KEY (name),
    CONSTRAINT MountainHeight CHECK (height >= 0) 
);

-- Table: Province
DROP TABLE IF EXISTS Province;
CREATE TABLE IF NOT EXISTS Province (
    name       VARCHAR (35),
    country    VARCHAR (4),
    population INT,
    area       FLOAT,
    capital    VARCHAR (35),
    PRIMARY KEY (name, country),
    FOREIGN KEY (country) REFERENCES Country(code),
    CONSTRAINT ProvincePopulation CHECK (population >= 0),
    CONSTRAINT ProvinceArea CHECK (area >= 0) 
);

-- Table: Purchases
DROP TABLE IF EXISTS Purchases;
CREATE TABLE IF NOT EXISTS Purchases (
    id integer PRIMARY KEY,
    time integer NOT NULL,
    province integer NOT NULL,
    product integer NOT NULL,
    qty integer NOT NULL
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
