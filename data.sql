INSERT INTO airport (airport_name, country, city)
VALUES 
    ('Vilnius Airport','Lithuania', 'Vilnius'),
    ('Ryga International','Latvia', 'Ryga'),
    ('Talin Airport','Estonia', 'Talin'),
    ('New York International','USA', 'New York'),
    ('London Airport','United Kingdom', 'London')
RETURNING *;


INSERT INTO airlines (airlines_name, country)
VALUES 
    ('LT Lines','Lithuania'),
    ('Air Europe','Poland'),
    ('American Express','USA'),
    ('Jet Airways','France'),
    ('Kaunas Airway','Lithuania')
RETURNING *;


INSERT INTO plane (airlines_id, model, capacity, status, acquire_date, expiration_date)
VALUES
    (1,'Airbus A380', 540, DEFAULT, '2022-05-21', NULL),
    (2,'Boeing 777', 388, DEFAULT, '1999-05-21', '2012-05-21'),
    (2,'Airbus A320', 170, DEFAULT, '2004-05-21', '2038-05-21'),
    (3,'Boeing 747', 524, 'Broken', '2002-05-21', '2032-05-21'), --
    (5,'Boeing 737', 188, DEFAULT, '1899-05-21', '2021-05-21')
RETURNING *;


INSERT INTO staff (airlines_id, identification_number, first_name, last_name, occupation, start_date, retirement_date)
VALUES 
    (1, '50412300070', 'Testas', 'Testavicius', 'Pilot', '2002-05-12', NULL),
    (2, '50412300071', 'Marius', 'Kublinskas', 'Pilot', '2011-07-01', '2023-04-12'),
    (2, '30812250250', 'Ahmed', 'Halamar', 'Pilot', '2001-09-10', '2023-10-11'),
    (4, '80415807882', 'Vadim', 'Ceremisimov', 'Pilot', '2019-02-03', NULL),
    (5, '24412308892', 'James', 'Tomson', 'Pilot', '1972-08-29', NULL),
    (1, '40409304270', 'Egle', 'Aijauskaite', 'Stewardess', '2002-05-12', '2025-12-05'),
    (1, '25012354570', 'Alma', 'Zinaviciute', 'Stewardess', '2015-09-01', NULL),
    (5, '40412300572', 'Teste', 'Bombinton', 'Stewardess', '1999-12-30', NULL)
RETURNING *;


INSERT INTO route (plane_id, departure_date, departure_airport, arrival_airport, duration, status)
VALUES 
    (1, '2023-02-14', 1, 3, 8, DEFAULT),
    (2, '2023-02-14', 1, 3, 8, DEFAULT),
    (3, '2022-12-24', 2, 4, 3, DEFAULT),
    (5, '2022-12-30', 5, 2, 10, DEFAULT)
RETURNING *;

INSERT INTO crew (route_id, staff_id)
VALUES 
    (1, 1),
    (1, 6),
    (1, 7),
    (2, 2),
    (3, 3),
    (4, 5),
    (4, 8)
RETURNING *;

INSERT INTO passenger (identification_number, first_name, last_name, mobile_number, email)
VALUES 
    ('40412300572', 'Lucas', 'Jim', '+37065207890', NULL),
    ('40404300572', 'Emma', 'Rammy', '854897523', 'test@gmail.com'),
    ('50412250572', 'Tom', 'Hulk', NULL, NULL),
    ('40412328972', 'Marry', 'Momson', '862550789', NULL),
    ('51212304572', 'Luce', 'Timberlake', NULL, 'my.luc@email.com'),
    ('20412308872', 'Wish', 'Jong', '+37051852481','auto@mob.en')
RETURNING *;

INSERT INTO ticket (passenger_id, class, seat_number, cost)
VALUES 
    (1, 'Economy', 1, 400.5),
    (2, 'Business', 2, 540.37),
    (3, 'First', 1, 350.40),
    (4, 'Economy', 2, 150.30),
    (5, 'Economy', 3, 150.30),
    (6, 'Business', 1, 200)
RETURNING *;

INSERT INTO flight (route_id, passenger_id)
VALUES 
    (1, 1),
    (2, 2),
    (2, 3),
    (2, 4),
    (3, 5),
    (4, 6)
RETURNING *;
