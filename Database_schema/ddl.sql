-- This is the data definition language for the database
-- First create a database called mental _clinic

CREATE TABLE department (
	id		VARCHAR(4) NOT NULL,
	dept_name		VARCHAR(50) NOT NULL,
	CONSTRAINT dept_pkey PRIMARY KEY (id)
);

CREATE TABLE healthcareProvider (
	id		VARCHAR(5) NOT NULL,
	fullName	VARCHAR(40) NOT NULL,
	jobTitle	VARCHAR(50) NOT NULL,
	salary		NUMERIC(8,2) NOT NULL,
	dept_id		VARCHAR(4) NOT NULL,
	CONSTRAINT hp_pkey PRIMARY KEY (id),
	CONSTRAINT hp_fkey FOREIGN KEY (dept_id) REFERENCES department(id)
		ON DELETE CASCADE,
	CONSTRAINT hp_check_salary CHECK (salary >= 0.00)
);

CREATE TABLE psychologist (
	id		VARCHAR(5) NOT NULL,
	fullName	VARCHAR(40) NOT NULL,
	jobTitle	VARCHAR(50) NOT NULL,
	salary		NUMERIC(8,2) NOT NULL,
	dept_id		VARCHAR(4) NOT NULL,
	CONSTRAINT psy_pkey PRIMARY KEY (id),
	CONSTRAINT psy_fkey FOREIGN KEY (dept_id) REFERENCES department(id)
		ON DELETE CASCADE,
	CONSTRAINT psy_check_salary CHECK (salary >= 0.00)
);

CREATE TABLE medicalStaff (
	id		VARCHAR(5) NOT NULL,
	fullName	VARCHAR(40) NOT NULL,
	jobTitle	VARCHAR(50) NOT NULL,
	salary		NUMERIC(8,2) NOT NULL,
	dept_id		VARCHAR(4) NOT NULL,
	CONSTRAINT ms_pkey PRIMARY KEY (id),
	CONSTRAINT ms_fkey FOREIGN KEY (dept_id) REFERENCES department(id)
		ON DELETE CASCADE,
	CONSTRAINT ms_check_salary CHECK (salary >= 0.00)
);

CREATE TABLE therapist (
	id		VARCHAR(5) NOT NULL,
	fullName	VARCHAR(40) NOT NULL,
	jobTitle	VARCHAR(50) NOT NULL,
	salary		NUMERIC(8,2) NOT NULL,
	dept_id		VARCHAR(4) NOT NULL,
	CONSTRAINT ther_pkey PRIMARY KEY (id),
	CONSTRAINT th_fkey FOREIGN KEY (dept_id) REFERENCES department(id)
		ON DELETE CASCADE,
	CONSTRAINT ther_check_salary CHECK (salary >= 0.00)
);

CREATE TABLE patient (
	id		VARCHAR(6) NOT NULL,
	fullName	VARCHAR(40) NOT NULL,
	gender	VARCHAR(30) NOT NULL,
	dob			DATE NOT NULL,
	email 	VARCHAR(60),
	phoneNum VARCHAR(20),
	CONSTRAINT pat_pkey PRIMARY KEY (id),
	CONSTRAINT gender_list CHECK (gender IN ('F', 'Female', 'M', 'Male', 'Non-binary', 'I Do Not Wish To Answer'))
);

CREATE TABLE insurance (
	id		VARCHAR(3) NOT NULL,
	ins_name	VARCHAR(40) NOT NULL,
	co_pay	NUMERIC NOT NULL,
	percent_covered	NUMERIC(3,2) NOT NULL,
	CONSTRAINT ins_pkey PRIMARY KEY (id),
	CONSTRAINT copay_list CHECK (co_pay IN (0, 25, 50, 75, 100)),
	CONSTRAINT per_cov_list CHECK (percent_covered IN (0.50, 0.80, 1.00))
);

CREATE TABLE therapy (
	id		VARCHAR(3) NOT NULL,
	therapy_type	VARCHAR(50) NOT NULL,
	cost_per_hr		NUMERIC NOT NULL,
	CONSTRAINT therapy_pkey PRIMARY KEY (id),
	CONSTRAINT cost_hr_check CHECK (cost_per_hr >= 0)
);

CREATE TABLE assessment (
	id		VARCHAR(3) NOT NULL,
	testName	VARCHAR(200) NOT NULL,
	test_cost	NUMERIC,
	CONSTRAINT asses_pkey PRIMARY KEY (id),
	CONSTRAINT cost_check CHECK (test_cost >= 0)
);

CREATE TABLE manager(
	hcp_id		VARCHAR(5) NOT NULL,
	dept_id		VARCHAR(4) NOT NULL,
	CONSTRAINT man_pkey PRIMARY KEY (hcp_id,dept_id),
	CONSTRAINT man_fkey_1 FOREIGN KEY (hcp_id) REFERENCES healthcareProvider (id)
		ON DELETE CASCADE,
	CONSTRAINT man_fkey_2 FOREIGN KEY (dept_id) REFERENCES department (id)
		ON DELETE CASCADE
);

