CREATE TABLE IF NOT EXISTS airport (
    id int GENERATED ALWAYS AS IDENTITY,
    airport_name varchar(255) UNIQUE NOT NULL,
    country varchar(255) NOT NULL,
    city varchar(255) NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS airlines (
    id int GENERATED ALWAYS AS IDENTITY,
    airlines_name varchar(255) UNIQUE NOT NULL,
    country varchar(255) NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS plane (
    id int GENERATED ALWAYS AS IDENTITY,
    airlines_id int NOT NULL,
    model varchar(255) NOT NULL,
    capacity int NOT NULL,
    status varchar(255) DEFAULT 'Ready',
    acquire_date DATE NOT NULL,
    expiration_date DATE,

    PRIMARY KEY (id),
    FOREIGN KEY (airlines_id) REFERENCES airlines (id),
    CONSTRAINT valid_status CHECK (status = ANY (ARRAY['Ready', 'In Flight', 'Broken', 'Expired']))
);

CREATE TABLE IF NOT EXISTS staff (
    id int GENERATED ALWAYS AS IDENTITY,
    airlines_id int NOT NULL,
    identification_number varchar(11) UNIQUE NOT NULL,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    occupation varchar(255) NOT NULL,
    start_date DATE NOT NULL,
    retirement_date DATE,

    PRIMARY KEY (id),
    FOREIGN KEY (airlines_id) REFERENCES airlines (id),
    CONSTRAINT valid_identification_number CHECK (identification_number ~ '^\d{11}$'),
    CONSTRAINT valid_occupation CHECK (occupation = ANY (ARRAY['Pilot', 'Stewardess']))
);

CREATE TABLE IF NOT EXISTS route (
    id int GENERATED ALWAYS AS IDENTITY,
    plane_id int NOT NULL,
    departure_date DATE NOT NULL,
    departure_airport int NOT NULL, 
    arrival_airport int NOT NULL,
    duration int NOT NULL,
    status varchar(255) DEFAULT 'Scheduled',

    PRIMARY KEY (id),
    FOREIGN KEY (plane_id) REFERENCES plane (id),
    FOREIGN KEY (departure_airport) REFERENCES airport (id),
    FOREIGN KEY (arrival_airport) REFERENCES airport (id),
    CONSTRAINT valid_status CHECK (status = ANY (ARRAY['Scheduled', 'In Flight', 'Ended', 'Cancelled']))
);

CREATE TABLE IF NOT EXISTS crew (
    route_id int NOT NULL,
    staff_id int NOT NULL,

    PRIMARY KEY (route_id, staff_id),
    FOREIGN KEY (route_id) REFERENCES route (id),
    FOREIGN KEY (staff_id) REFERENCES staff (id)
);

CREATE TABLE IF NOT EXISTS passenger (
    id int GENERATED ALWAYS AS IDENTITY,
    identification_number varchar(11) UNIQUE NOT NULL,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    mobile_number varchar(255),
    email varchar(255),

    PRIMARY KEY (id),
    CONSTRAINT valid_identification_number CHECK (identification_number ~ '^\d{11}$'),
    CONSTRAINT valid_mobile_number CHECK (mobile_number ~ '^((8|\+370)(6|5)\d{7})$'),
    CONSTRAINT valid_email CHECK (email ~ '^([a-zA-Z0-9_\-\.]+)@(([a-zA-Z0-9\-]+\.)+)([a-zA-Z]{2,4}|[0-9]{1,3})$')
);

CREATE TABLE IF NOT EXISTS ticket (
    id int GENERATED ALWAYS AS IDENTITY,
    passenger_id int NOT NULL,
    class varchar(255) NOT NULL,
    seat_number int NOT NULL,
    cost float(2) NOT NULL,

    PRIMARY KEY (id),
    FOREIGN KEY (passenger_id) REFERENCES passenger (id)
);

CREATE TABLE IF NOT EXISTS flight (
    route_id int NOT NULL,
    passenger_id int NOT NULL,

    FOREIGN KEY (route_id) REFERENCES route (id),
    FOREIGN KEY (passenger_id) REFERENCES passenger (id)
);

---------- VIEW TABLES

CREATE VIEW passengers_with_tickets
    AS SELECT passenger_id
        FROM ticket
        INNER JOIN passenger AS P
            ON passenger_id = P.id;

CREATE MATERIALIZED VIEW broken_planes
    AS SELECT id
        FROM plane
        WHERE status = 'Broken';

---------- FUNCTIONS

CREATE FUNCTION add_passenger_with_ticket()
    RETURNS TRIGGER 
    LANGUAGE PLPGSQL 
    AS $$
    BEGIN
        IF (SELECT T.passenger_id
            FROM passengers_with_tickets AS T
            WHERE NEW.passenger_id = T.passenger_id) = NEW.passenger_id
        THEN
            RETURN NEW;
        END IF;
        RAISE EXCEPTION 'Passenger does not have a ticket for this flight';
    END;
    $$;

CREATE FUNCTION check_plane_status_is_ready()
    RETURNS TRIGGER 
    LANGUAGE PLPGSQL 
    AS $$
    BEGIN
        IF NEW.status = 'In Flight'
        THEN
            IF (SELECT P.id
                FROM plane AS P
                WHERE NEW.plane_id = P.id AND P.status = 'Ready') = NEW.plane_id
            THEN
                RETURN NEW;
            END IF;
            RAISE EXCEPTION 'Plane is not ready to use';
        END IF;
        RETURN NEW;
    END;
    $$;

CREATE FUNCTION check_route_status_is_scheduled()
    RETURNS TRIGGER 
    LANGUAGE PLPGSQL 
    AS $$
    BEGIN
        IF (SELECT R.id
            FROM route AS R
            WHERE NEW.route_id = R.id AND R.status = 'Scheduled') = NEW.route_id
        THEN
            RETURN NEW;
        END IF;
        RAISE EXCEPTION 'Can only change or add data to scheduled route';
    END;
    $$;

---------- TRIGGERS

CREATE TRIGGER passenger_with_ticket
    BEFORE INSERT OR UPDATE ON flight
    FOR EACH ROW
    EXECUTE FUNCTION add_passenger_with_ticket();

CREATE TRIGGER plane_status
    BEFORE INSERT OR UPDATE OF status ON route
    FOR EACH ROW
    EXECUTE FUNCTION check_plane_status_is_ready();

CREATE TRIGGER route_status
    BEFORE INSERT OR UPDATE ON crew
    FOR EACH ROW
    EXECUTE FUNCTION check_route_status_is_scheduled();

CREATE TRIGGER route_status
    BEFORE INSERT OR UPDATE ON flight
    FOR EACH ROW
    EXECUTE FUNCTION check_route_status_is_scheduled();