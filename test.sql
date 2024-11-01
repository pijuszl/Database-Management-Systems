SELECT * FROM passenger;

INSERT INTO passenger (identification_number, first_name, last_name, mobile_number, email)
VALUES 
    ('37712300572', 'Test', 'Bebilietis', NULL, NULL);

SELECT * FROM passenger;

SELECT * FROM flight;

INSERT INTO flight (route_id, passenger_id)
VALUES (2, 7);



SELECT * FROM route;

UPDATE route SET status = 'In Flight'
    WHERE id = 2;

INSERT INTO staff (airlines_id, identification_number, first_name, last_name, occupation, start_date, retirement_date)
VALUES 
    (2, '40412310270', 'Testas', 'Testavicius', 'Stewardess', '2010-10-10', NULL);

INSERT INTO crew (route_id, staff_id)
VALUES (2, 8);

SELECT plane_id, route.id AS 'route_id' FROM plane
JOIN route
    ON plane.id = route.plane_id;

UPDATE plane SET status = 'Broken'
    WHERE id = 1;

UPDATE route SET status = 'In Flight'
    WHERE id = 1;
