DROP TRIGGER IF EXISTS route_status ON flight CASCADE;
DROP TRIGGER IF EXISTS route_status ON crew CASCADE;
DROP TRIGGER IF EXISTS plane_status ON route CASCADE;
DROP TRIGGER IF EXISTS passenger_with_ticket ON flight CASCADE;
DROP FUNCTION IF EXISTS check_route_status_is_scheduled() CASCADE;
DROP FUNCTION IF EXISTS check_plane_status_is_ready() CASCADE;
DROP FUNCTION IF EXISTS add_passenger_with_ticket() CASCADE;
DROP VIEW IF EXISTS passengers_with_tickets CASCADE;
DROP TABLE IF EXISTS Flight CASCADE;
DROP TABLE IF EXISTS Ticket CASCADE;
DROP TABLE IF EXISTS Passenger CASCADE;
DROP TABLE IF EXISTS Crew CASCADE;
DROP TABLE IF EXISTS Route CASCADE;
DROP TABLE IF EXISTS Staff CASCADE;
DROP TABLE IF EXISTS Plane CASCADE;
DROP TABLE IF EXISTS Airlines CASCADE;
DROP TABLE IF EXISTS Airport CASCADE;