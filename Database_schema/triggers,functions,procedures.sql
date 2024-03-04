-- function counts the number of senior citizens in the database
CREATE FUNCTION senior_citizen_count()
RETURNS int
LANGUAGE plpgsql
AS
$$
DECLARE
	senior_count integer;
BEGIN
	SELECT count(*)
	INTO senior_count
	FROM patient
	WHERE date_part('year', age(patient.dob)) >= 65;

	RETURN senior_count;
END;
$$;

-- function counts the number of patients who are teenagers in the database
CREATE FUNCTION teen_count()
RETURNS int
LANGUAGE plpgsql
AS
$$
DECLARE
	teen_count integer;
BEGIN
	SELECT count(*)
	INTO teen_count
	FROM patient
	WHERE date_part('year', age(patient.dob)) >= 13 AND date_part('year', age(patient.dob)) <= 19;

	RETURN teen_count;
END;
$$;

-- create procedure to give psychologists a raise from a certain department
CREATE OR REPLACE PROCEDURE psy_raise(
	department varchar(4),
	psy_raise NUMERIC(3,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE psychologist
	SET salary = salary * psy_raise
	WHERE dept_id = department;

	COMMIT;
END;$$

-- create procedure to give healthcare providers a raise from a certain department
CREATE OR REPLACE PROCEDURE hcp_raise(
	department varchar(4),
	hcp_raise NUMERIC(3,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE healthcareprovider
	SET salary = salary * hcp_raise
	WHERE dept_id = department;

	COMMIT;
END;$$

-- create procedure to give medical staff a raise from a certain department
CREATE OR REPLACE PROCEDURE ms_raise(
	department varchar(4),
	ms_raise NUMERIC(3,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE medicalstaff 
	SET salary = salary * ms_raise
	WHERE dept_id = department;

	COMMIT;
END;$$

-- create procedure to give therapist a raise from a certain department
CREATE OR REPLACE PROCEDURE the_raise(
	department varchar(4),
	the_raise NUMERIC(3,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE therapist 
	SET salary = salary * the_raise
	WHERE dept_id = department;

	COMMIT;
END;$$

-- create view with all patient information
CREATE VIEW patient_master AS
	SELECT
		p.id,
		p.fullname AS name,
		p.gender,
		p.dob AS birth_date,
		date_part('year', age(current_date, p.dob)) AS age,
		p.email,
		p.phonenum,
		i.ins_name AS insurance,
		i.co_pay,
		i.percent_covered,
		t.therapy_type,
		cs.session_date AS therapy_date,
		cs.start_time AS therapy_start,
		cs.end_time AS therapy_end,
		t.cost_per_hr AS session_cost,
		a.testname AS assessment,
		h2.app_date AS assessment_date,
		h2.diagnosis,
		a.test_cost AS assessment_cost,
		p2.visit_date AS provider_visit_date,
		p2.reason,
		p2.prescribed,
		p2.visit_cost
	FROM patient p
		LEFT JOIN hasinsurance h ON h.pat_id = p.id
		LEFT JOIN insurance i ON i.id = h.ins_id
		LEFT JOIN cousneling_session cs ON cs.pat_id = p.id 
		LEFT JOIN therapy t ON t.id = cs.therapy_id
		LEFT JOIN hadassessment h2 ON h2.pat_id = p.id
		LEFT JOIN assessment a ON a.id = h2.assmen_id
		LEFT JOIN providervisit p2 ON p2.pat_id = p.id;
		
	
-- create view with all staff info
CREATE VIEW staff_master AS 
	SELECT
		p.id,
		p.fullname,
		p.jobtitle,
		p.salary,
		d.dept_name
	FROM (
			SELECT * FROM healthcareprovider h
			UNION ALL
			SELECT * FROM psychologist p 
			UNION ALL
			SELECT * FROM medicalstaff m 
			UNION ALL
			SELECT * FROM therapist t 
	) AS p
	INNER JOIN department d ON d.id = p.dept_id;
	

-- create trigger to track prodvider job title changes
CREATE OR REPLACE FUNCTION log_provider_job_chances()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
	AS 
$$
BEGIN
		IF NEW.jobtitle <> OLD.jobtitle THEN
				INSERT INTO provider_job_audit (provider_id, jobtitle, changed_on)
				VALUES (OLD.id, OLD.jobtitle, now());
		END IF;
	    
	    RETURN NEW;
END;
$$

CREATE TRIGGER provider_job_changes
	BEFORE UPDATE
	ON healthcareprovider
	FOR EACH ROW
	EXECUTE PROCEDURE log_provider_job_chances();

-- create trigger to track psychologist job title changes
CREATE OR REPLACE FUNCTION log_psy_job_changes()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
	AS 
$$
BEGIN
		IF NEW.jobtitle <> OLD.jobtitle THEN
				INSERT INTO psy_job_audit (psy_id, jobtitle, changed_on)
				VALUES (OLD.id, OLD.jobtitle, now());
		END IF;
	    
	    RETURN NEW;
END;
$$

CREATE TRIGGER psy_job_changes
	BEFORE UPDATE
	ON psychologist
	FOR EACH ROW
	EXECUTE PROCEDURE log_psy_job_changes();
	
-- create trigger to track medical staff job title changes
CREATE OR REPLACE FUNCTION log_med_job_changes()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
	AS 
$$
BEGIN
		IF NEW.jobtitle <> OLD.jobtitle THEN
				INSERT INTO medst_job_audit (medst_id, jobtitle, changed_on)
				VALUES (OLD.id, OLD.jobtitle, now());
		END IF;
	    
	    RETURN NEW;
END;
$$

CREATE TRIGGER med_job_changes
	BEFORE UPDATE
	ON medicalstaff 
	FOR EACH ROW
	EXECUTE PROCEDURE log_med_job_changes();
	
-- create trigger to track therapist job title changes
CREATE OR REPLACE FUNCTION log_the_job_changes()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
	AS 
$$
BEGIN
		IF NEW.jobtitle <> OLD.jobtitle THEN
				INSERT INTO the_job_audit (the_id, jobtitle, changed_on)
				VALUES (OLD.id, OLD.jobtitle, now());
		END IF;
	    
	    RETURN NEW;
END;
$$

CREATE TRIGGER the_job_changes
	BEFORE UPDATE
	ON therapist  
	FOR EACH ROW
	EXECUTE PROCEDURE log_the_job_changes();

-- create trigger to log changes to patient insurance
CREATE OR REPLACE FUNCTION log_insurance_change ()
	RETURNS TRIGGER 
	LANGUAGE PLPGSQL
	AS 
$$
BEGIN 
		IF NEW.ins_id <> OLD.ins_id THEN 
				INSERT INTO pat_insurance_change(pat_id, ins_id, changed_on)
				VALUES (OLD.pat_id, OLD.ins_id, now());
		END IF;
	
		RETURN NEW;	
END;
$$

CREATE TRIGGER insurance_change
	BEFORE UPDATE 
	ON hasinsurance 
	FOR EACH ROW 
	EXECUTE PROCEDURE log_insurance_change();
