/* Split the fullname columns in the patient, healthcareprovider, medicalstaff, psychologist,  and therapist tables.
 * The fullname should be split into a first_name and last_name column.
 */

-- First, a new column must be added to each of the tables above to represent the last_name column
ALTER TABLE healthcareprovider 
ADD COLUMN last_name VARCHAR(50);

ALTER TABLE medicalstaff 
ADD COLUMN last_name VARCHAR(50);

ALTER TABLE patient  
ADD COLUMN last_name VARCHAR(50);

ALTER TABLE psychologist 
ADD COLUMN last_name VARCHAR(50);

ALTER TABLE therapist 
ADD COLUMN last_name VARCHAR(50);

-- Second, rename the fullname column to first_name as this will column eventually will eventually hold the first name
ALTER TABLE healthcareprovider 
RENAME COLUMN fullname TO first_name;

ALTER TABLE medicalstaff  
RENAME COLUMN fullname TO first_name;

ALTER TABLE patient  
RENAME COLUMN fullname TO first_name;

ALTER TABLE psychologist
RENAME COLUMN fullname TO first_name;

ALTER TABLE therapist 
RENAME COLUMN fullname TO first_name;

-- Now all the tables can be updated, the split_part function can be used to split first_name column using the space as a delimeter
UPDATE healthcareprovider
SET first_name = split_part(first_name, ' ', 1), last_name = split_part(first_name, ' ', 2);

UPDATE medicalstaff 
SET first_name = split_part(first_name, ' ', 1), last_name = split_part(first_name, ' ', 2);

UPDATE patient 
SET first_name = split_part(first_name, ' ', 1), last_name = split_part(first_name, ' ', 2);

UPDATE psychologist 
SET first_name = split_part(first_name, ' ', 1), last_name = split_part(first_name, ' ', 2);

UPDATE therapist 
SET first_name = split_part(first_name, ' ', 1), last_name = split_part(first_name, ' ', 2);

--example
SELECT
first_name,
last_name 
FROM healthcareprovider h;

/* Give all psychologist in the Forensic Psychiatry department a 5% raise.
 * Since I have already made a function for this, I can just call the function */

CALL psy_raise('1016', 1.05);

-- change Evan Romero job title from Clinical Psychologist to Neuropsychologist, check log
UPDATE psychologist 
SET jobtitle = 'Neuropsychologist'
WHERE id = '84534';

SELECT * FROM psy_job_audit pja;

-- give every all the therapist whose last name over 7 characters a 2% decrease in pay 
SELECT * FROM department d;

-- rank managers by salary. Output full name, job title, salary, and rank of salaries
SELECT 
	h.salary
FROM manager m 
INNER JOIN healthcareprovider h 
	ON h.id = m.hcp_id;
