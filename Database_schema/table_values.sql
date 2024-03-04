-- csv files that will be used to populate tables
-- In the FROM clause the entire file path of the csv file on your local machine should be include. Entire path is removed in this document for security reasons.

/* IMPORTANT: In the file path, change the backslashes to forward slashes. Also to make sure the csv file can be accessed by the database, 
   you need to make the file accessible to all. To do this, open File Explorer > locate csv file > right-click on file > click Properties >
   click the security tab > click edit permisions > click add > create a user called 'Everyone' > click box labelled 'Full Control' > now csv is accessible by the database.
   This must be done for every csv file.
*/

COPY department (id, dept_name)
FROM 'department_values.csv'
DELIMITER ','
CSV HEADER;

COPY healthcareprovider (id, fullname, jobtitle, salary, dept_id)
FROM 'new_healthprovide_values.csv'
DELIMITER ','
CSV HEADER;

COPY manager (hcp_id, dept_id)
FROM 'man_values.csv'
DELIMITER ','
CSV HEADER; 

COPY psychologist (id, fullname, jobtitle, salary, dept_id)
FROM 'psychologist_values.csv'
DELIMITER ','
CSV HEADER;

COPY assessment (id, testName, test_cost)
FROM 'assessment_values.csv'
DELIMITER ','
CSV HEADER;

COPY insurance (id, ins_name, co_pay, percent_covered)
FROM 'insurance_values.csv'
DELIMITER ','
CSV HEADER;

COPY therapy (id, therapy_type, cost_per_hr)
FROM 'therapy_values.csv'
DELIMITER ','
CSV HEADER;

COPY therapist (id, fullname, jobtitle, salary, dept_id)
FROM 'therapist_values.csv'
DELIMITER ','
CSV HEADER;

COPY medicalStaff (id, fullname, jobtitle, salary, dept_id)
FROM 'medical_staff_values.csv'
DELIMITER ','
CSV HEADER;

COPY patient (id, fullName, gender, dob, email, phoneNum)
FROM 'new_patient_value.csv'
DELIMITER ','
CSV HEADER;

COPY cousneling_session (therapy_id, the_id, pat_id, session_date, start_time, end_time)
FROM 'session_val.csv'
DELIMITER ','
CSV HEADER;

COPY hasinsurance (pat_id, ins_id)
FROM 'has_ins_values.csv'
DELIMITER ','
CSV HEADER;

COPY hadAssessment(assmen_id, pat_id, psy_id, app_date,diagnosis)
FROM 'had_asses_values.csv'
DELIMITER ','
CSV HEADER;

COPY providervisit (pat_id, hcp_id, intake_id, visit_date, reason, prescribed, visit_cost)
FROM 'office_vis_values.csv'
DELIMITER ','
CSV HEADER;
