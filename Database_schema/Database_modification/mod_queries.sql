-- These queries are performed after the database modification 

/* Output the name, jobtitle, salary, department, and socioeconomic class of all
 * medical personnel. Socioeconomic class are defined as:
 * 
 * Lower class: salary is less than or equal to $30,000
 * Lower-middle class: salary is more than $30,000 and less than or equal to $58,020
 * Middle class: salary is more than $58,020 and less than or equal to $94,000
 * Upper-middle class: salary is more than $94,000 and less than or equal to $153,000
 * Upper class: salary is greater than $153,00 */
SELECT
	p.first_name,
	p.last_name,
	p.jobtitle,
	d.dept_name, 
	p.salary,
	CASE
		WHEN p.salary <= 30000 THEN 'Lower class'
		WHEN p.salary > 30000 AND p.salary <= 58020 THEN 'Lower-middle class'
		WHEN p.salary > 58020 AND p.salary <= 94000 THEN 'Middle class'
		WHEN p.salary > 94000 AND p.salary <= 153000 THEN 'Upper-middle class'
		ELSE 'Upper class'
	END AS Socio_econ_class
FROM (
	SELECT * FROM healthcareprovider
	UNION 
	SELECT * FROM psychologist 
	UNION 
	SELECT * FROM therapist
	UNION 
	SELECT * FROM medicalstaff 
) AS p
LEFT JOIN department d ON d.id  = p.dept_id;

/* find the number of employees in each department and the average salary by department, 
group by salary in descending order. */
SELECT d.dept_name , COUNT(*) AS dept_count, round(AVG(p.salary)) AS avg_salary
FROM (
	SELECT * FROM healthcareprovider
	UNION 
	SELECT * FROM psychologist 
	UNION 
	SELECT * FROM therapist
	UNION 
	SELECT * FROM medicalstaff 
) AS p
LEFT JOIN department d ON d.id  = p.dept_id
GROUP BY d.dept_name 
ORDER BY avg_salary DESC;

-- rank managers by salary. Output full name, job title, salary, and rank of salaries
SELECT 
	h.first_name,
	h.last_name,
	h.jobtitle,
	h.salary,
	RANK() OVER(ORDER BY h.salary DESC) AS salary_rank
FROM manager m 
INNER JOIN healthcareprovider h 
	ON h.id = m.hcp_id;

-- rank all healthcare personnel by salary in their respective departments
SELECT 
	p.first_name,
	p.last_name
	p.jobtitle,
	p.salary,
	d.dept_name,
	RANK() OVER(PARTITION BY d.dept_name ORDER BY p.salary DESC) AS salary_rank
FROM (
	SELECT * FROM healthcareprovider
	UNION 
	SELECT * FROM psychologist 
	UNION 
	SELECT * FROM therapist
	UNION 
	SELECT * FROM medicalstaff 
) AS p
LEFT JOIN department d ON d.id  = p.dept_id;

-- How many therapist make more than the lowest paied psychologist
SELECT COUNT(*)
FROM therapist t 
WHERE t.salary > (SELECT
					MIN(salary)
				  FROM psychologist p);
				  
/* Count the number of appointments each healthcare provider partcipated in.
   Order by number of appointments in descending order.
 */
SELECT
	h.id,
	h.first_name,
	h.last_name,
	h.jobtitle,
	COUNT(*) AS appointments
FROM healthcareprovider h 
LEFT JOIN providervisit p 
	ON p.hcp_id  = h.id
GROUP BY h.id , h.fullname
ORDER BY appointments DESC;

-- select the 2nd highest paid medical personnel in each department
WITH personnel AS(
	SELECT
		p.first_name,
		p.last_name,
		p.jobtitle,
		d.dept_name,
		p.salary,
		RANK() OVER(PARTITION BY d.dept_name ORDER BY p.salary DESC) AS dept_rank
	FROM (
		SELECT * FROM healthcareprovider
		UNION 
		SELECT * FROM psychologist 
		UNION 
		SELECT * FROM therapist
		UNION 
		SELECT * FROM medicalstaff 
	) AS p
	LEFT JOIN department d ON d.id  = p.dept_id
)
SELECT
	*
