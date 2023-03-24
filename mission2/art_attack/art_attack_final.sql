--
-- File generated with SQLiteStudio v3.4.3 on Fri Mar 24 13:01:38 2023
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Artist
DROP TABLE IF EXISTS Artist;
CREATE TABLE IF NOT EXISTS Artist (
    artist_id INT NOT NULL default AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    birth_place VARCHAR(50) NOT NULL,
    constraint pk_artist PRIMARY KEY (artist_id)
);

-- Table: Collection
DROP TABLE IF EXISTS Collection;
CREATE TABLE IF NOT EXISTS Collection (
    col_id INT NOT NULL default AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    museum_id INT default NULL,
    constraint pk_collection PRIMARY KEY (col_id),
    constraint fk_museum_id FOREIGN KEY (museum_id) REFERENCES Museum(loc_id)
);

-- Table: Exhibition
DROP TABLE IF EXISTS Exhibition;
CREATE TABLE IF NOT EXISTS Exhibition (
    ex_id INT NOT NULL default AUTO_INCREMENT,
    begin_date DATE NOT NULL,
    end_date DATE NOT NULL,
    loc_id INT NOT NULL,
    constraint pk_exhibition PRIMARY KEY (ex_id),
    constraint fk_loc_id FOREIGN KEY (loc_id) REFERENCES Location(loc_id)
);

-- Table: Location
DROP TABLE IF EXISTS Location;
CREATE TABLE IF NOT EXISTS Location (
    loc_id INT NOT NULL default AUTO_INCREMENT,
    city VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    number INT NOT NULL,
    constraint pk_location PRIMARY KEY (loc_id),
    constraint uk_location UNIQUE (city, street, number)
);

-- Table: Move
DROP TABLE IF EXISTS Move;
CREATE TABLE IF NOT EXISTS Move (
    move_id int not null default auto_increment,
    pof_id int not null,
    target_loc_id int not null,
    year int not null,
    day int not null,
    constraint pk_move primary key (move_id),
    constraint fk_pof_id foreign key (pof_id) references Piece_of_art(pof_id),
    constraint fk_target_loc_id foreign key (target_loc_id) references Location(loc_id)
    constraint ck_day check (day >= 1 and day <= 366),
    constraint uk_pof_id_year_day unique (pof_id, year, day)
);

-- Table: Museum
DROP TABLE IF EXISTS Museum;
CREATE TABLE IF NOT EXISTS Museum (
    loc_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    opening_hours VARCHAR(50) NOT NULL,
    constraint pk_museum PRIMARY KEY (loc_id),
    constraint fk_loc_id FOREIGN KEY (loc_id) REFERENCES Location(loc_id)
);

-- Table: Paintings
DROP TABLE IF EXISTS Paintings;
CREATE TABLE IF NOT EXISTS Paintings (
    pof_id INT NOT NULL,
    width INT NOT NULL,
    height INT NOT NULL,
    constraint pk_paintings PRIMARY KEY (pof_id),
    constraint fk_pof_id FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id)
);

-- Table: Piece_of_art
DROP TABLE IF EXISTS Piece_of_art;
CREATE TABLE IF NOT EXISTS Piece_of_art (
    pof_id INT NOT NULL default AUTO_INCREMENT,
    creation_date DATE NOT NULL,
    name VARCHAR(50) NOT NULL,
    constraint pk_piece_of_art PRIMARY KEY (pof_id)
);

-- Table: Pof_Artist
DROP TABLE IF EXISTS Pof_Artist;
CREATE TABLE IF NOT EXISTS Pof_Artist (
    pof_id INT NOT NULL,
    artist_id INT NOT NULL,
    constraint pk_pof_artist PRIMARY KEY (pof_id, artist_id),
    constraint fk_pof_id FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id),
    constraint fk_artist_id FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
);

-- Table: Pof_Collection
DROP TABLE IF EXISTS Pof_Collection;
CREATE TABLE IF NOT EXISTS Pof_Collection (
    pof_id INT NOT NULL,
    col_id INT NOT NULL,
    constraint pk_pof_collection PRIMARY KEY (pof_id, col_id),
    constraint fk_pof_id FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id),
    constraint fk_col_id FOREIGN KEY (col_id) REFERENCES Collection(col_id)
);

-- Table: Pof_Exhibition
DROP TABLE IF EXISTS Pof_Exhibition;
CREATE TABLE IF NOT EXISTS Pof_Exhibition (
    pof_id INT NOT NULL,
    ex_id INT NOT NULL,
    constraint pk_pof_exhibition PRIMARY KEY (pof_id, ex_id),
    constraint fk_pof_id FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id),
    constraint fk_ex_id FOREIGN KEY (ex_id) REFERENCES Exhibition(ex_id)
);

-- Table: Sculptures
DROP TABLE IF EXISTS Sculptures;
CREATE TABLE IF NOT EXISTS Sculptures (
    pof_id INT NOT NULL,
    width int not null,
    height int not null,
    weight INT NOT NULL,
    constraint pk_sculptures PRIMARY KEY (pof_id),
    constraint fk_pof_id FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id)
);

-- Table: Storage
DROP TABLE IF EXISTS Storage;
CREATE TABLE IF NOT EXISTS Storage (
    loc_id INT NOT NULL,
    size INT NOT NULL,
    constraint pk_storage PRIMARY KEY (loc_id),
    constraint fk_loc_id FOREIGN KEY (loc_id) REFERENCES Location(loc_id)
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
