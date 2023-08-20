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

4.  Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
SELECT
  first_name,
  last_name
FROM patients
where weight between 100 and 120

5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA
UPDATE patients
SET allergies = 'NKA'
WHERE allergies IS NULL

6. Show first name and last name concatinated into one column to show their full name.
SELECT
  CONCAT(first_name, ' ', last_name) AS full_name
FROM patients

7. Show first name, last name, and the full province name of each patient.
SELECT
  patients.first_name,
  patients.last_name,
  province_names.province_name
FROM patients
  JOIN province_names using(province_id)

8. Show how many patients have a birth_date with 2010 as the birth year.
select count(*) AS total_patients
from patients
where year(birth_date) = 2010

9.  Show the first_name, last_name, and height of the patient with the greatest height
select
  first_name,
  last_name,
  height
from patients
where height = (
    select max(height)
    from patients
  )

10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
SELECT *
FROM patients
where
  patient_id in (1, 45, 534, 879, 1000)

11. Show the total number of admissions
SELECT count(*) as total_admissions
FROM admissions

12. Show all the columns from admissions where the patient was admitted and discharged on the same day.
SELECT *
from admissions
where admission_date = discharge_date

13. Show the patient id and the total number of admissions for patient_id 579.
SELECT
  patient_id,
  count(*) AS total_admissions
FROM admissions
WHERE patient_id = 579

14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
SELECT distinct city
FROM patients
WHERE province_id = 'NS'

(or)
SELECT city
FROM patients
GROUP BY city
HAVING province_id = 'NS'

15. Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70
SELECT
  first_name,
  last_name,
  birth_date
FROM patients
where height > 160 and weight > 70

16. Write a query to find list of patients first_name, last_name, and allergies from Hamilton where allergies are not null
SELECT
  first_name,
  last_name,
  allergies
FROM patients
where allergies is not null and city = 'Hamilton'

17. Based on cities where our patient lives in, write a query to display the list of unique city starting with a vowel (a, e, i, o, u). Show the result order in ascending by city.
SELECT
 distinct city
FROM patients
where substring(city,1,1) in ('A','E', 'I', 'O', 'U')
order by city

18. Show unique birth years from patients and order them by ascending.
SELECT
  distinct year(birth_date) as birth_year
FROM patients
order by birth_year

19. Show unique first names from the patients table which only occurs once in the list.

For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.

SELECT first_name
FROM patients
group by first_name
having count(*) = 1

20. Show patient_id and first_name from patients where their first_name start and ends with "s" and is at least 6 characters long.

SELECT
  patient_id,
  first_name
FROM patients
WHERE
  first_name LIKE 's%s'
  AND len(first_name) >= 6;

(or)
SELECT
  patient_id,
  first_name
FROM patients
where
  first_name like 's%'
  and first_name like '%s'
  and len(first_name) >= 6;


21. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
select
  patients.patient_id,
  patients.first_name,
  patients.last_name
from patients
  join admissions using(patient_id)
where diagnosis = 'Dementia'

22. Display every patient's first_name.
Order the list by the length of each name and then by alphbetically

select first_name 
from patients
order by len(first_name), first_name


23. Show the total amount of male patients and the total amount of female patients in the patients table.
Display the two results in the same row.
SELECT 
  SUM(Gender = 'M') as male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients
