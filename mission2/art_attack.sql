

CREATE TABLE Piece_of_art (
    pof_id INT NOT NULL AUTO_INCREMENT,
    creation_date DATE NOT NULL,
    artist_id INT NULL,
    constraint pk_piece_of_art PRIMARY KEY (pof_id),
    constraint fk_artist_id FOREIGN KEY (artist_id) REFERENCES Artist(artist_id),
);

CREATE TABLE Artist (
    artist_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    birth_place VARCHAR(50) NOT NULL,
    constraint pk_artist PRIMARY KEY (artist_id)
);

CREATE TABLE Exhibition (
    ex_id INT NOT NULL AUTO_INCREMENT,
    begin_date DATE NOT NULL,
    end_date DATE NOT NULL,
    constraint pk_exhibition PRIMARY KEY (ex_id),
    constraint fk_piece_of_art FOREIGN KEY (pof_id) REFERENCES Piece_of_art(pof_id),
);

CREATE 