CREATE TABLE hasInsurance (
	pat_id		VARCHAR(6) NOT NULL,
	ins_id		VARCHAR(3) NOT NULL,
	CONSTRAINT has_pkey PRIMARY KEY (pat_id, ins_id),
	CONSTRAINT has_fkey1 FOREIGN KEY (pat_id) REFERENCES patient(id)
		ON DELETE CASCADE,
	CONSTRAINT has_fkey2 FOREIGN KEY (ins_id) REFERENCES insurance(id)
		ON DELETE CASCADE
);

CREATE TABLE cousneling_session (
	therapy_id		VARCHAR(3) NOT NULL,
	the_id			VARCHAR(5) NOT NULL,
	pat_id			VARCHAR(6) NOT NULL,
	session_date	DATE NOT NULL DEFAULT CURRENT_DATE,
	start_time		TIME NOT NULL,
	end_time		TIME NOT NULL,
	CONSTRAINT cs_pkey PRIMARY KEY (therapy_id, the_id, pat_id, session_date, start_time, end_time),
	CONSTRAINT cs_fkey1 FOREIGN KEY (therapy_id) REFERENCES therapy(id)
		ON DELETE CASCADE,
	CONSTRAINT cs_fkey2 FOREIGN KEY (the_id) REFERENCES therapist (id)
		ON DELETE CASCADE,
	CONSTRAINT cs_fkey3 FOREIGN KEY (pat_id) REFERENCES patient (id)
		ON DELETE CASCADE
);

CREATE TABLE hadAssessment (
	assmen_id		VARCHAR(3) NOT NULL,
	pat_id			VARCHAR(6) NOT NULL,
	psy_id			VARCHAR(5) NOT NULL,
	app_date		DATE NOT NULL DEFAULT CURRENT_DATE,
	diagnosis		TEXT NOT NULL,
	CONSTRAINT had_pkey PRIMARY KEY (Assmen_id, pat_id, psy_id, app_date),
	CONSTRAINT had_fkey1 FOREIGN KEY (Assmen_id) REFERENCES assessment(id)
		ON DELETE CASCADE,
	CONSTRAINT had_fkey2 FOREIGN KEY (pat_id) REFERENCES patient(id)
		ON DELETE CASCADE,
	CONSTRAINT had_fkey3 FOREIGN KEY (psy_id) REFERENCES psychologist(id)
		ON DELETE CASCADE
);

CREATE TABLE providerVisit (
	pat_id		VARCHAR(6) NOT NULL,
	hcp_id		VARCHAR(5) NOT NULL,
	intake_id	VARCHAR(5) NOT NULL,
	visit_date	DATE NOT NULL DEFAULT CURRENT_DATE,
	reason		VARCHAR(50) NOT NULL,
	prescribed	VARCHAR(100),
	visit_cost	NUMERIC (8,2),
	CONSTRAINT vis_pkey PRIMARY KEY (pat_id, hcp_id, intake_id, visit_date),
	CONSTRAINT vis_fkey1 FOREIGN KEY (pat_id) REFERENCES patient (id)
		ON DELETE CASCADE,
	CONSTRAINT vis_fkey2 FOREIGN KEY (hcp_id) REFERENCES healthcareProvider (id)
		ON DELETE CASCADE,
	CONSTRAINT vis_fkey3 FOREIGN KEY (intake_id) REFERENCES medicalStaff (id)
		ON DELETE CASCADE,
	CONSTRAINT cost_check CHECK (visit_cost >= 0.00)
);

CREATE TABLE provider_job_audit (
	id INT GENERATED ALWAYS AS IDENTITY,
	provider_id		VARCHAR(5) NOT NULL,
	jobtitle		VARCHAR(50)NOT NULL,
	changed_on		TIMESTAMP(6) NOT NULL
);

CREATE TABLE psy_job_audit (
	id INT GENERATED ALWAYS AS IDENTITY,
	psy_id		VARCHAR(5) NOT NULL,
	jobtitle		VARCHAR(50)NOT NULL,
	changed_on		TIMESTAMP(6) NOT NULL
);

CREATE TABLE medst_job_audit (
	id INT GENERATED ALWAYS AS IDENTITY,
	medst_id		VARCHAR(5) NOT NULL,
	jobtitle		VARCHAR(50)NOT NULL,
	changed_on		TIMESTAMP(6) NOT NULL
);

CREATE TABLE the_job_audit (
	id INT GENERATED ALWAYS AS IDENTITY,
	the_id		VARCHAR(5) NOT NULL,
	jobtitle		VARCHAR(50)NOT NULL,
	changed_on		TIMESTAMP(6) NOT NULL
);

CREATE TABLE pat_insurance_change (
	id INT GENERATED ALWAYS AS IDENTITY,
	pat_id VARCHAR (6) NOT NULL,
	ins_id	VARCHAR(3) NOT NULL,
	changed_on		TIMESTAMP(6) NOT NULL
);
