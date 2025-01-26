-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/CngbeH
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.
CREATE TABLE "titles" (
    "title_id" varchar(10)   NOT NULL,
    "title" varchar(50)   NOT NULL,
    "last_updated" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "departments" (
    "dept_no" varchar(10)   NOT NULL,
    "dept_name" varchar(50)   NOT NULL,
    "last_updated" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar(10)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(50)   NOT NULL,
    "last_name" varchar(50)   NOT NULL,
    "sex" varchar(5)   NOT NULL,
    "hire_date" date   NOT NULL,
    "last_update" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "salary_id" serial   NOT NULL,
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    "last_update" timestamp  default localtimestamp NOT NULL
);

CREATE TABLE "dept_emp" (
    "dept_emp_id" serial   NOT NULL,
    "emp_no" int   NOT NULL,
    "dept_no" varchar(10)   NOT NULL,
    "last_update" timestamp default localtimestamp  NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "dept_emp_id"
     )
);

CREATE TABLE "dept_manager" (
    "dept_manager_id" serial   NOT NULL,
    "dept_no" varchar(10)   NOT NULL,
    "emp_no" int   NOT NULL,
    "last_update" timestamp  default localtimestamp NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_manager_id"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");



-- CREATE TABLE THAT LISTS EMPLOYEE NUMBER,LAST NAME, FIRST NAME . SEX. SALARY
--STEP 1 JOIN TABLE SALARIES AND EMPLOYEES
SELECT 
    salaries.emp_no,
    employees.last_name,
    employees.first_name,
    employees.sex,
    salaries.salary
FROM salaries
JOIN employees ON salaries.emp_no = employees.emp_no
--SET ORDER OF HOW COLUMNS WILL BE LISTED
ORDER BY salaries.emp_no, 
employees.last_name, 
employees.first_name, 
employees.sex, 
salaries.salary;

--List the first name, last name, and hire date for the employees who were hired in 1986 
--STEP 1 

SELECT 
	employees.first_name,
 	employees.last_name,
 	employees.hire_date
FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
WHERE employees.hire_date BETWEEN '1986-01-01' AND '1986-12-31'

--SET ORDER OF HOW COLUMNS WILL BE LISTED
ORDER BY 
 employees.hire_date;

--List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT 
    departments.dept_no,
    departments.dept_name,
    dept_emp.emp_no,
    employees.last_name,
    employees.first_name,
    employees.hire_date,
    titles.title
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN titles ON employees.emp_title_id = titles.title_id
WHERE titles.title_id = 'm0001'
ORDER BY 
    titles.title,
    departments.dept_no,
    departments.dept_name,
    dept_emp.emp_no,
    employees.last_name,
    employees.first_name;

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT 
    departments.dept_no,
    departments.dept_name,
    dept_emp.emp_no,
    employees.last_name,
    employees.first_name
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
JOIN employees ON dept_emp.emp_no = employees.emp_no

ORDER BY 
dept_emp.emp_no ASC;


--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.    
SELECT
SELECT 
    departments.dept_no,
    dept_emp.emp_no,
    employees.last_name,
    employees.first_name,
    employees.sex
FROM departments
JOIN dept_emp ON departments.dept_no = dept_emp.dept_no
JOIN employees ON dept_emp.emp_no = employees.emp_no
ORDER BY 
    CASE 
        WHEN employees.last_name = 'B' THEN 0 
        ELSE 1 
    END,
    CASE 
        WHEN employees.first_name = 'Hercules' THEN 0 
        ELSE 1 
    END,
	employees.first_name,
    employees.last_name;


--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT 
    employees.emp_no,
    employees.last_name,
    employees.first_name,
    departments.dept_name
    
FROM 
    employees
JOIN 
    dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN 
    departments ON dept_emp.dept_no = departments.dept_no

WHERE 
    departments.dept_name = 'Sales'
ORDER BY 
    employees.emp_no;


--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

SELECT 
    last_name,
    COUNT(*) AS name_count
FROM 
    employees
GROUP BY 
    last_name
ORDER BY 
    name_count DESC

