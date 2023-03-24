--
-- File generated with SQLiteStudio v3.4.3 on Mon Mar 20 12:15:13 2023
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: bicycle
DROP TABLE IF EXISTS bicycle;
CREATE TABLE IF NOT EXISTS bicycle(
    bnum integer not null,
    constraint bicycle_pk primary key (bnum),
    constraint fk_bicycle_vehicle foreign key (bnum) references vehicle(num)
);

-- Table: car
DROP TABLE IF EXISTS car;
CREATE TABLE IF NOT EXISTS car(
    cnum integer not null,
    plate_num varchar(20) not null,
    constraint car_pk primary key (cnum),
    constraint fk_car_vehicle foreign key (cnum) references vehicle(num)
);

-- Table: customer
DROP TABLE IF EXISTS customer;
CREATE TABLE IF NOT EXISTS customer(
    cid integer not null default auto_increment,
    first_name varchar(30) not null,
    last_name varchar(30) not null,
    preference integer not null,
    constraint customer_pk primary key (cid),
    constraint customer_unique unique (first_name, last_name),
    constraint fk_customer_vehicle_class foreign key (preference) references vehicle_class(vcid)
);

-- Table: finished_reservation
DROP TABLE IF EXISTS finished_reservation;
CREATE TABLE IF NOT EXISTS finished_reservation(
    resid integer not null,
    distance integer not null,
    cost real not null,
    constraint finished_reservation_pk primary key (resid),
    constraint fk_finished_reservation_reservation foreign key (resid) references reservation(resid)
);

-- Table: reservation
DROP TABLE IF EXISTS reservation;
CREATE TABLE IF NOT EXISTS reservation(
    resid integer not null default auto_increment,
    vnum integer not null,
    cid integer not null,
    start_date_time datetime not null,
    end_date_time datetime not null,
    constraint reservation_pk primary key (resid),
    constraint reservation_unique unique (vnum, start_date_time),
    constraint fk_reservation_vehicle foreign key (vnum) references vehicle(num)
);

-- Table: station
DROP TABLE IF EXISTS station;
CREATE TABLE IF NOT EXISTS station(
    name varchar(30) not null,
    street varchar(50) not null,
    postcode varchar(10) not null,
    city varchar(30) not null,
    constraint station_pk primary key (name),
    constraint station_unique unique (street, postcode, city)
);

-- Table: vehicle
DROP TABLE IF EXISTS vehicle;
CREATE TABLE IF NOT EXISTS vehicle(
    num integer not null,
    sname varchar(30) not null,
    classid integer not null,
    last_check_date date not null,
    constraint vehicle_pk primary key (num),
    constraint fk_vehicle_station foreign key (sname) references station(name),
    constraint fk_vehicle_vehicle_class foreign key (classid) references vehicle_class(vcid)
);

-- Table: vehicle_class
DROP TABLE IF EXISTS vehicle_class;
CREATE TABLE IF NOT EXISTS vehicle_class(
    vcid integer not null default AUTO_INCREMENT,
    vcname varchar(30) not null,
    length integer not null,
    width integer not null,
    height integer not null,
    constraint vehicle_class_pk primary key (vcid),
    constraint vehicle_class_unique unique (vcname)
);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
