create table station(
    name varchar(30) not null,
    street varchar(50) not null,
    postcode varchar(10) not null,
    city varchar(30) not null,
    constraint station_pk primary key (name),
    constraint station_unique unique (street, postcode, city)
);

create table vehicle_class(
    vcid integer not null default auto_increment,
    vcname varchar(30) not null,
    length integer not null,
    width integer not null,
    height integer not null,
    constraint vehicle_class_pk primary key (vcid),
    constraint vehicle_class_unique unique (vcname)
);

create table customer(
    cid integer not null default auto_increment,
    first_name varchar(30) not null,
    last_name varchar(30) not null,
    preference integer not null,
    constraint customer_pk primary key (cid),
    constraint customer_unique unique (first_name, last_name),
    constraint fk_customer_vehicle_class foreign key (preference) references vehicle_class(vcid)
);

create table vehicle(
    num integer not null,
    sname varchar(30) not null,
    classid integer not null,
    last_check_date date not null,
    constraint vehicle_pk primary key (num),
    constraint fk_vehicle_station foreign key (sname) references station(name),
    constraint fk_vehicle_vehicle_class foreign key (classid) references vehicle_class(vcid)
);

create table car(
    cnum integer not null,
    plate_num varchar(20) not null,
    constraint car_pk primary key (cnum),
    constraint fk_car_vehicle foreign key (cnum) references vehicle(num)
);

create table bicycle(
    bnum integer not null,
    constraint bicycle_pk primary key (bnum),
    constraint fk_bicycle_vehicle foreign key (bnum) references vehicle(num)
);

create table reservation(
    resid integer not null default auto_increment,
    vnum integer not null,
    cid integer not null,
    start_date_time datetime not null,
    end_date_time datetime not null,
    constraint reservation_pk primary key (resid),
    constraint reservation_unique unique (vnum, start_date_time),
    constraint fk_reservation_vehicle foreign key (vnum) references vehicle(num)
);

create table finished_reservation(
    resid integer not null,
    distance integer not null,
    cost real not null,
    constraint finished_reservation_pk primary key (resid),
    constraint fk_finished_reservation_reservation foreign key (resid) references reservation(resid)
);