FROM personnel
WHERE dept_rank = 2;

------------------------------------- insurance -------------------------------
-- output the number of patients that each insurance company covers
SELECT
	i.ins_name,
	COUNT(*) AS num_covered
FROM insurance i 
INNER JOIN hasinsurance h 
	ON h.ins_id = i.id
GROUP BY i.ins_name
ORDER BY num_covered DESC;

-- Output the number insured patient and total patients

SELECT
	COUNT(*) AS num_insured,
	(SELECT COUNT(*) FROM patient p2) AS total_pat_ct
FROM patient p
INNER JOIN hasinsurance h 
	ON h.pat_id = p.id;

-- list all patient along with insurance if they have any
SELECT p.id, p.first_name, p.last_name, i.ins_name , i.co_pay , i.percent_covered 
FROM patient p 
LEFT JOIN hasinsurance h ON h.pat_id = p.id 
LEFT JOIN insurance i ON i.id = h.ins_id;

/* list all patient along with insurance if they have any, age, 
the cost of office visit and patient portion */
SELECT p.id, p.first_name, p.last_name, date_part('year', age(p.dob)) AS age, i.ins_name ,
	   i.co_pay , i.percent_covered , p2.visit_cost,
	   CASE 
	   	WHEN ins_name IS NULL THEN visit_cost
	   	ELSE (i.co_pay + (p2.visit_cost - (p2.visit_cost * i.percent_covered)))
	   END AS pat_portion
FROM patient p 
LEFT JOIN hasinsurance h ON h.pat_id = p.id 
LEFT JOIN insurance i ON i.id = h.ins_id
LEFT JOIN providervisit p2 ON p2.pat_id = p.id
ORDER BY pat_portion DESC;

/* Write a query that outputs the insurance name if any, the patient's name, age and 
 * the average age the corresponding insurance company covers. */
WITH ages AS (
	SELECT 
		id,
		first_name,
		last_name,
		date_part('year', age(dob)) AS age
FROM patient
)
SELECT
	i.ins_name,
	a.first_name,
	a.last_name,
	a.age,
	ROUND(AVG(a.age) OVER(PARTITION BY i.ins_name)) AS avg_age
FROM ages a
LEFT JOIN hasinsurance h
	ON h.pat_id = a.id
LEFT JOIN insurance i
	ON i.id = h.ins_id
ORDER BY a.age DESC;

/* Find the total each insurance company paid out. Output insurance name and total payout,
 with total payout in descending order. */
SELECT
	i.ins_name,
	SUM((p2.visit_cost * i.percent_covered) - i.co_pay) AS total_payout
FROM patient p 
INNER  JOIN hasinsurance h ON h.pat_id = p.id 
INNER  JOIN insurance i ON i.id = h.ins_id
INNER  JOIN providervisit p2 ON p2.pat_id = p.id
GROUP BY i.ins_name
ORDER BY total_payout DESC; 

------------------------------ patients --------------------------------
/*find patients who have had an assesment and therapy SESSION. output patient first name, 
 * therapist name, psychologist name, type of therapy, 
 * type of assessment
 */
SELECT p.first_name AS pat_name, t.first_name  AS the_name, t2.therapy_type , 
	cs.session_date, p2.first_name AS psy_name, a.testname AS assest_type , h.app_date 
FROM patient p 
INNER JOIN cousneling_session cs ON cs.pat_id = p.id
INNER JOIN therapy t2 ON t2.id = cs.therapy_id 
INNER JOIN therapist t ON t.id = cs.the_id
INNER JOIN hadassessment h ON h.pat_id = p.id 
INNER JOIN assessment a ON a.id = h.assmen_id
INNER JOIN psychologist p2 ON p2.id = h.psy_id;

-- what month were the most counseling sessions held in.
SELECT
	TO_CHAR(cs.session_date, 'Month') AS month,
	count(*) AS sessions
FROM therapy t 
LEFT JOIN cousneling_session cs
	ON cs.therapy_id = t.id
GROUP BY month
ORDER BY sessions DESC
FETCH FIRST 1 ROWS ONLY;

