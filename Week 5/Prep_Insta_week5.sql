use detective;
describe crime_scene_report;

#Retrieve Crime Scene Report 
SELECT description FROM crime_scene_report
WHERE date = '20180115' AND type = 'murder' AND city = 'SQL City'

# View Witness Interviews
With wit1 AS (
    SELECT id FROM person
    WHERE address_street_name = 'Northwestern Dr'
    ORDER BY address_number DESC LIMIT 1
), wit2 AS (
    SELECT id FROM person
    WHERE INSTR(name, 'Annabel') > 0 AND address_street_name = 'Franklin Ave'
), witnesses AS (
    SELECT *, 1 AS witness FROM wit1
    UNION
    SELECT *, 2 AS witness FROM wit2
)
SELECT witness, transcript FROM witnesses
LEFT JOIN interview ON witnesses.id = interview.person_id

#Check Gym Database,Membership Status at the Gym,Personal Details

WITH gym_checkins AS (
    SELECT person_id, name
    FROM get_fit_now_member
    LEFT JOIN get_fit_now_check_in ON get_fit_now_member.id = get_fit_now_check_in.membership_id
    WHERE membership_status = 'gold'
      AND id REGEXP '^48Z'
      AND check_in_date = '20180109'
), suspects AS (
    SELECT gym_checkins.person_id, gym_checkins.name, plate_number, gender
    FROM gym_checkins
    LEFT JOIN person ON gym_checkins.person_id = person.id
    LEFT JOIN drivers_license ON person.license_id = drivers_license.id
)

#Check Car Details:

SELECT * FROM suspects
WHERE INSTR(plate_number, 'H42W') > 0 AND gender = 'male'

#Inserting answer into database

INSERT INTO solution VALUES (1, "Jeremy Bowers");

SELECT value FROM solution;

#Further investigation 

SELECT transcript FROM interview WHERE person_id = 67318


With red_haired_tesla_drivers AS (
    SELECT id AS license_id
    FROM drivers_license
    WHERE gender = 'female' AND hair_color = 'red' -- She has red hair
      AND car_make = 'Tesla' AND car_model = 'Model S' -- she drives a Tesla Model S
      AND height >= 64 AND height <= 68 -- she is around 5'5" (65") or 5'7" (67")
), rich_suspects AS (
    SELECT person.id AS person_id, name, annual_income
    FROM red_haired_tesla_drivers AS rhtd
    LEFT JOIN person ON rhtd.license_id = person.license_id
    LEFT JOIN income ON person.ssn = income.ssn
), symphony_attenders AS (
    SELECT person_id, COUNT(1) AS n_checkins
    FROM facebook_event_checkin
    WHERE event_name = 'SQL Symphony Concert' -- she attended the SQL Symphony Concert
      AND `date` REGEXP '^201712' -- in December 2017
    GROUP BY person_id
    HAVING n_checkins = 3 -- 3 times
)
SELECT name, annual_income
FROM rich_suspects
INNER JOIN symphony_attenders ON rich_suspects.person_id = symphony_attenders.person_id


INSERT INTO solution VALUES (1, "Miranda Priestly");

SELECT value FROM solution;