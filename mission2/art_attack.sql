CREATE TABLE Piece_of_art (
    pof_id INT NOT NULL default AUTO_INCREMENT,
    creation_date DATE NOT NULL,
    artist_id INT NULL,
    constraint pk_piece_of_art PRIMARY KEY (pof_id),
    constraint fk_artist_id FOREIGN KEY (artist_id) REFERENCES Artist(artist_id)
);

CREATE TABLE Artist (
    artist_id INT NOT NULL default AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    birth_place VARCHAR(50) NOT NULL,
    constraint pk_artist PRIMARY KEY (artist_id)
);

CREATE TABLE Paintings (
    pof_id INT NOT NULL,
    width INT NOT NULL,
    height INT NOT NULL,
    constraint pk_paintings PRIMARY KEY (pof_id),
    constraint fk_pof_id FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id)
);

CREATE TABLE Sculptures (
    pof_id INT NOT NULL,
    width int not null,
    height int not null,
    weight INT NOT NULL,
    constraint pk_sculptures PRIMARY KEY (pof_id),
    constraint fk_pof_id FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id)
);

CREATE TABLE Exhibition (
    ex_id INT NOT NULL default AUTO_INCREMENT,
    begin_date DATE NOT NULL,
    end_date DATE NOT NULL,
    loc_id INT NOT NULL,
    constraint pk_exhibition PRIMARY KEY (ex_id),
    constraint fk_loc_id FOREIGN KEY (loc_id) REFERENCES Location(loc_id)
);

CREATE TABLE Pof_Exhibition (
    pof_id INT NOT NULL,
    ex_id INT NOT NULL,
    constraint pk_pof_exhibition PRIMARY KEY (pof_id, ex_id),
    constraint fk_pof_id FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id),
    constraint fk_ex_id FOREIGN KEY (ex_id) REFERENCES Exhibition(ex_id)
);

CREATE TABLE Location (
    loc_id INT NOT NULL default AUTO_INCREMENT,
    city VARCHAR(50) NOT NULL,
    street VARCHAR(50) NOT NULL,
    number INT NOT NULL,
    constraint pk_location PRIMARY KEY (loc_id),
    constraint uk_location UNIQUE (city, street, number)
);

CREATE TABLE Museum (
    loc_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    opening_hours VARCHAR(50) NOT NULL,
    constraint pk_museum PRIMARY KEY (loc_id),
    constraint fk_loc_id FOREIGN KEY (loc_id) REFERENCES Location(loc_id)
);

create table Storage (
    loc_id INT NOT NULL,
    size INT NOT NULL,
    constraint pk_storage PRIMARY KEY (loc_id),
    constraint fk_loc_id FOREIGN KEY (loc_id) REFERENCES Location(loc_id)
);

CREATE table Collection (
    col_id INT NOT NULL default AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    museum_id INT default NULL,
    constraint pk_collection PRIMARY KEY (col_id),
    constraint fk_museum_id FOREIGN KEY (museum_id) REFERENCES Museum(loc_id)
);

create table Pof_Collection (
    pof_id INT NOT NULL,
    col_id INT NOT NULL,
    constraint pk_pof_collection PRIMARY KEY (pof_id, col_id),
    constraint fk_pof_id FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id),
    constraint fk_col_id FOREIGN KEY (col_id) REFERENCES Collection(col_id)
);

create table Move (
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
