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

19. Show unique first names from the patients table which only occurs once in the list. For example, if two or more people are named 'John' in the first_name column then dont include their name in the output list. If only 1 person is named 'Leo' then include them in the output.

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

22. Display every patients first_name. Order the list by the length of each name and then by alphbetically
select first_name 
from patients
order by len(first_name), first_name


23. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
SELECT 
  SUM(Gender = 'M') as male_count, 
  SUM(Gender = 'F') AS female_count
FROM patients

24. Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.
SELECT
  first_name,
  last_name,
  allergies
FROM
  patients
WHERE
  allergies = 'Penicillin'
  OR allergies = 'Morphine'
ORDER BY
  allergies,  
  first_name ,
  last_name  

25. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
SELECT
  patient_id,
  diagnosis 
FROM
  admissions
group by patient_id, diagnosis
having count(*)>1

26. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.

SELECT
  city,
  count(*) as num_patients
FROM
  patients
group by city
order by num_patients desc , city

27. Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"
SELECT first_name, last_name, 'Patient' as role FROM patients
    union all
select first_name, last_name, 'Doctor' from doctors;

28. Show all allergies ordered by popularity. Remove NULL values from query.
SELECT
  allergies,
  count(*) as total_diagnosis
from patients
where allergies is not null
group by allergies
order by total_diagnosis desc

29. Show all patients first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
  
SELECT  first_name, last_name, birth_date
from patients
where year(birth_date) >=  1970 and year(birth_date) <= 1979
order by birth_date

(or)
SELECT
  first_name,
  last_name,
  birth_date
FROM patients
WHERE
  YEAR(birth_date) BETWEEN 1970 AND 1979
ORDER BY birth_date ASC;

30. We want to display each patients full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane

SELECT
  concat(UPPER(last_name), ',', lower(first_name)) AS new_name_format
from patients
order by first_name desc

31. Show the province_id(s), sum of height; where the total sum of its patients height is greater than or equal to 7,000.

SELECT
  province_id,
  sum(height) as sum_height
FROM patients
group by province_id
having sum_height >= 7000

32. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'

SELECT max(weight) - min(weight)
FROM patients
where last_name = 'Maroni'
group by last_name

33. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions

SELECT
  day(admission_date) as day_number,
  count(*) as number_of_admissions
from admissions
group by day_number
order by number_of_admissions desc

34. Show all columns for patient_id 542s most recent admission_date.

SELECT
   *
from admissions
where patient_id = 542
and admission_date = (select max(admission_date) from admissions where patient_id = 542)

(or)
SELECT *
FROM admissions
WHERE patient_id = 542
GROUP BY patient_id
HAVING
  admission_date = MAX(admission_date)

35. Show first_name, last_name, and the total number of admissions attended for each doctor. Every admission has been attended by a doctor.

  SELECT
  doctors.first_name,
  doctors.last_name,
  count(*)
from doctors
  join admissions on doctors.doctor_id = admissions.attending_doctor_id
group by admissions.attending_doctor_id

36. For each doctor, display their id, full name, and the first and last admission date they attended.

SELECT
  doctors.doctor_id,
  concat(
    doctors.first_name,
    ' ',
    doctors.last_name
  ),
  min(admissions.admission_date) AS first_admission_date,
  max(admissions.admission_date) AS last_admission_date
from doctors
  join admissions on doctors.doctor_id = admissions.attending_doctor_id
group by admissions.attending_doctor_id


37. Display the total amount of patients for each province. Order by descending.

SELECT
  province_names.province_name,
  count(*) as patient_count
from province_names
  join patients using(province_id)
group by province_names.province_name
order by patient_count desc

38. For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem
select
  concat(
    patients.first_name,
    ' ',
    patients.last_name
  ) as patient_name,
  admissions.diagnosis,
  concat(
    doctors.first_name,
    ' ',
    doctors.last_name
  ) as doctor_name
from patients
  join admissions using(patient_id)
  join doctors on admissions.attending_doctor_id = doctors.doctor_id

39. display the number of duplicate patients based on their first_name and last_name.
select
  first_name,
  last_name,
  count(*) as num_of_duplicates
from patients
group by
  first_name,
  last_name
having num_of_duplicates > 1

40. Display patient full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals, birth_date, gender non abbreviated.
Convert CM to feet by dividing by 30.48.
Convert KG to pounds by multiplying by 2.205.

select
  concat(first_name, ' ', last_name),
  round(height / 30.48, 1) as height,
  round(weight * 2.205, 0) as weight,
  birth_date,
  case
    when gender = 'M' then 'MALE'
    else 'FEMALE'
  end as gender
from patients
