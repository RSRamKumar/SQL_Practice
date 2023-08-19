1. Show first name, last name, and gender of patients whose gender is 'M'
SELECT
  first_name,
  last_name,
  gender
FROM patients
where gender = 'M'

2. Show first name and last name of patients who does not have allergies. (null)
SELECT
  first_name,
  last_name
FROM patients
where allergies is null

3. Show first name of patients that start with the letter 'C'
SELECT first_name
FROM patients
where first_name like 'C%'
